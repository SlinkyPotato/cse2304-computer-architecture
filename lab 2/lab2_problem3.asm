# Brian Patino
# CSE 2304 - Sec. 001
# Lab 2 - Problem 3

.data
inputPrompt: .asciiz "Enter a number to convert: "
tempPrompt: .asciiz "Enter the Temperature: "
output: .asciiz " is the same as "

.text

main:
	li $v0, 4			# 4: system service to display prompt
	la $a0, inputPrompt # load up that input prompt
	syscall

	li $v0, 5			# 5: system service to read int
	syscall

	move $t0, $v0		# $t0 = integer input

	li $v0, 4			# 4: system service to display prompt
	la $a0, tempPrompt 	# load up that temperature prompt
	syscall

	li $v0, 12			# 12: system service to read character
	syscall				
	move $t1, $v0

	li $v0, 11 			# 8: system service to display character
	li $a0, '\n'		# load up new line
	syscall
	
	li $v0, 1			# 1: system service to display int
	move $a0, $t0		# $a0 = input
	syscall

	li $v0, 11 			# 11: system service to display character
	li $a0, ' '			# store space character
	syscall
	move $a0, $t1		# load temperature label
	syscall 			

	li $v0, 4			# 4: system service to display string
	la $a0, output 		# load output
	syscall

	li $t2, 'C'					# 0x43 = C
	beq $t2, $t1, convertToF 	# convert to C if matches
	j convertToC			# else convert to F

	convertToC:
		addi $t0, $t0, -32		# start by substracting 32
		li $t1, 5
		mul	$t0, $t1, $t0		# $t0 = result * 5
		li $t1, 9
		div $t0, $t1			# lo = reult/9
		mflo $a0

		li $v0, 1				# 1: system service to print int
		syscall

		li $v0, 11				# 11: system service to print string
		li $a0, ' ' 			# load space label
		syscall
		li $a0, 'C' 			# load C label
		syscall

		j exit

	convertToF:
		li $t1, 9
		mul $t0, $t1, $t0		# lo = 9*input
		li $t1, 5
		div $t0, $t1			# lo = $t0/5
		mflo $t0				# $t0 gets lo value
		addi $a0, $t0, 32		# add by 32 to result

		li $v0, 1				# 1: system service to print int
		syscall

		li $v0, 11 			  	# 11: system service to display character
		li $a0, ' '			# load C label
		syscall
		li $a0, 'F'			# load C label
		syscall

		j exit

exit:
	li $v0, 10			# 10: system service to exit program
	syscall