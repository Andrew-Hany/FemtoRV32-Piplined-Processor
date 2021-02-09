`timescale 1ns / 1ps

module ripple_carry(input [31:0] x_ripple,
input [31:0] y_ripple,
input cin,
output [31:0] sum_ripple,
output cout1_ripple
);


wire [31:0]c;
FullAdder add(x_ripple[0],y_ripple[0],cin,sum_ripple[0],c[0]);
genvar i;
generate
for(i=1;i<32;i=i+1)
begin
FullAdder add1(x_ripple[i],y_ripple[i],c[i-1],sum_ripple[i],c[i]);
end
endgenerate 
assign cout1_ripple= c[31];
endmodule
