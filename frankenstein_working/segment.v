module segment#(parameter DOT = 1)
(
    input [3:0] dig,
    output reg [7:0] dig_out
);

always @(*) begin
    dig_out[7] = DOT;
    case(dig)	
        4'b0000 : dig_out[6:0] <= 7'b1000000;  
        4'b0001 : dig_out[6:0] <= 7'b1111001;  
        4'b0010 : dig_out[6:0] <= 7'b0100100;  
        4'b0011 : dig_out[6:0] <= 7'b0110000;
        4'b0100 : dig_out[6:0] <= 7'b0011001; 
        4'b0101 : dig_out[6:0] <= 7'b0010010; 
        4'b0110 : dig_out[6:0] <= 7'b0000010;  
        4'b0111 : dig_out[6:0] <= 7'b1111000;  
        4'b1000 : dig_out[6:0] <= 7'b0000000;  
        4'b1001 : dig_out[6:0] <= 7'b0010000;
    default: dig_out <= 7'b1111111;
    endcase
end
endmodule 
