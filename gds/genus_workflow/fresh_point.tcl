# ============================================================
# ONE frequency, ONE fresh Genus process. Called by run_sweep.sh:
#   FREQ=137 OUT_DIR=./sweep_fresh genus -f fresh_point.tcl -no_gui
# Run from: PositCoprocessor_UART/gds/genus_workflow/
# Same RTL, lib, constraints, commands and parsers as
# best_operating_point.tcl, but with no session history.
# ============================================================
set FREQ    $::env(FREQ)
set OUT_DIR $::env(OUT_DIR)

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
set IO_DELAY_FRAC 0.1

file mkdir $OUT_DIR

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
proc passes {wns_ns} {
    return [expr {$wns_ns ne "" && $wns_ns >= 0}]
}

set_db init_lib_search_path [list [file dirname $LIB_FILES]]
set_db library $LIB_FILES
read_hdl -sv $RTL_FILES
elaborate $TOP_MODULE

set period [expr {1000.0 / $FREQ}]
create_clock -name clk -period $period [get_ports clk]
set_input_delay  [expr {$period * $IO_DELAY_FRAC}] -clock clk [all_inputs -no_clocks]
set_output_delay [expr {$period * $IO_DELAY_FRAC}] -clock clk [all_outputs]

set area_val ""; set wns_ns ""; set leak_val ""; set dyn_val ""; set tot_val ""

if {[catch { syn_generic; syn_map; syn_opt } err]} {
    puts "WARNING: synthesis failed at ${FREQ} MHz: $err"
} else {
    set area_rpt   "$OUT_DIR/area_${FREQ}.rpt"
    set power_rpt  "$OUT_DIR/power_${FREQ}.rpt"
    set timing_rpt "$OUT_DIR/timing_${FREQ}.rpt"
    report_area   > $area_rpt
    report_power  > $power_rpt
    report_timing > $timing_rpt

    set fh [open $area_rpt r]; set area_data [read $fh]; close $fh
    foreach line [split $area_data "\n"] {
        if {[regexp "^${TOP_MODULE}\\s" $line]} {
            set nums [regexp -all -inline {[0-9]+\.[0-9]+} $line]
            if {[llength $nums] >= 3} { set area_val [lindex $nums 2] }
        }
    }

    set wns_ns [parse_wns_ns $timing_rpt]

    set fh [open $power_rpt r]; set power_data [read $fh]; close $fh
    if {[regexp {Subtotal\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)\s+([0-9.eE+-]+)} \
            $power_data -> leak_w int_w sw_w tot_w]} {
        set leak_val [expr {$leak_w * 1.0e6}]
        set dyn_val  [expr {($int_w + $sw_w) * 1.0e6}]
        set tot_val  [expr {$tot_w * 1.0e6}]
    }

    if {[passes $wns_ns]} {
        set pt_dir "$OUT_DIR/pt_${FREQ}MHz"
        file mkdir $pt_dir
        catch { write_hdl > $pt_dir/${TOP_MODULE}_netlist.v }
        catch { write_sdc > $pt_dir/${TOP_MODULE}.sdc }
    }
}

# One CSV row (9 columns; run_sweep.sh appends the phase column)
set area_out [expr {$area_val eq "" ? "NA" : $area_val}]
set wns_out  [expr {$wns_ns   eq "" ? "NA" : $wns_ns}]
set leak_out [expr {$leak_val eq "" ? "NA" : $leak_val}]
set dyn_out  [expr {$dyn_val  eq "" ? "NA" : $dyn_val}]
set tot_out  [expr {$tot_val  eq "" ? "NA" : $tot_val}]
set timing_met [passes $wns_ns]
set fh [open $OUT_DIR/row_${FREQ}.csv w]
puts -nonewline $fh "$FREQ,$period,$wns_out,NA,$area_out,$leak_out,$dyn_out,$tot_out,$timing_met"
close $fh

exit
