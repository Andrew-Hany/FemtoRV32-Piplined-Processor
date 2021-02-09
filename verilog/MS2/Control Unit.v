`timescale 1ns / 1ps

module Control_unit(input [6:2]opcode, output reg branch,
output reg  memread,output reg  memtoreg,
output reg [1:0]aluop,output reg memwrite, output reg  alusrc,output reg regwrite,
output reg i_type,
output reg [1:0] AJ_control,
output reg lui_flag 

);

always @(*)
begin
case(opcode) 
5'b01100 : 
begin 
 branch=0;
  memread=0;
   memtoreg=0;
 aluop=10;
  memwrite=0; 
   alusrc=0;
    regwrite=1;
i_type=0;
lui_flag=0;
AJ_control=2'b00;
end
5'b00000 :
begin 
 branch=0;
  memread=1;
   memtoreg=1;
 aluop=00;
  memwrite=0; 
   alusrc=1;
    regwrite=1;
i_type=0;
lui_flag=0;
AJ_control=2'b00;
end
5'b01000:
begin 
 branch=0;
  memread=0;
   memtoreg=1;
 aluop=00;
  memwrite=1; 
   alusrc=1;
    regwrite=0;
i_type=0;
lui_flag=0;
AJ_control=2'b00;
end
5'b11000:
begin 
 branch=1;
  memread=0;
  // memtoreg=1;
 aluop=01;
  memwrite=0; 
   alusrc=0;
    regwrite=0;
    i_type=0;
    lui_flag=0;
    AJ_control=2'b00;
    end
5'b00100:
begin 
 branch=0;
  memread=0;
   memtoreg=0;
 aluop=10;
  memwrite=0; 
   alusrc=1;
    regwrite=1;
    i_type=1;
    lui_flag=0;
    AJ_control=2'b00;
    end
  5'b11011: //jal
  begin
   branch=1;
   memread=0;
    memtoreg=0;
  aluop=11;
   memwrite=0; 
    alusrc=1;
     regwrite=0;
     i_type=0;
     lui_flag=0;
     AJ_control=2'b01;
     
end
 5'b11001: //jalr
 begin
  branch=0;
   memread=0;
    memtoreg=0;
  aluop=10;
   memwrite=0; 
    alusrc=1;
     regwrite=1;
     lui_flag=0;
     i_type=0;
 AJ_control=2'b01;
 end
  5'b00101: //auipc
begin
  branch=0;
 memread=0;
  memtoreg=0;
aluop=00;  //add as load 
 memwrite=0; 
  alusrc=1;
  lui_flag=0;
   regwrite=1;
   i_type=0;
   AJ_control=2'b11;
end
 5'b01101:      //lui
 begin
  branch=0;
 memread=0;
  memtoreg=0;
aluop=10; 
 memwrite=0; 
  alusrc=1;
   regwrite=1;
   i_type=0;
   lui_flag=1;
   AJ_control=2'b00;
 end
endcase
end

endmodule

