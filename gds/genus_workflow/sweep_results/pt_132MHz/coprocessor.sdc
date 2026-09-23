# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Wed Sep 23 20:17:30 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design coprocessor

create_clock -name "clk" -period 7.57576 -waveform {0.0 3.78788} [get_ports clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.7576 [get_ports rst]
set_input_delay -clock [get_clocks clk] -add_delay 0.7576 [get_ports rx]
set_output_delay -clock [get_clocks clk] -add_delay 0.7576 [get_ports tx]
set_wire_load_mode "top"
