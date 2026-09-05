#!/usr/bin/env python3
"""Extensive test suite for the posit coprocessor over serial.

Protocol (see coprocessor.sv): standard 8-bit UART. Each 16-bit field
(in1, in2, result) is sent/received as two back-to-back 8-bit frames,
MSB byte first. Opcode and status are each a single 8-bit frame.

This suite goes well beyond a handful of smoke-test values. It's split
into independent categories so you can run all of them or just one
while chasing a specific bug:

  identities    a+0=a, a-a=0, a*1=a, a*0=0, a/1=a, a/a=1 (a!=0)
  magnitude     add/sub/mul/div across a wide sweep of magnitudes
  signs         all four sign combinations for each op
  edge          zero/zero combos, div-by-zero, NaR propagation, over/underflow
  commute       a+b==b+a and a*b==b*a (order shouldn't matter)
  fuzz          randomized pairs across a log-uniform magnitude range

VALUE vs FLAGS are graded and reported *separately*. A result can have
the right bit pattern but the wrong inf/zero status flags (or vice
versa) -- that distinction matters when you're debugging the ALU, so
a mismatched flag does not get silently absorbed into a generic FAIL.

Posit16(es=2) loses precision as magnitude moves away from 1.0 (fewer
useful fraction bits per regime), so the numeric tolerance widens for
very large/small expected values -- see `tolerance_for`.

ptf/ftp are only echoed, never graded: their exact byte format wasn't
confirmed from the files available when this suite was written.

Usage:
    python3 posit_serial_extensive.py /dev/pts/4
    python3 posit_serial_extensive.py /dev/pts/4 --categories edge,fuzz
    python3 posit_serial_extensive.py /dev/pts/4 --fuzz-count 200 --seed 7
"""
import argparse
import math
import random
import sys
from dataclasses import dataclass, field
from typing import Callable, Optional

import serial

from posit_codec import encode_posit, decode_posit

OPCODES = {"add": 0b000, "sub": 0b001, "mul": 0b010, "div": 0b011, "ptf": 0b100, "ftp": 0b101}
N, ES = 16, 2
NAR_PATTERN = 0x8000  # Posit16 NaR: sign=1, all else 0

ALL_CATEGORIES = ["identities", "magnitude", "signs", "edge", "commute", "fuzz"]


# --------------------------------------------------------------------------
# Wire protocol
# --------------------------------------------------------------------------

def send_op(ser: serial.Serial, op: str, in1: int, in2: int):
    payload = bytes([OPCODES[op]])
    payload += (in1 & 0xFFFF).to_bytes(2, byteorder="big")
    payload += (in2 & 0xFFFF).to_bytes(2, byteorder="big")
    ser.write(payload)

    resp = ser.read(3)
    if len(resp) != 3:
        raise TimeoutError(f"no response for op={op} in1=0x{in1:04X} in2=0x{in2:04X}")
    result = int.from_bytes(resp[0:2], byteorder="big")
    status = resp[2]
    return result, bool(status & 0b10), bool(status & 0b01)  # result, inf, zero


# --------------------------------------------------------------------------
# Grading
# --------------------------------------------------------------------------

def tolerance_for(expect: float) -> float:
    """Relative tolerance, widened for magnitudes far from 1.0 where
    Posit16(es=2) has fewer significant fraction bits."""
    mag = abs(expect)
    if mag == 0:
        return 0.0
    if 0.01 <= mag <= 100:
        return 0.02
    if 1e-6 <= mag <= 1e6:
        return 0.08
    return 0.25


@dataclass
class CaseResult:
    label: str
    value_ok: bool
    flags_ok: bool
    detail: str


def grade(op: str, a, b, expect_fn: Callable, got: int, inf: bool, zero: bool,
          expect_zero_override: Optional[bool] = None) -> CaseResult:
    label = f"{op}({a}, {b})"
    expect = expect_fn(a, b) if expect_fn is not None else None

    if expect is None:
        # NaR expected regardless of numeric value.
        value_ok = (got == NAR_PATTERN)
        flags_ok = inf
        got_val = decode_posit(got, N, ES)
        detail = f"got 0x{got:04X}={got_val}  expected=NaR  [inf={inf} zero={zero}]"
        return CaseResult(label, value_ok, flags_ok, detail)

    got_val = decode_posit(got, N, ES)
    tol = max(tolerance_for(expect), 1e-9)
    if expect == 0:
        value_ok = abs(got_val) <= 1e-6
    else:
        value_ok = abs(got_val - expect) <= tol * abs(expect)

    expect_zero = (expect == 0) if expect_zero_override is None else expect_zero_override
    flags_ok = (inf == False) and (zero == expect_zero)

    detail = (f"got 0x{got:04X}={got_val:.6g}  expected~{expect:.6g}  "
              f"tol={tol*100:.0f}%  [inf={inf} zero={zero}]")
    return CaseResult(label, value_ok, flags_ok, detail)


