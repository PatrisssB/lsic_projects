module counter#(parameter CLOCK_CYCLES = 50_000_000) 
(
    input clk, rst,
    input start, pause,
    output wire tick,
    output wire [3:0] unit_tick
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
        end
	
        if (!start && !pause) 
        begin
          state_nxt = IDLE;
        end
      end
      
      PAUSE: begin
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

