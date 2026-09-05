module posit_arithmetic #(
    parameter int DATA_BITS = 8,
    parameter int N_VAL     = 2
)(
    input  logic [2:0]              opcode,
    input  logic [DATA_BITS-1:0]    in1,
    input  logic [DATA_BITS-1:0]    in2,
    output logic [DATA_BITS-1:0]    out
);

    logic [DATA_BITS-1:0] as_out;   // add/sub result
    logic [DATA_BITS-1:0] md_out;   // mul/div result
    logic [DATA_BITS-1:0] ptf_out;  // posit -> float
    logic [DATA_BITS-1:0] ftp_out;  // float -> posit

    posit_addsub #(
        .DATA_BITS(DATA_BITS),
        .N_VAL(N_VAL)
    ) addsub_inst (
        .in1(in1),
        .in2(in2),
        .op(opcode[0]),
        .out(as_out)
    );

    posit_muldiv #(
        .DATA_BITS(DATA_BITS),
        .N_VAL(N_VAL)
    ) muldiv_inst (
        .in1(in1),
        .in2(in2),
        .op(opcode[0]),
        .out(md_out)
    );

    posit_to_float #(
        .DATA_BITS(DATA_BITS),
        .N_VAL(N_VAL)
    ) to_float_inst (
        .in1(in1),
        .out(ptf_out)
    );

    float_to_posit #(
        .DATA_BITS(DATA_BITS),
        .N_VAL(N_VAL)
    ) to_posit_inst (
        .in1(in1),
        .out(ftp_out)
    );

    logic [DATA_BITS-1:0] arith_out;
    assign arith_out = opcode[1] ? md_out : as_out;      // opcode[1]: 0=add/sub group, 1=mul/div group
    assign out        = opcode[2] ? (opcode[0] ? ftp_out : ptf_out) // opcode[2]: 1=conversion group
                                   : arith_out;
    // 000 : ADD   - posit addition            (in1 + in2)
    // 001 : SUB   - posit subtraction         (in1 - in2)
    // 010 : MUL   - posit multiplication      (in1 * in2)
    // 011 : DIV   - posit division            (in1 / in2)
    // 100 : PTF   - posit to float conversion (float(in1), in2 unused)
    // 101 : FTP   - float to posit conversion (posit(in1), in2 unused)
    // 110 : —     - unused/reserved
    // 111 : —     - unused/reserved
endmodule


module posit_addsub #(
    parameter int DATA_BITS = 8,
    parameter int N_VAL     = 2
)(
    input  logic [DATA_BITS-1:0] in1,
    input  logic [DATA_BITS-1:0] in2,
    input  logic                  op, // 0=add, 1=sub
    output logic [DATA_BITS-1:0] out
);
    logic [DATA_BITS-1:0] n1, n2;
    assign n1 = in1;
    assign n2 = op ? ~in2 + 1'b1 : in2; // 2's complement for subtraction

    assign out = n1 + n2; //testing
endmodule

module posit_muldiv #(
    parameter int DATA_BITS = 8,
    parameter int N_VAL     = 2
)(
    input  logic [DATA_BITS-1:0] in1,
    input  logic [DATA_BITS-1:0] in2,
    input  logic                  op, // 0=mul, 1=div
    output logic [DATA_BITS-1:0] out
);
    logic [DATA_BITS-1:0] n1, n2;
    assign n1 = in1;
    assign n2 = op ? 1/in2 + 1'b1 : in2; // 2's complement for subtraction

    assign out = n1 * n2; //testing
endmodule

module posit_to_float #(
    parameter int DATA_BITS = 8,
    parameter int N_VAL     = 2
)(
    input  logic [DATA_BITS-1:0] in1,
    output logic [DATA_BITS-1:0] out
);
    assign out = in1; // Placeholder for actual conversion logic
endmodule

module float_to_posit #(
    parameter int DATA_BITS = 8,
    parameter int N_VAL     = 2
)(
    input  logic [DATA_BITS-1:0] in1,
    output logic [DATA_BITS-1:0] out
);
    assign out = in1; // Placeholder for actual conversion logic
endmodule