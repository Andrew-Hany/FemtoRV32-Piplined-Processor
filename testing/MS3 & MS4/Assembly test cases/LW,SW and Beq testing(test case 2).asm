main:


lw t4, 0(zero)     //pc=0 
lw t5, 4(zero)     //pc=4
lw t6, 8(zero)     //pc=8
loop:
beq t4,t6,exit     //pc=12        
add  t4,t4,t5       //pc=16
beq zero,zero,loop   //pc=20

exit:
sw t4, 12(zero)     //pc=24
