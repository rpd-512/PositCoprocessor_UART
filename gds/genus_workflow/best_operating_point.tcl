# ============================================================
# Genus Binary Search — Max Passing Frequency + Local PPA Sweep
# Run from: PositCoprocessor_UART/gds/genus_workflow/
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
set CSV_PATH     "$OUT_DIR/sweep_results.csv"

# Binary search bounds (MHz) and resolution
set FREQ_LOW    10
set FREQ_HIGH   500
set FREQ_TOL    2    ;# stop when hi-lo <= this many MHz

file mkdir $OUT_DIR
set_db init_lib_search_path [list [file dirname $LIB_FILES]]
set_db library $LIB_FILES
read_hdl -sv $RTL_FILES
elaborate $TOP_MODULE

# ---- Reusable: run synthesis at one frequency, return {area wns_ns leak dyn tot} ----
proc run_point {freq OUT_DIR TOP_MODULE} {
    set period [expr {1000.0 / $freq}]
    reset_design -timing
    create_clock -name clk -period $period [get_ports clk]
    set_input_delay  [expr {$period * 0.1}] -clock clk [all_inputs -no_clocks]
    set_output_delay [expr {$period * 0.1}] -clock clk [all_outputs]

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

    set fh [open $timing_rpt r]; set timing_data [read $fh]; close $fh
    set slack_pairs [regexp -all -inline {Slack:=\s*(-?[0-9]+)} $timing_data]
    set wns_ns ""
    set vals {}
    foreach {full val} $slack_pairs { lappend vals $val }
    if {[llength $vals] > 0} {
        set min_ps [lindex $vals 0]
        foreach v $vals { if {$v < $min_ps} { set min_ps $v } }
        set wns_ns [expr {$min_ps / 1000.0}]
    }

    set fh [open $power_rpt r]; set power_data [read $fh]; close $fh
    set leak_val ""; set dyn_val ""; set tot_val ""
    if {[regexp {Subtotal\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)} \
            $power_data -> leak_w int_w sw_w tot_w]} {
        set leak_val [expr {$leak_w * 1.0e6}]
        set dyn_val  [expr {($int_w + $sw_w) * 1.0e6}]
        set tot_val  [expr {$tot_w * 1.0e6}]
    }

    return [list $area_val $wns_ns $leak_val $dyn_val $tot_val]
}

proc passes {wns_ns} {
    return [expr {$wns_ns ne "" && $wns_ns >= 0}]
}

# ---- CSV setup (records every point actually tried, in either phase) ----
set csv_file [open $CSV_PATH w]
puts $csv_file "freq_mhz,period_ns,wns_ns,tns_ns,area_um2,leakage_power_uw,dynamic_power_uw,total_power_uw,timing_met,phase"
close $csv_file

proc log_point {freq res phase CSV_PATH} {
    lassign $res area_val wns_ns leak_val dyn_val tot_val
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

set best_freq $lo

# ============================================================
# PHASE 2: Small local PPA sweep around the found boundary
# so you actually get an area/power curve near the operating point,
# not just a single pass/fail boundary.
# ============================================================
set LOCAL_OFFSETS {-40 -20 -10 0}   ;# MHz below best_freq; edit spacing as needed
puts "\n===== Local PPA sweep around ${best_freq} MHz ====="
foreach off $LOCAL_OFFSETS {
    set f [expr {$best_freq + $off}]
    if {$f <= 0} { continue }
    if {$off == 0} { continue }   ;# best_freq itself already logged in phase 1
    puts "\n----- Local sweep point: ${f} MHz -----"
    set res [run_point $f $OUT_DIR $TOP_MODULE]
    log_point $f $res "local_sweep" $CSV_PATH
}

puts "\n===== DONE ====="
puts "Max passing frequency (binary search): ${best_freq} MHz"
puts "Full results (search + local sweep) in: $CSV_PATH"
puts ""
puts "NOTE: power figures use Genus vectorless power analysis (PWRA-0302/PWRA-0304"
puts "warnings apply) — treat as roughly comparable across points, not absolute"
puts "frequency-scaled dynamic power."
