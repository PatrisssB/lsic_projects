module top_wishbone 
(
  input wire clk,
  input wire rst,
  input start,
  input pause,
  output wire [7:0] segment1,
  output wire [7:0] segment2,
  output wire [7:0] segment3,
  output wire [7:0] segment4,

  // wishbone ports
  output wire [31:0] wb_addr,
  output wire [31:0] wb_data,
  output wire [3:0] wb_sel,
  output wire wb_cyc,
  output wire wb_stb,
  output wire wb_we,
  input wire [31:0] wb_data_read,
  input wire wb_ack
);

  wire e1, e2, e3, e4, e5;
  wire [3:0] sec1, sec2, min1, min2;


//counter wrapper instantiation
wb_master_counter_wrapper counter_wrapper_inst 
(
    .clk(clk),
    .rst(rst),
    .start(start),
    .pause(pause),
    .tick(e1),
    .unit_tick(e2),
    .wb_adr_i(wb_addr),
    .wb_dat_i(wb_data),
    .wb_sel_i(wb_sel),
    .wb_cyc_i(wb_cyc),
    .wb_stb_i(wb_stb),
    .wb_we_i(wb_we),
    .wb_dat_o(wb_data_read),
    .wb_ack_o(wb_ack)
);

//timer Wrapper instantiation
wb_slave_timer_wrapper timer_wrapper_inst (
    .clk(clk),
    .rst(rst),
    .enable(e1),
    .display_time_digit(sec1),
    .tick(e2),
    .wb_adr_i(wb_addr),
    .wb_dat_i(wb_data),
    .wb_sel_i(wb_sel),
    .wb_cyc_i(wb_cyc),
    .wb_stb_i(wb_stb),
    .wb_we_i(wb_we),
    .wb_dat_o(wb_data_read),
    .wb_ack_o(wb_ack)
);


// connect Wishbone signals to counter and timer wrappers
assign wb_addr = (counter_wrapper_inst.wb_cyc) ? counter_wrapper_inst.wb_addr : timer_wrapper_inst.wb_addr;
assign wb_data = (counter_wrapper_inst.wb_cyc) ? counter_wrapper_inst.wb_data : timer_wrapper_inst.wb_data;
assign wb_sel = (counter_wrapper_inst.wb_cyc) ? counter_wrapper_inst.wb_sel : timer_wrapper_inst.wb_sel;
assign wb_cyc = counter_wrapper_inst.wb_cyc | timer_wrapper_inst.wb_cyc;
assign wb_stb = counter_wrapper_inst.wb_stb | timer_wrapper_inst.wb_stb;
assign wb_we = counter_wrapper_inst.wb_we | timer_wrapper_inst.wb_we;

assign wb_data_read = (counter_wrapper_inst.wb_cyc) ? counter_wrapper_inst.wb_data_read : timer_wrapper_inst.wb_data_read;
assign wb_ack = (counter_wrapper_inst.wb_cyc) ? counter_wrapper_inst.wb_ack : timer_wrapper_inst.wb_ack;



  segment #(.DOT(1)) display_sec1 (.dig(sec1), .dig_out(segment1));
  segment #(.DOT(1)) display_sec2 (.dig(sec2), .dig_out(segment2));
  segment #(.DOT(1)) display_min1 (.dig(min1), .dig_out(segment3));
  segment #(.DOT(1)) display_min2 (.dig(min2), .dig_out(segment4));

endmodule
