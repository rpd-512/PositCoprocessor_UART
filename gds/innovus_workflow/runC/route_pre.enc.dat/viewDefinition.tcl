if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name LIB_TYP\
   -timing\
    [list ${::IMEX::libVar}/mmmc/sky130_fd_sc_hd__tt_025C_1v80.lib]
create_rc_corner -name RC_TYP\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name DELAY_TYP\
   -library_set LIB_TYP\
   -rc_corner RC_TYP
create_constraint_mode -name CONSTRAINTS\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name VIEW_TYP -constraint_mode CONSTRAINTS -delay_corner DELAY_TYP
set_analysis_view -setup [list VIEW_TYP] -hold [list VIEW_TYP]
