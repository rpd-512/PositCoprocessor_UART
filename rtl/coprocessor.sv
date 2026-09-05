module coprocessor #(
    parameter int DATA_BITS   = 8,
    parameter int N_VAL       = 2,
    parameter int BAUD_RATE   = 115200,
    parameter int CLK_FREQ    = 50000000,
    parameter int OVER_SAMPLE = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic rx,
    output logic tx
);
    // ---- UART front-end ----
    logic [DATA_BITS-1:0] uart_rx_data;
    logic                 uart_rx_valid;
    logic [DATA_BITS-1:0] uart_tx_data;
    logic                 uart_tx_start;
    logic                 uart_tx_busy;
    logic                 uart_tx_done;

    uart_head #(
        .DATA_BITS(DATA_BITS),
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

    // ---- Posit ALU ----
    logic [2:0]            opcode_r;
    logic [DATA_BITS-1:0]  in1_r, in2_r;
    logic [DATA_BITS-1:0]  alu_out;

    posit_arithmetic #(
        .DATA_BITS(DATA_BITS),
        .N_VAL(N_VAL)
    ) alu_inst (
        .opcode(opcode_r),
        .in1(in1_r),
        .in2(in2_r),
        .out(alu_out)
    );

    // ---- Control FSM ----
    // Host protocol: send 3 bytes { opcode[2:0] (in low bits), in1, in2 }.
    // Coprocessor replies with 1 byte: the result.
    typedef enum logic [2:0] {
        S_OPCODE, S_IN1, S_IN2, S_COMPUTE, S_SEND, S_WAIT_DONE
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= S_OPCODE;
            opcode_r      <= '0;
            in1_r         <= '0;
            in2_r         <= '0;
            uart_tx_data  <= '0;
            uart_tx_start <= 1'b0;
        end
        else begin
            uart_tx_start <= 1'b0; // default: 1-cycle pulse only

            case (state)
                S_OPCODE: if (uart_rx_valid) begin
                    opcode_r <= uart_rx_data[2:0];
                    state    <= S_IN1;
                end

                S_IN1: if (uart_rx_valid) begin
                    in1_r <= uart_rx_data;
                    state <= S_IN2;
                end

                S_IN2: if (uart_rx_valid) begin
                    in2_r <= uart_rx_data;
                    state <= S_COMPUTE;
                end

                // one cycle for the combinational ALU output to settle
                S_COMPUTE: begin
                    uart_tx_data <= alu_out;
                    state        <= S_SEND;
                end

                S_SEND: if (!uart_tx_busy) begin
                    uart_tx_start <= 1'b1;
                    state         <= S_WAIT_DONE;
                end

                S_WAIT_DONE: if (uart_tx_done) begin
                    state <= S_OPCODE;
                end

                default: state <= S_OPCODE;
            endcase
        end
    end

endmodule