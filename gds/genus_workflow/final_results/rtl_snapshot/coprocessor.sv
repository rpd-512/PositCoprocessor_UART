module coprocessor #(
    parameter int DATA_BITS   = 16,     // posit width used internally (must match posit_arithmetic)
    parameter int N_VAL       = 2,
    parameter int UART_BITS   = 8,      // physical UART frame width -- standard 8-bit UART, do not change
    parameter int BAUD_RATE   = 115200,
    parameter int CLK_FREQ    = 50000000,
    parameter int OVER_SAMPLE = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic rx,
    output logic tx
);
    // Every DATA_BITS-wide value (in1, in2, result) is transferred as
    // BYTES_PER_WORD back-to-back UART_BITS-wide UART frames, MSB byte
    // first. Opcode and status each fit in a single UART_BITS-wide frame.
    // With DATA_BITS=16, UART_BITS=8 -> BYTES_PER_WORD=2 (hi byte, lo byte).
    localparam int BYTES_PER_WORD = DATA_BITS / UART_BITS;
    localparam int BYTE_CNT_W     = (BYTES_PER_WORD <= 1) ? 1 : $clog2(BYTES_PER_WORD);

    // ---- UART front-end (real, standard 8-bit-frame UART) ----
    logic [UART_BITS-1:0] uart_rx_data;
    logic                 uart_rx_valid;
    logic [UART_BITS-1:0] uart_tx_data;
    logic                 uart_tx_start;
    logic                 uart_tx_busy;
    logic                 uart_tx_done;

    uart_head #(
        .DATA_BITS(UART_BITS),
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ),
        .OVER_SAMPLE(OVER_SAMPLE)
    ) uart_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(uart_tx_start),
        .rx(rx),
        .tx_data(uart_tx_data),
        .rx_data(uart_rx_data),
        .tx(tx),
        .rx_valid(uart_rx_valid),
        .tx_busy(uart_tx_busy),
        .tx_done(uart_tx_done),
        .rx_busy()          // unused
    );

    // ---- Posit ALU (still DATA_BITS wide, e.g. 16-bit Posit, es=2) ----
    logic [2:0]            opcode_r;
    logic [DATA_BITS-1:0]  in1_r, in2_r;
    logic [DATA_BITS-1:0]  alu_out;
    logic                  alu_inf, alu_zero;

    posit_arithmetic #(
        .DATA_BITS(DATA_BITS),
        .N_VAL(N_VAL)
    ) alu_inst (
        .opcode(opcode_r),
        .in1(in1_r),
        .in2(in2_r),
        .inf(alu_inf),
        .zero(alu_zero),
        .out(alu_out)
    );

    // ---- Control FSM ----
    // Host protocol (every frame is UART_BITS = 8 bits, standard UART):
    //   opcode   1 frame,             low 3 bits used, zero-extended
    //   in1      BYTES_PER_WORD frames, MSB byte first
    //   in2      BYTES_PER_WORD frames, MSB byte first
    // Coprocessor replies:
    //   result   BYTES_PER_WORD frames, MSB byte first
    //   status   1 frame: {..., inf, zero}
    typedef enum logic [3:0] {
        S_OPCODE,
        S_IN1, S_IN2, S_COMPUTE,
        S_SEND_RESULT, S_WAIT_RESULT_DONE,
        S_SEND_STATUS, S_WAIT_STATUS_DONE
    } state_t;

    state_t state;
    logic [DATA_BITS-1:0]  result_r;
    logic [UART_BITS-1:0]  status_r;
    logic [BYTE_CNT_W-1:0] byte_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= S_OPCODE;
            opcode_r      <= '0;
            in1_r         <= '0;
            in2_r         <= '0;
            result_r      <= '0;
            status_r      <= '0;
            byte_cnt      <= '0;
            uart_tx_data  <= '0;
            uart_tx_start <= 1'b0;
        end
        else begin
            uart_tx_start <= 1'b0; // default: 1-cycle pulse only

            case (state)
                S_OPCODE: if (uart_rx_valid) begin
                    opcode_r <= uart_rx_data[2:0];
                    byte_cnt <= '0;
                    state    <= S_IN1;
                end

                // Assemble in1_r from BYTES_PER_WORD UART frames, MSB byte first.
                S_IN1: if (uart_rx_valid) begin
                    in1_r[(DATA_BITS-1 - byte_cnt*UART_BITS) -: UART_BITS] <= uart_rx_data;
                    if (byte_cnt == BYTE_CNT_W'(BYTES_PER_WORD-1)) begin
                        byte_cnt <= '0;
                        state    <= S_IN2;
                    end
                    else begin
                        byte_cnt <= byte_cnt + 1'b1;
                    end
                end

                // Assemble in2_r the same way.
                S_IN2: if (uart_rx_valid) begin
                    in2_r[(DATA_BITS-1 - byte_cnt*UART_BITS) -: UART_BITS] <= uart_rx_data;
                    if (byte_cnt == BYTE_CNT_W'(BYTES_PER_WORD-1)) begin
                        byte_cnt <= '0;
                        state    <= S_COMPUTE;
                    end
                    else begin
                        byte_cnt <= byte_cnt + 1'b1;
                    end
                end

                // one cycle for the combinational ALU output to settle
                S_COMPUTE: begin
                    result_r <= alu_out;
                    status_r <= {{(UART_BITS-2){1'b0}}, alu_inf, alu_zero};
                    byte_cnt <= '0;
                    state    <= S_SEND_RESULT;
                end

                // Send result_r out as BYTES_PER_WORD UART frames, MSB byte first.
                S_SEND_RESULT: if (!uart_tx_busy) begin
                    uart_tx_data  <= result_r[(DATA_BITS-1 - byte_cnt*UART_BITS) -: UART_BITS];
                    uart_tx_start <= 1'b1;
                    state         <= S_WAIT_RESULT_DONE;
                end

                S_WAIT_RESULT_DONE: if (uart_tx_done) begin
                    if (byte_cnt == BYTE_CNT_W'(BYTES_PER_WORD-1)) begin
                        byte_cnt <= '0;
                        state    <= S_SEND_STATUS;
                    end
                    else begin
                        byte_cnt <= byte_cnt + 1'b1;
                        state    <= S_SEND_RESULT;
                    end
                end

                S_SEND_STATUS: if (!uart_tx_busy) begin
                    uart_tx_data  <= status_r;
                    uart_tx_start <= 1'b1;
                    state         <= S_WAIT_STATUS_DONE;
                end

                S_WAIT_STATUS_DONE: if (uart_tx_done) begin
                    state <= S_OPCODE;
                end

                default: state <= S_OPCODE;
            endcase
        end
    end

endmodule