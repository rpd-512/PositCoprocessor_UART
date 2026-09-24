set RUN runD
set CELL_GDS "/root/open_pdks/sky130/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds"
set MAPFILE  "./sky130_innovus.map"

restoreDesign ./$RUN/route.enc.dat coprocessor
verify_drc -report ./$RUN/drc_gdscheck.rpt
streamOut ./$RUN/coprocessor_nofill.gds -mapFile $MAPFILE -libName DesignLib -merge $CELL_GDS -units 1000 -mode ALL
exit
