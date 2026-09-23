# ============================================================
# Genus Binary Search — Max Passing Frequency + Local PPA Sweep
# + captures the best point for Innovus hand-off
# Run from: PositCoprocessor_UART/gds/genus_workflow/
#
#   genus -f best_operating_point.tcl -log sweep.log
#
# The search itself is unchanged from the original (one elaboration,
# reset_design -timing between points). What is new:
#   * every point that meets timing has its netlist + SDC written to disk
#     IMMEDIATELY after it is measured, while that point is the design
#     in memory (so the saved netlist is the one the numbers came from)
#   * the best point is copied to ./handoff with a manifest
#   * a fresh-session reproduce script is generated so the result can be
#     independently re-checked
# ============================================================

set TOP_MODULE   "coprocessor"
set RTL_DIR      "../../rtl"
set RTL_FILES [list \
    $RTL_DIR/posit_primitives.sv \
    $RTL_DIR/posit_decoder.sv \
    $RTL_DIR/posit_encoder.sv \
    $RTL_DIR/posit_addsub.sv \
    $RTL_DIR/posit_muldiv.sv \
    $RTL_DIR/posit_to_float.sv \
    $RTL_DIR/float_to_posit.sv \
    $RTL_DIR/posit_arithmetic.sv \
    $RTL_DIR/uart_head.sv \
    $RTL_DIR/coprocessor.sv \
]
set LIB_FILES    "../lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
set OUT_DIR      "./sweep_results"
set HANDOFF_DIR  "./final_results"
set CSV_PATH     "$OUT_DIR/sweep_results.csv"

# Binary search bounds (MHz) and resolution
set FREQ_LOW    10
set FREQ_HIGH   500
set FREQ_TOL    2    ;# stop when hi-lo <= this many MHz

# I/O delay as a fraction of the clock period (recorded in the manifest)
set IO_DELAY_FRAC 0.1

file mkdir $OUT_DIR
set_db init_lib_search_path [list [file dirname $LIB_FILES]]
set_db library $LIB_FILES
read_hdl -sv $RTL_FILES
elaborate $TOP_MODULE

# ------------------------------------------------------------
# Shared WNS parser. Kept as source text so the exact same code is
# used here and pasted into the generated reproduce script.
# Returns worst slack in ns, or "" if no Slack line was found.
# ------------------------------------------------------------
set PARSE_WNS_SRC {
proc parse_wns_ns {timing_rpt} {
    set fh [open $timing_rpt r]; set timing_data [read $fh]; close $fh
    set slack_pairs [regexp -all -inline {Slack:=\s*(-?[0-9]+)} $timing_data]
    set vals {}
    foreach {full val} $slack_pairs { lappend vals $val }
    if {[llength $vals] == 0} { return "" }
    set min_ps [lindex $vals 0]
    foreach v $vals { if {$v < $min_ps} { set min_ps $v } }
    return [expr {$min_ps / 1000.0}]
}
}
uplevel #0 $PARSE_WNS_SRC

proc passes {wns_ns} {
    return [expr {$wns_ns ne "" && $wns_ns >= 0}]
}

# Per-frequency bookkeeping (filled as points are run)
array set RES      {}   ;# freq -> {area wns_ns leak dyn tot}
array set WRITE_OK {}   ;# freq -> 1 if netlist+SDC were written for it

