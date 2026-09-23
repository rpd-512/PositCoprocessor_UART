
//input ports
add mapped point clk clk -type PI PI
add mapped point rst rst -type PI PI
add mapped point rx rx -type PI PI

//output ports
add mapped point tx tx -type PO PO

//inout ports




//Sequential Pins
add mapped point uart_inst/uart_tx_inst/tx/q uart_inst_uart_tx_inst_tx_reg/Q -type DFF DFF
add mapped point uart_tx_start/q uart_tx_start_reg/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/rx_sync/q uart_inst_uart_rx_inst_rx_sync_reg/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/rx_ff1/q uart_inst_uart_rx_inst_rx_ff1_reg/Q -type DFF DFF
add mapped point in1_r[0]/q in1_r_reg[0]/Q -type DFF DFF
add mapped point in1_r[1]/q in1_r_reg[1]/Q -type DFF DFF
add mapped point in1_r[2]/q in1_r_reg[2]/Q -type DFF DFF
add mapped point in1_r[3]/q in1_r_reg[3]/Q -type DFF DFF
add mapped point in1_r[4]/q in1_r_reg[4]/Q -type DFF DFF
add mapped point in1_r[5]/q in1_r_reg[5]/Q -type DFF DFF
add mapped point in1_r[6]/q in1_r_reg[6]/Q -type DFF DFF
add mapped point in1_r[7]/q in1_r_reg[7]/Q -type DFF DFF
add mapped point in1_r[8]/q in1_r_reg[8]/Q -type DFF DFF
add mapped point in1_r[9]/q in1_r_reg[9]/Q -type DFF DFF
add mapped point in1_r[10]/q in1_r_reg[10]/Q -type DFF DFF
add mapped point in1_r[11]/q in1_r_reg[11]/Q -type DFF DFF
add mapped point in1_r[12]/q in1_r_reg[12]/Q -type DFF DFF
add mapped point in1_r[13]/q in1_r_reg[13]/Q -type DFF DFF
add mapped point in1_r[14]/q in1_r_reg[14]/Q -type DFF DFF
add mapped point in1_r[15]/q in1_r_reg[15]/Q -type DFF DFF
add mapped point in2_r[0]/q in2_r_reg[0]/Q -type DFF DFF
add mapped point in2_r[1]/q in2_r_reg[1]/Q -type DFF DFF
add mapped point in2_r[2]/q in2_r_reg[2]/Q -type DFF DFF
add mapped point in2_r[3]/q in2_r_reg[3]/Q -type DFF DFF
add mapped point in2_r[4]/q in2_r_reg[4]/Q -type DFF DFF
add mapped point in2_r[5]/q in2_r_reg[5]/Q -type DFF DFF
add mapped point in2_r[6]/q in2_r_reg[6]/Q -type DFF DFF
add mapped point in2_r[7]/q in2_r_reg[7]/Q -type DFF DFF
add mapped point in2_r[8]/q in2_r_reg[8]/Q -type DFF DFF
add mapped point in2_r[9]/q in2_r_reg[9]/Q -type DFF DFF
add mapped point in2_r[10]/q in2_r_reg[10]/Q -type DFF DFF
add mapped point in2_r[11]/q in2_r_reg[11]/Q -type DFF DFF
add mapped point in2_r[12]/q in2_r_reg[12]/Q -type DFF DFF
add mapped point in2_r[13]/q in2_r_reg[13]/Q -type DFF DFF
add mapped point in2_r[14]/q in2_r_reg[14]/Q -type DFF DFF
add mapped point in2_r[15]/q in2_r_reg[15]/Q -type DFF DFF
add mapped point opcode_r[0]/q opcode_r_reg[0]/Q -type DFF DFF
add mapped point opcode_r[1]/q opcode_r_reg[1]/Q -type DFF DFF
add mapped point opcode_r[2]/q opcode_r_reg[2]/Q -type DFF DFF
add mapped point result_r[0]/q result_r_reg[0]/Q -type DFF DFF
add mapped point result_r[1]/q result_r_reg[1]/Q -type DFF DFF
add mapped point result_r[2]/q result_r_reg[2]/Q -type DFF DFF
add mapped point result_r[3]/q result_r_reg[3]/Q -type DFF DFF
add mapped point result_r[4]/q result_r_reg[4]/Q -type DFF DFF
add mapped point result_r[5]/q result_r_reg[5]/Q -type DFF DFF
add mapped point result_r[6]/q result_r_reg[6]/Q -type DFF DFF
add mapped point result_r[7]/q result_r_reg[7]/Q -type DFF DFF
add mapped point result_r[8]/q result_r_reg[8]/Q -type DFF DFF
add mapped point result_r[9]/q result_r_reg[9]/Q -type DFF DFF
add mapped point result_r[10]/q result_r_reg[10]/Q -type DFF DFF
add mapped point result_r[11]/q result_r_reg[11]/Q -type DFF DFF
add mapped point result_r[12]/q result_r_reg[12]/Q -type DFF DFF
add mapped point result_r[13]/q result_r_reg[13]/Q -type DFF DFF
add mapped point result_r[14]/q result_r_reg[14]/Q -type DFF DFF
add mapped point result_r[15]/q result_r_reg[15]/Q -type DFF DFF
add mapped point status_r[0]/q status_r_reg[0]/Q -type DFF DFF
add mapped point status_r[1]/q status_r_reg[1]/Q -type DFF DFF
add mapped point uart_inst/baud_gen_inst/count[0]/q uart_inst_baud_gen_inst_count_reg[0]/Q -type DFF DFF
add mapped point uart_inst/baud_gen_inst/count[1]/q uart_inst_baud_gen_inst_count_reg[1]/Q -type DFF DFF
add mapped point uart_inst/baud_gen_inst/count[2]/q uart_inst_baud_gen_inst_count_reg[2]/Q -type DFF DFF
add mapped point uart_inst/baud_gen_inst/count[3]/q uart_inst_baud_gen_inst_count_reg[3]/Q -type DFF DFF
add mapped point uart_inst/baud_gen_inst/count[4]/q uart_inst_baud_gen_inst_count_reg[4]/Q -type DFF DFF
add mapped point uart_inst/baud_gen_inst/tick/q uart_inst_baud_gen_inst_tick_reg/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/bit_count[1]/q uart_inst_uart_rx_inst_bit_count_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[0]/q uart_inst_uart_rx_inst_data_rx_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[1]/q uart_inst_uart_rx_inst_data_rx_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[2]/q uart_inst_uart_rx_inst_data_rx_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[3]/q uart_inst_uart_rx_inst_data_rx_reg[3]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[4]/q uart_inst_uart_rx_inst_data_rx_reg[4]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[5]/q uart_inst_uart_rx_inst_data_rx_reg[5]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[6]/q uart_inst_uart_rx_inst_data_rx_reg[6]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/data_rx[7]/q uart_inst_uart_rx_inst_data_rx_reg[7]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/rx_valid/q uart_inst_uart_rx_inst_rx_valid_reg/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[0]/q uart_inst_uart_rx_inst_shift_reg_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[1]/q uart_inst_uart_rx_inst_shift_reg_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[2]/q uart_inst_uart_rx_inst_shift_reg_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[3]/q uart_inst_uart_rx_inst_shift_reg_reg[3]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[4]/q uart_inst_uart_rx_inst_shift_reg_reg[4]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[5]/q uart_inst_uart_rx_inst_shift_reg_reg[5]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[6]/q uart_inst_uart_rx_inst_shift_reg_reg[6]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/shift_reg[7]/q uart_inst_uart_rx_inst_shift_reg_reg[7]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/tick_count[0]/q uart_inst_uart_rx_inst_tick_count_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/tick_count[1]/q uart_inst_uart_rx_inst_tick_count_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/tick_count[2]/q uart_inst_uart_rx_inst_tick_count_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/tick_count[3]/q uart_inst_uart_rx_inst_tick_count_reg[3]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/bit_count[0]/q uart_inst_uart_tx_inst_bit_count_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/bit_count[1]/q uart_inst_uart_tx_inst_bit_count_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/bit_count[2]/q uart_inst_uart_tx_inst_bit_count_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[0]/q uart_inst_uart_tx_inst_shift_reg_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[1]/q uart_inst_uart_tx_inst_shift_reg_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[2]/q uart_inst_uart_tx_inst_shift_reg_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[3]/q uart_inst_uart_tx_inst_shift_reg_reg[3]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[4]/q uart_inst_uart_tx_inst_shift_reg_reg[4]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[5]/q uart_inst_uart_tx_inst_shift_reg_reg[5]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[6]/q uart_inst_uart_tx_inst_shift_reg_reg[6]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/shift_reg[7]/q uart_inst_uart_tx_inst_shift_reg_reg[7]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/state[0]/q uart_inst_uart_tx_inst_state_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/state[1]/q uart_inst_uart_tx_inst_state_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/tick_count[0]/q uart_inst_uart_tx_inst_tick_count_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/tick_count[1]/q uart_inst_uart_tx_inst_tick_count_reg[1]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/tick_count[2]/q uart_inst_uart_tx_inst_tick_count_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/tick_count[3]/q uart_inst_uart_tx_inst_tick_count_reg[3]/Q -type DFF DFF
add mapped point uart_inst/uart_tx_inst/tx_done/q uart_inst_uart_tx_inst_tx_done_reg/Q -type DFF DFF
add mapped point uart_tx_data[0]/q uart_tx_data_reg[0]/Q -type DFF DFF
add mapped point uart_tx_data[1]/q uart_tx_data_reg[1]/Q -type DFF DFF
add mapped point uart_tx_data[2]/q uart_tx_data_reg[2]/Q -type DFF DFF
add mapped point uart_tx_data[3]/q uart_tx_data_reg[3]/Q -type DFF DFF
add mapped point uart_tx_data[4]/q uart_tx_data_reg[4]/Q -type DFF DFF
add mapped point uart_tx_data[5]/q uart_tx_data_reg[5]/Q -type DFF DFF
add mapped point uart_tx_data[6]/q uart_tx_data_reg[6]/Q -type DFF DFF
add mapped point uart_tx_data[7]/q uart_tx_data_reg[7]/Q -type DFF DFF
add mapped point byte_cnt[0]/q byte_cnt_reg[0]/Q -type DFF DFF
add mapped point state[0]/q state_reg[0]/Q -type DFF DFF
add mapped point state[1]/q state_reg[1]/Q -type DFF DFF
add mapped point state[2]/q state_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/bit_count[0]/q uart_inst_uart_rx_inst_bit_count_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/bit_count[2]/q uart_inst_uart_rx_inst_bit_count_reg[2]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/state[0]/q uart_inst_uart_rx_inst_state_reg[0]/Q -type DFF DFF
add mapped point uart_inst/uart_rx_inst/state[1]/q uart_inst_uart_rx_inst_state_reg[1]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
