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
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	zero,-20(s0)
	j	.L2
.L3:
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a4,s0,-48
	add	a5,a4,a5
	sw	zero,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,4
	ble	a4,a5,.L3
	addi	a5,s0,-48
	li	a1,6
	mv	a0,a5
	call	dp_fib
	sw	a0,-24(s0)
	addi	a5,s0,-48
	li	a1,4
	mv	a0,a5
	call	dp_fib
	sw	a0,-28(s0)
	li	a1,1
	li	a0,26
	call	digitalWrite
	lw	a4,-24(s0)
	li	a5,1000
	mul	a5,a4,a5
	mv	a0,a5
	call	delay
	li	a1,0
	li	a0,26
	call	digitalWrite
	lw	a4,-28(s0)
	li	a5,1000
	mul	a5,a4,a5
	mv	a0,a5
	call	delay
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	codegen, .-codegen
	.align	1
	.globl	dp_fib
	.type	dp_fib, @function
dp_fib:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-40(s0)
	bne	a5,zero,.L5
	li	a5,0
	j	.L6
.L5:
	lw	a4,-40(s0)
	li	a5,1
	bne	a4,a5,.L7
	li	a5,1
	j	.L6
.L7:
	lw	a5,-40(s0)
	addi	a5,a5,-2
	sw	a5,-20(s0)
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	bne	a5,zero,.L8
	lw	a5,-40(s0)
	addi	a5,a5,-2
	mv	a1,a5
	lw	a0,-36(s0)
	call	dp_fib
	mv	s1,a0
	lw	a5,-40(s0)
	addi	a5,a5,-1
	mv	a1,a5
	lw	a0,-36(s0)
	call	dp_fib
	mv	a5,a0
	add	a5,s1,a5
	sw	a5,-24(s0)
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,-24(s0)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	j	.L6
.L8:
	lw	a5,-20(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
.L6:
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
	.size	dp_fib, .-dp_fib
	.ident	"GCC: () 13.2.0"
