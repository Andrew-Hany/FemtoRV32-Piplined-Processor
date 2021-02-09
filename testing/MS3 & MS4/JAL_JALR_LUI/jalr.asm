
.text

   

lw x1, 0(x0)   # 17
lw x2, 4(x0)   # 9
lw x3, 8(x0)   # 25

jal ra, sum1
addi x4,x2,3

ecall
#the function
sum1:

jalr x0,x1,0

addi x5,x2,3






