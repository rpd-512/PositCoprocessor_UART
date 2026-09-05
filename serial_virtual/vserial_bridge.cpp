// vserial_bridge.cpp
//
// Bridges the posit_coprocessor RTL (simulated with Verilator) to a
// virtual serial port (a Linux pty), so any real serial client -- e.g.
// a Python script using pyserial -- can talk to the simulated design
// as if it were a real UART device.
//
// Build (needs uart.sv = uart_head/uart_tx/uart_rx/baud_gen, and
// posit_arithmetic.sv, alongside posit_coprocessor.sv):
//
//   verilator -Wall --cc --exe --build -j 0 \
//       --top-module posit_coprocessor \
//       -CFLAGS "-std=c++17" -LDFLAGS "-lutil" \
//       posit_coprocessor.sv uart.sv posit_arithmetic.sv \
//       vserial_bridge.cpp -o vserial_bridge
//
//   ./obj_dir/vserial_bridge
//
// It prints the pty path (e.g. /dev/pts/4) -- point pyserial at that.

#include "Vcoprocessor.h"
#include "verilated.h"

#include <pty.h>
#include <unistd.h>
#include <fcntl.h>
#include <cstdio>
#include <cstdint>
#include <cstring>
#include <queue>

static constexpr uint32_t CLK_FREQ       = 50000000;
static constexpr uint32_t BAUD_RATE      = 115200;
static constexpr uint32_t CYCLES_PER_BIT = CLK_FREQ / BAUD_RATE;
static constexpr uint32_t RESET_CYCLES   = 16;

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    auto* dut = new Vcoprocessor;

    // --- open a pty pair; we keep both ends open in this process ---
    int master_fd, slave_fd;
    char slave_name[64];
    if (openpty(&master_fd, &slave_fd, slave_name, nullptr, nullptr) != 0) {
        perror("openpty");
        return 1;
    }
    fcntl(master_fd, F_SETFL, O_NONBLOCK);
    printf("virtual serial port: %s\n", slave_name);
    fflush(stdout);

    // --- device state ---
    dut->rst = 1;
    dut->rx  = 1; // idle high

    // Host -> device: drive dut->rx from bytes read off the pty
    enum RxState { RX_IDLE, RX_START, RX_DATA, RX_STOP };
    RxState rx_state = RX_IDLE;
    uint32_t rx_cycle = 0;
    int rx_bitidx = 0;
    uint8_t rx_byte = 0;
    std::queue<uint8_t> to_device;

    // Device -> host: sample dut->tx, reassemble bytes, write to the pty
    enum TxState { TX_WAIT, TX_BYTE };
    TxState tx_state = TX_WAIT;
    bool tx_prev = true;
    uint32_t tx_cycle = 0;
    int tx_next_bit = 0;
    uint8_t tx_byte = 0;
    uint32_t bit_target[9];
    for (int i = 0; i < 9; i++)
        bit_target[i] = (i + 1) * CYCLES_PER_BIT + CYCLES_PER_BIT / 2;

    uint64_t cycle_count = 0;

    while (!Verilated::gotFinish()) {
        if (cycle_count == RESET_CYCLES) dut->rst = 0;

        // one clock cycle (posedge triggers the design's always_ff blocks)
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        cycle_count++;

        // ---- top up the to-device queue from the pty (non-blocking) ----
        if (to_device.empty()) {
            uint8_t buf[64];
            ssize_t n = read(master_fd, buf, sizeof(buf));
            if (n > 0) for (ssize_t i = 0; i < n; i++) to_device.push(buf[i]);
        }

        // ---- bit-bang dut->rx from to_device ----
        switch (rx_state) {
            case RX_IDLE:
                dut->rx = 1;
                if (!to_device.empty()) {
                    rx_byte = to_device.front(); to_device.pop();
                    rx_state = RX_START; rx_cycle = 0;
                }
                break;
            case RX_START:
                dut->rx = 0;
                if (++rx_cycle >= CYCLES_PER_BIT) { rx_state = RX_DATA; rx_cycle = 0; rx_bitidx = 0; }
                break;
            case RX_DATA:
                dut->rx = (rx_byte >> rx_bitidx) & 1;
                if (++rx_cycle >= CYCLES_PER_BIT) {
                    rx_cycle = 0;
                    if (++rx_bitidx == 8) rx_state = RX_STOP;
                }
                break;
            case RX_STOP:
                dut->rx = 1;
                if (++rx_cycle >= CYCLES_PER_BIT) { rx_state = RX_IDLE; rx_cycle = 0; }
                break;
        }

        // ---- sample dut->tx, reassemble bytes, emit to the pty ----
        bool tx_cur = dut->tx;
        if (tx_state == TX_WAIT) {
            if (tx_prev && !tx_cur) { // falling edge = start bit
                tx_state = TX_BYTE; tx_cycle = 0; tx_next_bit = 0; tx_byte = 0;
            }
        } else {
            tx_cycle++;
            if (tx_next_bit < 9 && tx_cycle >= bit_target[tx_next_bit]) {
                if (tx_next_bit < 8) {
                    if (tx_cur) tx_byte |= (1 << tx_next_bit);
                } else if (tx_cur) { // valid stop bit -> emit the completed byte
                    uint8_t b = tx_byte;
                    write(master_fd, &b, 1);
                }
                tx_next_bit++;
            }
            if (tx_next_bit == 9) tx_state = TX_WAIT;
        }
        tx_prev = tx_cur;
    }

    close(slave_fd);
    close(master_fd);
    delete dut;
    return 0;
}