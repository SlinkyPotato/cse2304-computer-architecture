# Brian Patino
# CSE 2304 - Sec. 001
# Lab 3 - Problem 2

.data 		# data section

promptA: .asciiz "Please enter a: "
promptB: .asciiz "Please enter b: "

.text 

main:
	li $v0, 4			# 4: system service to print string 
	la $a0, promptA 	# load string
	syscall

	li $v0, 5			# 1: system service to read integer
	syscall				

	move $t0, $v0		# $t0 = a

	li $v0, 4			# 4: system service to print string
	la $a0, promptB		# load string
	syscall

	li $v0, 5			# 5: system service to read int
	syscall

	move $t1, $v0		# $t1 = b

	addi $sp, $sp, -12	# adjust stack to make room for 3 items
	sw $t0, 8($sp)		# save a for later
	sw $t1, 4($sp)		# save b for later

	jal doAlgebra

	j exit

	doAlgebra:	
		lw $t1, 4($sp)		# load $t1 = b
		li $t0, 10
		mul $t1, $t1, $t0	# $t1 = 10b
		
		sw $t1, 0($sp)		# 10b stored in stack

		li $t0, 8			# $t0 = 8
		lw $t1, 8($sp)		# $t1 = a
		mul $t0, $t1, $t0	# $t0 = 8a

		lw $t1, 0($sp)		# $t1 = 10b
		sub $t0, $t0, $t1	# $t0 = 8a - 10b

		addi $t0, $t0, 19	# $t0 = 8a - 10b + 19
		sw $t0, 0($sp)		# store (8a - 10b + 19) in stack

		lw $t0, 8($sp)		# $t0 = a
		lw $t1, 4($sp)		# $t1 = b

		mul $t1, $t0, $t1	# $t1 = a*b
		mul $t0, $t0, $t0	# $t0 = a^2
		sub $t0, $t0, $t1	# $t0 = a^2 - ab

		lw $t1, 0($sp)		# $t1 = (8a - 10b + 19)

		add $t0, $t0, $t1
		addi $sp, $sp, 12	# adjust stack to delete 3 items

		li $v0, 1			# 4: system service to print string
		move $a0, $t0		# load int
		syscall				# call and show the result
		jr $ra
exit:
	li $v0, 10			# 10: system service to exit
	syscall
