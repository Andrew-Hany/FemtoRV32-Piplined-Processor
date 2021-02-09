.text

lw t1,0(zero)#0    pc =0
lw t2,4,(zero) #12  pc =4
lw t3,8(zero) #10    pc =8


jal  jumb            pc = 12
addi t1,t1,1         pc =16
jumb:

auipc t2,10000       pc = 20
lui t3,10000         pc = 24

addi t4,zero,0       pc = 28
jalr t0,t4,36      # pc = 32  t0 = the return address (if we are at 4 , t0 =8  &&& the new pc = 2+ t4)

addi t1,t1,1        pc = 36
jumb2:     pc = 40
sw t3,12(zero) #10    

