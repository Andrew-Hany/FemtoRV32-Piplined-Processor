`timescale 1ns / 1ps
module Top_module(input clk,input uart_in,
 output [6:0]SSDout,
 output [7:0]leds,
 output wire [7:0]leds2, 
  output [3:0]Anode);
  
// wire [7:0]leds2;
//assign sAnode=4'b1111;
// assign Anode=4'b0000;
 
 
 UART_receiver_multiple_Keys keyys(
    clk,
    uart_in, // input receiving data line  ,
     leds // output
  );
 
   Full_dataPath riscv(  leds[0],clk ,  leds[1] ,leds [3:2] , 
   leds [7:4], leds2,   SSDout,  Anode);
endmodule
