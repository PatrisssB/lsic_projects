module wb_slave_timer_wrapper 
(
  input wire clk,
  input wire rst,
  input wire enable,
  output wire [3:0] display_time_digit,
  output wire tick,
  input wire [31:0] wb_adr_i,
  input wire [31:0] wb_dat_i,
  input wire [3:0] wb_sel_i,
  input wire wb_cyc_i,
  input wire wb_stb_i,
  input wire wb_we_i,
  output wire [31:0] wb_dat_o,
  output wire wb_ack_o
);
  wire [3:0] timer_tick;

  timer #(.MAX(10)) timer_inst 
  (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .display_time_digit(display_time_digit),
    .tick(timer_tick)
  );

  assign tick = timer_tick;
endmodule
