module BCD_decoder#(parameter DOT = 1)(
    input [3:0] BCD,
    output reg [7:0] BCD_OUT
);

always @(*) begin
    BCD_OUT[7] = DOT;
    case(BCD)
        4'b0000 : BCD_OUT[6:0] <= 7'b1000000;  //     a
        4'b0001 : BCD_OUT[6:0] <= 7'b1111001;  //    ----
        4'b0010 : BCD_OUT[6:0] <= 7'b0100100;  //   |   |
        4'b0011 : BCD_OUT[6:0] <= 7'b0110000;  //  f| g |b
        4'b0100 : BCD_OUT[6:0] <= 7'b0011001;  //    ----
        4'b0101 : BCD_OUT[6:0] <= 7'b0010010;  //   |   |
        4'b0110 : BCD_OUT[6:0] <= 7'b0000010;  //  e|   |c
        4'b0111 : BCD_OUT[6:0] <= 7'b1111000;  //    ----
        4'b1000 : BCD_OUT[6:0] <= 7'b0000000;  //      d
        4'b1001 : BCD_OUT[6:0] <= 7'b0010000;
    default: BCD_OUT <= 7'b1111111;
    endcase
end
endmodule 
