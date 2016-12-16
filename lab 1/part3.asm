# Brian Patino
# CSE 2304 - Sec. 001 -  Lab Assignment 1
# Part 3

.data # data section 

#int_value: .word 0

warning: .asciiz "Please note, this is integer operation.\n"
promptX: .asciiz "Enter value for X: "
promptY: .asciiz "Enter value for Y: "
promptZ: .asciiz "Enter value for Z: "
output1: .asciiz "X + Y + Z = "
output2: .asciiz "\nX - (Y + Z) = "
output3: .asciiz "\nX + Y * Z = "
output4: .asciiz "\nX - (Y/Z) = "
output5: .asciiz "\n(X^3 - Y)/Z = "

.text

main:
	### Display Warning ###
	li $v0, 4			# 4: system service to display string
	la $a0, warning   	# $a0: load warning message
	syscall

	### Obtain input X ###
	li $v0, 4			# 4: system service to display string
	la $a0, promptX 	# $a0: load promptX
	syscall

	li $v0, 5 			# 5: system service to read integer
	syscall
	add $t0, $zero, $v0 # temp load input X 
	
	#### Obtain input Y ###
	li $v0, 4			# 4: system service to display string
	la $a0, promptY 	# $a0: load promptX
	syscall
	
	li $v0, 5 			# 5: system service to read integers
	syscall
	add $t1, $zero, $v0 # temp load input Y 
	
	#### Obtain input Z ###
	li $v0, 4			# 4: system service to display string
	la $a0, promptZ 	# $a0: load promptX
	syscall

	li $v0, 5 			# 5: system service to read integers
	syscall
	add $t2, $zero, $v0 # temp load input Z 

	## Perform operation 1 ##
	add $t3, $t0, $t1
	add $t3, $t2, $t3

	li $v0, 4			# 4: system service to display string
	la $a0, output1 	# $a0: load promptX
	syscall

	# Print result 1 # 
	li $v0, 1			# 1: system service to display integer
	add $a0, $t3, $zero	# $a0: load integer result
	syscall

	## Perform Operation 2 ##
	li $t3, 0 			# clear $t3, prepare to hold value
	add $t4, $t1, $t2	# $t4 = X + Y
	sub $t3, $t0, $t4	# $t3 = X - $t4

	li $v0, 4
	la $a0, output2		# 4: system service to display string
	syscall

	# Print result 2 #
	li $v0, 1
	add $a0, $t3, $zero	# print output 2 result
	syscall

	## Perform Operation 3 ##
	li $t3, 0			# clear $t3
	mult $t1, $t2		# Hi/Lo = Y * Z
	#mfhi $t7			# most sig bits to $t7
	mflo $t6 			# least sig bits to $t6
	add $t3, $t0, $t7	# add most sig bits with $t0
	add $t4, $t0, $t6	# add least sig bits with $t0

	li $v0, 4
	la $a0, output3		# 4: system service to display string
	syscall
	
	# Print result #
	li $v0, 1
	#add $a0, $t3, $zero # print most sig bits
	#syscall
	add $a0, $t4, $zero # print least sig bits
	syscall

	## Perform Operation 4 ##
	li $t3, 0			# clear $t3
	li $t4, 0			# clear $t4
	li $t6, 0			# clear $t6
	li $t7, 0			# clear $t7

	div $t1, $t2		# Lo = Y/Z, Hi = Y mod Z
	mflo $t3			# $t3 = Lo
	sub $t3, $t0, $t3	# $t0 = X - Lo

	# Print Output and Result #
	li $v0, 4			# 4: system service to display string
	la $a0, output4		# load up output4
	syscall

	li $v0, 1			# 1: system service to display integer
	add $a0, $t3, $zero	# load up op3 result
	syscall

	## Perform Operation 5 ##
	li $t3, 0 			# clear $t3
	mult $t0, $t0		# Least bits = X * X
	mflo $t3			# move from least bits
	mult $t3, $t0		# $t3 = X^3
	mflo $t3			# move X^3 from least bits
	sub $t3, $t3, $t1	# $t3 = X^3 - Y
	div $t3, $t3, $t2	# Lo = (X^3 - Y)/Z,
	mflo $t4

	# Print Output and Result #
	li, $v0, 4			# 4: system service to display string
	la $a0, output5		# load output 5
	syscall

	li, $v0, 1			# 1: system service to display integer result
	add $a0, $t4, $zero	# load integer 4 result
	syscall

exit:
	li $v0, 10			# 10: system service to terminate
	syscall