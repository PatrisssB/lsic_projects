module wb_master_counter_wrapper 
(
  input wire clk,
  input wire rst,
  input wire start,
  input wire pause,
  output wire tick,
  output wire [3:0] unit_tick,
  input wire [31:0] wb_adr_i,
  input wire [31:0] wb_dat_i,
  input wire [3:0] wb_sel_i,
  input wire wb_cyc_i,
  input wire wb_stb_i,
  input wire wb_we_i,
  output wire [31:0] wb_dat_o,
  output wire wb_ack_o
);
  wire [3:0] counter_tick;

  counter #(.CLOCK_CYCLES(50_000_000)) counter_inst 
  (
    .clk(clk),
    .rst(rst),
    .start(start),
    .pause(pause),
    .tick(counter_tick),
    .unit_tick(unit_tick),
    .wb_adr_i(wb_adr_i),
    .wb_dat_i(wb_dat_i),
    .wb_sel_i(wb_sel_i),
    .wb_cyc_i(wb_cyc_i),
    .wb_stb_i(wb_stb_i),
    .wb_we_i(wb_we_i),
    .wb_dat_o(wb_dat_o),
    .wb_ack_o(wb_ack_o)
  );

  assign tick = counter_tick;
endmodule
