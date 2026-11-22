.data
	n:	.word 10
	msg1:	.asciiz "F("
	msg2:	.asciiz ") = "

.text
	la $t0, n
	lw $a0, 0($t0)
	move $s0, $a0

	jal fib_rec
	move $s1, $v0

	li $v0, 4
	la $a0, msg1
	syscall

	li $v0, 1
	move $a0, $s0
	syscall

	li $v0, 4
	la $a0, msg2
	syscall

	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 10
	syscall

fib_rec:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)

	slti $t0, $a0, 2
	bne $t0, $zero, fr_base

	move $s0, $a0
	addi $a0, $s0, -1
	jal fib_rec
	move $s1, $v0

	addi $a0, $s0, -2
	jal fib_rec
	add $v0, $s1, $v0
	j fr_end
fr_base:
	move $v0, $a0
fr_end:
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra

fib_iter:
	move $v0, $zero
	li $t0, 1
	move $t1, $zero
fi_loop:
	slt $t2, $t1, $a0
	beq $t2, $zero, fi_done
	addu $t3, $v0, $t0
	move $v0, $t0
	move $t0, $t3
	addiu $t1, $t1, 1
	j fi_loop
fi_done:
	jr $ra