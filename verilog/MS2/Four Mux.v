`timescale 1ns / 1ps


module FourMux(input [31:0]A, input [31:0]J, input [31:0]E, input[1:0] AJ_control, output reg[31:0]WD );

always@(*)
begin
case (AJ_control)
2'b00 :WD=E;
2'b01 :WD=J;
2'b11 :WD=A;
default : WD=0;
endcase 
end 
endmodule

