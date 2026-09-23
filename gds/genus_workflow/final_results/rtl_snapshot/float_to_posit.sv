// ============================================================================
// float_to_posit -- IEEE-754 binary16 (half precision) -> Posit16(es=2)
//
// Inverse of posit_to_float: half value = (-1)^s * 2^(exp-15) * (1.mant),
// posit value = (-1)^s * 2^E * (1+f). So E = exp-15 directly, and the
// posit fraction is the half-float's 10-bit mantissa padded with one zero
// LSB (11 bits total, matching posit_decoder/posit_encoder's FW).
// posit_encoder (reg_exp_op + DSR_right_N_S) is the same one posit_addsub
// uses for scR/fR -- it's expected to saturate to maxpos/minpos itself if
// E falls outside the representable regime range, same as addsub relies on.
//
// Simplifications (flag if these need to be tightened for your test suite):
//   - Half-float subnormals (exp==0, mant!=0) are flushed to signed zero
//     rather than properly decoded -- their true magnitudes are all well
//     within Posit16(es=2)'s representable range, so this does lose
//     precision on those specific inputs.
//   - Half-float +-inf and NaN (exp==11111) both map to posit NaR, since
//     posit has no signed-infinity or distinct-NaN concept.
// ============================================================================
module float_to_posit #(
    parameter int DATA_BITS = 16,
    parameter int N_VAL     = 2      // es
)(
    input  logic [DATA_BITS-1:0] in1,
    output logic inf,
    output logic zero,
    output logic [DATA_BITS-1:0] out
);

    // Hardwired to N=16/ES=2 to match posit_decoder/posit_encoder (same
    // convention posit_addsub/posit_muldiv/posit_to_float already use).
    localparam int N  = 16;
    localparam int ES = 2;
    localparam int BS = 4;          // log2(N)
    localparam int FW = N-ES-3;     // 11 -- posit fraction width

    // ---- decode the half-float input ----
    logic        s;
    logic [4:0]  hexp;
    logic [9:0]  hmant;
    assign s     = in1[15];
    assign hexp  = in1[14:10];
    assign hmant = in1[9:0];

    logic exp_zero, exp_ones, mant_zero;
    assign exp_zero  = (hexp == 5'b00000);
    assign exp_ones  = (hexp == 5'b11111);
    assign mant_zero = (hmant == 10'b0);

    logic nar_in, zero_in, subnormal_in;
    assign nar_in       = exp_ones;                 // covers both +-inf and NaN
    assign zero_in      = exp_zero & mant_zero;
    assign subnormal_in = exp_zero & ~mant_zero;     // flushed to zero, see header note

    // ---- total exponent and fraction for posit_encoder ----
    logic signed [ES+BS:0] scale_in;
    assign scale_in = $signed({2'b0, hexp}) - 8'sd15;   // E = exp - 15

    logic [FW-1:0] frac_in;
    assign frac_in = {hmant, 1'b0};    // pad 10-bit half mantissa to 11-bit posit frac

    // ---- re-encode via posit_encoder (shared with posit_addsub/muldiv) ----
    logic [N-1:0] result_normal;
    posit_encoder #(.N(N), .ES(ES), .BS(BS)) enc (
        .sign  (s),
        .scale (scale_in),
        .frac  (frac_in),
        .out   (result_normal)
    );

    always_comb begin
        if (nar_in)
            out = 16'h8000;                          // posit NaR
        else if (zero_in | subnormal_in)
            out = {s, 15'b0};                         // signed zero
        else
            out = result_normal;
    end

    assign inf  = nar_in;
    assign zero = zero_in | subnormal_in;

endmodule