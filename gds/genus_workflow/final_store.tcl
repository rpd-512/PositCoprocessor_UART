# ============================================================
# Genus — Finalize Netlist + Constraints at Optimal Frequency
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

# ---- The winning operating point from the sweep ----
set BEST_FREQ    137
set BEST_PERIOD  [expr {1000.0 / $BEST_FREQ}]

set OUT_DIR      "./final_netlist"
file mkdir $OUT_DIR

# ---- Setup (same as sweep) ----
set_db init_lib_search_path [list [file dirname $LIB_FILES]]
set_db library $LIB_FILES
read_hdl -sv $RTL_FILES
elaborate $TOP_MODULE

# ---- Apply the winning constraints ----
reset_design -timing
create_clock -name clk -period $BEST_PERIOD [get_ports clk]
set_input_delay  [expr {$BEST_PERIOD * 0.1}] -clock clk [all_inputs -no_clocks]
set_output_delay [expr {$BEST_PERIOD * 0.1}] -clock clk [all_outputs]

# ---- Synthesize ----
syn_generic
syn_map
syn_opt

# ---- Confirm timing actually closes before writing anything out ----
report_timing > $OUT_DIR/final_timing.rpt
report_area   > $OUT_DIR/final_area.rpt
report_power  > $OUT_DIR/final_power.rpt

set fh [open $OUT_DIR/final_timing.rpt r]
set timing_data [read $fh]
close $fh
set slack_pairs [regexp -all -inline {Slack:=\s*(-?[0-9]+)} $timing_data]
set min_ps ""
foreach {full val} $slack_pairs {
    if {$min_ps eq "" || $val < $min_ps} { set min_ps $val }
}

if {$min_ps ne "" && $min_ps < 0} {
    puts "\n*** WARNING: Final netlist at ${BEST_FREQ} MHz does NOT meet timing (WNS=${min_ps} ps). ***"
    puts "*** Files will still be written, but review before handing off to Innovus. ***\n"
} else {
    puts "\n===== Timing closed at ${BEST_FREQ} MHz (WNS=${min_ps} ps) — proceeding to write outputs =====\n"
}

# ---- Write everything Innovus needs ----

# 1. Structural gate-level netlist
write_hdl > $OUT_DIR/${TOP_MODULE}_netlist.v

# 2. SDC constraints (clock, I/O delays — carries straight into Innovus)
write_sdc > $OUT_DIR/${TOP_MODULE}_constraints.sdc

# 3. SDF (optional but useful) — post-synthesis delay annotation for gate-level sim
# Comment out if you don't need SDF-based simulation later
if {[catch { write_sdf > $OUT_DIR/${TOP_MODULE}.sdf } err]} {
    puts "NOTE: write_sdf not available/failed in this Genus config: $err"
}

# 4. Design + library setup script — lets you (or Innovus) recreate the exact
#    library/attribute environment this netlist was synthesized under
write_script > $OUT_DIR/${TOP_MODULE}_setup.tcl

puts "\n===== FINALIZE COMPLETE ====="
puts "Netlist:     $OUT_DIR/${TOP_MODULE}_netlist.v"
puts "Constraints: $OUT_DIR/${TOP_MODULE}_constraints.sdc"
puts "Reports:     $OUT_DIR/final_timing.rpt, final_area.rpt, final_power.rpt"
puts "Frequency:   ${BEST_FREQ} MHz (period ${BEST_PERIOD} ns)"
