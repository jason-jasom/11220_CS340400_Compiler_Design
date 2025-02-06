	.file	"1.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	codegen
	.type	codegen, @function
codegen:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,4
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	addi	a4,a5,-2
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mul	a5,a4,a5
	sw	a5,-24(s0)
	li	a1,1
	li	a0,27
	call	digitalWrite
	lw	a4,-20(s0)
	li	a5,1000
	mul	a5,a4,a5
	mv	a0,a5
	call	delay
	li	a1,0
	li	a0,27
	call	digitalWrite
	lw	a4,-24(s0)
	li	a5,1000
	mul	a5,a4,a5
	mv	a0,a5
	call	delay
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	codegen, .-codegen
	.ident	"GCC: () 13.2.0"
