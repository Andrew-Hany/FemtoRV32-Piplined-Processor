`timescale 1ns / 1ps
module Forward_unit(input [4:0] Rs1,[4:0] Rs2,[4:0]Ex_mem_RegistarRd,[4:0] Mem_Wb_RegistarRd,
input exmem_Regwrite,memwb_Regwrite,output reg [1:0]f1,reg[1:0]f2 );

always@(*)
begin
if(exmem_Regwrite==1 && Ex_mem_RegistarRd!=0 && Ex_mem_RegistarRd==Rs1 )
f1=2'b10;
else if(memwb_Regwrite==1 && Mem_Wb_RegistarRd!=0 && Mem_Wb_RegistarRd==Rs1 )
f1=2'b01;
else f1=2'b00;

 if(exmem_Regwrite==1 && Ex_mem_RegistarRd!=0 && Ex_mem_RegistarRd==Rs2 )

f2=2'b10;
 else 


 if(memwb_Regwrite==1 && Mem_Wb_RegistarRd!=0 && Mem_Wb_RegistarRd==Rs2 )
f2=2'b01;
else 

f2=2'b00;

end
endmodule

