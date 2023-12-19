module top_memory 
(
    input clk,
    input rst,
    input start, pause,
    output wire [7:0] segment1, segment2, segment3, segment4
);

wire e1, e2, e3, e4, e5;
wire [3:0] sec1, sec2, min1, min2;
wire [7:0] memory_data_read, memory_data_write;
wire mem_read, mem_write;
wire [7:0] mem_address;

counter_memory#(.CLOCK_CYCLES(50_000_000)) counter1 
(
    .clk(clk),
    .rst(rst),
    .tick(e1),
    .start(start),
    .pause(pause),
    .mem_data_read(memory_data_read),
    .mem_data_write(memory_data_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_address(mem_address)
);

timer#(.MAX(10)) second_counter1 
(
    .clk(clk),
    .rst(rst),
    .enable(e1),
    .display_time_digit(sec1),
    .tick(e2)
);

timer#(.MAX(6)) second_counter2 
(
    .clk(clk),
    .rst(rst),
    .enable(e1 & e2),
    .display_time_digit(sec2),
    .tick(e3)
);

timer#(.MAX(10)) minute_counter1 
(
    .clk(clk),
    .rst(rst),
    .enable(e1 & e2 & e3),
    .display_time_digit(min1),
    .tick(e4)
);

timer#(.MAX(6)) minute_counter2 
(
    .clk(clk),
    .rst(rst),
    .enable(e1 & e2 & e3 & e4),
    .display_time_digit(min2),
    .tick(e5)
);

segment#(.DOT(1)) display_sec1 
(
    .dig(sec1),
    .dig_out(segment1)
);

segment#(.DOT(1)) display_sec2 
(
    .dig(sec2),
    .dig_out(segment2)
);

segment#(.DOT(1)) display_min1 
(
    .dig(min1),
    .dig_out(segment3)
);

segment#(.DOT(1)) display_min2 
(
    .dig(min2),
    .dig_out(segment4)
);

endmodule
