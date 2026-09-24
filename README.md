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
│       ├── run_flow.tcl        # full flow: init, floorplan, place, CTS, route, post-route opt, DRC, reports (RUN=<dir>)
│       ├── gds_flow.tcl        # stream-out with filler insertion (produces DRC shorts, not used for the final GDS)
│       ├── gds_nofill.tcl      # final stream-out from the routed database, no fillers
│       ├── sky130_innovus.map  # Innovus stream-out layer map (LEF layer -> GDS layer/datatype)
│       ├── power.rpt
│       ├── timingReports/
│       ├── runA/               # 110 MHz netlist, 9.09 ns target: pt/ (netlist + SDC), checkpoints, reports
│       ├── runB/               # 130 MHz netlist, 8.8 ns target
│       ├── runC/               # 130 MHz netlist, 9.09 ns target
│       └── runD/               # 130 MHz netlist, 9.3 ns target (timing closed); contains coprocessor_nofill.gds
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

## Physical Design: Cadence Innovus — Place & Route and GDS

### Flow

Implemented in `gds/innovus_workflow/run_flow.tcl`, run once per candidate with `RUN=<dir>`, each directory holding its own netlist and SDC in `pt/`:

```
init_design -> floorPlan (330 x 325 um die) -> place_opt_design -> ccopt_design (CTS) -> routeDesign
            -> post-route optDesign (OCV analysis) -> verify_drc -> timing / area / power reports
```

- **Technology files:** SKY130 HD typical-corner liberty (`tt_025C_1v80`), standard-cell LEF, and a tech LEF patched for Innovus (the original was rejected with `IMPLF-121`; a `licon` cut layer was inserted after `pwell` to fix the layer order).
- **Floorplan:** the larger 330 x 325 um floorplan replaced the original ~277 x 273 um one, which had excessive density, congestion and 69 DRC violations after routing.
- **Post-route optimization:** run with `setAnalysisMode -analysisType onChipVariation -cppr both`, since Innovus requires OCV mode for SI-aware post-route optimization (`IMPOPT-6080`).

### Results

All four runs use SKY130 HD, a 330 x 325 um die, and the same flow. Runs B to D use the netlist that Genus synthesized at 130 MHz (7.69 ns), with only the SDC period relaxed for Innovus.

| Run | Netlist | Target period | Setup slack (pre-opt → post-opt) | Hold slack | DRC | Std-cell area |
|-----|---------|---------------|----------------------------------|------------|-----|---------------|
| A | 110 MHz Genus netlist | 9.09 ns (110 MHz) | -0.177 → -0.112 ns | +0.553 ns | clean | 50,128 µm² |
| B | 130 MHz Genus netlist | 8.80 ns (113.6 MHz) | -0.245 → -0.156 ns | +0.517 ns | clean | 48,761 µm² |
| C | 130 MHz Genus netlist | 9.09 ns (110 MHz) | -0.522 → -0.061 ns | +0.485 ns | clean | 45,669 µm² |
| **D** | 130 MHz Genus netlist | **9.30 ns (107.5 MHz)** | -0.334 → **+0.023 ns** | +0.550 ns | clean | **42,210 µm²** |

**Run D closes timing** post-route at a 9.3 ns target (about 107.5 MHz) with 0 DRC violations. Setup slack after post-route optimization is only +0.023 ns, so the margin is thin.

Key observations:
- Genus reports zero slack at 130 MHz (132 MHz is the first failing point), but the same netlist did not close post-route at the 7.69 ns target: an earlier baseline run on the same netlist showed about -1.06 ns post-route WNS. Routing and clock-tree effects cost roughly 1 ns on top of the synthesis result.
- The critical paths run through the 12x12 significand multiplier in `posit_muldiv`, which Genus maps to generic NAND-based standard cells. Raising `syn_generic_effort` from medium to high left the area unchanged.
- Area after routing falls as the target period relaxes (50.1k, 48.8k, 45.7k and 42.2k µm² across A to D).
- Results vary from run to run (run C has worse pre-optimization slack than run B despite a looser target), so small differences between runs should not be over-interpreted.

Known messages that do not affect the result:
- `IMPCCOPT-1209` (CTS transition-time target) appears in all runs; the runs still complete CTS, routing and DRC.
- `IMPSP-9099`: Genus mapped some registers to SKY130 scan flops (`sky130_fd_sc_hd__sdf*`, 53 cells in the 110 MHz netlist), and no scan chains are defined for them.

### GDS generation

The final layout is produced by `gds_nofill.tcl` from the routed, DRC-clean database of run D (`runD/route.enc.dat`):

```
restoreDesign runD/route.enc.dat -> verify_drc -> streamOut (merge SKY130 standard-cell GDS)
```

- **Output:** `gds/innovus_workflow/runD/coprocessor_nofill.gds` (about 7.9 MB), with 0 DRC violations on the source database and 0 errors in the stream-out log.
- **Standard-cell layouts:** merged from the SKY130A PDK file `sky130_fd_sc_hd.gds`.
- **Layer map:** `sky130_innovus.map` maps LEF layers to SKY130 GDS layer/datatype numbers (for example `met1` to 68/20, `li1` to 67/20).
- **No filler cells:** `gds_flow.tcl` also tried `addFiller` before stream-out, but adding fillers to a post-route database produced metal shorts (about 1000 DRC violations in the report), so the final GDS is generated without fillers.
- **Limitations:** the flow has no power grid (no rings, stripes or tap cells), so the GDS is a layout of the placed and routed logic, not a tape-out-ready or LVS-clean design.

Open `coprocessor_nofill.gds` in KLayout with `sky130A.map` from the PDK as the layer properties file to inspect it.

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
- [x] Innovus place & route with timing closed post-route at 107.5 MHz (0 DRC)
- [x] GDS generated from the routed database (no fillers, no power grid)
- [ ] Power grid, tap cells and LVS
- [ ] Multiplier architecture exploration (12x12 significand multiplier is the critical path)

## License

MIT
