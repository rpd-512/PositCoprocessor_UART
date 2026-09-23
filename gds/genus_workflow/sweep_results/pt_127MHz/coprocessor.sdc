# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Wed Sep 23 21:23:17 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design coprocessor

create_clock -name "clk" -period 7.87402 -waveform {0.0 3.93701} [get_ports clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.7874 [get_ports rst]
set_input_delay -clock [get_clocks clk] -add_delay 0.7874 [get_ports rx]
set_output_delay -clock [get_clocks clk] -add_delay 0.7874 [get_ports tx]
set_wire_load_mode "top"
