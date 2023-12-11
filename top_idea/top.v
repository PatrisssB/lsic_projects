module top(
    input clk,
    input rst,
    input start, pause,
    output wire [7:0] segment1, segment2, segment3, segment4
);

wire e1, e2, e3, e4, e5;
wire [3:0] sec1, sec2, min1, min2;

counter#(.CLOCK_PERIOD(50_000_000)) counter1 (.clk(clk), .rst(rst), .tick(e1), .start(start), .pause(pause));
segment_counter#(.MAX(10)) second_counter1 (.clk(clk), .rst(rst), .enable(e1), .display_time_digit(sec1), .tick(e2));
segment_counter#(.MAX(6)) second_counter2 (.clk(clk), .rst(rst), .enable(e1 & e2), .display_time_digit(sec2), .tick(e3));
segment_counter#(.MAX(10)) minute_counter1 (.clk(clk), .rst(rst), .enable(e1 & e2 & e3), .display_time_digit(min1), .tick(e4));
segment_counter#(.MAX(6)) minute_counter2 (.clk(clk), .rst(rst), .enable(e1 & e2 & e3 & e4), .display_time_digit(min2), .tick(e5));

BCD_decoder#(.DOT(1)) display_sec1(.BCD(sec1), .BCD_OUT(segment1));
BCD_decoder#(.DOT(1)) display_sec2(.BCD(sec2), .BCD_OUT(segment2));
BCD_decoder#(.DOT(0)) display_min1(.BCD(min1), .BCD_OUT(segment3));
BCD_decoder#(.DOT(1)) display_min2(.BCD(min2), .BCD_OUT(segment4));

endmodule