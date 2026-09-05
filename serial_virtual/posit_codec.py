def encode_posit(x: float, N: int = 8, es: int = 0) -> int:
    """Encode a python float into an N-bit posit(es) bit pattern (round-to-nearest)."""
    if x != x:  # NaN
        return 1 << (N - 1)
    if x == 0.0:
        return 0
    sign = 1 if x < 0 else 0
    x = abs(x)

    useed = 2.0 ** (2 ** es)
    # find regime k such that x / useed^k is in [1,useed)
    k = 0
    v = x
    if v >= 1.0:
        while v >= useed:
            v /= useed
            k += 1
    else:
        while v < 1.0:
            v *= useed
            k -= 1

    # v in [1, useed). extract exponent e in [0, 2^es) and fraction
    exp_max = 1 << es
    e = 0
    while v >= 2.0 and e < exp_max - 1:
        v /= 2.0
        e += 1
    # v now in [1,2)
    frac_real = v - 1.0

    # regime field length: k>=0 -> k+2 bits (k ones + terminating 0); k<0 -> -k+1 bits (-k zeros + terminating 1)
    if k >= 0:
        regime_bits = '1' * (k + 1) + '0'
    else:
        regime_bits = '0' * (-k) + '1'

    avail = N - 1 - len(regime_bits)  # bits left for exponent+fraction after sign+regime
    if avail <= 0:
        # saturate to minpos/maxpos magnitude
        bits_str = regime_bits[:N-1]
        mag = int(bits_str, 2) if bits_str else 0
        mag <<= (N - 1 - len(bits_str))
    else:
        e_bits_len = min(es, avail)
        e_field = e >> (es - e_bits_len) if e_bits_len < es else e
        e_str = format(e_field, f'0{e_bits_len}b') if e_bits_len > 0 else ''
        avail -= e_bits_len
        f_bits_len = max(avail, 0)
        # round fraction to f_bits_len bits (round-to-nearest, ties to even-ish via round())
        scaled = frac_real * (1 << f_bits_len)
        f_int = int(round(scaled))
        if f_int >= (1 << f_bits_len):
            f_int = (1 << f_bits_len) - 1
        f_str = format(f_int, f'0{f_bits_len}b') if f_bits_len > 0 else ''
        bits_str = regime_bits + e_str + f_str
        mag = int(bits_str, 2)

    mag &= (1 << (N - 1)) - 1
    if sign:
        result = ((~mag) + 1) & ((1 << N) - 1)
    else:
        result = mag
    return result


def decode_posit(bits: int, N: int = 8, es: int = 0) -> float:
    """Decode an N-bit posit(es) bit pattern into a python float."""
    bits &= (1 << N) - 1
    if bits == 0:
        return 0.0
    if bits == (1 << (N - 1)):
        return float('nan')  # NaR

    sign = (bits >> (N - 1)) & 1
    mag = bits
    if sign:
        mag = ((~bits) + 1) & ((1 << N) - 1)

    mbits = format(mag, f'0{N}b')[1:]  # drop sign bit, N-1 bits left
    rc = mbits[0]
    i = 1
    while i < len(mbits) and mbits[i] == rc:
        i += 1
    # run of `i` bits of value rc, terminated by opposite bit (or ran off the end)
    if rc == '1':
        k = i - 1
    else:
        k = -i
    rest = mbits[i + 1:] if i < len(mbits) else ''  # skip terminating bit if present

    es_bits_len = min(es, len(rest))
    e_str = rest[:es_bits_len]
    f_str = rest[es_bits_len:]
    e = int(e_str, 2) if e_str else 0
    if es_bits_len < es:
        e <<= (es - es_bits_len)  # missing low exponent bits assumed 0
    f = int(f_str, 2) / (2 ** len(f_str)) if f_str else 0.0

    useed = 2.0 ** (2 ** es)
    value = (useed ** k) * (2 ** e) * (1.0 + f)
    return -value if sign else value


if __name__ == "__main__":
    import random
    random.seed(0)
    N, ES = 16, 2   # updated from Posit8,es=0 -> Posit16,es=2

    max_err = 0.0
    for _ in range(20000):
        x = random.uniform(-16, 16)
        b = encode_posit(x, N, ES)
        y = decode_posit(b, N, ES)
        # round-trip self-consistency check (still valid at any N/es)
        b2 = encode_posit(y, N, ES)
        assert b2 == b, (x, b, y, b2)

    # known reference points for posit16,es=2 (useed = 2^(2^es) = 16, not 4 --
    # these bit patterns are NOT the same as the old Posit8,0 table and were
    # recomputed by hand from the encoding rules, not by round-tripping through
    # encode_posit itself)
    refs = {
        0x0000: 0.0,
        0x4000: 1.0,
        0x3800: 0.5,
        0x4800: 2.0,
        0x3000: 0.25,
        0x5000: 4.0,
        0x2800: 0.125,
        0x8000: float('nan'),
    }
    for b, expect in refs.items():
        got = decode_posit(b, N, ES)
        if expect != expect:
            assert got != got, (b, got)
        else:
            assert abs(got - expect) < 1e-9, (b, got, expect)
        # and re-encode
        if expect == expect:
            assert encode_posit(expect, N, ES) == b, (expect, encode_posit(expect, N, ES), b)
    print("all checks passed")