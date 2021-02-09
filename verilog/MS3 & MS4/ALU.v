`timescale 1ns / 1ps

module ALU (
input [31:0] in1, in2,input [2:0] func3,
input [3:0] aluSel,
output reg [31:0] result, output reg zero );
wire c1, c2;
wire [31:0]sum;
ripple_carry plus( in1,in2, 0,sum,c1);

wire [31:0]sub;
ripple_carry subt( in1,~in2+1, 0,sub,c2);
always @(*)
begin
case(aluSel)
4'b0000:
begin
zero=1;
 result = sum;
end 
4'b0001 :result= sub ;   
4'b0101 : result= in1 & in2  ;
4'b0100 :  result= in1 | in2 ;
4'b0111:result=in1^in2;
4'b1000: result = in1>>in2; //SRL
4'b1010:result = in1>>>in2; //SRA
4'b1001:result = in1<<in2; //SLL 
4'b1101:result={(in1<in2)?1:0};//SLT
4'b1111:result={({in1<0?-in1:in1}<{in2<0?-in2:in2})?1:0};//SLTU
4'b0110:result={in2,12'b0}; ///LUI  
4'b0010 :  // branching 
begin
case(func3)
3'b000: if (in1 == in2) zero =1; else zero = 0; // beq zero =1 branch =1
3'b001: if (in1 != in2) zero = 1; else zero = 0; // bne branch =1  zero =0
3'b100: if ((in1-in2)<0) zero = 1; else zero = 0;    // blt branch=1   
3'b101: if (in1>= in2) zero = 1; else zero = 0;  //bge branch=1
3'b110: if (({in1<0?-in1:in1}-{in2<0?-in2:in2})<0) zero = 1; else zero = 0;   // bltu branch=1
3'b111: if (({in1<0?-in1:in1}-{in2<0?-in2:in2})>=0) zero = 1; else zero = 0;  //bgeu branch=1

default: zero=0;
endcase
end
4'b0011:zero=1;//jal
default:result=0;
endcase
end
//  assign zero={result==0?1:0}; // branch
endmodule