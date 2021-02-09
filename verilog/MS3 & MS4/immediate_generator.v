`timescale 1ns / 1ps

module immediate_generator(output reg [31:0] gen_out, input [31:0] inst );
always @(*)
begin
case (inst [6:0])
7'b0110111:  gen_out={{inst[31]?12'hFFFF:12'h0000},inst[31:12]};  //LUI
7'b0010111: gen_out=inst[31:12]<<11; //AUIPC
7'b1101111: gen_out = {{inst[31]?12'hFFFF:12'h0000},inst[31], inst[19:12],inst[20]  ,inst[30:21] };  // JAL
7'b1100111: gen_out={{inst[31]?20'hFFFFF:20'h00000},inst[31:20]}; //JALR
7'b1100011: gen_out = {{inst[31]?20'hFFFFF:20'h00000}, inst [31], inst [7], inst [30:25]  ,inst [11:8]}; // branches 
7'b0000011:  gen_out={{inst[31]?20'hFFFFF:20'h00000},inst[31:20]}; // loades
7'b0100011: gen_out = {{inst[31]?20'hFFFFF:20'h00000},inst [31:25],inst [11:7]};  // stores
7'b0010011: 
begin
if(inst[30]==1 && inst[14:12]==3'b101)
 gen_out={27'h00000,inst[24:20]};
else
 gen_out={{inst[31]?20'hFFFFF:20'h00000},inst[31:20]}; // immediates ( I_type)
 end
default : gen_out = 0;  
         endcase 

end 
endmodule
