set LIB "../lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
create_library_set -name LIB_TYP -timing [list $LIB]
create_rc_corner -name RC_TYP
create_delay_corner -name DELAY_TYP -library_set LIB_TYP -rc_corner RC_TYP
create_constraint_mode -name CONSTRAINTS -sdc_files [list "./runC/pt/coprocessor.sdc"]
create_analysis_view -name VIEW_TYP -constraint_mode CONSTRAINTS -delay_corner DELAY_TYP
set_analysis_view -setup [list VIEW_TYP] -hold [list VIEW_TYP]
