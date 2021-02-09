`timescale 1ns / 1ps


module ALU_Control(input [1:0]aluop, input [14:12]intr1,input  instr2 ,input i_type,input lui_flag,
output reg[3:0]aluS);
always @(*)
begin
if(aluop==2'b00) // lw & sw
aluS=4'b0000;

if(aluop==2'b11) //jal
aluS=4'b0011;

else if(aluop==2'b01 ) // branching
aluS=4'b0010;
else if (aluop == 2'b10 &&lui_flag==0 && i_type==0&& instr2 == 0 && intr1 == 3'b000) // R- type instruction (ADD) //instr2 VI
aluS = 4'b0000;

else if (aluop == 2'b10 &&lui_flag==0 && i_type==1&&  intr1 == 3'b000) // R- type instruction (ADDi) //same aluS as add
aluS = 4'b0000;

else if (aluop == 2'b10 && lui_flag==0 && instr2 == 1 && i_type==0&&  intr1 == 3'b000) // R- type instruction (SUB) //instr2 VI
aluS = 4'b0001;



else if (aluop == 2'b10  &&lui_flag==0 && intr1 == 3'b111) // R- type instruction (AND) && ANDI
aluS = 4'b0101;

else if (aluop == 2'b10 &&lui_flag==0 && intr1 == 3'b110) // R- type instruction (OR) && ORI
aluS = 4'b0100;

else if (aluop == 2'b10 &&lui_flag==0 && intr1 == 3'b100) // R- type instruction (XOR)
aluS = 4'b0111;

else if (aluop == 2'b10 &&lui_flag==0 &&i_type==0 && instr2 == 0 && intr1 == 3'b101) // R- type instruction (SRL)
aluS = 4'b1000;


else if (aluop == 2'b10 && instr2 == 1 &&lui_flag==0 && i_type==0 && intr1 == 3'b101) // R- type instruction (SRA)
aluS = 4'b1010;

else if (aluop == 2'b10  &&lui_flag==0 && intr1 == 3'b001) // R- type instruction (SLL)
aluS = 4'b1001;

else if (aluop == 2'b10 &&lui_flag==0 && intr1 == 3'b010) // R- type instruction (SLT)
aluS = 4'b1101;

else if (aluop == 2'b10 &&lui_flag==0 && intr1 == 3'b011) // R- type instruction (SLTU)
aluS = 4'b1111;

else if (aluop == 2'b10 &&lui_flag==0 &&i_type==1 && instr2 == 0 && intr1 == 3'b101) // R- type instruction (SRLI)
aluS = 4'b1000;


else if (aluop == 2'b10 &&lui_flag==0 && instr2 == 1 &&i_type==1 && intr1 == 3'b101) // R- type instruction (SRAI)
aluS = 4'b1010;

//added by salma

//lui
else if(aluop == 2'b10 && lui_flag==1 )
aluS = 4'b0110;

end
endmodule