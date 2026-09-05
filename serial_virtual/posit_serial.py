#!/usr/bin/env python3
"""Talk to the posit_coprocessor over its (virtual or real) serial port.

Usage:
    python posit_serial.py /dev/pts/4 --op add --in1 5 --in2 3
"""
import argparse
import serial

OPCODES = {
    "add": 0b000,
    "sub": 0b001,
    "mul": 0b010,
    "div": 0b011,
    "ptf": 0b100,
    "ftp": 0b101,
}


def send_op(port: str, op: str, in1: int, in2: int,
            baud: int = 115200, timeout: float = 2.0) -> int:
    with serial.Serial(port, baudrate=baud, timeout=timeout) as ser:
        ser.write(bytes([OPCODES[op], in1 & 0xFF, in2 & 0xFF]))
        result = ser.read(1)
        if len(result) != 1:
            raise TimeoutError("no response from coprocessor")
        return result[0]


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("port", help="serial device, e.g. /dev/pts/4")
    ap.add_argument("--op", choices=OPCODES.keys(), default="add")
    ap.add_argument("--in1", type=lambda x: int(x, 0), default=0)
    ap.add_argument("--in2", type=lambda x: int(x, 0), default=0)
    ap.add_argument("--baud", type=int, default=115200)
    args = ap.parse_args()

    result = send_op(args.port, args.op, args.in1, args.in2, args.baud)
    print(f"{args.op}({args.in1}, {args.in2}) = {result} (0x{result:02X})")


if __name__ == "__main__":
    main()