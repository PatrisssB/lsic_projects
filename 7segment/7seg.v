// Code your design here
module seg7
(
	input clk,
	input rst,
  input start,
  input pause,
	output wire tick,
  output wire [6:0] sec1,
  output wire [6:0] sec2,
  output wire [6:0] min1,
  output wire [6:0] min2
);

  reg [31:0] count_reg, count_nxt;
  reg [6:0] sec1_reg, sec1_nxt, sec1_7;
  reg [6:0] sec2_reg, sec2_nxt, sec2_7;
  reg [6:0] min1_reg, min1_nxt, min1_7;
  reg [6:0] min2_reg, min2_nxt, min2_7;
  reg tick_reg, tick_nxt;
  reg [3:0] state_reg, state_nxt;

assign tick = tick_reg;
assign sec1 = sec1_7;
assign sec2 = sec2_7;
assign min1 = min1_7;
assign min2 = min2_7;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam PAUSE = 2'b10;

always @* 
begin
	count_nxt = count_reg;
  	sec1_nxt = sec1_reg;
        sec2_nxt = sec2_reg;
          min1_nxt = min1_reg;
          min2_nxt = min2_reg;
	tick_nxt = tick_reg;
  state_nxt = state_reg;

  if(count_nxt == 50_000_000) 
  begin
		count_nxt = 'b0;
        sec1_nxt = sec1_reg + 1'b1;
		tick_nxt = ~tick_reg;
	end 
	
	else 
	begin
		count_nxt = count_reg + 1'b1;
	end
	
  if(sec1_nxt == 10) 
  begin
	  sec1_nxt = 'b0;
    sec2_nxt = sec2_reg + 1'b1;
    if(sec2_nxt == 6) 
      begin
        sec2_nxt = 'b0;
        min1_nxt = min1_reg + 1'b1;
      end
  end

  if(min1_nxt == 10)
    begin
      min1_nxt = 'b0;
      min2_nxt = min2_reg + 1'b1;
        if(min2_nxt == 6)
          begin
            min2_nxt = 'b0;
          end
    end 	

  case (state_reg)
    IDLE: 
    begin
      tick_nxt = 0;
      if (start && !pause) 
      begin
        state_nxt = START;
      end
    end

    START: 
    begin
      if (count_nxt == 50_000_000) 
      begin
        count_nxt = 'b0;
        tick_nxt = ~tick_reg;
      end 
      else 
      begin
        count_nxt = count_reg + 32'b1;
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
      count_nxt = count_reg;
      if (start && !pause) 
      begin
        state_nxt = START;
      end
    end
  endcase
end

  always @ (sec1_reg) 
  begin
    case (sec1_reg)
  	0 : sec1_7 = 7'b0000001;
  	1 : sec1_7 = 7'b1001111;
    2 : sec1_7 = ~7'b1101101;
    3 : sec1_7 = ~7'b1111001;
    4 : sec1_7 = ~7'b0110011;
    5 : sec1_7 = ~7'b1011011;
    6 : sec1_7 = ~7'b1011111;
    7 : sec1_7 = ~7'b1110000;
    8 : sec1_7 = ~7'b1111111;
    9 : sec1_7 = ~7'b1111011;
  	default: sec1_7 = ~7'b1111110;
	endcase
  end
  always @ (sec2_reg) 
  begin
    case (sec2_reg)
  	0 : sec2_7 = 7'b0000001;
  	1 : sec2_7 = 7'b1001111;
    2 : sec2_7 = ~7'b1101101;
    3 : sec2_7 = ~7'b1111001;
    4 : sec2_7 = ~7'b0110011;
    5 : sec2_7 = ~7'b1011011;
    6 : sec2_7 = ~7'b1011111;
    7 : sec2_7 = ~7'b1110000;
    8 : sec2_7 = ~7'b1111111;
    9 : sec2_7 = ~7'b1111011;
  	default: sec2_7 = ~7'b1111110;
	endcase
  end
  
  always @ (min1_reg) 
  begin
    case (min1_reg)
  	0 : min1_7 = 7'b0000001;
  	1 : min1_7 = 7'b1001111;
    2 : min1_7 = ~7'b1101101;
    3 : min1_7 = ~7'b1111001;
    4 : min1_7 = ~7'b0110011;
    5 : min1_7 = ~7'b1011011;
    6 : min1_7 = ~7'b1011111;
    7 : min1_7 = ~7'b1110000;
    8 : min1_7 = ~7'b1111111;
    9 : min1_7 = ~7'b1111011;
  	default: min1_7 = ~7'b1111110;
	endcase
  end
  
  always @ (min2_reg) 
  begin
    case (min2_reg)
  	0 : min2_7 = 7'b0000001;
  	1 : min2_7 = 7'b1001111;
    2 : min2_7 = ~7'b1101101;
    3 : min2_7 = ~7'b1111001;
    4 : min2_7 = ~7'b0110011;
    5 : min2_7 = ~7'b1011011;
    6 : min2_7 = ~7'b1011111;
    7 : min2_7 = ~7'b1110000;
    8 : min2_7 = ~7'b1111111;
    9 : min2_7 = ~7'b1111011;
  	default: min2_7 = ~7'b1111110;
	endcase
  end
  
always @ (posedge clk or negedge rst) 
begin
	if(~rst) 
	begin
		count_reg <= 'b0;
      	sec1_reg <= 'b0;
        sec2_reg <= 'b0;
          min1_reg <= 'b0;
            min2_reg <= 'b0;
		tick_reg <= 1'b0;
    state_reg <= IDLE;

	end 
	else 
	begin
		count_reg <= count_nxt;
      	sec1_reg <= sec1_nxt;
        sec2_reg <= sec2_nxt;
          min1_reg <= min1_nxt;
            min2_reg <= min2_nxt;
		tick_reg <= tick_nxt;
    state_reg <= state_nxt;
	end
end
endmodule
