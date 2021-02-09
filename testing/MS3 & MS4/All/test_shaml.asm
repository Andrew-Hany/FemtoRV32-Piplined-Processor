.text

lw x1, 0(x0)   # 17
lw x2, 4(x0)   # 9
lw x3, 8(x0)   # 25

or x4, x1, x2  # 25
beq x4, x3, jumb  # yes --> goto 24
add x3, x3, x2 # 34 should be skipped ,so x3 = 25
jumb:
sub x5, x3, x2 # 17 (pc =24)
sw x5, 12(x0)  #  -->
jal loop   	# goto 44 from 32
addi x4,x0,10  # 35 skipped
sub  x3,x3,x0   # 25 skipped
loop:      	# pc= 44
lw x6, 12(x0)  # 17
bne x6,x5,exit # continue
and x7, x6, x1 # 17
sub x8, x1, x2 # 8
auipc x10,100  # x10 = pc + 20upper = current pc = 60
lui   x11,1000000 # 976
blt x10,x11,store # yes --> store
or x30,x3,x2  	# 25 skipped
store :
sb x11,12(x0)  	# mem12 =  208
sh x11,16(x0)  	# 976
bge x3,x2,load 	# yes --> load
addi x4,x0,10  # 35 skipped
sub  x3,x3,x0  # 28 skipped
load:
lb  x20,16(x0)
lh  x21,16(x0)
lbu x22,16(x0)
lhu x23,16(x0)
bgeu x20,x21,exit
bltu x20,x21,store
exit:
ebreak
fence 1,1
ecall
