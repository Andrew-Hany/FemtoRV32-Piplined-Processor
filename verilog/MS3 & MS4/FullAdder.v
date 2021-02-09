


`timescale 1ns/1ns

module FullAdder(input a,b,c, output sum1, carry_out);

wire w1,w2,w3;
assign sum1=a^b^c;
assign w1=a&b;
assign w2=a&c;
assign w3=c&b;
assign carry_out=w1|w2|w3;

endmodule
