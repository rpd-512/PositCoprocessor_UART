module coprocessor#(
    parameter int DATA_BITS   = 8,

    parameter int BAUD_RATE = 115200,
    parameter int CLK_FREQ = 50000000,
    parameter int OVER_SAMPLE = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic tx_start,
    input  logic rx,
    input  logic [DATA_BITS-1:0] tx_data,
    output logic [DATA_BITS-1:0] rx_data,
    output logic tx,
    output logic rx_valid,
    output logic tx_busy,
    output logic tx_done,
    output logic rx_busy
);

    uart_head#(
        parameter int DATA_BITS   = 8,

        parameter int BAUD_RATE = 115200,
        parameter int CLK_FREQ = 50000000,
        parameter int OVER_SAMPLE = 16
    )(
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .rx(rx),
        .tx_data(tx_data),
        .rx_data(rx_data),
        .tx(tx),
        .rx_valid(rx_valid),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_busy(rx_busy)
    );

endmodule