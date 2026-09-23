######################################################################

# Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Wed Sep 23 20:17:30 IST 2026

# This file contains the Genus script for design:coprocessor

######################################################################

set_db -quiet init_lib_search_path ../lib
set_db -quiet design_mode_process no_value
set_db -quiet phys_assume_met_fill 0.0
set_db -quiet map_placed_for_route_early_global false
set_db -quiet phys_use_invs_extraction true
set_db -quiet phys_route_time_out 120.0
set_db -quiet capacitance_per_unit_length_mmmc {}
set_db -quiet resistance_per_unit_length_mmmc {}
set_db -quiet runtime_by_stage {{PBS_Generic-Start 0 10 0.0 7.0} {to_generic 42 52 41 48} {first_condense 10 64 12 64} {PBS_Generic_Opt-Post 55 65 55.747154 62.747154} {{PBS_Generic-Postgen HBO Optimizations} 1 66 0.0 62.747154} {PBS_TechMap-Start 0 66 0.0 62.747154} {{PBS_TechMap-Premap HBO Optimizations} 0 66 0.0 62.747154} {second_condense 8 74 10 77} {reify 11 85 21 99} {global_incr_map 1 86 1 100} {{PBS_Techmap-Global Mapping} 26 92 26.17131099999998 88.91846499999998} {{PBS_TechMap-Datapath Postmap Operations} 0 92 0.9838859999999983 89.90235099999998} {{PBS_TechMap-Postmap HBO Optimizations} 0 92 -0.01380100000000084 89.88854999999998} {{PBS_TechMap-Postmap Clock Gating} 1 93 1.0 90.88854999999998} {{PBS_TechMap-Postmap Cleanup} 1 94 -0.016073000000005777 90.87247699999998} {PBS_Techmap-Post_MBCI 0 94 0.0 90.87247699999998} {incr_opt 3 97 3 111} {PBS_Generic-Start 0 99 0.0 95.82288799999998} {to_generic 0 99 0 113} {first_condense 84 210 91 232} {PBS_Generic_Opt-Post 127 226 127.67547400000001 223.498362} {{PBS_Generic-Postgen HBO Optimizations} 0 226 0.0 223.498362} {PBS_TechMap-Start 0 226 0.0 223.498362} {{PBS_TechMap-Premap HBO Optimizations} 0 226 0.0 223.498362} {second_condense 88 314 93 341} {reify 23 337 44 385} {global_incr_map 11 349 11 397} {{PBS_Techmap-Global Mapping} 123 349 123.19123199999996 346.68959399999994} {{PBS_TechMap-Datapath Postmap Operations} 0 349 0.0 346.68959399999994} {{PBS_TechMap-Postmap HBO Optimizations} 0 349 -0.024454999999989013 346.66513899999995} {{PBS_TechMap-Postmap Clock Gating} 1 350 1.0 347.66513899999995} {{PBS_TechMap-Postmap Cleanup} 7 357 6.959103000000027 354.624242} {PBS_Techmap-Post_MBCI 0 357 0.0 354.624242} {incr_opt 449 806 449 856} {PBS_Generic-Start 0 807 0.0 806.1019910000002} {to_generic 0 808 0 858} {first_condense 70 897 75 953} {PBS_Generic_Opt-Post 104 911 104.71324299999992 910.8152340000001} {{PBS_Generic-Postgen HBO Optimizations} 0 911 0.0 910.8152340000001} {PBS_TechMap-Start 0 911 0.0 910.8152340000001} {{PBS_TechMap-Premap HBO Optimizations} 0 911 0.0 910.8152340000001} {second_condense 62 974 66 1034} {reify 20 994 37 1072} {global_incr_map 12 1006 12 1085} {{PBS_Techmap-Global Mapping} 95 1006 94.29488200000003 1005.1101160000002} {{PBS_TechMap-Datapath Postmap Operations} 0 1006 0.0 1005.1101160000002} {{PBS_TechMap-Postmap HBO Optimizations} 0 1006 -0.022254999999972824 1005.0878610000002} {{PBS_TechMap-Postmap Clock Gating} 0 1006 1.0 1006.0878610000002} {{PBS_TechMap-Postmap Cleanup} 4 1010 3.9725290000000086 1010.0603900000002} {PBS_Techmap-Post_MBCI 0 1010 0.0 1010.0603900000002} {incr_opt 416 1426 417 1507} }
set_db -quiet timing_adjust_tns_of_complex_flops false
set_db -quiet tinfo_tstamp_file .rs_root.tstamp
set_db -quiet metric_enable true
set_db -quiet flow_metrics_snapshot_uuid ae2923dd-6bae-4535-8660-d11d42718c81
set_db -quiet phys_use_segment_parasitics true
set_db -quiet probabilistic_extraction true
set_db -quiet ple_correlation_factors {1.9000 2.0000}
set_db -quiet maximum_interval_of_vias inf
set_db -quiet layer_aware_buffer true
set_db -quiet interconnect_mode wireload
set_db -quiet wireload_mode top
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkbufkapwr_1 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkbufkapwr_16 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkbufkapwr_2 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkbufkapwr_4 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkbufkapwr_8 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkinvkapwr_1 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkinvkapwr_16 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkinvkapwr_2 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkinvkapwr_4 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_clkinvkapwr_8 .is_always_on true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_inputiso0n_1 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_inputiso0p_1 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_inputiso1n_1 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_inputiso1p_1 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_inputisolatch_1 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_isobufsrc_1 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_isobufsrc_16 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_isobufsrc_2 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_isobufsrc_4 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_isobufsrc_8 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_isobufsrckapwr_16 .is_isolation_cell true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_1 .level_shifter_direction bidir
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_2 .level_shifter_direction bidir
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap_4 .level_shifter_direction bidir
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_4 .level_shifter_direction up
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_1 .level_shifter_direction up
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_2 .level_shifter_direction up
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .is_level_shifter true
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .min_input_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .max_input_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .min_output_voltage 1.2000000476837158
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .max_output_voltage 2.0999999046325684
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .level_shifter_valid_location any
set_db -quiet lib_cell:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap_4 .level_shifter_direction up
set_db -quiet wireload_selection none
set_db -quiet operating_condition:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/tt_025C_1v80 .tree_type balanced_tree
set_db -quiet operating_condition:default_emulate_libset_max/sky130_fd_sc_hd__tt_025C_1v80/_nominal_ .tree_type balanced_tree
# BEGIN MSV SECTION
# END MSV SECTION
define_clock -name clk -domain domain_1 -period 189394.0 -divide_period 25 -rise 0 -divide_rise 1 -fall 1 -divide_fall 2 -remove -design design:coprocessor port:coprocessor/clk
define_cost_group -design design:coprocessor -name clk
external_delay -accumulate -input {0.0 no_value 0.0 no_value} -clock clock:coprocessor/clk -name create_clock_delay_domain_1_clk_R_0 port:coprocessor/clk
set_db -quiet external_delay:coprocessor/create_clock_delay_domain_1_clk_R_0 .clock_network_latency_included true
external_delay -accumulate -input {no_value 0.0 no_value 0.0} -clock clock:coprocessor/clk -edge_fall -name create_clock_delay_domain_1_clk_F_0 port:coprocessor/clk
set_db -quiet external_delay:coprocessor/create_clock_delay_domain_1_clk_F_0 .clock_network_latency_included true
external_delay -accumulate -input {757.6 757.6 757.6 757.6} -clock clock:coprocessor/clk -name in_del port:coprocessor/rst
external_delay -accumulate -input {757.6 757.6 757.6 757.6} -clock clock:coprocessor/clk -name in_del_1_1 port:coprocessor/rx
external_delay -accumulate -output {757.6 757.6 757.6 757.6} -clock clock:coprocessor/clk -name ou_del port:coprocessor/tx
path_group -paths [specify_paths -lenient -to clock:coprocessor/clk]  -name clk -group cost_group:coprocessor/clk -user_priority -1047552
# BEGIN DFT SECTION
set_db -quiet dft_scan_style muxed_scan
set_db -quiet dft_scanbit_waveform_analysis false
# END DFT SECTION
set_db -quiet design:coprocessor .seq_reason_deleted_internal {{{state_reg[3]} {{constant 0}} {state[3]}} {{status_r_reg[2]} {{constant 0}} {status_r[2]}} {{status_r_reg[3]} {{constant 0}} {status_r[3]}} {{status_r_reg[4]} {{constant 0}} {status_r[4]}} {{status_r_reg[5]} {{constant 0}} {status_r[5]}} {{status_r_reg[6]} {{constant 0}} {status_r[6]}} {{status_r_reg[7]} {{constant 0}} {status_r[7]}}}
set_db -quiet design:coprocessor .qos_by_stage {{to_generic {wns -11111111} {tns -111111111} {vep -111111111} {area 77129} {cell_count 9090} {utilization  0.00} {runtime 42 52 41 48} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 78451} {cell_count 9031} {utilization  0.00} {runtime 10 64 12 64} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 76296} {cell_count 8768} {utilization  0.00} {runtime 8 74 10 77} }{reify {wns 73104} {tns 0} {vep 0} {area 27129} {cell_count 3907} {utilization  0.00} {runtime 11 85 21 99} }{global_incr_map {wns 73425} {tns 0} {vep 0} {area 27013} {cell_count 3861} {utilization  0.00} {runtime 1 86 1 100} }{incr_opt {wns 214748365} {tns 0} {vep 0} {area 26913} {cell_count 3831} {utilization  0.00} {runtime 3 97 3 111} }{to_generic {wns -11111111} {tns -111111111} {vep -111111111} {area 51682} {cell_count 4048} {utilization  0.00} {runtime 0 99 0 113} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 79698} {cell_count 9156} {utilization  0.00} {runtime 84 210 91 232} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 78326} {cell_count 8993} {utilization  0.00} {runtime 88 314 93 341} }{reify {wns -4996} {tns 82218} {vep 18} {area 52027} {cell_count 10232} {utilization  0.00} {runtime 23 338 44 385} }{global_incr_map {wns -4987} {tns 82209} {vep 18} {area 38973} {cell_count 6966} {utilization  0.00} {runtime 11 349 11 397} }{incr_opt {wns -3884} {tns 66767} {vep 18} {area 43203} {cell_count 7801} {utilization  0.00} {runtime 449 806 449 856} }{to_generic {wns -11111111} {tns -111111111} {vep -111111111} {area 71712} {cell_count 6824} {utilization  0.00} {runtime 0 808 0 858} }{first_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 77762} {cell_count 8927} {utilization  0.00} {runtime 70 897 75 953} }{second_condense {wns -11111111} {tns -111111111} {vep -111111111} {area 77063} {cell_count 8844} {utilization  0.00} {runtime 62 974 66 1034} }{reify {wns -1134} {tns 15696} {vep 17} {area 53660} {cell_count 10740} {utilization  0.00} {runtime 20 994 37 1072} }{global_incr_map {wns -1115} {tns 15549} {vep 17} {area 39091} {cell_count 7098} {utilization  0.00} {runtime 12 1006 12 1085} }{incr_opt {wns 214748365} {tns 0} {vep 0} {area 43872} {cell_count 7940} {utilization  0.00} {runtime 416 1426 417 1507} }}
set_db -quiet design:coprocessor .seq_mbci_coverage 0.0
set_db -quiet design:coprocessor .hdl_user_name coprocessor
set_db -quiet design:coprocessor .hdl_filelist {{default -sv {SYNTHESIS} {../../rtl/posit_primitives.sv ../../rtl/posit_decoder.sv ../../rtl/posit_encoder.sv ../../rtl/posit_addsub.sv ../../rtl/posit_muldiv.sv ../../rtl/posit_to_float.sv ../../rtl/float_to_posit.sv ../../rtl/posit_arithmetic.sv ../../rtl/uart_head.sv ../../rtl/coprocessor.sv} {} {}}}
set_db -quiet design:coprocessor .verification_directory fv/coprocessor
set_db -quiet design:coprocessor .seq_reason_deleted {{{state_reg[3]} {{constant 0}}} {{status_r_reg[2]} {{constant 0}}} {{status_r_reg[3]} {{constant 0}}} {{status_r_reg[4]} {{constant 0}}} {{status_r_reg[5]} {{constant 0}}} {{status_r_reg[6]} {{constant 0}}} {{status_r_reg[7]} {{constant 0}}}}
set_db -quiet design:coprocessor .lp_clock_gating_max_flops inf
set_db -quiet port:coprocessor/clk .original_name clk
set_db -quiet port:coprocessor/rst .original_name rst
set_db -quiet port:coprocessor/rx .original_name rx
set_db -quiet port:coprocessor/tx .original_name tx
set_db -quiet module:coprocessor/posit_arithmetic_DATA_BITS16_N_VAL2 .hdl_user_name posit_arithmetic
set_db -quiet module:coprocessor/posit_arithmetic_DATA_BITS16_N_VAL2 .hdl_filelist {{default -sv {SYNTHESIS} {../../rtl/posit_primitives.sv ../../rtl/posit_decoder.sv ../../rtl/posit_encoder.sv ../../rtl/posit_addsub.sv ../../rtl/posit_muldiv.sv ../../rtl/posit_to_float.sv ../../rtl/float_to_posit.sv ../../rtl/posit_arithmetic.sv} {} {}}}
set_db -quiet module:coprocessor/posit_arithmetic_DATA_BITS16_N_VAL2 .lp_clock_gating_max_flops inf
set_db -quiet inst:coprocessor/alu_inst/g592059 .seq_dup_name_count 1
set_db -quiet inst:coprocessor/alu_inst/g602350 .seq_dup_name_count 1
set_db -quiet inst:coprocessor/alu_inst/fopt602682 .seq_dup_name_count 1
set_db -quiet {inst:coprocessor/byte_cnt_reg[0]} .original_name {{byte_cnt[0]}}
set_db -quiet {inst:coprocessor/byte_cnt_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/byte_cnt_reg[0]} .single_bit_orig_name {byte_cnt[0]}
set_db -quiet {inst:coprocessor/byte_cnt_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/byte_cnt_reg[0]/Q} .original_name {byte_cnt[0]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[0]} .original_name {{in1_r[0]}}
set_db -quiet {inst:coprocessor/in1_r_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[0]} .single_bit_orig_name {in1_r[0]}
set_db -quiet {inst:coprocessor/in1_r_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[0]/Q} .original_name {in1_r[0]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[1]} .original_name {{in1_r[1]}}
set_db -quiet {inst:coprocessor/in1_r_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[1]} .single_bit_orig_name {in1_r[1]}
set_db -quiet {inst:coprocessor/in1_r_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[1]/Q} .original_name {in1_r[1]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[2]} .original_name {{in1_r[2]}}
set_db -quiet {inst:coprocessor/in1_r_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[2]} .single_bit_orig_name {in1_r[2]}
set_db -quiet {inst:coprocessor/in1_r_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[2]/Q} .original_name {in1_r[2]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[3]} .original_name {{in1_r[3]}}
set_db -quiet {inst:coprocessor/in1_r_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[3]} .single_bit_orig_name {in1_r[3]}
set_db -quiet {inst:coprocessor/in1_r_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[3]/Q} .original_name {in1_r[3]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[4]} .original_name {{in1_r[4]}}
set_db -quiet {inst:coprocessor/in1_r_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[4]} .single_bit_orig_name {in1_r[4]}
set_db -quiet {inst:coprocessor/in1_r_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[4]/Q} .original_name {in1_r[4]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[5]} .original_name {{in1_r[5]}}
set_db -quiet {inst:coprocessor/in1_r_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[5]} .single_bit_orig_name {in1_r[5]}
set_db -quiet {inst:coprocessor/in1_r_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[5]/Q} .original_name {in1_r[5]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[6]} .original_name {{in1_r[6]}}
set_db -quiet {inst:coprocessor/in1_r_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[6]} .single_bit_orig_name {in1_r[6]}
set_db -quiet {inst:coprocessor/in1_r_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[6]/Q} .original_name {in1_r[6]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[7]} .original_name {{in1_r[7]}}
set_db -quiet {inst:coprocessor/in1_r_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[7]} .single_bit_orig_name {in1_r[7]}
set_db -quiet {inst:coprocessor/in1_r_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[7]/Q} .original_name {in1_r[7]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[8]} .original_name {{in1_r[8]}}
set_db -quiet {inst:coprocessor/in1_r_reg[8]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[8]} .single_bit_orig_name {in1_r[8]}
set_db -quiet {inst:coprocessor/in1_r_reg[8]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[8]/Q} .original_name {in1_r[8]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[9]} .original_name {{in1_r[9]}}
set_db -quiet {inst:coprocessor/in1_r_reg[9]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[9]} .single_bit_orig_name {in1_r[9]}
set_db -quiet {inst:coprocessor/in1_r_reg[9]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[9]/Q} .original_name {in1_r[9]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[10]} .original_name {{in1_r[10]}}
set_db -quiet {inst:coprocessor/in1_r_reg[10]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[10]} .single_bit_orig_name {in1_r[10]}
set_db -quiet {inst:coprocessor/in1_r_reg[10]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[10]/Q} .original_name {in1_r[10]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[11]} .original_name {{in1_r[11]}}
set_db -quiet {inst:coprocessor/in1_r_reg[11]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[11]} .single_bit_orig_name {in1_r[11]}
set_db -quiet {inst:coprocessor/in1_r_reg[11]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[11]/Q} .original_name {in1_r[11]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[12]} .original_name {{in1_r[12]}}
set_db -quiet {inst:coprocessor/in1_r_reg[12]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[12]} .single_bit_orig_name {in1_r[12]}
set_db -quiet {inst:coprocessor/in1_r_reg[12]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[12]/Q} .original_name {in1_r[12]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[13]} .original_name {{in1_r[13]}}
set_db -quiet {inst:coprocessor/in1_r_reg[13]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[13]} .single_bit_orig_name {in1_r[13]}
set_db -quiet {inst:coprocessor/in1_r_reg[13]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[13]/Q} .original_name {in1_r[13]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[14]} .original_name {{in1_r[14]}}
set_db -quiet {inst:coprocessor/in1_r_reg[14]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[14]} .single_bit_orig_name {in1_r[14]}
set_db -quiet {inst:coprocessor/in1_r_reg[14]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[14]/Q} .original_name {in1_r[14]/q}
set_db -quiet {inst:coprocessor/in1_r_reg[15]} .original_name {{in1_r[15]}}
set_db -quiet {inst:coprocessor/in1_r_reg[15]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in1_r_reg[15]} .single_bit_orig_name {in1_r[15]}
set_db -quiet {inst:coprocessor/in1_r_reg[15]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in1_r_reg[15]/Q} .original_name {in1_r[15]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[0]} .original_name {{in2_r[0]}}
set_db -quiet {inst:coprocessor/in2_r_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[0]} .single_bit_orig_name {in2_r[0]}
set_db -quiet {inst:coprocessor/in2_r_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[0]/Q} .original_name {in2_r[0]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[1]} .original_name {{in2_r[1]}}
set_db -quiet {inst:coprocessor/in2_r_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[1]} .single_bit_orig_name {in2_r[1]}
set_db -quiet {inst:coprocessor/in2_r_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[1]/Q} .original_name {in2_r[1]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[2]} .original_name {{in2_r[2]}}
set_db -quiet {inst:coprocessor/in2_r_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[2]} .single_bit_orig_name {in2_r[2]}
set_db -quiet {inst:coprocessor/in2_r_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[2]/Q} .original_name {in2_r[2]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[3]} .original_name {{in2_r[3]}}
set_db -quiet {inst:coprocessor/in2_r_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[3]} .single_bit_orig_name {in2_r[3]}
set_db -quiet {inst:coprocessor/in2_r_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[3]/Q} .original_name {in2_r[3]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[4]} .original_name {{in2_r[4]}}
set_db -quiet {inst:coprocessor/in2_r_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[4]} .single_bit_orig_name {in2_r[4]}
set_db -quiet {inst:coprocessor/in2_r_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[4]/Q} .original_name {in2_r[4]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[5]} .original_name {{in2_r[5]}}
set_db -quiet {inst:coprocessor/in2_r_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[5]} .single_bit_orig_name {in2_r[5]}
set_db -quiet {inst:coprocessor/in2_r_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[5]/Q} .original_name {in2_r[5]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[6]} .original_name {{in2_r[6]}}
set_db -quiet {inst:coprocessor/in2_r_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[6]} .single_bit_orig_name {in2_r[6]}
set_db -quiet {inst:coprocessor/in2_r_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[6]/Q} .original_name {in2_r[6]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[7]} .original_name {{in2_r[7]}}
set_db -quiet {inst:coprocessor/in2_r_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[7]} .single_bit_orig_name {in2_r[7]}
set_db -quiet {inst:coprocessor/in2_r_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[7]/Q} .original_name {in2_r[7]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[8]} .original_name {{in2_r[8]}}
set_db -quiet {inst:coprocessor/in2_r_reg[8]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[8]} .single_bit_orig_name {in2_r[8]}
set_db -quiet {inst:coprocessor/in2_r_reg[8]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[8]/Q} .original_name {in2_r[8]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[9]} .original_name {{in2_r[9]}}
set_db -quiet {inst:coprocessor/in2_r_reg[9]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[9]} .single_bit_orig_name {in2_r[9]}
set_db -quiet {inst:coprocessor/in2_r_reg[9]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[9]/Q} .original_name {in2_r[9]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[10]} .original_name {{in2_r[10]}}
set_db -quiet {inst:coprocessor/in2_r_reg[10]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[10]} .single_bit_orig_name {in2_r[10]}
set_db -quiet {inst:coprocessor/in2_r_reg[10]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[10]/Q} .original_name {in2_r[10]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[11]} .original_name {{in2_r[11]}}
set_db -quiet {inst:coprocessor/in2_r_reg[11]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[11]} .single_bit_orig_name {in2_r[11]}
set_db -quiet {inst:coprocessor/in2_r_reg[11]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[11]/Q} .original_name {in2_r[11]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[12]} .original_name {{in2_r[12]}}
set_db -quiet {inst:coprocessor/in2_r_reg[12]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[12]} .single_bit_orig_name {in2_r[12]}
set_db -quiet {inst:coprocessor/in2_r_reg[12]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[12]/Q} .original_name {in2_r[12]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[13]} .original_name {{in2_r[13]}}
set_db -quiet {inst:coprocessor/in2_r_reg[13]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[13]} .single_bit_orig_name {in2_r[13]}
set_db -quiet {inst:coprocessor/in2_r_reg[13]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[13]/Q} .original_name {in2_r[13]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[14]} .original_name {{in2_r[14]}}
set_db -quiet {inst:coprocessor/in2_r_reg[14]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[14]} .single_bit_orig_name {in2_r[14]}
set_db -quiet {inst:coprocessor/in2_r_reg[14]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[14]/Q} .original_name {in2_r[14]/q}
set_db -quiet {inst:coprocessor/in2_r_reg[15]} .original_name {{in2_r[15]}}
set_db -quiet {inst:coprocessor/in2_r_reg[15]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/in2_r_reg[15]} .single_bit_orig_name {in2_r[15]}
set_db -quiet {inst:coprocessor/in2_r_reg[15]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/in2_r_reg[15]/Q} .original_name {in2_r[15]/q}
set_db -quiet {inst:coprocessor/opcode_r_reg[0]} .original_name {{opcode_r[0]}}
set_db -quiet {inst:coprocessor/opcode_r_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/opcode_r_reg[0]} .single_bit_orig_name {opcode_r[0]}
set_db -quiet {inst:coprocessor/opcode_r_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/opcode_r_reg[0]/Q} .original_name {opcode_r[0]/q}
set_db -quiet {inst:coprocessor/opcode_r_reg[1]} .original_name {{opcode_r[1]}}
set_db -quiet {inst:coprocessor/opcode_r_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/opcode_r_reg[1]} .single_bit_orig_name {opcode_r[1]}
set_db -quiet {inst:coprocessor/opcode_r_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/opcode_r_reg[1]/Q} .original_name {opcode_r[1]/q}
set_db -quiet {inst:coprocessor/opcode_r_reg[2]} .original_name {{opcode_r[2]}}
set_db -quiet {inst:coprocessor/opcode_r_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/opcode_r_reg[2]} .single_bit_orig_name {opcode_r[2]}
set_db -quiet {inst:coprocessor/opcode_r_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/opcode_r_reg[2]/Q} .original_name {opcode_r[2]/q}
set_db -quiet {inst:coprocessor/result_r_reg[0]} .original_name {{result_r[0]}}
set_db -quiet {inst:coprocessor/result_r_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[0]} .single_bit_orig_name {result_r[0]}
set_db -quiet {inst:coprocessor/result_r_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[0]/Q} .original_name {result_r[0]/q}
set_db -quiet {inst:coprocessor/result_r_reg[1]} .original_name {{result_r[1]}}
set_db -quiet {inst:coprocessor/result_r_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[1]} .single_bit_orig_name {result_r[1]}
set_db -quiet {inst:coprocessor/result_r_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[1]/Q} .original_name {result_r[1]/q}
set_db -quiet {inst:coprocessor/result_r_reg[2]} .original_name {{result_r[2]}}
set_db -quiet {inst:coprocessor/result_r_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[2]} .single_bit_orig_name {result_r[2]}
set_db -quiet {inst:coprocessor/result_r_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[2]/Q} .original_name {result_r[2]/q}
set_db -quiet {inst:coprocessor/result_r_reg[3]} .original_name {{result_r[3]}}
set_db -quiet {inst:coprocessor/result_r_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[3]} .single_bit_orig_name {result_r[3]}
set_db -quiet {inst:coprocessor/result_r_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[3]/Q} .original_name {result_r[3]/q}
set_db -quiet {inst:coprocessor/result_r_reg[4]} .original_name {{result_r[4]}}
set_db -quiet {inst:coprocessor/result_r_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[4]} .single_bit_orig_name {result_r[4]}
set_db -quiet {inst:coprocessor/result_r_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[4]/Q} .original_name {result_r[4]/q}
set_db -quiet {inst:coprocessor/result_r_reg[5]} .original_name {{result_r[5]}}
set_db -quiet {inst:coprocessor/result_r_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[5]} .single_bit_orig_name {result_r[5]}
set_db -quiet {inst:coprocessor/result_r_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[5]/Q} .original_name {result_r[5]/q}
set_db -quiet {inst:coprocessor/result_r_reg[6]} .original_name {{result_r[6]}}
set_db -quiet {inst:coprocessor/result_r_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[6]} .single_bit_orig_name {result_r[6]}
set_db -quiet {inst:coprocessor/result_r_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[6]/Q} .original_name {result_r[6]/q}
set_db -quiet {inst:coprocessor/result_r_reg[7]} .original_name {{result_r[7]}}
set_db -quiet {inst:coprocessor/result_r_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[7]} .single_bit_orig_name {result_r[7]}
set_db -quiet {inst:coprocessor/result_r_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[7]/Q} .original_name {result_r[7]/q}
set_db -quiet {inst:coprocessor/result_r_reg[8]} .original_name {{result_r[8]}}
set_db -quiet {inst:coprocessor/result_r_reg[8]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[8]} .single_bit_orig_name {result_r[8]}
set_db -quiet {inst:coprocessor/result_r_reg[8]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[8]/Q} .original_name {result_r[8]/q}
set_db -quiet {inst:coprocessor/result_r_reg[9]} .original_name {{result_r[9]}}
set_db -quiet {inst:coprocessor/result_r_reg[9]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[9]} .single_bit_orig_name {result_r[9]}
set_db -quiet {inst:coprocessor/result_r_reg[9]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[9]/Q} .original_name {result_r[9]/q}
set_db -quiet {inst:coprocessor/result_r_reg[10]} .original_name {{result_r[10]}}
set_db -quiet {inst:coprocessor/result_r_reg[10]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[10]} .single_bit_orig_name {result_r[10]}
set_db -quiet {inst:coprocessor/result_r_reg[10]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[10]/Q} .original_name {result_r[10]/q}
set_db -quiet {inst:coprocessor/result_r_reg[11]} .original_name {{result_r[11]}}
set_db -quiet {inst:coprocessor/result_r_reg[11]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[11]} .single_bit_orig_name {result_r[11]}
set_db -quiet {inst:coprocessor/result_r_reg[11]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[11]/Q} .original_name {result_r[11]/q}
set_db -quiet {inst:coprocessor/result_r_reg[12]} .original_name {{result_r[12]}}
set_db -quiet {inst:coprocessor/result_r_reg[12]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[12]} .single_bit_orig_name {result_r[12]}
set_db -quiet {inst:coprocessor/result_r_reg[12]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[12]/Q} .original_name {result_r[12]/q}
set_db -quiet {inst:coprocessor/result_r_reg[13]} .original_name {{result_r[13]}}
set_db -quiet {inst:coprocessor/result_r_reg[13]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[13]} .single_bit_orig_name {result_r[13]}
set_db -quiet {inst:coprocessor/result_r_reg[13]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[13]/Q} .original_name {result_r[13]/q}
set_db -quiet {inst:coprocessor/result_r_reg[14]} .original_name {{result_r[14]}}
set_db -quiet {inst:coprocessor/result_r_reg[14]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[14]} .single_bit_orig_name {result_r[14]}
set_db -quiet {inst:coprocessor/result_r_reg[14]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[14]/Q} .original_name {result_r[14]/q}
set_db -quiet {inst:coprocessor/result_r_reg[15]} .original_name {{result_r[15]}}
set_db -quiet {inst:coprocessor/result_r_reg[15]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/result_r_reg[15]} .single_bit_orig_name {result_r[15]}
set_db -quiet {inst:coprocessor/result_r_reg[15]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/result_r_reg[15]/Q} .original_name {result_r[15]/q}
set_db -quiet {inst:coprocessor/status_r_reg[0]} .original_name {{status_r[0]}}
set_db -quiet {inst:coprocessor/status_r_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/status_r_reg[0]} .single_bit_orig_name {status_r[0]}
set_db -quiet {inst:coprocessor/status_r_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/status_r_reg[0]/Q} .original_name {status_r[0]/q}
set_db -quiet {inst:coprocessor/status_r_reg[1]} .original_name {{status_r[1]}}
set_db -quiet {inst:coprocessor/status_r_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/status_r_reg[1]} .single_bit_orig_name {status_r[1]}
set_db -quiet {inst:coprocessor/status_r_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/status_r_reg[1]/Q} .original_name {status_r[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[2]} .original_name {{uart_inst/uart_rx_inst/bit_count[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[2]} .single_bit_orig_name {uart_inst/uart_rx_inst/bit_count[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[2]/Q} .original_name {uart_inst/uart_rx_inst/bit_count[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[0]} .original_name {{uart_inst/uart_rx_inst/data_rx[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[0]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[0]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[1]} .original_name {{uart_inst/uart_rx_inst/data_rx[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[1]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[1]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[2]} .original_name {{uart_inst/uart_rx_inst/data_rx[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[2]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[2]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[3]} .original_name {{uart_inst/uart_rx_inst/data_rx[3]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[3]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[3]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[3]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[3]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[4]} .original_name {{uart_inst/uart_rx_inst/data_rx[4]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[4]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[4]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[4]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[4]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[5]} .original_name {{uart_inst/uart_rx_inst/data_rx[5]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[5]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[5]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[5]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[5]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[6]} .original_name {{uart_inst/uart_rx_inst/data_rx[6]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[6]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[6]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[6]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[6]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[7]} .original_name {{uart_inst/uart_rx_inst/data_rx[7]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[7]} .single_bit_orig_name {uart_inst/uart_rx_inst/data_rx[7]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_data_rx_reg[7]/Q} .original_name {uart_inst/uart_rx_inst/data_rx[7]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[0]} .original_name {{uart_inst/uart_tx_inst/shift_reg[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[0]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[0]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[1]} .original_name {{uart_inst/uart_tx_inst/shift_reg[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[1]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[1]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[2]} .original_name {{uart_inst/uart_tx_inst/shift_reg[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[2]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[2]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[3]} .original_name {{uart_inst/uart_tx_inst/shift_reg[3]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[3]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[3]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[3]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[3]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[4]} .original_name {{uart_inst/uart_tx_inst/shift_reg[4]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[4]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[4]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[4]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[4]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[5]} .original_name {{uart_inst/uart_tx_inst/shift_reg[5]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[5]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[5]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[5]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[5]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[6]} .original_name {{uart_inst/uart_tx_inst/shift_reg[6]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[6]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[6]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[6]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[6]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[7]} .original_name {{uart_inst/uart_tx_inst/shift_reg[7]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[7]} .single_bit_orig_name {uart_inst/uart_tx_inst/shift_reg[7]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_shift_reg_reg[7]/Q} .original_name {uart_inst/uart_tx_inst/shift_reg[7]/q}
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_reg .original_name uart_inst/uart_tx_inst/tx
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_reg .single_bit_orig_name uart_inst/uart_tx_inst/tx
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_inst_uart_tx_inst_tx_reg/Q .original_name uart_inst/uart_tx_inst/tx/q
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_done_reg .original_name uart_inst/uart_tx_inst/tx_done
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_done_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_done_reg .single_bit_orig_name uart_inst/uart_tx_inst/tx_done
set_db -quiet inst:coprocessor/uart_inst_uart_tx_inst_tx_done_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_inst_uart_tx_inst_tx_done_reg/Q .original_name uart_inst/uart_tx_inst/tx_done/q
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_valid_reg .original_name uart_inst/uart_rx_inst/rx_valid
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_valid_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_valid_reg .single_bit_orig_name uart_inst/uart_rx_inst/rx_valid
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_valid_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_inst_uart_rx_inst_rx_valid_reg/Q .original_name uart_inst/uart_rx_inst/rx_valid/q
set_db -quiet inst:coprocessor/uart_inst_baud_gen_inst_tick_reg .original_name uart_inst/baud_gen_inst/tick
set_db -quiet inst:coprocessor/uart_inst_baud_gen_inst_tick_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_inst_baud_gen_inst_tick_reg .single_bit_orig_name uart_inst/baud_gen_inst/tick
set_db -quiet inst:coprocessor/uart_inst_baud_gen_inst_tick_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_inst_baud_gen_inst_tick_reg/Q .original_name uart_inst/baud_gen_inst/tick/q
set_db -quiet inst:coprocessor/uart_tx_start_reg .original_name uart_tx_start
set_db -quiet inst:coprocessor/uart_tx_start_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_tx_start_reg .single_bit_orig_name uart_tx_start
set_db -quiet inst:coprocessor/uart_tx_start_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_tx_start_reg/Q .original_name uart_tx_start/q
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_ff1_reg .original_name uart_inst/uart_rx_inst/rx_ff1
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_ff1_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_ff1_reg .single_bit_orig_name uart_inst/uart_rx_inst/rx_ff1
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_ff1_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_inst_uart_rx_inst_rx_ff1_reg/Q .original_name uart_inst/uart_rx_inst/rx_ff1/q
set_db -quiet {inst:coprocessor/state_reg[0]} .original_name {{state[0]}}
set_db -quiet {inst:coprocessor/state_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/state_reg[0]} .single_bit_orig_name {state[0]}
set_db -quiet {inst:coprocessor/state_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/state_reg[0]/Q} .original_name {state[0]/q}
set_db -quiet {inst:coprocessor/state_reg[1]} .original_name {{state[1]}}
set_db -quiet {inst:coprocessor/state_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/state_reg[1]} .single_bit_orig_name {state[1]}
set_db -quiet {inst:coprocessor/state_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/state_reg[1]/Q} .original_name {state[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[0]} .original_name {{uart_inst/baud_gen_inst/count[0]}}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[0]} .single_bit_orig_name {uart_inst/baud_gen_inst/count[0]}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_baud_gen_inst_count_reg[0]/Q} .original_name {uart_inst/baud_gen_inst/count[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[1]} .original_name {{uart_inst/baud_gen_inst/count[1]}}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[1]} .single_bit_orig_name {uart_inst/baud_gen_inst/count[1]}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_baud_gen_inst_count_reg[1]/Q} .original_name {uart_inst/baud_gen_inst/count[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[2]} .original_name {{uart_inst/baud_gen_inst/count[2]}}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[2]} .single_bit_orig_name {uart_inst/baud_gen_inst/count[2]}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_baud_gen_inst_count_reg[2]/Q} .original_name {uart_inst/baud_gen_inst/count[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[3]} .original_name {{uart_inst/baud_gen_inst/count[3]}}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[3]} .single_bit_orig_name {uart_inst/baud_gen_inst/count[3]}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_baud_gen_inst_count_reg[3]/Q} .original_name {uart_inst/baud_gen_inst/count[3]/q}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[4]} .original_name {{uart_inst/baud_gen_inst/count[4]}}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[4]} .single_bit_orig_name {uart_inst/baud_gen_inst/count[4]}
set_db -quiet {inst:coprocessor/uart_inst_baud_gen_inst_count_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_baud_gen_inst_count_reg[4]/Q} .original_name {uart_inst/baud_gen_inst/count[4]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[0]} .original_name {{uart_inst/uart_rx_inst/bit_count[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[0]} .single_bit_orig_name {uart_inst/uart_rx_inst/bit_count[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[0]/Q} .original_name {uart_inst/uart_rx_inst/bit_count[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[1]} .original_name {{uart_inst/uart_rx_inst/bit_count[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[1]} .single_bit_orig_name {uart_inst/uart_rx_inst/bit_count[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_bit_count_reg[1]/Q} .original_name {uart_inst/uart_rx_inst/bit_count[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[0]} .original_name {{uart_inst/uart_rx_inst/shift_reg[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[0]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[0]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[1]} .original_name {{uart_inst/uart_rx_inst/shift_reg[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[1]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[1]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[2]} .original_name {{uart_inst/uart_rx_inst/shift_reg[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[2]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[2]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[3]} .original_name {{uart_inst/uart_rx_inst/shift_reg[3]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[3]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[3]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[3]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[3]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[4]} .original_name {{uart_inst/uart_rx_inst/shift_reg[4]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[4]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[4]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[4]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[4]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[5]} .original_name {{uart_inst/uart_rx_inst/shift_reg[5]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[5]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[5]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[5]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[5]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[6]} .original_name {{uart_inst/uart_rx_inst/shift_reg[6]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[6]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[6]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[6]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[6]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[7]} .original_name {{uart_inst/uart_rx_inst/shift_reg[7]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[7]} .single_bit_orig_name {uart_inst/uart_rx_inst/shift_reg[7]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_shift_reg_reg[7]/Q} .original_name {uart_inst/uart_rx_inst/shift_reg[7]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[1]} .original_name {{uart_inst/uart_rx_inst/state[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[1]} .single_bit_orig_name {uart_inst/uart_rx_inst/state[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_state_reg[1]/Q} .original_name {uart_inst/uart_rx_inst/state[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[0]} .original_name {{uart_inst/uart_rx_inst/tick_count[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[0]} .single_bit_orig_name {uart_inst/uart_rx_inst/tick_count[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[0]/Q} .original_name {uart_inst/uart_rx_inst/tick_count[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[1]} .original_name {{uart_inst/uart_rx_inst/tick_count[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[1]} .single_bit_orig_name {uart_inst/uart_rx_inst/tick_count[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[1]/Q} .original_name {uart_inst/uart_rx_inst/tick_count[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[2]} .original_name {{uart_inst/uart_rx_inst/tick_count[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[2]} .single_bit_orig_name {uart_inst/uart_rx_inst/tick_count[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[2]/Q} .original_name {uart_inst/uart_rx_inst/tick_count[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[3]} .original_name {{uart_inst/uart_rx_inst/tick_count[3]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[3]} .single_bit_orig_name {uart_inst/uart_rx_inst/tick_count[3]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_tick_count_reg[3]/Q} .original_name {uart_inst/uart_rx_inst/tick_count[3]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[0]} .original_name {{uart_inst/uart_tx_inst/bit_count[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[0]} .single_bit_orig_name {uart_inst/uart_tx_inst/bit_count[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[0]/Q} .original_name {uart_inst/uart_tx_inst/bit_count[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[1]} .original_name {{uart_inst/uart_tx_inst/bit_count[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[1]} .single_bit_orig_name {uart_inst/uart_tx_inst/bit_count[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[1]/Q} .original_name {uart_inst/uart_tx_inst/bit_count[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[2]} .original_name {{uart_inst/uart_tx_inst/bit_count[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[2]} .single_bit_orig_name {uart_inst/uart_tx_inst/bit_count[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_bit_count_reg[2]/Q} .original_name {uart_inst/uart_tx_inst/bit_count[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[1]} .original_name {{uart_inst/uart_tx_inst/state[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[1]} .single_bit_orig_name {uart_inst/uart_tx_inst/state[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_state_reg[1]/Q} .original_name {uart_inst/uart_tx_inst/state[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[0]} .original_name {{uart_inst/uart_tx_inst/tick_count[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[0]} .single_bit_orig_name {uart_inst/uart_tx_inst/tick_count[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[0]/Q} .original_name {uart_inst/uart_tx_inst/tick_count[0]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[1]} .original_name {{uart_inst/uart_tx_inst/tick_count[1]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[1]} .single_bit_orig_name {uart_inst/uart_tx_inst/tick_count[1]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[1]/Q} .original_name {uart_inst/uart_tx_inst/tick_count[1]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[2]} .original_name {{uart_inst/uart_tx_inst/tick_count[2]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[2]} .single_bit_orig_name {uart_inst/uart_tx_inst/tick_count[2]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[2]/Q} .original_name {uart_inst/uart_tx_inst/tick_count[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[3]} .original_name {{uart_inst/uart_tx_inst/tick_count[3]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[3]} .single_bit_orig_name {uart_inst/uart_tx_inst/tick_count[3]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_tick_count_reg[3]/Q} .original_name {uart_inst/uart_tx_inst/tick_count[3]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[0]} .original_name {{uart_tx_data[0]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[0]} .single_bit_orig_name {uart_tx_data[0]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[0]/Q} .original_name {uart_tx_data[0]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[1]} .original_name {{uart_tx_data[1]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[1]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[1]} .single_bit_orig_name {uart_tx_data[1]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[1]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[1]/Q} .original_name {uart_tx_data[1]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[2]} .original_name {{uart_tx_data[2]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[2]} .single_bit_orig_name {uart_tx_data[2]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[2]/Q} .original_name {uart_tx_data[2]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[3]} .original_name {{uart_tx_data[3]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[3]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[3]} .single_bit_orig_name {uart_tx_data[3]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[3]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[3]/Q} .original_name {uart_tx_data[3]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[4]} .original_name {{uart_tx_data[4]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[4]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[4]} .single_bit_orig_name {uart_tx_data[4]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[4]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[4]/Q} .original_name {uart_tx_data[4]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[5]} .original_name {{uart_tx_data[5]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[5]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[5]} .single_bit_orig_name {uart_tx_data[5]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[5]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[5]/Q} .original_name {uart_tx_data[5]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[6]} .original_name {{uart_tx_data[6]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[6]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[6]} .single_bit_orig_name {uart_tx_data[6]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[6]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[6]/Q} .original_name {uart_tx_data[6]/q}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[7]} .original_name {{uart_tx_data[7]}}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[7]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_tx_data_reg[7]} .single_bit_orig_name {uart_tx_data[7]}
set_db -quiet {inst:coprocessor/uart_tx_data_reg[7]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_tx_data_reg[7]/Q} .original_name {uart_tx_data[7]/q}
set_db -quiet {inst:coprocessor/state_reg[2]} .original_name {{state[2]}}
set_db -quiet {inst:coprocessor/state_reg[2]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/state_reg[2]} .single_bit_orig_name {state[2]}
set_db -quiet {inst:coprocessor/state_reg[2]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/state_reg[2]/Q} .original_name {state[2]/q}
set_db -quiet {pin:coprocessor/state_reg[2]/Q_N} .original_name {state[2]/q}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[0]} .original_name {{uart_inst/uart_tx_inst/state[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[0]} .single_bit_orig_name {uart_inst/uart_tx_inst/state[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_tx_inst_state_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_state_reg[0]/Q} .original_name {uart_inst/uart_tx_inst/state[0]/q}
set_db -quiet {pin:coprocessor/uart_inst_uart_tx_inst_state_reg[0]/Q_N} .original_name {uart_inst/uart_tx_inst/state[0]/q}
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_sync_reg .original_name uart_inst/uart_rx_inst/rx_sync
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_sync_reg .orig_hdl_instantiated false
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_sync_reg .single_bit_orig_name uart_inst/uart_rx_inst/rx_sync
set_db -quiet inst:coprocessor/uart_inst_uart_rx_inst_rx_sync_reg .gint_phase_inversion false
set_db -quiet pin:coprocessor/uart_inst_uart_rx_inst_rx_sync_reg/Q .original_name uart_inst/uart_rx_inst/rx_sync/q
set_db -quiet pin:coprocessor/uart_inst_uart_rx_inst_rx_sync_reg/Q_N .original_name uart_inst/uart_rx_inst/rx_sync/q
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[0]} .original_name {{uart_inst/uart_rx_inst/state[0]}}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[0]} .orig_hdl_instantiated false
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[0]} .single_bit_orig_name {uart_inst/uart_rx_inst/state[0]}
set_db -quiet {inst:coprocessor/uart_inst_uart_rx_inst_state_reg[0]} .gint_phase_inversion false
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_state_reg[0]/Q} .original_name {uart_inst/uart_rx_inst/state[0]/q}
set_db -quiet {pin:coprocessor/uart_inst_uart_rx_inst_state_reg[0]/Q_N} .original_name {uart_inst/uart_rx_inst/state[0]/q}
# BEGIN PMBIST SECTION
# END PMBIST SECTION
set_db -quiet source_verbose true
#############################################################
#####   FLOW WRITE   ########################################
##
## Written by Genus(TM) Synthesis Solution version 21.14-s082_1
## flowkit v21.12-s008_1
## Written on 20:17:30 23-Sep 2026
#############################################################
#####   Flow Definitions   ##################################

#############################################################
#####   Step Definitions   ##################################


#############################################################
#####   Attribute Definitions   #############################

if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}


#############################################################
#####   Flow History   ######################################

if {[is_attribute flow_user_templates -obj_type root]} {set_db flow_user_templates {}}
if {[is_attribute flow_plugin_steps -obj_type root]} {set_db flow_plugin_steps {}}
if {[is_attribute flow_template_type -obj_type root]} {set_db flow_template_type {}}
if {[is_attribute flow_template_tools -obj_type root]} {set_db flow_template_tools {}}
if {[is_attribute flow_template_version -obj_type root]} {set_db flow_template_version {}}
if {[is_attribute flow_template_feature_definition -obj_type root]} {set_db flow_template_feature_definition {}}
if {[is_attribute flow_remark -obj_type root]} {set_db flow_remark {}}
if {[is_attribute flow_features -obj_type root]} {set_db flow_features {}}
if {[is_attribute flow_feature_values -obj_type root]} {set_db flow_feature_values {}}
if {[is_attribute flow_write_db_args -obj_type root]} {set_db flow_write_db_args {}}
if {[is_attribute flow_write_db_sdc -obj_type root]} {set_db flow_write_db_sdc true}
if {[is_attribute flow_write_db_common -obj_type root]} {set_db flow_write_db_common false}
if {[is_attribute flow_post_db_overwrite -obj_type root]} {set_db flow_post_db_overwrite {}}
if {[is_attribute flow_step_order -obj_type root]} {set_db flow_step_order {}}
if {[is_attribute flow_step_begin_tcl -obj_type root]} {set_db flow_step_begin_tcl {}}
if {[is_attribute flow_step_end_tcl -obj_type root]} {set_db flow_step_end_tcl {}}
if {[is_attribute flow_step_last -obj_type root]} {set_db flow_step_last {}}
if {[is_attribute flow_step_current -obj_type root]} {set_db flow_step_current {}}
if {[is_attribute flow_step_canonical_current -obj_type root]} {set_db flow_step_canonical_current {}}
if {[is_attribute flow_step_next -obj_type root]} {set_db flow_step_next {}}
if {[is_attribute flow_working_directory -obj_type root]} {set_db flow_working_directory .}
if {[is_attribute flow_branch -obj_type root]} {set_db flow_branch {}}
if {[is_attribute flow_caller_data -obj_type root]} {set_db flow_caller_data {}}
if {[is_attribute flow_metrics_snapshot_uuid -obj_type root]} {set_db flow_metrics_snapshot_uuid ae2923dd-6bae-4535-8660-d11d42718c81}
if {[is_attribute flow_starting_db -obj_type root]} {set_db flow_starting_db {}}
if {[is_attribute flow_db_directory -obj_type root]} {set_db flow_db_directory dbs}
if {[is_attribute flow_report_directory -obj_type root]} {set_db flow_report_directory reports}
if {[is_attribute flow_log_directory -obj_type root]} {set_db flow_log_directory logs}
if {[is_attribute flow_mail_to -obj_type root]} {set_db flow_mail_to {}}
if {[is_attribute flow_exit_when_done -obj_type root]} {set_db flow_exit_when_done false}
if {[is_attribute flow_mail_on_error -obj_type root]} {set_db flow_mail_on_error false}
if {[is_attribute flow_summary_tcl -obj_type root]} {set_db flow_summary_tcl {}}
if {[is_attribute flow_history -obj_type root]} {set_db flow_history {}}
if {[is_attribute flow_step_last_status -obj_type root]} {set_db flow_step_last_status not_run}
if {[is_attribute flow_step_last_msg -obj_type root]} {set_db flow_step_last_msg {}}
if {[is_attribute flow_run_tag -obj_type root]} {set_db flow_run_tag {}}
if {[is_attribute flow_current_cache -obj_type root]} {set_db flow_current_cache {}}
if {[is_attribute flow_step_order_cache -obj_type root]} {set_db flow_step_order_cache {}}
if {[is_attribute flow_step_results_cache -obj_type root]} {set_db flow_step_results_cache {}}
if {[is_attribute flow_metadata -obj_type root]} {set_db flow_metadata {}}
if {[is_attribute flow_execute_in_global -obj_type root]} {set_db flow_execute_in_global true}
if {[is_attribute flow_overwrite_db -obj_type root]} {set_db flow_overwrite_db false}
if {[is_attribute flow_print_run_information -obj_type root]} {set_db flow_print_run_information false}
if {[is_attribute flow_verbose -obj_type root]} {set_db flow_verbose true}
if {[is_attribute flow_print_run_information_full -obj_type root]} {set_db flow_print_run_information_full false}
if {[is_attribute flow_header_tcl -obj_type root]} {set_db flow_header_tcl {}}
if {[is_attribute flow_footer_tcl -obj_type root]} {set_db flow_footer_tcl {}}
if {[is_attribute flow_init_header_tcl -obj_type root]} {set_db flow_init_header_tcl {}}
if {[is_attribute flow_init_footer_tcl -obj_type root]} {set_db flow_init_footer_tcl {}}
if {[is_attribute flow_edit_start_steps -obj_type root]} {set_db flow_edit_start_steps {}}
if {[is_attribute flow_edit_end_steps -obj_type root]} {set_db flow_edit_end_steps {}}
if {[is_attribute flow_step_last_number -obj_type root]} {set_db flow_step_last_number 0}
if {[is_attribute flow_autoload_applets -obj_type root]} {set_db flow_autoload_applets false}
if {[is_attribute flow_autoload_dir -obj_type root]} {set_db flow_autoload_dir error}
if {[is_attribute flow_skip_auto_db_save -obj_type root]} {set_db flow_skip_auto_db_save true}
if {[is_attribute flow_skip_auto_generate_metrics -obj_type root]} {set_db flow_skip_auto_generate_metrics false}
if {[is_attribute flow_top -obj_type root]} {set_db flow_top {}}
if {[is_attribute flow_hier_path -obj_type root]} {set_db flow_hier_path {}}
if {[is_attribute flow_schedule -obj_type root]} {set_db flow_schedule {}}
if {[is_attribute flow_step_check_tcl -obj_type root]} {set_db flow_step_check_tcl {}}
if {[is_attribute flow_script -obj_type root]} {set_db flow_script {}}
if {[is_attribute flow_yaml_script -obj_type root]} {set_db flow_yaml_script {}}
if {[is_attribute flow_cla_enabled_features -obj_type root]} {set_db flow_cla_enabled_features {}}
if {[is_attribute flow_cla_inject_tcl -obj_type root]} {set_db flow_cla_inject_tcl {}}
if {[is_attribute flow_error_message -obj_type root]} {set_db flow_error_message {}}
if {[is_attribute flow_error_errorinfo -obj_type root]} {set_db flow_error_errorinfo {}}
if {[is_attribute flow_exclude_time_for_init_flow -obj_type root]} {set_db flow_exclude_time_for_init_flow false}
if {[is_attribute flow_error_write_db -obj_type root]} {set_db flow_error_write_db true}
if {[is_attribute flow_advanced_metric_isolation -obj_type root]} {set_db flow_advanced_metric_isolation flow}
if {[is_attribute flow_yaml_root -obj_type root]} {set_db flow_yaml_root {}}
if {[is_attribute flow_yaml_root_dir -obj_type root]} {set_db flow_yaml_root_dir {}}
if {[is_attribute flow_setup_config -obj_type root]} {set_db flow_setup_config {HUDDLE {!!map {}}}}

#############################################################
#####   User Defined Attributes   ###########################