# ---- Run synthesis at one frequency, return {area wns_ns leak dyn tot} ----
proc run_point {freq OUT_DIR TOP_MODULE} {
    set period [expr {1000.0 / $freq}]
    reset_design -timing
    create_clock -name clk -period $period [get_ports clk]
    set_input_delay  [expr {$period * $::IO_DELAY_FRAC}] -clock clk [all_inputs -no_clocks]
    set_output_delay [expr {$period * $::IO_DELAY_FRAC}] -clock clk [all_outputs]

    if {[catch { syn_generic; syn_map; syn_opt } err]} {
        puts "WARNING: synthesis failed at ${freq} MHz: $err"
        return [list "" "" "" "" ""]
    }

    set area_rpt   "$OUT_DIR/area_${freq}.rpt"
    set power_rpt  "$OUT_DIR/power_${freq}.rpt"
    set timing_rpt "$OUT_DIR/timing_${freq}.rpt"
    report_area   > $area_rpt
    report_power  > $power_rpt
    report_timing > $timing_rpt

    set area_val ""
    set fh [open $area_rpt r]; set area_data [read $fh]; close $fh
    foreach line [split $area_data "\n"] {
        if {[regexp "^${TOP_MODULE}\\s" $line]} {
            set nums [regexp -all -inline {[0-9]+\.[0-9]+} $line]
            if {[llength $nums] >= 3} { set area_val [lindex $nums 2] }
        }
    }

    set wns_ns [parse_wns_ns $timing_rpt]

    set fh [open $power_rpt r]; set power_data [read $fh]; close $fh
    set leak_val ""; set dyn_val ""; set tot_val ""
    if {[regexp {Subtotal\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)} \
            $power_data -> leak_w int_w sw_w tot_w]} {
        set leak_val [expr {$leak_w * 1.0e6}]
        set dyn_val  [expr {($int_w + $sw_w) * 1.0e6}]
        set tot_val  [expr {$tot_w * 1.0e6}]
    }

    # ---- NEW: save this point's design NOW, while it is the one in memory ----
    if {[passes $wns_ns]} {
        set pt_dir "$OUT_DIR/pt_${freq}MHz"
        file mkdir $pt_dir
        if {[catch {
            write_hdl > $pt_dir/${TOP_MODULE}_netlist.v
            write_sdc > $pt_dir/${TOP_MODULE}.sdc
        } werr]} {
            puts "WARNING: could not write netlist/SDC at ${freq} MHz: $werr"
            set ::WRITE_OK($freq) 0
        } else {
            set ::WRITE_OK($freq) 1
            # Optional extra state record; not required for hand-off
            catch { write_script > $pt_dir/${TOP_MODULE}_setup.tcl }
        }
    }

    return [list $area_val $wns_ns $leak_val $dyn_val $tot_val]
}

# ---- CSV setup (records every point actually tried, in either phase) ----
set csv_file [open $CSV_PATH w]
puts $csv_file "freq_mhz,period_ns,wns_ns,tns_ns,area_um2,leakage_power_uw,dynamic_power_uw,total_power_uw,timing_met,phase"
close $csv_file

proc log_point {freq res phase CSV_PATH} {
    lassign $res area_val wns_ns leak_val dyn_val tot_val
    set ::RES($freq) $res
    set period [expr {1000.0 / $freq}]
    set area_out [expr {$area_val eq "" ? "NA" : $area_val}]
    set wns_out  [expr {$wns_ns   eq "" ? "NA" : $wns_ns}]
    set leak_out [expr {$leak_val eq "" ? "NA" : $leak_val}]
    set dyn_out  [expr {$dyn_val  eq "" ? "NA" : $dyn_val}]
    set tot_out  [expr {$tot_val  eq "" ? "NA" : $tot_val}]
    set timing_met [passes $wns_ns]
    set csv_file [open $CSV_PATH a]
    puts $csv_file "$freq,$period,$wns_out,NA,$area_out,$leak_out,$dyn_out,$tot_out,$timing_met,$phase"
    close $csv_file
}

# ============================================================
# PHASE 1: Binary search for max passing frequency
# ============================================================
set lo $FREQ_LOW
set hi $FREQ_HIGH

puts "\n===== Checking lower bound: ${lo} MHz ====="
set res_lo [run_point $lo $OUT_DIR $TOP_MODULE]
log_point $lo $res_lo "binary_search" $CSV_PATH
if {![passes [lindex $res_lo 1]]} {
    puts "ERROR: even the lowest bound (${lo} MHz) fails timing. Lower FREQ_LOW and rerun."
} else {
    while {[expr {$hi - $lo}] > $FREQ_TOL} {
        set mid [expr {int(($lo + $hi) / 2)}]
        puts "\n===== Binary search: trying ${mid} MHz (range ${lo}-${hi}) ====="
        set res_mid [run_point $mid $OUT_DIR $TOP_MODULE]
        log_point $mid $res_mid "binary_search" $CSV_PATH
        if {[passes [lindex $res_mid 1]]} {
            set lo $mid
        } else {
            set hi $mid
        }
    }
    puts "\n===== Binary search converged: max passing frequency ~= ${lo} MHz ====="
}

set search_best $lo
# If no tested frequency ever failed, hi is still FREQ_HIGH: the true ceiling
# was NOT found (FREQ_HIGH itself is never measured), only a lower bound.
set ceiling_found [expr {$hi != $FREQ_HIGH}]
if {!$ceiling_found && [passes [lindex $res_lo 1]]} {
    puts "\nWARNING: every frequency tried passed, so the real limit is above ${search_best} MHz."
    puts "         Raise FREQ_HIGH and rerun; ${search_best} MHz is a lower bound, not a maximum."
}

