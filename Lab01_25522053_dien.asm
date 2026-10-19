.data
	kWh_size:	.word 50, 50, 100, 100, 100, 9599
	don_gia:	.word 1660, 1720, 2010, 2560, 2910, 3060
	str_out0:	.asciiz "Nhap so kWh (0..9999): "
	str_err:	.asciiz "Gia tri khong hop le, nhap lai\n"
	str_out1:	.asciiz "Tien dien: "
	str_out2:	.asciiz " dong"
.text
	# $s0: luu gia tri input
	# $s1: &kWh_size
	# $s2: &don_gia
	# $t0: so kWh con lai
	# $t1: luu gia tri i
	# $t2: tong tien dien
input_loop:
	li $v0, 4
	la $a0, str_out0
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $t0, 10000
	slt $t1, $s0, $t0		# if(0<= $s0 < 10000): $t1 = 1
	bne $t1, $zero, end_input
	
	li $v0, 4
	la $a0, str_err
	syscall
	
	j input_loop

end_input:
	la $s1, kWh_size
	la $s2, don_gia
	move $t0, $s0
	li $t1, 0
	li $t2, 0
	
money_calc:
	sll $t6, $t1, 2		# Dùng $t6 làm offset = i * 4 (để bảo vệ tổng tiền ở $t2)
	
	add $t3, $s1, $t6
	lw  $t3, 0($t3)		# $t3 = A[i] (kWh_size[i])
	
	sub $t4, $t0, $t3	# $t4 = x - A[i]
	blez $t4, else
	
	add $t5, $s2, $t6
	lw  $t5, 0($t5)		# $t5 = B[i] (don_gia[i])
	
	mul $t7, $t3, $t5	# $t7 = A[i] * B[i]
	add $t2, $t2, $t7	# sum += A[i] * B[i]
	j end_if

else:
	add $t5, $s2, $t6
	lw  $t5, 0($t5)		# $t5 = B[i]
	
	mul $t7, $t0, $t5	# $t7 = x * B[i]
	add $t2, $t2, $t7	# sum += x * B[i]
	j end_calc

end_if:
	move $t0, $t4		# $t0 = x - A[i]
	addi $t1, $t1, 1
	j money_calc

end_calc:
	li $v0, 4
	la $a0, str_out1
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, str_out2
	syscall
	
	li $v0, 10
	syscall