`timescale 1ns / 1ps
module Full_dataPath( input clk,input fpga, input rst ,input [1:0] LedSel , 
input [3:0] ssdSel , output reg [7:0] leds, output  [6:0]SSDout, output[3:0] anodes);

wire [31:0] adder1,adder2,PCmux,PCout;
wire cout1_ripple1,cout1_ripple2;
wire [31:0]ints_out;
wire [31:0]readdata1, readdata2 ;
wire  [31:0] gen_out; //should be reg || wire
wire branch;
 wire  memread;
  wire  memtoreg;
 wire [1:0]aluop;
  wire memwrite; 
   wire  alusrc;
    wire regwrite; 
    wire [3:0]aluS;
    wire [31:0]outmux_input_alu;
    wire [31:0]ALU_result;
    wire zero;
    wire [31:0] dataMem_out;
    wire [31:0] writingData;
    wire [31:0] shiftout;
    reg S;
    wire i_type;
    wire [1:0] AJ_control;
    wire [31:0]WD ;
    reg [12:0]num;
    wire lui_flag;
    
    
//instantiate 32bitreg PCin PCout
OneReg  pc( clk,1, PCmux, rst,  PCout );
ripple_carry  ripplecar0(PCout,
32'd4,
0,
adder1,
cout1_ripple1
);
//adder tany
ripple_carry  ripplecar1(PCout,
shiftout,
0,
adder2,
cout1_ripple2
);

//mux
wire [31:0]pcmux2;
ThirtytwoMUX  mux3(adder1,adder2,branch&zero ,pcmux2); 
always@(*)
begin
if(ints_out[6:2]==5'b11001)
S=1;
else 
S=0;
end
ThirtytwoMUX  mux4(pcmux2,ALU_result,S ,PCmux);
//register (PCmux, PCin)  //reload the PC

//instmem
InstMem instmem(PCout[7:2],ints_out);  
//control unit 
Control_unit  controlunit(ints_out[6:2], branch,
   memread, memtoreg,
aluop, memwrite,  alusrc, regwrite,i_type,AJ_control , lui_flag);
//alu_control
ALU_Control   aluControl(aluop,  ints_out[14:12],ints_out[30] ,i_type,lui_flag,aluS);
//registerfile
RegisterFile regfile( clk, rst, 
ints_out[19:15], ints_out[24:20], ints_out[11:7],
 WD,
 regwrite,
 readdata1, readdata2  );
//immGenerator
immediate_generator   immgen( gen_out, ints_out );
//shifting left
 shiftLeft sh(gen_out ,shiftout);
//mux 
 ThirtytwoMUX mux (readdata2,gen_out,alusrc ,outmux_input_alu);
 //ALU
 ALU alu(
 readdata1, outmux_input_alu, ints_out [14:12],
 aluS,
 ALU_result,  zero );
 //dataMem
 DataMem  datamem( clk, memread, memwrite,
  ALU_result[7:2] , readdata2,ints_out [14:12],  dataMem_out);
//mux after the datamem
ThirtytwoMUX mux_writing (ALU_result,dataMem_out,memtoreg ,writingData);

FourMux  WD_mux(adder2, adder1, writingData,  AJ_control, WD );


//switch or if on input ledsel to generate outputs leds
always @(*)
begin
        case(LedSel)
        2'b00 :
        begin
         leds[0]= regwrite;
         leds[1]= alusrc;
         leds[3:2]=  aluop;
         leds[4]=  memread;
         leds[5]= memwrite;
         leds[6]=  memtoreg;
         leds[7]=  branch;
        end
        2'b01:
        begin
        leds[3:0]=aluS;
        leds [4]=zero;
        leds[5]=branch&zero;
        leds[7:6] =0;
       
        end
        2'b11:
             leds[7:0]= {0,ints_out[6:0]}; //  monotring the opcode
        ////switch or if on input ssdsel to generate ssdnumber
        default : leds[7:0]= 0; 
endcase

end
always@(*) begin 
case (ssdSel)
4'b0000:num = PCout;
4'b0001: num =PCout+4;
4'b0010:  num = adder1;
4'b0011: num = PCmux;
4'b0100: num = readdata1;
4'b0101: num= readdata2;
4'b0110: num=  ints_out[11:7]; 
4'b0111: num= gen_out;
4'b1000: num= shiftout;
4'b1001:num=outmux_input_alu;
4'b1010: num= ALU_result;
4'b1011:num=dataMem_out;
default : num = 0;
endcase
  end
//instantiate 7 seg

seven ssd ( fpga, num,anodes,SSDout);

endmodule

