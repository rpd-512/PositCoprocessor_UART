# UNTESTED template. Add an RC corner (create_rc_corner) if your flow needs one,
# and pass it to create_delay_corner with -rc_corner.
create_library_set     -name lib_tt -timing [list /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/lib/sky130_fd_sc_hd__tt_025C_1v80.lib]
create_constraint_mode -name cm_func -sdc_files [list /home/harshit/Desktop/rtltogds6/synth/.testing_pluto/PositCoprocessor_UART/gds/genus_workflow/final_results/coprocessor.sdc]
create_delay_corner    -name dc_tt -library_set lib_tt
create_analysis_view   -name av_tt -constraint_mode cm_func -delay_corner dc_tt
set_analysis_view -setup [list av_tt] -hold [list av_tt]
