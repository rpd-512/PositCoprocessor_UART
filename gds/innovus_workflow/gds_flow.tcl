set RUN runD
set CELL_GDS "/root/open_pdks/sky130/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds"
set MAPFILE  "./sky130_innovus.map"

restoreDesign ./$RUN/route.enc.dat coprocessor

addFiller -cell {sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1} -prefix FILL
verify_drc -report ./$RUN/drc_fill.rpt

streamOut ./$RUN/coprocessor.gds -mapFile $MAPFILE -libName DesignLib -merge $CELL_GDS -units 1000 -mode ALL
exit
