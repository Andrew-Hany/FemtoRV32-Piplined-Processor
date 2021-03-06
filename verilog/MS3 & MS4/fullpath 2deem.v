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
    reg [12:0]num;
    // wires of piplened regs
    wire [31:0] IF_ID_PC, IF_ID_Inst; // input to REG1_ID
    //output of ID_EX
wire memtoreg_ID_out;
wire regwrite_ID_out;
wire memread_ID_out;
wire memwrite_ID_out; 
   wire  branch_ID_out;
   wire [1:0]aluop_ID_out;
   wire alusrc_ID_out;
   wire [31:0]IF_ID_PC_ID_out;
   wire [31:0]readdata1_ID_out;
   wire [31:0]readdata2_ID_out;//////////
   wire [31:0]gen_out_ID_out;
   wire [3:0]ints_out_ID_out_up;
   wire [4:0]ints_out_ID_out_down;
   //out of EX/MEM
  wire  memtoreg_EX_out;
  wire regwrite_EX_out;
  wire memread_EX_out;
   wire memwrite_EX_out;
   wire  branch_EX_out;
     wire [31:0]adder_branch_Ex_out;
     wire zero_EX_out;
     wire [31:0]ALU_result_EX_out;
     wire [31:0]readdata2_EX_out;///////////
     wire [4:0]ints_out_EX_out_down;
   //out of MEM_WB
   wire memtoreg_MEM_out;
      wire  regwrite_MEM_out;
      wire  [31:0] dataMem_out_MEM_out;
      wire [31:0]ALU_result_MEM_out;
      wire [4:0]ints_out_MEM_out_down;
     wire [31:0] RD1_output;
      wire [31:0] RD2_output;
   wire [4:0]RS1, RS2;
    wire [1:0]forwardA,forwardB;
    wire stall;
    wire [31:0]ints_out2;
    wire i_type;
     wire i_type_ID_out;
     wire [31:0] adder1_IF_out;
    wire [31:0] adder1_EX_out;  //*****
    wire [31:0] adder1_ID_out; // aren't they the same????
      wire [31:0] adder1_MEM_out;
    wire [31:0] adder_branch_MEM_out;
    wire[1:0] AJ_control;
    wire [1:0] AJ_control_ID_out;
     wire [1:0] AJ_control_EX_out;
     wire [1:0]AJ_control_MEM_out;
     wire [31:0]WD;
     wire [3:0] ints_out_EX_out_up;
     
     wire lui_flag_EX_out;
     wire lui_flag;
      wire  lui_flag_ID_out;
      wire lui_flag_MEM_out;
      
    /// integration 
//instantiate 32bitreg PCin PCout
//module OneReg(input clk,input S,input [31:0] in,input rst, output [31:0] Q );

wire ecall ;
reg Terminated=0;
reg pauseEXE ;

