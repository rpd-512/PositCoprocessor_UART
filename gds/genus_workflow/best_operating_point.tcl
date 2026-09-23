# ============================================================
# Genus PPA Sweep — PositCoprocessor_UART (sky130_fd_sc_hd)
# Run from: PositCoprocessor_UART/gds/genus_workflow/
# ============================================================

# ---- User-editable setup ----
set TOP_MODULE   "coprocessor"     ;# <-- confirm this is your actual top module name
set RTL_DIR      "../../rtl"
set RTL_FILES [list \
    $RTL_DIR/posit_primitives.sv \
    $RTL_DIR/posit_decoder.sv \
    $RTL_DIR/posit_encoder.sv \
    $RTL_DIR/posit_addsub.sv \
    $RTL_DIR/posit_muldiv.sv \
    $RTL_DIR/posit_to_float.sv \
    $RTL_DIR/float_to_posit.sv \
    $RTL_DIR/posit_arithmetic.sv \
    $RTL_DIR/uart_head.sv \
    $RTL_DIR/coprocessor.sv \
]

set LIB_FILES    "../lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

set OUT_DIR      "./sweep_results"
set FREQ_LIST    {50 75 100 125 150 175 200 250 300}   ;# MHz — sky130 HD std cells, adjust as needed
set CSV_PATH     "$OUT_DIR/sweep_results.csv"

file mkdir $OUT_DIR

# ---- Library / design setup (once) ----
set_db init_lib_search_path [list [file dirname $LIB_FILES]]
set_db library $LIB_FILES

read_hdl -sv $RTL_FILES
elaborate $TOP_MODULE

# ---- CSV header ----
set csv_file [open $CSV_PATH w]
puts $csv_file "freq_mhz,period_ns,wns_ns,tns_ns,area_um2,leakage_power_uw,dynamic_power_uw,total_power_uw,timing_met"
close $csv_file

# ---- Track best point ----
set best_freq 0
set best_score -1e30
set last_passing_freq 0

foreach freq $FREQ_LIST {

    puts "\n===== Running freq = ${freq} MHz ====="
    set period [expr {1000.0 / $freq}]

    reset_design -timing;
    create_clock -name clk -period $period [get_ports clk]
    set_input_delay  [expr {$period * 0.1}] -clock clk [all_inputs -no_clocks]
    set_output_delay [expr {$period * 0.1}] -clock clk [all_outputs]

    if {[catch {
        syn_generic
        syn_map
        syn_opt
    } err]} {
        puts "WARNING: synthesis failed at ${freq} MHz: $err"
        continue
    }

    set area_rpt   "$OUT_DIR/area_${freq}.rpt"
    set power_rpt  "$OUT_DIR/power_${freq}.rpt"
    set timing_rpt "$OUT_DIR/timing_${freq}.rpt"

    report_area   > $area_rpt
    report_power  > $power_rpt
    report_timing > $timing_rpt

    set area_val 0
    set leak_val 0
    set dyn_val  0
    set tot_val  0
    set wns_val  0
    set tns_val  0

    set fh [open $area_rpt r];   set area_data   [read $fh]; close $fh
    set fh [open $power_rpt r];  set power_data  [read $fh]; close $fh
    set fh [open $timing_rpt r]; set timing_data [read $fh]; close $fh

    regexp {Total Area:\s*([0-9.]+)}            $area_data   -> area_val
    regexp {Leakage Power:\s*([0-9.eE+-]+)}     $power_data  -> leak_val
    regexp {Dynamic Power:\s*([0-9.eE+-]+)}     $power_data  -> dyn_val
    regexp {Total Power:\s*([0-9.eE+-]+)}       $power_data  -> tot_val
    regexp {WNS:\s*(-?[0-9.]+)}                 $timing_data -> wns_val
    regexp {TNS:\s*(-?[0-9.]+)}                 $timing_data -> tns_val

    set timing_met [expr {$wns_val >= 0} ? 1 : 0]

    set csv_file [open $CSV_PATH a]
    puts $csv_file "$freq,$period,$wns_val,$tns_val,$area_val,$leak_val,$dyn_val,$tot_val,$timing_met"
    close $csv_file

    if {$timing_met} {
        set last_passing_freq $freq
        set w_area  1.0
        set w_power 1.0
        set score [expr {$freq*1.0 - ($w_area * $area_val * 0.001) - ($w_power * $tot_val * 0.01)}]
        if {$score > $best_score} {
            set best_score $score
            set best_freq  $freq
        }
    }
}

puts "\n===== SWEEP COMPLETE ====="
puts "Fastest timing-clean frequency: ${last_passing_freq} MHz"
puts "Best PPA-weighted operating point: ${best_freq} MHz (score=${best_score})"
puts "Full results in: $CSV_PATH"
