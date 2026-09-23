# UNTESTED template. You must fill in LEF_FILES (tech LEF + std-cell LEF).
set LEF_FILES [list]
if {![llength $LEF_FILES]} { error "Fill in LEF_FILES before sourcing" }
set init_verilog   /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/coprocessor_netlist.v
set init_top_cell  coprocessor
set init_lef_file  $LEF_FILES
set init_pwr_net   VPWR
set init_gnd_net   VGND
set init_mmmc_file /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/innovus_mmmc_template.tcl
init_design
