#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu Sep 24 16:16:49 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.15-s110_1 (64bit) 09/23/2022 13:08 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.15-s110_1 NR220912-2004/21_15-UB (database version 18.20.592) {superthreading v2.17}
#@(#)CDS: AAE 21.15-s039 (64bit) 09/23/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.15-s038_1 () Sep 20 2022 11:42:13 ( )
#@(#)CDS: SYNTECH 21.15-s012_1 () Sep  5 2022 10:25:51 ( )
#@(#)CDS: CPE v21.15-s076
#@(#)CDS: IQuantus/TQuantus 21.1.1-s867 (64bit) Sun Jun 26 22:12:54 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
set init_verilog ./runA/pt/coprocessor_netlist.v
set init_top_cell coprocessor
set init_lef_file {../lib/sky130_fd_sc_hd_innovus.tlef ../lib/sky130_fd_sc_hd.lef}
set init_mmmc_file ./runA/mmmc.tcl
init_design
floorPlan -d 330 325 10 10 10 10
place_opt_design
saveDesign ./runA/place.enc
ccopt_design
saveDesign ./runA/cts.enc
routeDesign
saveDesign ./runA/route_pre.enc
report_timing -path_type full_clock -late -max_paths 10 > ./$RUN/timing_setup_preopt.rpt
verify_drc -report ./runA/drc_preopt.rpt
setAnalysisMode -analysisType onChipVariation -cppr both
optDesign -postRoute -setup
saveDesign ./runA/route.enc
verify_drc -report ./runA/drc.rpt
report_timing -path_type full_clock -late  -max_paths 10 > ./$RUN/timing_setup.rpt
report_timing -path_type full_clock -early -max_paths 5  > ./$RUN/timing_hold.rpt
report_area > ./runA/area.rpt
report_power > ./runA/power.rpt
summaryReport -noHtml -outfile ./runA/summary.rpt
