.data
	str0:	.asciiz "kien truc may tinh"
	str1:	.asciiz "mips"
	str2:	.asciiz ""
	str3:	.asciiz "a bc def"
	str4:	.asciiz "thanh ghi s phai duoc bao toan"
	daugach:.asciiz "|"
	newline:.asciiz "\n"
.text
	la $a0, str4
	move $s0, $a0		# luu dia chi chuoi vao $s0 vi thu tuc rev_range thay doi $a0
	jal reverse_words
	j end
	
# $a0: dia chi chuoi .asciiz
# $t0: bien tinh dia chi tam thoi
# $v0: so ky tu truoc byte 0
strlen:
	move $t0, $a0
strlen_loop:
	lbu $t1, 0($t0)
	beq $t1, $zero, strlen_end
	addiu $t0, $t0, 1
	j strlen_loop
strlen_end:
	sub $v0, $t0, $a0
	jr $ra
	
# $a0: dia chi ky tu dau
# $a1: dia chi ky tu cuoi
# $t0: bien gia tri so sanh
# $t1: luu gia tri tam thoi cua byte $a0
# $t2: luu gia tri tam thoi cua byte $a1
rev_range:
rev_range_loop:
	sltu $t0, $a0, $a1
	beq $t0, $zero, rev_range_end	
	lbu $t1, 0($a0)
	lbu $t2, 0($a1)
	sb $t1, 0($a1)
	sb $t2, 0($a0)
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	j rev_range_loop
rev_range_end:
	jr $ra

# $s0: dia chi chuoi
reverse_words:
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	move $s0, $a0
	
	jal strlen
	beq $v0, $zero, reverse_words_end

	move  $a0, $s0
	addu  $a1, $s0, $v0
	addiu $a1, $a1, -1
	jal   rev_range

	move  $s1, $s0
	move  $s2, $s0
reverse_words_loop:
	lbu $t0, 0($s2)
	beq $t0, $zero, reverse_words_last
	li $t1, 32
	beq $t0, $t1, reverse_words_space
	addiu $s2, $s2, 1
	j reverse_words_loop

reverse_words_space:
	move $a0, $s1
	addiu $a1, $s2, -1
	jal rev_range
	addiu $s2, $s2, 1
	move $s1, $s2
	j reverse_words_loop

reverse_words_last:
	move $a0, $s1
	addiu $a1, $s2, -1
	jal rev_range
	
reverse_words_end:
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra
end:
# in ket qua 
	li $v0, 4
	la $a0, daugach
	syscall
	
	li $v0, 4
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, daugach
	syscall
	
	li $v0, 10
	syscall