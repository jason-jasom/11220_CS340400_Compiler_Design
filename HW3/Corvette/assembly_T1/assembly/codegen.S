.global codegen
codegen:
 addi sp,sp,-8
 sw ra,4(sp)
 sw s0,0(sp)
 addi s0,sp,8
 addi sp, sp, -4
 addi t0, sp ,-4
 sw t0, 0(sp) 
 addi sp, sp, -20
 addi sp, sp, -4
//for start:
 li t0, 0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -36(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 addi sp, sp, 4
for0:
 lw t0, -36(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 5
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t0, t1
 slt t0, zero, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0,0(sp)
 addi sp, sp, 4
 li t1,1
 blt t0,t1,end0
 j content0
step0:
 lw t0, -36(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 add t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -36(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 addi sp, sp, 4
 j for0
content0:
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -36(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 li t1, -4
 mul t0, t0, t1
 lw t1, 0(sp)
 addi sp, sp, 4
 add t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 lw t1, 0(sp) 
 addi sp, sp, 4
 sw t0, 0(t1) 
 addi sp, sp, -4
 sw t0, 0(sp)
 addi sp, sp, 4
 j step0
end0:
//for end:
 addi sp, sp, -4
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 6
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,dp_fib
 addi sp, sp, -4
 sw a0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -40(s0) 
 addi sp, sp, -4
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 4
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,dp_fib
 addi sp, sp, -4
 sw a0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -44(s0) 
 li t0, 13
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,digitalWrite
 addi sp, sp, -4
 sw a0, 0(sp)
 addi sp, sp, 4
 lw t0, -40(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 1000
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 mul t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,delay
 addi sp, sp, -4
 sw a0, 0(sp)
 addi sp, sp, 4
 li t0, 13
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,digitalWrite
 addi sp, sp, -4
 sw a0, 0(sp)
 addi sp, sp, 4
 lw t0, -44(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 1000
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 mul t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,delay
 addi sp, sp, -4
 sw a0, 0(sp)
 addi sp, sp, 4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 lw ra,4(sp)
 lw s0,0(sp)
 addi sp,sp,8
 jr ra
.global dp_fib
dp_fib:
 addi sp,sp,-16
 sw ra,12(sp)
 sw s0,8(sp)
 addi s0,sp,16
 sw a0,4(sp)
 sw a1,0(sp)
//if start:
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t1, t0
 li t1, 1
 sltu t0, t0, t1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0,0(sp)
 addi sp, sp, 4
 li t1,1
 blt t0,t1,else1
 li t0, 0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 lw ra,12(sp)
 lw s0,8(sp)
 addi sp,sp,16
 jr ra
 j end1
else1:
end1:
//if end:
//if start:
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t1, t0
 li t1, 1
 sltu t0, t0, t1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0,0(sp)
 addi sp, sp, 4
 li t1,1
 blt t0,t1,else2
 li t0, 1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 lw ra,12(sp)
 lw s0,8(sp)
 addi sp,sp,16
 jr ra
 j end2
else2:
end2:
//if end:
 addi sp, sp, -4
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 2
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -20(s0) 
//if start:
 lw t0, -20(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 li t1, -4
 mul t0, t0, t1
 lw t1, -12(s0)
 add t0, t0, t1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t0, 0(t0)
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t1, t0
 li t1, 1
 sltu t0, t0, t1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0,0(sp)
 addi sp, sp, 4
 li t1,1
 blt t0,t1,else3
 addi sp, sp, -4
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 2
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,dp_fib
 addi sp, sp, -4
 sw a0, 0(sp)
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 li t0, 1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 sub t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 jal ra,dp_fib
 addi sp, sp, -4
 sw a0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t1, 0(sp)
 addi sp, sp, 4
 add t0, t1, t0
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -24(s0) 
 lw t0, -20(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 li t1, -4
 mul t0, t0, t1
 lw t1, -12(s0)
 add t0, t0, t1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -24(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 lw t1, 0(sp) 
 addi sp, sp, 4
 sw t0, 0(t1) 
 addi sp, sp, -4
 sw t0, 0(sp)
 addi sp, sp, 4
 lw t0, -24(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 lw ra,20(sp)
 lw s0,16(sp)
 addi sp,sp,24
 jr ra
 addi sp,sp,4
 j end3
else3:
 lw t0, -20(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 li t1, -4
 mul t0, t0, t1
 lw t1, -12(s0)
 add t0, t0, t1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp)
 addi sp, sp, 4
 lw t0, 0(t0)
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 lw ra,16(sp)
 lw s0,12(sp)
 addi sp,sp,20
 jr ra
end3:
//if end:
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 lw ra,4(sp)
 lw s0,0(sp)
 addi sp,sp,8
 jr ra
