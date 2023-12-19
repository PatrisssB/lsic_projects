//the basic implemenation of the memory
module memory #(parameter WIDTH = 8, parametere DEPTH = 6)
(
    //inputs of the block: clk, addr, we, data_in
    //output of the basic block: fata_out
    input clk,
    input rst, 
    input rd_wr_en,
    input [WIDTH-1:0] data_in,
    input [DEPTH-1:0] addr,
    output [WIDTH-1:0] data_out    
);

reg [WIDTH-1:0] mem_arr [2**DEPTH-1:0];

always @ (posedge clk)
if (rd_wr_en)
    mem_arr[addr] <= data_in;
assign data_out = mem_arr[addr];

endmodule