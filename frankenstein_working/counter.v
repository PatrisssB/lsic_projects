module counter#(parameter CLOCK_CYCLES = 50_000_000, MEM_SIZE = 1024, MEM_WIDTH = 8) 
(
    input clk, rst,
    output wire tick,
    output wire [3:0] unit_tick,
    
    // memory ports
    input [MEM_WIDTH-1:0] mem_data_read,
    input mem_read,
    input [MEM_WIDTH-1:0] mem_data_write,
    input mem_write,
    input [MEM_WIDTH-1:0] mem_address
);

reg [31:0] counter_reg, counter_nxt;
reg [7:0] unit_tick_reg, unit_tick_nxt;
reg tick_reg, tick_nxt;
reg [3:0] state_reg, state_nxt;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam PAUSE = 2'b10;

assign tick = tick_reg;
assign unit_tick = unit_tick_reg;

always @(*) 
begin
    counter_nxt = counter_reg;
    tick_nxt = tick_reg;
    unit_tick_nxt = unit_tick_reg;
    state_nxt = state_reg;
    
    // memo read op
    if (mem_read)
    begin
        case (mem_address)
            // ...
            default: 
                state_nxt = state_reg;
        endcase
    end
    
    case (state_reg)
        IDLE: 
        begin
            unit_tick_nxt = 8'b0;
            tick_nxt = 0;
            if (state_reg == START) 
            begin
                state_nxt = START;
            end
        end
      
        START: begin
            if (counter_reg == CLOCK_CYCLES - 1) 
            begin
                counter_nxt = 'b0;
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
                
                // mem write op when PAUSE opcode is seen
                if (mem_write && (mem_address == 2'b10 )) //pause opcode address
                begin
                    memory[mem_address] <= counter_reg;
                end
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
        end
    endcase
end

always @(posedge clk or negedge rst) 
begin
    if (~rst) 
    begin
        counter_reg <= 'b0;
        tick_reg <= 1'b0;
        unit_tick_reg <= 8'b0;
        state_reg <= IDLE;
    end 
    else 
    begin
        counter_reg <= counter_nxt;
        tick_reg <= tick_nxt;
        unit_tick_reg <= unit_tick_nxt;
        state_reg <= state_nxt;
    end
end
endmodule