def run_case(ser, results: list, category: str, op: str, a: float, b: float,
             expect_fn: Optional[Callable], expect_zero_override: Optional[bool] = None):
    in1, in2 = encode_posit(a, N, ES), encode_posit(b, N, ES)
    got, inf, zero = send_op(ser, op, in1, in2)
    r = grade(op, a, b, expect_fn, got, inf, zero, expect_zero_override)
    tag = "PASS" if (r.value_ok and r.flags_ok) else (
        "PART" if r.value_ok != r.flags_ok else "FAIL")
    print(f"  [{tag}] {r.label:24s} sent 0x{in1:04X},0x{in2:04X}  {r.detail}")
    if not r.value_ok:
        print(f"         -> value mismatch")
    if not r.flags_ok:
        print(f"         -> flag mismatch (inf/zero)")
    results.append((category, r))


# --------------------------------------------------------------------------
# Categories
# --------------------------------------------------------------------------

def cat_identities(ser, results):
    print("\n== identities ==")
    for x in [0.5, 1.0, 2.0, 3.0, -1.0, -4.0, 0.125, 100.0]:
        run_case(ser, results, "identities", "add", x, 0.0, lambda a, b: a + b)
        run_case(ser, results, "identities", "sub", x, x, lambda a, b: a - b, expect_zero_override=True)
        run_case(ser, results, "identities", "mul", x, 1.0, lambda a, b: a * b)
        run_case(ser, results, "identities", "mul", x, 0.0, lambda a, b: a * b, expect_zero_override=True)
        run_case(ser, results, "identities", "div", x, 1.0, lambda a, b: a / b)
        if x != 0:
            run_case(ser, results, "identities", "div", x, x, lambda a, b: a / b)


def cat_magnitude(ser, results):
    print("\n== magnitude sweep ==")
    mags = [0.001, 0.01, 0.1, 0.25, 0.5, 1.0, 2.0, 4.0, 16.0, 64.0, 256.0, 1000.0, 10000.0]
    for m in mags:
        run_case(ser, results, "magnitude", "add", m, m, lambda a, b: a + b)
        run_case(ser, results, "magnitude", "mul", m, 2.0, lambda a, b: a * b)
        run_case(ser, results, "magnitude", "div", m, 2.0, lambda a, b: a / b)
        run_case(ser, results, "magnitude", "sub", m, m / 2, lambda a, b: a - b)


def cat_signs(ser, results):
    print("\n== sign combinations ==")
    pairs = [(3.0, 2.0), (-3.0, 2.0), (3.0, -2.0), (-3.0, -2.0)]
    for a, b in pairs:
        run_case(ser, results, "signs", "add", a, b, lambda x, y: x + y)
        run_case(ser, results, "signs", "sub", a, b, lambda x, y: x - y)
        run_case(ser, results, "signs", "mul", a, b, lambda x, y: x * y)
        run_case(ser, results, "signs", "div", a, b, lambda x, y: x / y)


def cat_edge(ser, results):
    print("\n== edge cases ==")
    # zero op zero
    run_case(ser, results, "edge", "add", 0.0, 0.0, lambda a, b: a + b, expect_zero_override=True)
    run_case(ser, results, "edge", "mul", 0.0, 0.0, lambda a, b: a * b, expect_zero_override=True)
    run_case(ser, results, "edge", "sub", 0.0, 0.0, lambda a, b: a - b, expect_zero_override=True)
    # division by zero -> NaR (nonzero / 0)
    run_case(ser, results, "edge", "div", 1.0, 0.0, None)
    run_case(ser, results, "edge", "div", -5.0, 0.0, None)
    # 0 / 0 -> NaR
    run_case(ser, results, "edge", "div", 0.0, 0.0, None)
    # NaR propagation: feed NaR pattern directly as an operand
    got, inf, zero = send_op(ser, "add", NAR_PATTERN, encode_posit(1.0, N, ES))
    ok = (got == NAR_PATTERN) and inf
    tag = "PASS" if ok else "FAIL"
    print(f"  [{tag}] add(NaR, 1.0)            got 0x{got:04X}  [inf={inf} zero={zero}]  "
          f"expected 0x{NAR_PATTERN:04X} with inf=True")
    results.append(("edge", CaseResult("add(NaR,1.0)", got == NAR_PATTERN, inf, "")))
    # near-overflow / near-underflow (largest and smallest normal magnitudes worth probing)
    run_case(ser, results, "edge", "mul", 1000.0, 1000.0, lambda a, b: a * b)
    run_case(ser, results, "edge", "mul", 0.001, 0.001, lambda a, b: a * b)


