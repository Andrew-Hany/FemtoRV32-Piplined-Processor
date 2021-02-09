#lw t0, 0(zero)   # 10 ->1010
lw t1, 4(zero) #12  ->1100
#lw t2, 8(zero)  #1   ->5


addi  t3,t1,10  #22
andi t5,t1,10    #1000  ->8
xori t6,t1,10     #0100 ->4

ori s0,t1,10     #1110 ->14
slli s1,t1,2    #24
slti  s2,t1,10   #0

sltiu s3,t1,10   #0
srai  s4,t1,2  #6
srli  s5,t1,10   #6