assign ecall= {IF_ID_Inst[6:0]==7'b1110011}?1:0;
always @(*)


begin
//if(rst )
//pauseEXE=0;
if ( ecall )
//if happened once  
begin
pauseEXE=1;
Terminated=1;
end
else if (Terminated !=1 && ecall ==0 )
pauseEXE=0;
end

OneReg  pc( clk,~pauseEXE,PCmux, rst,  PCout );

ripple_carry  ripplecar0(PCout,
32'd4,
0,
adder1,
cout1_ripple1
);
//adder branch  (DONE)
ripple_carry  ripplecar1(IF_ID_PC_ID_out,
shiftout,
0,
adder2,
cout1_ripple2
);

//mux
ThirtytwoMUX  mux3(adder1,adder_branch_Ex_out,branch_EX_out & zero_EX_out ,PCmux);
//register (PCmux, PCin)  //reload the PC

//instmem

InstMem instmem(PCout[7:2],ints_out2); 
//control hazarads 

wire PCsrc;
wire ebreak;
wire fence;
assign PCsrc=branch_EX_out & zero_EX_out;
assign ebreak={IF_ID_Inst[6:0]==7'b1110011 &&IF_ID_Inst[20]==1'b1}?1:0; //ebreak
assign fence={IF_ID_Inst[6:0]==7'b0001111}?1:0;//fence
 ThirtytwoMUX mux_ControlH (ints_out2
 ,32'b0000000_00000_00000_000_00000_0110011,PCsrc| ebreak|fence,ints_out);
 
//---------------------------------------If/ID----------------------------------

  sixtyFour_reg #(96) IF_ID  (clk, ~stall,{PCout,ints_out,adder1},rst,{IF_ID_PC,IF_ID_Inst,adder1_IF_out});
//control unit  (DONE)

Control_unit  controlunit(IF_ID_Inst[6:2], branch,
   memread, memtoreg,
aluop, memwrite, alusrc, regwrite,i_type,AJ_control,lui_flag );

//mux hazards after control unit ------------//
wire [11:0]control_hazard;
 ThirtytwoMUX mux_hazard ({memtoreg,regwrite,memread,memwrite,
 branch,aluop,alusrc,i_type,AJ_control,lui_flag},0,stall|(branch_EX_out & zero_EX_out) ,control_hazard);
  
    
//alu_control (DONE)
ALU_Control   aluControl(aluop_ID_out,  ints_out_ID_out_up[2:0],ints_out_ID_out_up[3],
i_type_ID_out ,lui_flag_ID_out,aluS);
// mux bta3 el jalw auipc

//registerfile DONE
RegisterFile regfile(~ clk, rst, 
IF_ID_Inst[19:15], IF_ID_Inst[24:20], ints_out_MEM_out_down,
 WD,
 regwrite_MEM_out,
 readdata1, readdata2  );
//immGenerator    (DONE)
immediate_generator   immgen( gen_out, IF_ID_Inst );
//------------------hazarads--------------------/

hazard_unit hazardU ( IF_ID_Inst[19:15], ints_out_ID_out_down,IF_ID_Inst[24:20],
                     memread_ID_out,  stall );

//------------------------------- ID_EX--------------------------------

 sixtyFour_reg #(191) ID_EX (clk, 1'b1,
 {control_hazard ,  IF_ID_PC  ,  readdata1, readdata2
 ,gen_out,{IF_ID_Inst[30],IF_ID_Inst[14:12]},IF_ID_Inst[11:7]
 ,IF_ID_Inst[19:15],IF_ID_Inst[24:20],adder1_IF_out
  },rst,

{{memtoreg_ID_out,regwrite_ID_out, memread_ID_out, memwrite_ID_out, branch_ID_out,aluop_ID_out
,alusrc_ID_out,i_type_ID_out,AJ_control_ID_out,lui_flag_ID_out},IF_ID_PC_ID_out, readdata1_ID_out,readdata2_ID_out,
  gen_out_ID_out
 ,ints_out_ID_out_up
 , ints_out_ID_out_down
 ,RS1,RS2,adder1_ID_out
 });


//shifting left  (done)
 shiftLeft sh(gen_out_ID_out ,shiftout);
//mux (DONE)


  FourMuxForward mux_one (readdata1_ID_out,writingData, ALU_result_EX_out, forwardA, RD1_output);
  FourMuxForward mux_two (readdata2_ID_out,writingData, ALU_result_EX_out, forwardB, RD2_output);
  
   ThirtytwoMUX mux (RD2_output,gen_out_ID_out,alusrc_ID_out ,outmux_input_alu);
   Forward_unit fowr( RS1,RS2, ints_out_EX_out_down,ints_out_MEM_out_down
 ,   regwrite_EX_out, regwrite_MEM_out,forwardA,forwardB 
     );
 //ALU  (Done)
 ALU alu(
 RD1_output, outmux_input_alu,ints_out_ID_out_up[2:0],
 aluS,
 ALU_result,  zero );
 
 wire [7:0] ex_mem_controls= (branch_EX_out & zero_EX_out)?5'b00000: {memtoreg_ID_out,
 regwrite_ID_out, memread_ID_out, memwrite_ID_out,
  branch_ID_out,AJ_control_ID_out,lui_flag_ID_out};
//----------------------EX/MEM----------------------------------------------------

  sixtyFour_reg #(146) EX_MEM (clk,1 ,
 {ex_mem_controls,
  adder2,zero,ALU_result,RD2_output,ints_out_ID_out_down,adder1_ID_out,ints_out_ID_out_up },rst,

{ memtoreg_EX_out,
regwrite_EX_out,
   memread_EX_out,
    memwrite_EX_out,
     branch_EX_out,
     AJ_control_EX_out,
     lui_flag_EX_out,
      adder_branch_Ex_out,
      zero_EX_out,
     ALU_result_EX_out,
      readdata2_EX_out,
     ints_out_EX_out_down,adder1_EX_out,ints_out_EX_out_up});
     
 //dataMem
 DataMem  datamem( clk, memread_EX_out, memwrite_EX_out,
  ALU_result_EX_out[7:2] , readdata2_EX_out,ints_out_EX_out_up[2:0],  dataMem_out);
  //----------------------MEM/WB----------------------------------------------------

  sixtyFour_reg #(138) MEM_WB (clk, 1'b1,
   {regwrite_EX_out,memtoreg_EX_out,
     dataMem_out,ALU_result_EX_out,ints_out_EX_out_down, 
     adder_branch_Ex_out,adder1_EX_out,AJ_control_EX_out
     ,lui_flag_EX_out
     },rst,
   
  { 
      
       regwrite_MEM_out,
       memtoreg_MEM_out,
      dataMem_out_MEM_out,ALU_result_MEM_out,
             ints_out_MEM_out_down, adder_branch_MEM_out,adder1_MEM_out,AJ_control_MEM_out,lui_flag_MEM_out
 });
       
       
       
//mux after the datamem
ThirtytwoMUX mux_writing (ALU_result_MEM_out,dataMem_out_MEM_out,memtoreg_MEM_out ,writingData);
//Writing data from jal, Ahipc , regiter file
FourMux muxj (adder_branch_MEM_out, adder1_MEM_out, writingData, AJ_control_MEM_out,WD );

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
             leds[7:0]= {1'b0,ints_out[6:0]}; //  monotring the opcode
        ////switch or if on input ssdsel to generate ssdnumber
        default : leds[7:0]= 0; 
endcase

end
always@(*) begin 
case (ssdSel)
4'b0000:num = PCout;
4'b0001: num =PCout+4;
4'b0010:  num = adder2;
4'b0011: num = PCmux;
4'b0100: num = readdata1;
4'b0101: num= readdata2;
4'b0110: num=  writingData; 
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

