module timer #(parameter MAX = 60)
(
    input clk,
    input rst,
    input enable,
    output wire [3:0] display_time_digit,
    output wire tick
);

reg [3:0] count_reg, count_nxt;
reg tick_reg, tick_nxt;

assign tick = tick_reg;
assign display_time_digit = count_reg;

always @ * 
begin
    count_nxt = count_reg;
    tick_nxt = tick_reg;

    if(enable) 
    begin
        if(count_reg == MAX - 1) 
        begin
            count_nxt = 'b0;
            tick_nxt = 1'b0;
        end 
        else if(count_reg == MAX - 2) 
        begin
            count_nxt = count_reg + 1'b1;
            tick_nxt = 1'b1;
        end 
        else 
        begin
            count_nxt = count_reg + 1'b1;
            tick_nxt = 1'b0;
        end
    end
end

always @ (posedge clk or negedge rst) 
begin
	if(~rst) 
    begin
		count_reg <= 'b0;
		tick_reg <= 1'b0;
	end 
    else 
    begin
		count_reg <= count_nxt;
		tick_reg <= tick_nxt;
	end
end
endmodule
