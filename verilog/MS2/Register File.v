`timescale 1ns / 1ps


module RegisterFile(input clk, rst, 
input[4:0] readreg1, readreg2, writereg,
input[31:0] writedata,
input regwrite,
output[31:0] readdata1, readdata2  );
reg [31:0]S;
wire [31:0]dataout [0:31];
genvar i; 
assign dataout[0]=0;

generate 

for (i=1;i<32;i=i+1)
begin
OneReg regs (clk,S[i],writedata, rst,  dataout[i]);
end
endgenerate

// placement of MUXes

assign readdata1 =dataout[readreg1];
assign readdata2 =dataout[readreg2];
always@(*)
begin
S=0;
if (regwrite)
S[writereg] =1;

end
    
endmodule

