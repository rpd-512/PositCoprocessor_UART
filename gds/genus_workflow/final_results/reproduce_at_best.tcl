# ============================================================
# Re-run ONE frequency from a fresh Genus session and check timing.
#   genus -f reproduce_at_best.tcl
# Uses the RTL snapshot and the same library, constraints and commands
# as the sweep. Writes to ./verified next to this script.
# ============================================================
set TOP_MODULE {coprocessor}
set FREQ       137
set LIB        {/home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/lib/sky130_fd_sc_hd__tt_025C_1v80.lib}
set IO_FRAC    0.1
set RTL_FILES  [list /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_primitives.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_decoder.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_encoder.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_addsub.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_muldiv.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_to_float.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/float_to_posit.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/posit_arithmetic.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/uart_head.sv /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/rtl_snapshot/coprocessor.sv]
set OUT        {/home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/verified}
file mkdir $OUT


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
set recorded_wns {0.0}
set recorded_area {42385.651}

set fh [open $OUT/area.rpt r]; set area_data [read $fh]; close $fh
set area_now ""
foreach line [split $area_data "\n"] {
    if {[regexp "^${TOP_MODULE}\\s" $line]} {
        set nums [regexp -all -inline {[0-9]+\.[0-9]+} $line]
        if {[llength $nums] >= 3} { set area_now [lindex $nums 2] }
    }
}

if {$wns ne "" && $wns >= 0} { set verdict "REPRODUCED: fresh-session timing met" }  else { set verdict "NOT REPRODUCED: fresh-session timing FAILED (or WNS unreadable)" }

set fh [open $OUT/VERIFY_STATUS.txt w]
puts $fh $verdict
puts $fh "frequency      : $FREQ MHz"
puts $fh "fresh WNS (ns) : $wns      (sweep recorded: $recorded_wns)"
puts $fh "fresh area     : $area_now      (sweep recorded: $recorded_area)"
puts $fh "The files in this directory are from the fresh run."
close $fh
puts "\n===== $verdict  (WNS=$wns ns, sweep recorded $recorded_wns ns) ====="

