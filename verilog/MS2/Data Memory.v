`timescale 1ns / 1ps
module DataMem
(input clk, input MemRead, input MemWrite,
input [5:0] addr, input [31:0] data_in, input [2:0]func3, output reg[31:0] data_out);
reg [31:0] mem [0:63]; // dataout = [0:7] mem[addr];
always @(posedge clk) begin
if (MemWrite==1 && func3 ==3'b010) //SW
mem[addr] <= data_in;
else if (MemWrite==1 && func3 ==3'b001)//sh
mem[addr][15:0] <= data_in;
else if (MemWrite==1 && func3 ==3'b000)//sb
mem[addr][7:0] <= data_in;
end
initial
 begin
 mem[0]=32'd0;
 mem[1]=32'd20;
 mem[2]=32'd10; 
 end

always @(*)
begin
 if ( func3 == 3'b000) //LB
  data_out = MemRead ? mem[addr][7:0]: 0;
 else if ( func3 == 3'b001) //LH
  data_out = MemRead ? mem[addr][15:0]: 0;
 else if ( func3 == 3'b010) //LW
  data_out = MemRead ? mem[addr]:0;
 else if ( func3 == 3'b100) //LBU
  data_out = MemRead ?{ 24'h0,mem[addr][7:0]}:0;
 else if ( func3 == 3'b101)// LHU
 data_out = MemRead ? {16'h0,mem[addr][15:0]}: 0;
end
//assign data_out = MemRead ? mem[addr]:0;
 endmodule
