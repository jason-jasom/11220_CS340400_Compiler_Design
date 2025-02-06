	.file	"0.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	codegen
	.type	codegen, @function
codegen:
	
	//enter function(A)
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16

	//call function(C)
	li	a1,1
	li	a0,26
	call	digitalWrite

	li	a0,1000
	call	delay

	li	a1,0
	li	a0,26
	call	digitalWrite

	li	a0,1000
	call	delay

	nop

	//exit function(B)
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	codegen, .-codegen
	.ident	"GCC: () 13.2.0"