# ============================================================
# PHASE 2: Small local PPA sweep below the found boundary
# (skips any frequency that was already measured)
# ============================================================
set LOCAL_OFFSETS {-40 -20 -10}
puts "\n===== Local PPA sweep around ${search_best} MHz ====="
foreach off $LOCAL_OFFSETS {
    set f [expr {$search_best + $off}]
    if {$f <= 0} { continue }
    if {[info exists RES($f)]} { puts "(skipping ${f} MHz: already measured)"; continue }
    puts "\n----- Local sweep point: ${f} MHz -----"
    set res [run_point $f $OUT_DIR $TOP_MODULE]
    log_point $f $res "local_sweep" $CSV_PATH
}

# ============================================================
# PHASE 3: Pick the best MEASURED point and write the hand-off package
# Rule: highest frequency whose measured WNS >= 0 and whose netlist+SDC
# were successfully written.
# ============================================================
set best_freq ""
foreach f [lsort -integer -decreasing [array names RES]] {
    if {[passes [lindex $RES($f) 1]] && [info exists WRITE_OK($f)] && $WRITE_OK($f)} {
        set best_freq $f
        break
    }
}

if {$best_freq eq ""} {
    puts "\nERROR: no point met timing with a saved netlist. No hand-off written."
    puts "Sweep CSV: $CSV_PATH"
    return
}

lassign $RES($best_freq) b_area b_wns b_leak b_dyn b_tot
set best_period [expr {1000.0 / $best_freq}]
set pt_dir "$OUT_DIR/pt_${best_freq}MHz"

file mkdir $HANDOFF_DIR
file mkdir $HANDOFF_DIR/rtl_snapshot

# --- Copy the chosen point's files ---
file copy -force $pt_dir/${TOP_MODULE}_netlist.v $HANDOFF_DIR/
file copy -force $pt_dir/${TOP_MODULE}.sdc       $HANDOFF_DIR/
if {[file exists $pt_dir/${TOP_MODULE}_setup.tcl]} {
    file copy -force $pt_dir/${TOP_MODULE}_setup.tcl $HANDOFF_DIR/
}
foreach r {area power timing} {
    file copy -force $OUT_DIR/${r}_${best_freq}.rpt $HANDOFF_DIR/${r}.rpt
}
file copy -force $CSV_PATH $HANDOFF_DIR/sweep_results.csv
catch { file copy -force [info script] $HANDOFF_DIR/ }

# --- Snapshot the RTL that was actually synthesized (same order) ---
set snap_files {}
foreach f $RTL_FILES {
    file copy -force $f $HANDOFF_DIR/rtl_snapshot/
    lappend snap_files [file normalize $HANDOFF_DIR/rtl_snapshot/[file tail $f]]
}

