`timescale 1ns / 1ps
module TwoXOneMUX( input A,B,S,output reg C);
always @(*)
begin
 C = (A & ~S )|(S & B);
 end
endmodule

