`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2020 06:38:00 PM
// Design Name: 
// Module Name: CLK_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CLK_divider(input clk, input rst,  output reg Q );
    always @ (posedge clk  or posedge rst)
 begin
// Asynchronous Reset
if (rst)
Q <= 1'b0;
else
Q <= ~Q;
end
endmodule