# --- Small helpers for the manifest ---
proc md5_of {f} {
    if {[catch {exec md5sum $f} out]} { return "unavailable" }
    return [lindex [split $out " "] 0]
}
proc try_get {expr_str} {
    if {[catch {uplevel #0 $expr_str} v]} { return "unavailable" }
    return $v
}

set lib_abs [file normalize $LIB_FILES]
set net_abs [file normalize $HANDOFF_DIR/${TOP_MODULE}_netlist.v]
set sdc_abs [file normalize $HANDOFF_DIR/${TOP_MODULE}.sdc]

# --- Manifest ---
set mf [open $HANDOFF_DIR/MANIFEST.txt w]
puts $mf "GENUS SWEEP HAND-OFF MANIFEST"
puts $mf "============================="
puts $mf "date            : [clock format [clock seconds]]"
puts $mf "host / user     : [try_get {info hostname}] / [try_get {set ::env(USER)}]"
puts $mf "run directory   : [pwd]"
puts $mf "genus version   : [try_get {get_db program_version}]"
puts $mf "top module      : $TOP_MODULE"
puts $mf ""
puts $mf "SELECTED POINT"
puts $mf "  frequency          : $best_freq MHz  (period $best_period ns)"
puts $mf "  WNS (setup)        : $b_wns ns   (from Genus report_timing, worst path reported)"
puts $mf "  area               : $b_area um^2 (Genus report_area)"
puts $mf "  leakage / dynamic / total power : $b_leak / $b_dyn / $b_tot uW"
puts $mf "  selection rule     : highest frequency measured with WNS >= 0 in this run"
puts $mf "  binary-search result (hi-lo <= $FREQ_TOL MHz) : $search_best MHz"
if {!$ceiling_found} {
    puts $mf "  WARNING: no tested frequency failed; $search_best MHz is only a LOWER BOUND on max frequency (FREQ_HIGH=$FREQ_HIGH too low)"
}
puts $mf ""
puts $mf "CONSTRAINTS USED"
puts $mf "  clock port 'clk', period = 1000/freq ns"
puts $mf "  input delay  = $IO_DELAY_FRAC x period, output delay = $IO_DELAY_FRAC x period"
puts $mf "  no uncertainty, no false/multicycle paths, no wire-load or parasitics"
puts $mf ""
puts $mf "TOOL SETTINGS (values as reported by Genus at run time; this script does not set them)"
foreach a {syn_generic_effort syn_map_effort syn_opt_effort} {
    puts $mf "  $a = [try_get [list get_db $a]]"
}
puts $mf ""
puts $mf "INPUT CHECKSUMS (md5)"
puts $mf "  [md5_of $lib_abs]  $lib_abs"
foreach f $RTL_FILES { puts $mf "  [md5_of $f]  [file normalize $f]" }
puts $mf "  RTL git commit : [try_get [list exec git -C $RTL_DIR rev-parse HEAD]]"
set git_st [try_get [list exec git -C $RTL_DIR status --porcelain]]
if {$git_st eq "unavailable"} { set git_dirty "unknown (git not available)" } \
elseif {$git_st eq ""}        { set git_dirty "no" } \
else                          { set git_dirty "yes (uncommitted changes in RTL dir)" }
puts $mf "  RTL git dirty  : $git_dirty"
puts $mf ""
puts $mf "STATUS / LIMITATIONS"
puts $mf "  * The selected netlist was written in the same Genus session that measured it,"
puts $mf "    but that session ran several frequencies back-to-back on one elaboration."
puts $mf "    Results can depend on that history. It has NOT been re-run from a fresh session"
puts $mf "    unless ./handoff/verified/VERIFY_STATUS.txt exists and says so."
puts $mf "  * Timing is synthesis-level (no placement/routing parasitics). Post-route slack in"
puts $mf "    Innovus will generally be worse; a point at WNS ~ 0 has no margin."
puts $mf "  * Only setup timing was checked. Hold is not evaluated here."
puts $mf "  * Power is vectorless estimation and is not frequency-accurate."
puts $mf "  * LEF/tech files, RC corners, and power-net names are NOT produced by Genus."
puts $mf ""
puts $mf "FILES"
puts $mf "  ${TOP_MODULE}_netlist.v   mapped netlist for Innovus (init_verilog)"
puts $mf "  ${TOP_MODULE}.sdc         constraints for Innovus"
puts $mf "  area/power/timing.rpt    Genus reports for the selected point"
puts $mf "  sweep_results.csv        every point measured (binary search + local sweep)"
puts $mf "  rtl_snapshot/            exact RTL used, in synthesis order"
puts $mf "  reproduce_at_best.tcl    fresh-session re-run + pass/fail check"
puts $mf "  innovus_*_template.tcl   UNTESTED starting points (see files)"
close $mf

# --- Innovus starting-point templates (not tested against your Innovus version) ---
set fh [open $HANDOFF_DIR/innovus_mmmc_template.tcl w]
puts $fh "# UNTESTED template. Add an RC corner (create_rc_corner) if your flow needs one,"
puts $fh "# and pass it to create_delay_corner with -rc_corner."
puts $fh "create_library_set     -name lib_tt -timing \[list $lib_abs\]"
puts $fh "create_constraint_mode -name cm_func -sdc_files \[list $sdc_abs\]"
puts $fh "create_delay_corner    -name dc_tt -library_set lib_tt"
puts $fh "create_analysis_view   -name av_tt -constraint_mode cm_func -delay_corner dc_tt"
puts $fh "set_analysis_view -setup \[list av_tt\] -hold \[list av_tt\]"
close $fh

set fh [open $HANDOFF_DIR/innovus_init_template.tcl w]
puts $fh "# UNTESTED template. You must fill in LEF_FILES (tech LEF + std-cell LEF)."
puts $fh "set LEF_FILES \[list\]"
puts $fh "if {!\[llength \$LEF_FILES\]} { error \"Fill in LEF_FILES before sourcing\" }"
puts $fh "set init_verilog   $net_abs"
puts $fh "set init_top_cell  $TOP_MODULE"
puts $fh "set init_lef_file  \$LEF_FILES"
puts $fh "set init_pwr_net   VPWR"
puts $fh "set init_gnd_net   VGND"
puts $fh "set init_mmmc_file [file normalize $HANDOFF_DIR/innovus_mmmc_template.tcl]"
puts $fh "init_design"
close $fh

# --- Fresh-session reproduce script ---
set REPRO_TEMPLATE {# ============================================================
# Re-run ONE frequency from a fresh Genus session and check timing.
#   genus -f reproduce_at_best.tcl
# Uses the RTL snapshot and the same library, constraints and commands
# as the sweep. Writes to ./verified next to this script.
# ============================================================
set TOP_MODULE {@TOP@}
set FREQ       @FREQ@
set LIB        {@LIB@}
set IO_FRAC    @IOFRAC@
set RTL_FILES  [list @RTL@]
set OUT        {@VERIFY_DIR@}
file mkdir $OUT

@PARSE_WNS@

set_db init_lib_search_path [list [file dirname $LIB]]
set_db library $LIB
read_hdl -sv $RTL_FILES
elaborate $TOP_MODULE

set period [expr {1000.0 / $FREQ}]
create_clock -name clk -period $period [get_ports clk]
set_input_delay  [expr {$period * $IO_FRAC}] -clock clk [all_inputs -no_clocks]
set_output_delay [expr {$period * $IO_FRAC}] -clock clk [all_outputs]

syn_generic
syn_map
syn_opt

report_timing > $OUT/timing.rpt
report_area   > $OUT/area.rpt
report_power  > $OUT/power.rpt
write_hdl > $OUT/${TOP_MODULE}_netlist.v
write_sdc > $OUT/${TOP_MODULE}.sdc

set wns [parse_wns_ns $OUT/timing.rpt]
set recorded_wns {@REC_WNS@}
set recorded_area {@REC_AREA@}

set fh [open $OUT/area.rpt r]; set area_data [read $fh]; close $fh
set area_now ""
foreach line [split $area_data "\n"] {
    if {[regexp "^${TOP_MODULE}\\s" $line]} {
        set nums [regexp -all -inline {[0-9]+\.[0-9]+} $line]
        if {[llength $nums] >= 3} { set area_now [lindex $nums 2] }
    }
}

if {$wns ne "" && $wns >= 0} { set verdict "REPRODUCED: fresh-session timing met" } \
else { set verdict "NOT REPRODUCED: fresh-session timing FAILED (or WNS unreadable)" }

set fh [open $OUT/VERIFY_STATUS.txt w]
puts $fh $verdict
puts $fh "frequency      : $FREQ MHz"
puts $fh "fresh WNS (ns) : $wns      (sweep recorded: $recorded_wns)"
puts $fh "fresh area     : $area_now      (sweep recorded: $recorded_area)"
puts $fh "The files in this directory are from the fresh run."
close $fh
puts "\n===== $verdict  (WNS=$wns ns, sweep recorded $recorded_wns ns) ====="
}

set repro [string map [list \
    @TOP@ $TOP_MODULE \
    @FREQ@ $best_freq \
    @LIB@ $lib_abs \
    @IOFRAC@ $IO_DELAY_FRAC \
    @RTL@ $snap_files \
    @VERIFY_DIR@ [file normalize $HANDOFF_DIR/verified] \
    @PARSE_WNS@ $PARSE_WNS_SRC \
    @REC_WNS@ $b_wns \
    @REC_AREA@ $b_area] $REPRO_TEMPLATE]
set fh [open $HANDOFF_DIR/reproduce_at_best.tcl w]
puts $fh $repro
close $fh

# --- Summary ---
puts "\n===== DONE ====="
puts "Binary-search result : ${search_best} MHz"
puts "Selected (best measured passing point) : ${best_freq} MHz (period ${best_period} ns), WNS=${b_wns} ns"
puts "Hand-off package     : $HANDOFF_DIR/"
puts "All points           : $CSV_PATH"
puts ""
puts "NEXT: confirm from a fresh session before trusting the result:"
puts "      genus -f $HANDOFF_DIR/reproduce_at_best.tcl"
puts "NOTE: power figures use Genus vectorless power analysis (PWRA-0302/PWRA-0304"
puts "warnings apply) — treat as roughly comparable across points, not absolute"
puts "frequency-scaled dynamic power."
