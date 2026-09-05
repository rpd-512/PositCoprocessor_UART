# Posit Arithmetic Coprocessor (UART)

A hardware coprocessor implementing Posit arithmetic, exposed to a host system over a UART interface. The host offloads posit encode/decode and arithmetic operations to the coprocessor via a simple serial command protocol.

## Overview

- **Number format:** Posit (configurable `n`-bit, `es` exponent bits)
- **Host interface:** UART (async serial), command/response protocol
- **Target:** FPGA (assumed; update if ASIC/other)
- **Operations:** encode/decode, add, sub, mul, div (extend as implemented)

> Assumption: posit width/es and op set below are placeholders. Fill in actual configuration once finalized.

## Architecture

```
Host (PC/MCU) <--UART--> [RX FIFO] -> Command Decoder -> Posit ALU -> [TX FIFO] --UART--> Host
```

- **UART core:** TX/RX with configurable baud rate, standard 8N1 framing (assumed)
- **Command decoder:** parses opcode + operand bytes from RX stream
- **Posit ALU:** performs requested operation on decoded posit operands
- **Response packer:** serializes result back into byte stream for TX

## UART Protocol

Assumed packet format (update to match actual implementation):

| Field    | Size      | Description                          |
|----------|-----------|---------------------------------------|
| Opcode   | 1 byte    | Operation selector                    |
| Operand A| N bytes   | Posit-encoded value                   |
| Operand B| N bytes   | Posit-encoded value (if binary op)    |
| Result   | N bytes   | Posit-encoded result (response)       |
| Status   | 1 byte    | Error/valid flag                      |

**Baud rate:** TBD (e.g. 115200)
**Framing:** 8 data bits, no parity, 1 stop bit (TBD)

### Opcode table (example)

| Opcode | Operation |
|--------|-----------|
| 0x01   | ADD       |
| 0x02   | SUB       |
| 0x03   | MUL       |
| 0x04   | DIV       |
| 0x05   | ENCODE (float -> posit) |
| 0x06   | DECODE (posit -> float) |

## Repository Structure

```
.
├── rtl/            # SystemVerilog/Verilog source
│   ├── uart/        # UART TX/RX modules
│   ├── posit_alu/    # Posit arithmetic units
│   └── top/          # Top-level integration
├── tb/             # Testbenches (Verilator/Icarus)
├── sw/             # Host-side driver/test scripts
├── docs/           # Protocol spec, timing diagrams
└── README.md
```

## Building & Simulation

```bash
# Example — adjust to actual toolchain
verilator --cc --exe --build tb/tb_top.cpp rtl/top/*.sv
./obj_dir/Vtop
```

## Host-Side Usage (example)

```python
import serial

ser = serial.Serial('/dev/ttyUSB0', baudrate=115200)
ser.write(bytes([0x01]) + posit_a + posit_b)  # ADD
result = ser.read(N)
```

## Status

- [ ] UART TX/RX core
- [ ] Posit encode/decode
- [ ] Posit ALU (add/sub/mul/div)
- [ ] Command protocol integration
- [ ] Host driver
- [ ] Verification (Boolean equivalence / testbench coverage)

## License

TBD