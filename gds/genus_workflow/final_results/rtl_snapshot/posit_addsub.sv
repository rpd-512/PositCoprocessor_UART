// ============================================================================
// posit_addsub -- N=16, ES=2 posit adder/subtractor.
//
// Uses:
//   - posit_decoder (LOD16-based: twoscom -> LOD16 -> regime/shift extraction)
//   - posit_encoder (reg_exp_op + DSR_right_N_S -- packs sign/scale/frac back
//     into an N-bit posit). Requires reg_exp_op and DSR_right_N_S from
//     posit_primitives.sv to be compiled alongside this file.
//
// Port-width contract with the new modules (unchanged from before, just
// spelled out since a mismatch here is the usual failure mode):
//   posit_decoder :  regi[4:0], expo[ES-1:0]=[1:0], frac[FW-1:0]=[10:0]
//   posit_encoder :  scale = signed [ES+BS:0] = signed [6:0]  (== {regi,expo})
//                    frac  = [N-ES-4:0] = [10:0]              (== FW-1:0)
// scR/fR below are declared with exactly those widths, so the enc instance
// at the bottom connects directly -- no repacking needed.
// ============================================================================
module posit_addsub (
    input  logic [15:0] in1,
    input  logic [15:0] in2,
    input  logic        op,      // 0 = add, 1 = subtract
    output logic [15:0] out,
    output logic        inf,
    output logic        zero
);

    localparam int N   = 16;
    localparam int ES  = 2;
    localparam int BS  = 4;         // log2(N)
    localparam int FW  = N-ES-3;    // fraction width posit_decoder gives you (11 for es=2)

    // ---- decode both operands ----
    logic s1, s2;
    logic [4:0] r1, r2;
    logic [ES-1:0] e1, e2;
    logic [FW-1:0] f1, f2;
    logic ao1, az1, ao2, az2;

    posit_decoder dec1 (.in(in1), .sign(s1), .regi(r1), .expo(e1), .frac(f1), .allone(ao1), .allzero(az1));
    posit_decoder dec2 (.in(in2), .sign(s2), .regi(r2), .expo(e2), .frac(f2), .allone(ao2), .allzero(az2));

    logic s2e;
    assign s2e = s2 ^ op;                // flip in2's sign for subtract

    // regi/expo concatenated in two's complement == regi*2^ES + expo
    logic signed [ES+BS:0] sc1, sc2;
    assign sc1 = {r1, e1};
    assign sc2 = {r2, e2};

    // ---- special cases ----
    logic [15:0] in2_neg;
    assign in2_neg = -in2;               // posit negate == two's complement

    logic nar_case, both_zero, z1_case, z2_case;
    assign nar_case  = ao1 | ao2;
    assign both_zero = az1 & az2;
    assign z1_case   = az1 & ~az2;
    assign z2_case   = az2 & ~az1;

    // ---- order by magnitude (scale first, then fraction) ----
    logic in1_ge_in2;
    assign in1_ge_in2 = (sc1 != sc2) ? (sc1 > sc2) : (f1 >= f2);

    logic sL, sS;
    logic signed [ES+BS:0] scL, scS;
    logic [FW-1:0] fL, fS;
    assign sL  = in1_ge_in2 ? s1  : s2e;
    assign sS  = in1_ge_in2 ? s2e : s1;
    assign scL = in1_ge_in2 ? sc1 : sc2;
    assign scS = in1_ge_in2 ? sc2 : sc1;
    assign fL  = in1_ge_in2 ? f1  : f2;
    assign fS  = in1_ge_in2 ? f2  : f1;

    localparam int GRD  = 3;             // guard+round+sticky headroom
    localparam int EFW  = FW + GRD;      // extended fraction width for the datapath
    localparam int PADE = 15 - EFW;      // zero-pad width to fill LOD16's 16-bit input

    logic [EFW:0] mL, mS;
    assign mL = {1'b1, fL, {GRD{1'b0}}};
    assign mS = {1'b1, fS, {GRD{1'b0}}};

    // ---- align, keeping a sticky bit for what falls off the bottom ----
    logic signed [ES+BS+1:0] diff_s;
    logic [4:0] diff;
    assign diff_s = scL - scS;
    assign diff   = (diff_s > EFW+1) ? (EFW+2) : diff_s[4:0];

    logic [EFW:0] mS_shift;
    logic sticky;
    assign sticky   = (diff > EFW) ? (|mS) : (|(mS & ((1 << diff) - 1)));
    assign mS_shift = (mS >> diff) | sticky;

    logic same_sign;
    assign same_sign = (sL == sS);

    logic [EFW+1:0] sum;
    assign sum = same_sign ? ({1'b0, mL} + {1'b0, mS_shift})
                            : ({1'b0, mL} - {1'b0, mS_shift});

    // ---- normalize (reuse LOD16 for the cancellation case) ----
    logic [15:0] lod_in;
    logic [3:0]  k;
    assign lod_in = {sum[EFW:0], {PADE{1'b0}}};   // pad up to 16 bits for LOD16
    LOD16 lod_norm (.in(lod_in), .k(k), .vld());  // vld unused

    logic [15:0] shifted;
    assign shifted = lod_in << k;        // shift by k, not k+1

    logic signed [ES+BS:0] scR;
    logic [FW-1:0] fR;
    logic zero_res;
    logic [EFW-1:0] fR_ext;              // extended result before final rounding

    always_comb begin
        zero_res = 1'b0;
        if (sum == 0) begin
            scR = '0; fR_ext = '0; zero_res = 1'b1;
        end else if (same_sign && sum[EFW+1]) begin
            scR    = scL + 1'b1;
            fR_ext = sum[EFW:1];
        end else if (!same_sign && !sum[EFW]) begin
            scR    = scL - {1'b0, k};
            fR_ext = shifted[14:PADE];
        end else begin
            scR    = scL;
            fR_ext = sum[EFW-1:0];
        end
    end

    // ---- round EFW-bit fraction down to FW bits (round-to-nearest) ----
    logic round_bit, sticky_after, roundup;
    assign round_bit    = fR_ext[GRD-1];
    assign sticky_after = |fR_ext[GRD-2:0];
    assign roundup       = round_bit & (sticky_after | fR_ext[GRD]);
    assign fR = fR_ext[EFW-1:GRD] + roundup;

    // ---- re-encode: via posit_encoder (reg_exp_op / DSR_right_N_S based) ----
    logic [N-1:0] result_normal_raw;
    posit_encoder #(.N(N), .ES(ES), .BS(BS)) enc (
        .sign  (sL),
        .scale (scR),
        .frac  (fR),
        .out   (result_normal_raw)
    );

    // ---- output + flags ----
    always_comb begin
        if (nar_case)        out = 16'h8000;
        else if (both_zero)  out = 16'h0000;
        else if (z1_case)    out = op ? in2_neg : in2;
        else if (z2_case)    out = in1;
        else                 out = zero_res ? {N{1'b0}} : result_normal_raw;
    end

    assign inf  = out[15] & ~(|out[14:0]);  // NaR = 1000_0000_0000_0000
    assign zero = out == 16'h0000;

endmodule