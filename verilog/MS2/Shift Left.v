`timescale 1ns / 1ps

module shiftLeft(input [31:0]num ,output[31:0] C);
assign  C ={num[30:0],1'b0}; 
endmodule

