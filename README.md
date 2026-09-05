# Posit Arithmetic Coprocessor (UART)

A hardware coprocessor implementing posit arithmetic, exposed to a host system over a UART interface. The host sends an opcode and two operand bytes; the coprocessor computes and returns a one-byte result.

## Overview

- **Number format:** 8-bit posit (`DATA_BITS`/`N_VAL` parameterized in `posit_arithmetic`)
- **Host interface:** UART, 3-byte command / 1-byte response protocol
- **UART config:** 115200 baud, 8N1, oversampled 16x (`baud_gen`)
- **Operations:** add, sub, mul, div, posit→float, float→posit

> `mul`/`div`/`ptf`/`ftp` in `posit_arithmetic.sv` are currently placeholder logic (not real posit math) — only `add`/`sub` do correct two's-complement arithmetic right now.

## Architecture

```
Host (PC) <--UART--> uart_head (baud_gen/uart_tx/uart_rx) -> control FSM -> posit_arithmetic -> uart_head -> Host
```

- **`uart_head`** (in `rtl/uart_head.sv`): `baud_gen`, `uart_tx`, `uart_rx` — standard 8N1 UART front-end
- **Control FSM** (in `posit_coprocessor`, `rtl/coprocessor.sv`): collects 3 incoming bytes (opcode, in1, in2), drives the ALU, sends the 1-byte result back
- **`posit_arithmetic`** (in `rtl/posit_arithmetic.sv`): the ALU — `posit_addsub`, `posit_muldiv`, `posit_to_float`, `float_to_posit`

## UART Protocol

Host → coprocessor, 3 bytes per command:

| Byte | Field   | Description                         |
|------|---------|---------------------------------------|
| 0    | Opcode  | low 3 bits select the operation (see table) |
| 1    | in1     | 8-bit posit operand                 |
| 2    | in2     | 8-bit posit operand (unused for ptf/ftp) |

Coprocessor → host, 1 byte per command:

| Byte | Field  | Description        |
|------|--------|---------------------|
| 0    | Result | 8-bit posit result |

**Baud rate:** 115200
**Framing:** 8 data bits, no parity, 1 stop bit

### Opcode table

| Opcode (bin) | Operation | Notes |
|--------------|-----------|-------|
| 000 | ADD | in1 + in2 |
| 001 | SUB | in1 - in2 |
| 010 | MUL | placeholder — not correct posit math yet |
| 011 | DIV | placeholder — not correct posit math yet |
| 100 | PTF (posit → float) | placeholder, currently passthrough |
| 101 | FTP (float → posit) | placeholder, currently passthrough |
| 110, 111 | reserved | unused |

## Repository Structure

```
.
├── rtl/
│   ├── coprocessor.sv          # posit_coprocessor top + control FSM
│   ├── uart_head.sv            # uart_head, uart_tx, uart_rx, baud_gen
│   └── posit_arithmetic.sv     # posit_arithmetic, posit_addsub, posit_muldiv, posit_to_float, float_to_posit
├── serial_virtual/
│   ├── vserial_bridge.cpp      # Verilator sim wrapped in a virtual serial port (Linux pty)
│   └── posit_serial.py         # host-side driver (pyserial)
├── Makefile
└── README.md
```

## Building & Simulation

```bash
make            # builds ./vserial_bridge via Verilator
./vserial_bridge
```

This starts the simulated coprocessor and prints a pty path, e.g.:

```
virtual serial port: /dev/pts/2
```

`vserial_bridge` bit-bangs the simulated `rx`/`tx` pins at real UART timing (115200 baud, matching `baud_gen`), so any serial client can talk to it through that pty as if it were real hardware.

```bash
make clean      # removes obj_dir
```

## Host-Side Usage

```bash
python serial_virtual/posit_serial.py /dev/pts/2 --op add --in1 5 --in2 3
```

```python
import serial

ser = serial.Serial('/dev/pts/2', baudrate=115200, timeout=2.0)
ser.write(bytes([0b000, 5, 3]))   # ADD, in1=5, in2=3
result = ser.read(1)[0]
```

## Status

- [x] UART TX/RX core
- [x] Command protocol + control FSM
- [x] Virtual serial port bridge (Verilator + pty) for host-side testing
- [x] posit ALU: add/sub (correct)
- [ ] posit ALU: mul/div (placeholder only)
- [ ] posit encode/decode (posit↔float, placeholder only)
- [ ] Verification / testbench coverage

## License

MIT