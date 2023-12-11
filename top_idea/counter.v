module counter#(parameter CLOCK_CYCLES = 50_000_000) (
    input clk, rst,
    input start, pause,
    output wire tick,
    output wire [3:0] unit_tick
);

reg [31:0] counter_ff, counter_nxt;
reg [7:0] unit_tick_ff , unit_tick_nxt;
reg tick_ff, tick_nxt;
reg [3:0] state_ff, state_nxt;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam PAUSE = 2'b10;

assign tick = tick_ff;
assign unit_tick = unit_tick_ff;

always @(*) begin
    counter_nxt = counter_ff;
    tick_nxt = tick_ff;
    unit_tick_nxt = unit_tick_ff;
    state_nxt = state_ff;
    
    case (state_ff)
      IDLE: begin
        unit_tick_nxt = 8'b0;
        tick_nxt = 0;
        if (start && !pause) begin
          state_nxt = START;
        end
      end
      
      START: begin
        if (counter_ff == CLOCK_CYCLES - 1) begin
          counter_nxt = 'b0;
          tick_nxt = ~tick_ff;
	        unit_tick_nxt = unit_tick_ff + 8'b1;
        end else begin
          counter_nxt = counter_ff + 32'b1;
        end
        
        if (start & pause) begin
          state_nxt = PAUSE;
        end
	
        if (!start && !pause) begin
          state_nxt = IDLE;
        end
      end
      
      PAUSE: begin
        counter_nxt = counter_ff;
        unit_tick_nxt = unit_tick_ff;
        if (start && !pause) begin
          state_nxt = START;
        end
      end
    endcase
end

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        counter_ff <= 32'b0;
        tick_ff <= 0;
        unit_tick_ff <= 8'b0;
        state_ff <= IDLE;
    end else begin
        counter_ff <= counter_nxt;
        tick_ff <= tick_nxt;
        unit_tick_ff <= unit_tick_nxt;
        state_ff <= state_nxt;
    end
end
endmodule

