# Posit Arithmetic Coprocessor (UART)

A hardware coprocessor implementing posit arithmetic, exposed to a host system over a UART interface. The host sends an opcode and two operand bytes; the coprocessor computes and returns a one-byte result.

## Overview

- **Number format:** 8-bit posit (`DATA_BITS`/`N_VAL` parameterized in `posit_arithmetic`)
- **Host interface:** UART, 3-byte command / 1-byte response protocol
- **UART config:** 115200 baud, 8N1, oversampled 16x (`baud_gen`)
- **Operations:** add, sub, mul, div, posit→float, float→posit
- **Hardware validation:** simulated on a Digilent Basys 3 FPGA board and tested over a real serial port, in addition to the Verilator virtual-serial-port flow below

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
| 000 | ADD | posit addition |
| 001 | SUB | posit subtraction |
| 010 | MUL | posit multiplication |
| 011 | DIV | posit division |
| 100 | PTF (posit → float) | implemented |
| 101 | FTP (float → posit) | implemented |
| 110, 111 | reserved | unused |

## Repository Structure

```
.
├── rtl/
│   ├── posit_primitives.sv     # shared primitives
│   ├── posit_decoder.sv        # posit decoder
│   ├── posit_encoder.sv        # posit encoder
│   ├── posit_addsub.sv         # add/sub unit
│   ├── posit_muldiv.sv         # mul/div unit
│   ├── posit_to_float.sv       # posit -> float
│   ├── float_to_posit.sv       # float -> posit
│   ├── posit_arithmetic.sv     # ALU wrapper
│   ├── uart_head.sv            # uart_head, uart_tx, uart_rx, baud_gen
│   └── coprocessor.sv          # coprocessor top + control FSM
├── serial_virtual/
│   ├── vserial_bridge.cpp      # Verilator sim wrapped in a virtual serial port (Linux pty)
│   └── posit_serial.py         # host-side driver (pyserial)
├── gds/                        # physical design flow (SKY130 HD)
│   ├── lib/
│   │   ├── sky130_fd_sc_hd__tt_025C_1v80.lib   # timing library
│   │   ├── sky130_fd_sc_hd.lef                 # standard-cell LEF
│   │   ├── sky130_fd_sc_hd.tlef                # original tech LEF
│   │   └── sky130_fd_sc_hd_innovus.tlef        # tech LEF patched for Innovus (licon cut layer added)
│   ├── genus_workflow/
│   │   ├── fresh_point.tcl     # single-frequency Genus synthesis script
│   │   ├── run_sweep.sh        # frequency binary search + local sweep driver
│   │   ├── sweep_fresh/        # per-frequency reports, row_*.csv, sweep_results.csv, pt_<f>MHz/ (netlist + SDC)
│   │   ├── final_results_fresh/
│   │   ├── fv/
│   │   ├── test_pt/
│   │   └── genus.cmd*, genus.log*   # Genus session command/log files
│   └── innovus_workflow/
│       ├── init_innovus.tcl    # original Innovus init script
│       ├── mmmc.tcl            # original MMMC setup
│       ├── run_flow.tcl        # full flow: init, floorplan, place, CTS, route, DRC, reports
│       ├── runA/               # 110 MHz netlist + SDC (pt/), checkpoints, reports
│       └── runB/               # 130 MHz netlist, SDC relaxed to 8.8 ns (pt/), checkpoints, reports
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

## Physical Design: Cadence Genus — Automated RTL Synthesis & Timing Search

- Developed an automated Cadence Genus 21.14 synthesis workflow for the SKY130 HD library, supporting frequency-parametric RTL synthesis with automatically generated clock and I/O timing constraints.
- Built a local automated binary-search framework to determine the highest timing-feasible operating frequency, launching an independent Genus process for each candidate point to avoid synthesis-session state contamination.
- Automated extraction of WNS, area, leakage power, dynamic power, total power, timing pass/fail, and synthesis runtime into structured CSV results.
- Automatically generated and archived frequency-specific synthesized netlists and SDC constraints for timing-feasible operating points, enabling direct handoff from Genus to Innovus.
- Performed a frequency sweep over the coprocessor and established the 130 MHz operating point used for subsequent physical implementation.
- At 130 MHz, Genus reported:
  - Area: 38,974.88 µm²
  - Dynamic power: 8,206.54 µW
  - Leakage power: 0.02091 µW
  - Total power: 8,206.56 µW
  - Clock period: 7.6923 ns
- Repeated the 130 MHz synthesis using high generic synthesis effort and verified that the resulting area remained 38,974.88 µm², providing an experimental check on the effect of synthesis effort.
- Created a reproducible Genus → Innovus handoff flow, with each feasible synthesis point producing its corresponding netlist and timing constraints.

## Status

- [x] UART TX/RX core
- [x] Command protocol + control FSM
- [x] Virtual serial port bridge (Verilator + pty) for host-side testing
- [x] posit ALU: add/sub
- [x] posit ALU: mul/div
- [x] posit encode/decode (posit↔float, placeholder only)
- [x] Verification / testbench coverage
- [x] Simulated on Basys 3 FPGA and tested over a real serial port
- [x] Genus synthesis flow with automated frequency search (SKY130 HD)

## License

MIT
