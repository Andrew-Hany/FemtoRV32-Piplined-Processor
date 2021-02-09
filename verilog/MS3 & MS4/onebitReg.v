`timescale 1ns / 1ps


module onebitReg( input  in, input S,input clk, input rst, output  Q);
wire C;
TwoXOneMUX  mux(  Q,in,S, C);
DFlipFlop flipflop( clk,  rst,  C, Q);

endmodule
