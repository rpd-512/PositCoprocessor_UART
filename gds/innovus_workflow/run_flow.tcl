set RUN $::env(RUN)

set fh [open ./$RUN/mmmc.tcl w]
puts $fh "set LIB \"../lib/sky130_fd_sc_hd__tt_025C_1v80.lib\"
create_library_set -name LIB_TYP -timing \[list \$LIB\]
create_rc_corner -name RC_TYP
create_delay_corner -name DELAY_TYP -library_set LIB_TYP -rc_corner RC_TYP
create_constraint_mode -name CONSTRAINTS -sdc_files \[list \"./$RUN/pt/coprocessor.sdc\"\]
create_analysis_view -name VIEW_TYP -constraint_mode CONSTRAINTS -delay_corner DELAY_TYP
set_analysis_view -setup \[list VIEW_TYP\] -hold \[list VIEW_TYP\]"
close $fh

set init_verilog "./$RUN/pt/coprocessor_netlist.v"
set init_top_cell "coprocessor"
set init_lef_file {../lib/sky130_fd_sc_hd_innovus.tlef ../lib/sky130_fd_sc_hd.lef}
set init_mmmc_file "./$RUN/mmmc.tcl"
init_design

floorPlan -d 330 325 10 10 10 10

place_opt_design
saveDesign ./$RUN/place.enc

ccopt_design
saveDesign ./$RUN/cts.enc

routeDesign
saveDesign ./$RUN/route_pre.enc
report_timing -path_type full_clock -late -max_paths 10 > ./$RUN/timing_setup_preopt.rpt
verify_drc -report ./$RUN/drc_preopt.rpt

catch {
  setAnalysisMode -analysisType onChipVariation -cppr both
  optDesign -postRoute -setup
  saveDesign ./$RUN/route.enc
}

verify_drc -report ./$RUN/drc.rpt
report_timing -path_type full_clock -late  -max_paths 10 > ./$RUN/timing_setup.rpt
report_timing -path_type full_clock -early -max_paths 5  > ./$RUN/timing_hold.rpt
report_area  > ./$RUN/area.rpt
report_power > ./$RUN/power.rpt
summaryReport -noHtml -outfile ./$RUN/summary.rpt
exit
