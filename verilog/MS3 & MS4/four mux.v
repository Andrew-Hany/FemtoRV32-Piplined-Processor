
    `timescale 1ns / 1ps
    
    
    module FourMuxForward(input [31:0] read_data_ID_EX, input [31:0] write_data_mux, 
    input [31:0] ALU_result_EX_MEM, input[1:0] forward,
     output reg[31:0]RD1_output
     );
    
    always@(*)
    begin
    case (forward)
    2'b00 :RD1_output=read_data_ID_EX;
    2'b01 :RD1_output=write_data_mux;
    2'b10 :RD1_output=ALU_result_EX_MEM;
//    2'b11:

    default : RD1_output=0;
    endcase 
    end 
    endmodule


