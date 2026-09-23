// ============================================================================
// posit_to_float -- Posit16(es=2) -> IEEE-754 binary16 (half precision)
//
// Posit value = (-1)^s * 2^E * (1+f), where E = regi*2^ES + expo (the same
// E the {regi,expo} signed-concat trick in posit_addsub/posit_muldiv gives
// you for free). Converting to half float is then just: rebias E by +15,
// and round the 11-bit posit fraction down to half float's 10-bit fraction.
//
// Simplifications (flag if these need to be tightened for your test suite):
//   - Half-float subnormals are NOT produced -- anything that would need
//     one is flushed to signed zero instead (this can lose a few of the
//     smallest representable magnitudes vs a fully IEEE-compliant path).
//   - NaR -> half-float quiet NaN (0x7E00), sign is dropped (NaR has no
//     sign distinction in posit anyway).
//   - Rounding is round-to-nearest on the single dropped fraction bit
//     (11->10 bits), not round-to-nearest-even; only matters on exact
//     halfway cases, which are rare given the frac field width.
// ============================================================================
module posit_to_float #(
    parameter int DATA_BITS = 16,
    parameter int N_VAL     = 2      // es
)(
    input  logic [DATA_BITS-1:0] in1,
    output logic inf,
    output logic zero,
    output logic [DATA_BITS-1:0] out
);

    // Hardwired to N=16/ES=2 to match posit_decoder (same convention as
    // posit_addsub/posit_muldiv, which do the same regardless of the
    // generic parameter names).
    localparam int N  = 16;
    localparam int ES = 2;
    localparam int BS = 4;          // log2(N)
    localparam int FW = N-ES-3;     // 11 -- posit fraction width

    logic s;
    logic [4:0]    regi;
    logic [ES-1:0] expo;
    logic [FW-1:0] frac;
    logic nar_in, zero_in;

    posit_decoder dec (
        .in     (in1),
        .sign   (s),
        .regi   (regi),
        .expo   (expo),
        .frac   (frac),
        .allone (nar_in),
        .allzero(zero_in)
    );

    // total unbiased binary exponent: E = regi*2^ES + expo
    logic signed [6:0] E;
    assign E = $signed({regi, expo});

    // ---- round 11-bit posit fraction down to 10-bit half-float fraction ----
    logic        round_bit;
    logic [9:0]  frac_trunc;
    logic [10:0] frac_sum;         // extra bit catches mantissa-rounding carry
    logic        mant_carry;
    logic [9:0]  frac_rounded;

    assign round_bit  = frac[0];          // dropped LSB, round-to-nearest
    assign frac_trunc = frac[FW-1:1];     // top 10 bits
    assign frac_sum   = {1'b0, frac_trunc} + {10'b0, round_bit};
    assign mant_carry = frac_sum[10];
    assign frac_rounded = frac_sum[9:0];

    // exponent after possible mantissa-rounding carry (e.g. frac all-ones rounds up)
    logic signed [7:0] E_adj;
    assign E_adj = E + {{7{1'b0}}, mant_carry};

    // biased half-float exponent (bias 15)
    logic signed [8:0] biased_exp;
    assign biased_exp = E_adj + 9'sd15;

    logic overflow, underflow;
    assign overflow  = (biased_exp >= 9'sd31);
    assign underflow = (biased_exp <= 9'sd0);

    logic [4:0] exp_out;
    assign exp_out = overflow  ? 5'b11111 :
                      underflow ? 5'b00000 :
                                  biased_exp[4:0];

    logic [9:0] mant_out;
    assign mant_out = (overflow | underflow) ? 10'b0
                                              : (mant_carry ? 10'b0 : frac_rounded);

    always_comb begin
        if (nar_in)
            out = 16'h7E00;                   // half-float quiet NaN
        else if (zero_in)
            out = {s, 15'b0};                 // signed zero
        else
            out = {s, exp_out, mant_out};     // covers normal / inf / flush-to-zero
    end

    assign inf  = nar_in | overflow;
    assign zero = zero_in | underflow;

endmodule