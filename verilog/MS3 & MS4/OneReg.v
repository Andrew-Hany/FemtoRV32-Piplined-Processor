`timescale 1ns / 1ps

module OneReg(input clk,input S,input [31:0] in,input rst, output [31:0] Q );
genvar i;  
generate 
for (i=0;i<=31;i=i+1)
begin
    onebitReg mod1 (   in[i],  S, clk,  rst,   Q[i]);
    end 
   endgenerate 
endmodule