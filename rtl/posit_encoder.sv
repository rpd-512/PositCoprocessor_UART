// ============================================================================
// posit_encoder -- the inverse of posit_decoder. Packs (sign, scale, frac)
// back into an N-bit posit bit pattern. This is exactly the re-encode stage
// already inlined at the end of posit_addsub/posit_muldiv, pulled out into
// its own module so those (and anything else) can call it instead of
// duplicating the packing logic.
//
// `scale` is regime*2^ES + exponent -- i.e. exactly what posit_decoder's
// {regi, expo} concatenation produces (see posit_addsub's sc1/sc2).
// `frac` is FW = N-ES-3 bits (11 for N=16, es=2), matching posit_decoder's
// frac output width.
//
// This module only packs a *normal* (nonzero, non-NaR) value. Zero and NaR
// are still the caller's job, same as they already are in addsub/muldiv --
// this only replaces the reg_exp_op/DSR_right_N_S/sign-twiddle plumbing.
//
// Depends on reg_exp_op and DSR_right_N_S (rtl/posit_primitives.sv).
// ============================================================================
module posit_encoder #(
    parameter int N  = 16,
    parameter int ES = 2,
    parameter int BS = 4                       // log2(N)
)(
    input  logic                    sign,
    input  logic signed [ES+BS:0]   scale,      // regime*2^ES + exponent
    input  logic [N-ES-4:0]         frac,       // FW-1:0, FW = N-ES-3
    output logic [N-1:0]            out
);

    localparam int FW = N - ES - 3;

    logic [ES-1:0] e_o;
    logic [BS-1:0] r_o;
    reg_exp_op #(.es(ES), .Bs(BS)) uut_reg_ro (scale, e_o, r_o);

    logic [2*N-1+3:0] tmp_o;
    assign tmp_o = { {N{~scale[ES+BS]}}, scale[ES+BS], e_o, frac, 5'b0 };

    logic [3*N-1+3:0] tmp1_o;
    DSR_right_N_S #(.N(3*N+3), .S(BS)) dsr_pack (.a({tmp_o, {N{1'b0}}}), .b(r_o), .c(tmp1_o));

    logic [N-1:0] packed_mag, tmp1_oN;
    assign packed_mag = tmp1_o[2*N-1+3:N+3];
    assign tmp1_oN     = sign ? -packed_mag : packed_mag;
    assign out         = {sign, tmp1_oN[N-1:1]};

endmodule