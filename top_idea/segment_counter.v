module time_passed #(parameter MAX = 60)(
    input clk,
    input rst,
    input enable,
    output wire [3:0] display_time_digit,
    output wire tick
);

reg [3:0] count_ff, count_nxt;
reg tick_ff, tick_nxt;

assign tick = tick_ff;
assign display_time_digit = count_ff;

always @ * begin
    count_nxt = count_ff;
    tick_nxt = tick_ff;

    if(enable) begin
        if(count_ff == MAX - 1) begin
            count_nxt = 'b0;
            tick_nxt = 1'b0;
        end else if(count_ff == MAX - 2) begin
            count_nxt = count_ff + 1'b1;
            tick_nxt = 1'b1;
        end else begin
            count_nxt = count_ff + 1'b1;
            tick_nxt = 1'b0;
        end
    end
end

always @ (posedge clk or negedge rst) begin
	if(~rst) begin
		count_ff <= 'b0;
		tick_ff <= 1'b0;
	end else begin
		count_ff <= count_nxt;
		tick_ff <= tick_nxt;
	end
end
endmodule
