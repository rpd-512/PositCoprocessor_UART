# ============================================================
# Innovus initialization
# ============================================================

set init_verilog "./pt_130MHz/coprocessor_netlist.v"

set init_top_cell "coprocessor"

set init_lef_file {
    "../lib/sky130_fd_sc_hd_innovus.tlef"
    "../lib/sky130_fd_sc_hd.lef"
}

set init_mmmc_file "./mmmc.tcl"

# Initialize design
init_design

puts "=========================================="
puts " Innovus initialization complete"
puts " Top: $init_top_cell"
puts "=========================================="

checkDesign -all > ./init_check.rpt
