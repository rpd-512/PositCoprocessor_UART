module posit_head#(
    parameter int DATA_BITS   = 8,
    parameter int N_VAL = 2
)(
    input logic[2:0] opcode,
    input logic[DATA_BITS-1:0] in1,
    input logic[DATA_BITS-1:0] in2,
    output logic[DATA_BITS-1:0] out
);



endmodule