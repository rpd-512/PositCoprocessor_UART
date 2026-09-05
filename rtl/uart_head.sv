module uart_head#(
    parameter int DATA_BITS   = 8,

    parameter int BAUD_RATE = 115200,
    parameter int CLK_FREQ = 50000000,
    parameter int OVER_SAMPLE = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic tx_start,
    input  logic rx,
    input  logic [DATA_BITS-1:0] tx_data,
    output logic [DATA_BITS-1:0] rx_data,
    output logic tx,
    output logic rx_valid,
    output logic tx_busy,
    output logic tx_done,
    output logic rx_busy
);
    logic tick;
    baud_gen #(
        .BAUD_RATE(BAUD_RATE),
        .CLK_FREQ(CLK_FREQ),
        .OVER_SAMPLE(OVER_SAMPLE)
    ) baud_gen_inst (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );

    uart_tx #(
        .DATA_BITS(DATA_BITS),
        .OVER_SAMPLE(OVER_SAMPLE)
    ) uart_tx_inst (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .data_tx(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_rx #(
        .DATA_BITS(DATA_BITS),
        .OVER_SAMPLE(OVER_SAMPLE)
    ) uart_rx_inst (
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .rx(rx),
        .data_rx(rx_data),
        .rx_valid(rx_valid),
        .rx_busy(rx_busy)
    );
endmodule

module uart_tx#(
    parameter int DATA_BITS   = 8,
    parameter int OVER_SAMPLE = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic tick,
    input  logic [DATA_BITS-1:0] data_tx,
    input  logic tx_start,
    output logic tx,
    output logic tx_busy,
    output logic tx_done
);
    typedef enum logic [1:0] {
        IDLE, START, DATA, STOP
    } state_t;

    state_t state; 
    localparam int TICK_COUNT_W = $clog2(OVER_SAMPLE);
    logic [TICK_COUNT_W-1:0] tick_count;

    localparam int BIT_COUNT_W = $clog2(DATA_BITS);
    logic [BIT_COUNT_W-1:0] bit_count;
    
    logic [DATA_BITS-1:0] shift_reg;

    //Finite State Machine
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE  : if(tx_start) state <= START;
                START : if(tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) state <= DATA;
                DATA  : if(tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1) && bit_count == BIT_COUNT_W'(DATA_BITS-1)) state <= STOP;
                STOP  : if(tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) state <= IDLE;
                default : state <= IDLE;
            endcase
        end
    end

    //Shift Register for Data Transmission
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            shift_reg <= '0;
        end
        else if(state == IDLE && tx_start) begin
            shift_reg <= data_tx; // Load data into shift register at start
        end
    end

    //Tick Count Manager
    always_ff @(posedge clk or posedge rst) begin
        if(rst || state == IDLE) tick_count <= '0;
        else if (tick) begin
            if (tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) tick_count <= '0;
            else tick_count <= tick_count + 1'b1;
        end
    end

    //Bit Count Manager
    always_ff @(posedge clk or posedge rst) begin
        if(rst) bit_count <= '0;
        else if(state == DATA && tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) begin
            bit_count <= bit_count + 1'b1;
        end
        else if(state != DATA) begin
            bit_count <= '0;
        end
    end

    // Data Transmission
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            tx      <= 1'b1;
            tx_done <= 1'b0;
        end
        else begin
            case (state)
                IDLE  : tx <= 1'b1; // Idle state, line is high
                START : tx <= 1'b0; // Start bit, line goes low
                DATA  : tx <= shift_reg[bit_count]; // Send data bits
                STOP  : tx <= 1'b1; // Stop bit, line goes high
                default : tx <= 1'b1; // Default to idle state
            endcase

            if (state == STOP && tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) begin
                tx_done <= 1'b1; // Transmission done
            end
            else tx_done <= 1'b0;
        end
    end
    assign tx_busy = (state!=IDLE);

endmodule

module uart_rx#(
    parameter int DATA_BITS   = 8,
    parameter int OVER_SAMPLE = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic tick,
    input  logic rx,
    output logic [DATA_BITS-1:0] data_rx,
    output logic rx_valid,
    output logic rx_busy
);
    typedef enum logic [1:0] {
        IDLE, START, DATA, STOP
    } state_t;

    state_t state;
    localparam int TICK_COUNT_W = $clog2(OVER_SAMPLE);
    logic [TICK_COUNT_W-1:0] tick_count;

    localparam int BIT_COUNT_W = $clog2(DATA_BITS);
    logic [BIT_COUNT_W-1:0] bit_count;

    logic [DATA_BITS-1:0] shift_reg;

    logic rx_ff1, rx_sync;

    //Handle metastability and synchronize the rx signal to the clk domain
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_ff1  <= 1'b1;
            rx_sync <= 1'b1;
        end
        else begin
            rx_ff1  <= rx;
            rx_sync <= rx_ff1;
        end
    end

    //Finite State Machine
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE  : if(!rx_sync) state <= START; // Detect start bit (line goes low)
                START : begin
                        if (tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE/2) && rx_sync)
                            state <= IDLE;  // false start, was noise
                        else if (tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1))
                            state <= DATA;  // confirmed, proceed
                    end
                DATA  : if(tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1) && bit_count == BIT_COUNT_W'(DATA_BITS-1)) state <= STOP;
                STOP  : if(tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) state <= IDLE;
                default : state <= IDLE;
            endcase
        end
    end

    //Shift Register for Data Reveiving
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_rx  <= '0;
            rx_valid <= 1'b0;
        end
        else if (state == STOP && tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE/2) && rx_sync) begin
            data_rx  <= shift_reg;
            rx_valid <= 1'b1;
        end
        else begin
            rx_valid <= 1'b0;
        end
    end

    //Tick Count Manager
    always_ff @(posedge clk or posedge rst) begin
        if(rst || state == IDLE) tick_count <= '0;
        else if (tick) begin
            if (tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) tick_count <= '0;
            else tick_count <= tick_count + 1'b1;
        end
    end

    //Bit Count Manager
    always_ff @(posedge clk or posedge rst) begin
        if(rst) bit_count <= '0;
        else if(state == DATA && tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE-1)) begin
            bit_count <= bit_count + 1'b1;
        end
        else if(state != DATA) begin
            bit_count <= '0;
        end
    end

    //Data Reception
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= '0;
        end
        else if(state == DATA && tick && tick_count == TICK_COUNT_W'(OVER_SAMPLE/2)) begin
            shift_reg[bit_count] <= rx_sync; // Sample data bits
        end
    end
    assign rx_busy = (state != IDLE);

endmodule


module baud_gen#(
    parameter BAUD_RATE = 115200,
    parameter CLK_FREQ = 50000000,
    parameter OVER_SAMPLE = 16
)(
    input logic clk,
    input logic rst,
    output logic tick
);
    localparam integer BAUD_TICK_COUNT = CLK_FREQ / (BAUD_RATE * OVER_SAMPLE);
    localparam integer BAUD_LOG = $clog2(BAUD_TICK_COUNT);
    logic [BAUD_LOG-1:0] count;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= '0;
            tick <= 1'b0;
        end
        else if(count == BAUD_LOG'(BAUD_TICK_COUNT-1)) begin
            count <= '0;
            tick <= 1'b1;
        end
        else begin
            count <= count + 1'b1;
            tick <= 1'b0;
        end
    end
endmodule