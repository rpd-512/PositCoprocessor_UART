module LOD2(
    input  logic [1:0] in,
    output logic k,
    output logic vld
);
    assign k = ~in[1];
    assign vld = in[1] | in[0];
endmodule

module LOD4(
    input  logic [3:0] in,
    output logic [1:0] k,
    output logic vld
);
    assign k[1] = ~( |in[3:2] );
    assign k[0] = (in[2] | ~in[1]) & ~in[3];
    assign vld = in[3] | in[2] | in[1] | in[0];
endmodule

module LOD8 (
    input  logic [7:0] in,
    output logic [2:0] k,
    output logic vld
);
    logic [1:0] k1, k2;
    logic v1, v2;
    logic o1,o2;
    logic a1,a2;

    LOD4 L1 (.in(in[3:0]), .k(k1), .vld(v1));
    LOD4 L2 (.in(in[7:4]), .k(k2), .vld(v2));

    //OR Block
    assign o1 = k1[0] | v2;
    assign o2 = k1[1] | v2;

    //AND Block
    assign k[0] = k2[0] & o1;
    assign k[1] = k2[1] & o2;

    assign k[2] = ~v2;
    assign vld = v1 | v2;
endmodule


module LOD16 (
    input  logic [15:0] in,
    output logic [3:0]  k,
    output logic        vld
);
    logic [2:0] k1, k2;
    logic v1, v2;
    logic o1,o2,o3;
    logic a1,a2,a3;

    LOD8 L1 (.in(in[7:0]), .k(k1), .vld(v1));
    LOD8 L2 (.in(in[15:8]), .k(k2), .vld(v2));

    //OR Block
    assign o1 = k1[0] | v2;
    assign o2 = k1[1] | v2;
    assign o3 = k1[2] | v2;

    //AND Block
    assign k[0] = k2[0] & o1;
    assign k[1] = k2[1] & o2;
    assign k[2] = k2[2] & o3;

    assign k[3] = ~v2;
    assign vld = v1 | v2;
endmodule

// ============================================================================
// Module: left_shifter
// ============================================================================
module left_shifter (
    output logic [14:0] out,
    input  logic [14:0] in,
    input  logic [3:0]  k
);

    always_comb begin
        case (k)
            4'd0:  out = in << 1;
            4'd1:  out = in << 2;
            4'd2:  out = in << 3;
            4'd3:  out = in << 4;
            4'd4:  out = in << 5;
            4'd5:  out = in << 6;
            4'd6:  out = in << 7;
            4'd7:  out = in << 8;
            4'd8:  out = in << 9;
            4'd9:  out = in << 10;
            4'd10: out = in << 11;
            4'd11: out = in << 12;
            4'd12: out = in << 13;
            4'd13: out = in << 14;
            4'd14: out = in << 15;
            4'd15: out = in << 16;
            default: out = 15'b0;
        endcase
    end

endmodule

// ============================================================================
// Module: shift
// ============================================================================
module shift (
    output logic        expo,
    output logic [11:0] frac,
    input  logic [14:0] xin,
    input  logic [3:0]  k
);

    logic [14:0] sh0;

    left_shifter s0 (
        .out(sh0),
        .in(xin),
        .k(k)
    );

    assign expo = sh0[14];
    assign frac = sh0[13:2];

endmodule

// ============================================================================
// Module: twoscom (2's Complement Logic)
// ============================================================================
module twoscom #(
    parameter int N = 16
)(
    output logic [N-2:0] out,
    input  logic [N-1:0] in
);

    always_comb begin
        case (in[N-1])
            1'b0: out = in[N-2:0];
            1'b1: out = ~in[N-2:0] + 1'b1;
        endcase
    end

endmodule

// ============================================================================
// Module: posit_decoder (Top-Level Decoder Module)
// ============================================================================
module posit_decoder (
    input  logic [15:0] in,
    output logic        sign,
    output logic [4:0]  regi,
    output logic        expo,
    output logic [11:0] frac,
    output logic        allone,
    output logic        allzero
);

    assign sign = in[15];

    logic [14:0] twos_in;
    logic [15:0] lod_in;
    logic [3:0]  k;
    logic [4:0]  k0;
    logic        vld;

    assign k0[4]   = 1'b0;
    assign k0[3:0] = k;

    // 2's Complement conversion
    twoscom #(.N(16)) t0 (
        .out(twos_in),
        .in(in)
    );

    // Prepare input for Leading One Detector
    always_comb begin
        case (twos_in[14])
            1'b0: begin
                lod_in[15:1] = twos_in;
                lod_in[0]    = 1'b1;
            end
            1'b1: begin
                lod_in[15:1] = ~twos_in;
                lod_in[0]    = 1'b1;
            end
        endcase
    end

    // Instantiation of LOD16
    LOD16 l0 (
        .in(lod_in),
        .k(k),
        .vld(vld)
    );

    // Regime calculation
    always_comb begin
        case (twos_in[14])
            1'b0: regi = ~(k0 - 1'b1);
            1'b1: regi = k0 - 1'b1;
        endcase
    end

    // Shift logic for exponent & fraction extraction
    shift s0 (
        .expo(expo),
        .frac(frac),
        .xin(twos_in),
        .k(k)
    );

    // Special cases identification
    always_comb begin
        case ({twos_in[14], k})
            5'b01111: begin
                allone  = 1'b0;
                allzero = 1'b1;
            end
            5'b11111: begin
                allone  = 1'b1;
                allzero = 1'b0;
            end
            default: begin
                allone  = 1'b0;
                allzero = 1'b0;
            end
        endcase
    end

endmodule
