module counter#(parameter CLOCK_CYCLES = 50_000_000) 
(
    input clk, rst,
    input start, pause, stop,
    output wire tick,
    output wire [3:0] unit_tick,

    // Memory ports
    input [7:0] mem_data_read,
    input mem_read, // Enable read
    input [7:0] mem_data_write,
    input mem_write, // Enable write
    input [7:0] mem_address
);

reg [31:0] counter_reg, counter_nxt;
reg [7:0] unit_tick_reg, unit_tick_nxt;
reg tick_reg, tick_nxt;
reg [3:0] state_reg, state_nxt;
reg rw_en;
reg [7:0] pause_address;
reg [7:0] memory [0:1023];  
reg [7:0] address_reg, address_nxt;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam PAUSE = 2'b10;
localparam STOP = 2'b11;

assign tick = tick_reg;
assign unit_tick = unit_tick_reg;

memory #(8, 8) mem_inst 
(
    .clk(clk),
    .rst(rst),
    .rd_wr_en(rw_en),
    .data_in(counter_reg),
    .addr(address_reg),
    .data_out()
);

always @(*) 
begin
    counter_nxt = counter_reg;
    tick_nxt = tick_reg;
    unit_tick_nxt = unit_tick_reg;
    state_nxt = state_reg;
    address_nxt = address_reg;

    case (state_reg)
        IDLE: 
        begin
            unit_tick_nxt = 8'b0;
            tick_nxt = 0;
            if (start && !pause) 
            begin
                state_nxt = START;
            end
        end

        START: 
        begin
            if (counter_reg == CLOCK_CYCLES - 1) 
            begin
                counter_nxt = 32'b0;
                tick_nxt = 1'b1;
                unit_tick_nxt = unit_tick_reg + 8'b1;
            end 
            else 
            begin
                counter_nxt = counter_reg + 1'b1;
                tick_nxt = 1'b0;
            end

            if (start & pause) 
            begin
                state_nxt = PAUSE;
            end

            if (!start && !pause) 
            begin
                state_nxt = IDLE;
            end
        end

        PAUSE: 
        begin
            counter_nxt = counter_reg;
            unit_tick_nxt = unit_tick_reg;
            if (start && !pause) 
            begin
                state_nxt = START;
            end
            if (pause && !stop)
            begin
                if (mem_write)
                begin
                    rw_en = 0;
                    memory[mem_address] = mem_data_write;
                    //mem_address = mem_address + 1;
                    address_nxt = address_reg + 8'b1;
                end
                else
                begin
                    rw_en = 1;
                    state_nxt = state_reg;
                end
            end
        end
      
        STOP:
        begin
            for (integer i = 0; i < address_nxt; i = i + 1)
            begin
                if (mem_read)
                begin
                    rw_en = 1; 
                    mem_data_read = memory[i];
                end
                else
                begin
                    rw_en = 0; 
                    state_nxt = state_reg;
                end
            end
        end
    endcase
end

always @(posedge clk or negedge rst) 
begin
    if (~rst) 
    begin
        counter_reg <= 32'b0;
        tick_reg <= 1'b0;
        unit_tick_reg <= 8'b0;
        state_reg <= IDLE;
        address_reg <= mem_address;
    end 
    else 
    begin
        counter_reg <= counter_nxt;
        tick_reg <= tick_nxt;
        unit_tick_reg <= unit_tick_nxt;
        state_reg <= state_nxt;
        address_reg <= address_nxt;
    end
end

endmodule
