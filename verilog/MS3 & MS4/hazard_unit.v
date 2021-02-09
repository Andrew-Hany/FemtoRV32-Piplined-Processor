`timescale 1ns / 1ps
module hazard_unit( input  [4:0] RS1_IF_ID, input [4:0]RD_ID_EX,input [4:0]RS2_IF_ID,
                    input memread_ID_EX, output reg stall );
always@(*)
begin
if( RS1_IF_ID == RD_ID_EX | RS2_IF_ID == RD_ID_EX && memread_ID_EX !=0 && RD_ID_EX != 0)
    stall = 1'b1;
   //If((IF/ID.RegisterRs1==ID/EX.RegisterRd) OR(IF/ID.RegisterRs2==ID/EX.RegisterRd))and ID/EX.MemRead and ID/EX.RegisterRd ? 0 
 else
 stall =1'b0;
end
endmodule