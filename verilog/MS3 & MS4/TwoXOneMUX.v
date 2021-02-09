`timescale 1ns / 1ps


module TwoXOneMUX( input A,B,S,output  C);

assign C= S? B:A;
//always @(*)
//begin
// C = (A & ~S )|(S & B);
// end
endmodule
