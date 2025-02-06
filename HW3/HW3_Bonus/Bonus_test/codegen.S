.global ext_dsp_codegen
ext_dsp_codegen:
 addi sp,sp,-16
 sw ra,12(sp)
 sw s0,8(sp)
 addi s0,sp,16
 sw a0,4(sp)
 sw a1,0(sp)
 addi sp, sp, -4
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 ukadd8 t0, a0, a1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -20(s0) 
 addi sp, sp, -4
 lw t0, -12(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -20(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 cmpeq8 t0, a0, a1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -24(s0) 
 addi sp, sp, -4
 lw t0, -16(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -20(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 ucmplt8 t0, a0, a1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, 0(sp) 
 addi sp, sp, 4
 sw t0, -28(s0) 
 lw t0, -24(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw t0, -28(s0) 
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a1,0(sp)
 addi sp, sp, 4
 lw a0,0(sp)
 addi sp, sp, 4
 uksub8 t0, a0, a1
 addi sp, sp, -4
 sw t0, 0(sp)
 lw a0,0(sp)
 addi sp, sp, 4
 lw ra,24(sp)
 lw s0,20(sp)
 addi sp,sp,28
 jr ra
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 addi sp,sp,4
 lw ra,4(sp)
 lw s0,0(sp)
 addi sp,sp,8
 jr ra
