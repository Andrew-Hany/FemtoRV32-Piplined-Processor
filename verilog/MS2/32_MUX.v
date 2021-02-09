`timescale 1ns / 1ps



module ThirtytwoMUX(input [31:0]A,input [31:0]B,input S ,output[31:0] C);
genvar i;  
generate 
for (i=0;i<=31;i=i+1)
begin
TwoXOneMUX m(A[i],B[i],S,C[i]);
 end 
  endgenerate 

endmodule

