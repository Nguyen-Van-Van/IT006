.data
	cao_do:		.word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
	do_dai:		.word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
	str_space:	.asciiz " "
	str_new_line:	.asciiz "\n"
	str_out0:	.asciiz "Tong du kien (ms): 6400"
    	str_out1:	.asciiz "\nThoi gian do duoc (ms): "
.text
	li $t0, 0	# $t0: i = 0
	li $s0, 15	# $s0: so not
	li $s1, 3	# $s1: nua cung dich giong a = 3
	li $s2, 200	# $s2: do dai mot don vi nhip (ms) = 200
	li $s3, 24	# $s3: nhac cu = 24
	li $s4, 100	# $s4: am luong = 100
	la $s5, cao_do	# $s5: &cao_do 
	la $s6, do_dai	# $s6: &do_dai
	
	li $v0, 30
	syscall
	move $s7, $a0	# time bat dau
loop:
	slt $t1, $t0, $s0		# if(i < 15)
	beq $t1, $zero, end_loop
	
	sll $t1, $t0, 2			# offset = i * 4
	
	add $t2, $s5, $t1		# A[i] = [base_addr + offset]
	lw $t3, 0($t2)
	add $t3, $t3, $s1		# cao do += a
	add $t2, $s6, $t1
	lw $t4, 0($t2)
	mul $t4, $t4, $s2		# do dai *= (150 + 10*b)
	
	# in dong <cao do> <ms>
	li $v0, 1
	move $a0, $t3
	syscall
	li $v0, 4
	la $a0, str_space
	syscall
	li $v0, 1
	move $a0, $t4
	syscall
	li $v0, 4
	la $a0, str_new_line
	syscall
	
	li $v0, 31			# syscall 31
	move $a0, $t3
	move $a1, $t4
	move $a2, $s3
	move $a3, $s4
	syscall
	li $v0, 32			# syscall 32
	move $a0, $t4
	syscall
	
	addi $t0, $t0, 1		# i++
	j loop
end_loop:
	li $v0, 30
	syscall
	sub $s7, $a0, $s7		# thoi gian do duoc
	
	li $v0, 4
	la $a0, str_out0
	syscall
	
	li $v0, 4
	la $a0, str_out1
	syscall
	
	li $v0, 1
	move $a0, $s7
	syscall
	
	li $v0, 10
	syscall