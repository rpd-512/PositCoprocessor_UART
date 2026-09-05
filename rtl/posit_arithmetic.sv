module posit_arithmetic #(
    parameter int DATA_BITS = 8,
    parameter int N_VAL     = 2
)(
    input  logic [2:0]              opcode,
    input  logic [DATA_BITS-1:0]    in1,
    input  logic [DATA_BITS-1:0]    in2,
    output logic inf,
    output logic zero,
    output logic [DATA_BITS-1:0]    out
);

    logic [DATA_BITS-1:0] as_out;   // add/sub result
    logic [DATA_BITS-1:0] md_out;   // mul/div result
    logic [DATA_BITS-1:0] ptf_out;  // posit -> float
    logic [DATA_BITS-1:0] ftp_out;  // float -> posit

    logic ad_inf, ad_zero;
    logic md_inf, md_zero;
    logic ptf_inf, ptf_zero;
    logic ftp_inf, ftp_zero;

    posit_addsub addsub_inst (
        .in1(in1), .in2(in2), .op(opcode[0]),
        .inf(ad_inf),
        .zero(ad_zero),
        .out(as_out)
    );

    posit_muldiv muldiv_inst (
        .in1(in1), .in2(in2), .op(opcode[0]),
        .inf(md_inf),
        .zero(md_zero),
        .out(md_out)
    );

    posit_to_float #(.DATA_BITS(DATA_BITS), .N_VAL(N_VAL)) to_float_inst (
        .in1(in1),
        .inf(ptf_inf),
        .zero(ptf_zero),
        .out(ptf_out)
    );

    float_to_posit #(.DATA_BITS(DATA_BITS), .N_VAL(N_VAL)) to_posit_inst (
        .in1(in1),
        .inf(ftp_inf),
        .zero(ftp_zero),
        .out(ftp_out)
    );
    logic [DATA_BITS-1:0] arith_out;
    assign arith_out = opcode[1] ? md_out : as_out;      // opcode[1]: 0=add/sub group, 1=mul/div group
    assign out        = opcode[2] ? (opcode[0] ? ftp_out : ptf_out) // opcode[2]: 1=conversion group
                                   : arith_out;
    assign inf        = opcode[2] ? (opcode[0] ? ftp_inf : ptf_inf)
                                   : (opcode[1] ? md_inf  : ad_inf);
    assign zero       = opcode[2] ? (opcode[0] ? ftp_zero : ptf_zero)
                                   : (opcode[1] ? md_zero : ad_zero);

    // 000 : ADD   - posit addition            (in1 + in2)
    // 001 : SUB   - posit subtraction         (in1 - in2)
    // 010 : MUL   - posit multiplication      (in1 * in2)
    // 011 : DIV   - posit division            (in1 / in2)
    // 100 : PTF   - posit to float conversion (float(in1), in2 unused)
    // 101 : FTP   - float to posit conversion (posit(in1), in2 unused)
    // 110 : —     - unused/reserved
    // 111 : —     - unused/reserved
endmodule