def cat_commute(ser, results):
    print("\n== commutativity (order should not matter) ==")
    pairs = [(2.0, 5.0), (-3.0, 7.0), (0.25, 0.125), (100.0, 0.01)]
    for a, b in pairs:
        for op in ("add", "mul"):
            in1, in2 = encode_posit(a, N, ES), encode_posit(b, N, ES)
            r1, inf1, z1 = send_op(ser, op, in1, in2)
            r2, inf2, z2 = send_op(ser, op, in2, in1)
            ok = (r1 == r2) and (inf1 == inf2) and (z1 == z2)
            tag = "PASS" if ok else "FAIL"
            print(f"  [{tag}] {op}({a},{b}) vs {op}({b},{a})  "
                  f"0x{r1:04X} vs 0x{r2:04X}")
            results.append(("commute", CaseResult(f"{op} commute {a},{b}", ok, ok, "")))


def cat_fuzz(ser, results, count: int, seed: int):
    print(f"\n== fuzz ({count} random cases, seed={seed}) ==")
    rng = random.Random(seed)
    ops = {
        "add": lambda a, b: a + b,
        "sub": lambda a, b: a - b,
        "mul": lambda a, b: a * b,
        "div": lambda a, b: a / b if b != 0 else None,
    }
    for _ in range(count):
        op = rng.choice(list(ops.keys()))
        # log-uniform magnitude across a wide dynamic range, random sign
        mag_a = 10 ** rng.uniform(-3, 4)
        mag_b = 10 ** rng.uniform(-3, 4)
        a = mag_a * rng.choice([1, -1])
        b = mag_b * rng.choice([1, -1])
        if op == "div" and abs(b) < 1e-4:
            b = 1.0  # avoid accidental div-by-zero muddying fuzz stats; edge cat covers that
        expect_fn = ops[op]
        run_case(ser, results, "fuzz", op, round(a, 6), round(b, 6), expect_fn)


CATEGORY_FUNCS = {
    "identities": lambda ser, results, args: cat_identities(ser, results),
    "magnitude": lambda ser, results, args: cat_magnitude(ser, results),
    "signs": lambda ser, results, args: cat_signs(ser, results),
    "edge": lambda ser, results, args: cat_edge(ser, results),
    "commute": lambda ser, results, args: cat_commute(ser, results),
    "fuzz": lambda ser, results, args: cat_fuzz(ser, results, args.fuzz_count, args.seed),
}


def smoke_ptf_ftp(ser):
    print("\n== ptf/ftp smoke test (format unconfirmed, not graded) ==")
    for op in ("ptf", "ftp"):
        got, inf, zero = send_op(ser, op, 0x4000, 0)
        print(f"  {op}(0x4000, 0x0000) -> 0x{got:04X}  [inf={inf} zero={zero}]")


def run(port: str, baud: int, categories: list, args):
    results = []
    with serial.Serial(port, baudrate=baud, timeout=2.0) as ser:
        for cat in categories:
            CATEGORY_FUNCS[cat](ser, results, args)
        if not args.no_ptf:
            smoke_ptf_ftp(ser)

    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    by_cat = {}
    for cat, r in results:
        by_cat.setdefault(cat, []).append(r)

    total_pass = total_fail = total_part = 0
    for cat in categories:
        rs = by_cat.get(cat, [])
        full_pass = sum(1 for r in rs if r.value_ok and r.flags_ok)
        partial = sum(1 for r in rs if r.value_ok != r.flags_ok)
        full_fail = sum(1 for r in rs if not r.value_ok and not r.flags_ok)
        total_pass += full_pass
        total_fail += full_fail
        total_part += partial
        print(f"  {cat:12s} {full_pass:3d} pass  {partial:3d} partial  {full_fail:3d} fail  "
              f"(of {len(rs)})")

    grand_total = total_pass + total_fail + total_part
    print("-" * 60)
    print(f"  {'TOTAL':12s} {total_pass:3d} pass  {total_part:3d} partial  {total_fail:3d} fail  "
          f"(of {grand_total})")
    if total_part:
        print("\n  'partial' = value correct but flags wrong, or vice versa -- see per-case")
        print("  '-> value mismatch' / '-> flag mismatch' lines above for which one.")

    return total_fail == 0 and total_part == 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("port")
    ap.add_argument("--baud", type=int, default=115200)
    ap.add_argument("--categories", type=str, default=",".join(ALL_CATEGORIES),
                     help=f"comma-separated subset of: {','.join(ALL_CATEGORIES)}")
    ap.add_argument("--fuzz-count", type=int, default=100, help="number of fuzz cases")
    ap.add_argument("--seed", type=int, default=0, help="fuzz RNG seed (for reproducibility)")
    ap.add_argument("--no-ptf", action="store_true", help="skip the ptf/ftp smoke test")
    args = ap.parse_args()

    cats = [c.strip() for c in args.categories.split(",") if c.strip()]
    bad = [c for c in cats if c not in ALL_CATEGORIES]
    if bad:
        print(f"Unknown categories: {bad}. Valid: {ALL_CATEGORIES}", file=sys.stderr)
        sys.exit(2)

    ok = run(args.port, args.baud, cats, args)
    sys.exit(0 if ok else 1)