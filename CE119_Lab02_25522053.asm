.data
	mang_diem:	.word 9, 6, 0, 1, 5, 8, 10, 5, 9, 1, 7, 6
	grade_tab:	.byte 0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3
	hist:		.word 0, 0, 0, 0
	n:		.word 12
	str_out0:	.asciiz "min="
	str_out1:	.asciiz " max="
	str_g0:		.asciiz "\ng0="
	str_g1:		.asciiz " g1="
	str_g2:		.asciiz " g2="
	str_g3:		.asciiz " g3="
	str_g:		.asciiz "g"
	str_nl:		.asciiz "\n"
	dauhaicham: 	.asciiz ": "
	daugachdung:	.asciiz "|"
	
.text
main:
# stats
	la $a0, mang_diem
	lw $a1, n
	jal stats
	move $t0, $v0
	move $t1, $v1
	# min
	la $a0, str_out0
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	# max
	la $a0, str_out1
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	
	
# histogram
	la $a0, mang_diem
	lw $a1, n
	la $a2, grade_tab
	la $a3, hist
	jal histogram_loop
	la $t0, hist
	# g0
	la $a0, str_g0
	li $v0, 4
	syscall
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	# g1
	la $a0, str_g1
	li $v0, 4
	syscall
	lw $a0, 4($t0)
	li $v0, 1
	syscall
	# g2
	la $a0, str_g2
	li $v0, 4
	syscall
	lw $a0, 8($t0)
	li $v0, 1
	syscall
	# g3
	la $a0, str_g3
	li $v0, 4
	syscall
	lw $a0, 12($t0)
	li $v0, 1
	syscall


# draw_hist
	la $a0, hist
	li $a1, 4
	jal draw_hist
	li $v0, 10
	syscall

# Tham so: 	$a0 = dia chi mang
#		$a1 = n (n >= 1)		
# Tra ve:	$v0 = min
#		$v1 = max
stats:
	lw $v0, 0($a0)
	lw $v1, 0($a0)
stats_loop:
	addi $a0, $a0, 4
	addi $a1, $a1, -1
	beq $a1, $zero, stats_end
	lw $t0, 0($a0)
	sltiu $t1, $t0, 11
	beq $t1, $zero, stats_loop
	# min
	slt $t1, $t0, $v0
	beq $t1, $zero, max
	move $v0, $t0
max:	
	sgt $t1, $t0, $v1
	beq $t1, $zero, stats_loop
	move $v1, $t0
stats_end:
	jr $ra	


# Tham so:	$a0 = dia chi mang diem
#		$a1 = n
#		$a2 = dia chi grade_tab
#		$a3 = dia chi hist
# Khong co gia tri tra ve
histogram_loop:
	beq $a1, $zero, histogram_end
	lw $t0, 0($a0)		# $t0 = s
	sltiu $t1, $t0, 11
	beq $t1, $zero, ignore_value
	add  $t1, $a2, $t0      # địa chỉ grade_tab[s]
    	lbu  $t2, 0($t1)        # $t2 = grade_tab[s]
    
    	sll  $t3, $t2, 2        # offset = g * 4
    	add  $t4, $a3, $t3      # địa chỉ hist[g]
    
    	lw   $t5, 0($t4)
    	addi $t5, $t5, 1
    	sw   $t5, 0($t4)
ignore_value:
    	addi $a0, $a0, 4
    	addi $a1, $a1, -1
    	j    histogram_loop
histogram_end:
	jr $ra

	
	
draw_hist:
	move $t0, $a0
	li $t2, 0
draw:
	la $a0, str_nl
	li $v0, 4
	syscall
	
	beq $a1, $zero, draw_hist_end	
	lw $t1, 0($t0)
	
	la $a0, str_g
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, dauhaicham
	li $v0, 4
	syscall
	
draw_loop:
	beq $t1, $zero, draw_loop_end
	la $a0, daugachdung
	li $v0, 4
	syscall
	addi $t1, $t1, -1
	j draw_loop
draw_loop_end:
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	addi $a1, $a1, -1
	j draw
draw_hist_end:
	jr $ra
