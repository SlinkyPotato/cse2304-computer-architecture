# Brian Patino
# CSE 2304 - Sec. 001
# Lab 3 - Problem 4

.data 			# data section

txtInfo: .asciiz 		"This application can determine if a given string is palindrome"
promptString: .asciiz 	"\nPlease enter a string with a maximum of 80 characters: "
txtOutput: .asciiz 		"Result (1 for true, 0 for false): "
buffer: .space 80				# 80 character space array

.text			# text section

main:
	move $s0, $sp 				# save stack pointer base value
	
	li $v0, 4					# 4: system service to display string
	la $a0, txtInfo 			# load app info
	syscall
	la $a0, promptString 		# load string promopt
	syscall

	li $v0, 8					# 8: system service to read string
	la $a0, buffer				# reserve memory buffer
	li $a1, 80					# allot the byte space for string
	syscall

	jal	ISPAL					# return 1 if string is palindrome
	move $t0, $v0				# $t0 = result

	li $v0, 4					# 4: system service to print string
	la $a0, txtOutput 			# load output string
	syscall 

	move $a0, $t0 				# $a0 = result	
	li $v0, 1					# 1: system service to print int
	syscall

	j exit

	ISPAL:
		move $s1, $a0			# save string just in case
		move $s2, $a0			# $s2 store another copy of string
		li $s3, 10				# used to check for new line
		li $s4, 0				# i = length counter
		move $s5, $ra 			# save return address

		pushAllChars:
			lb $a0, 0($s1)				# $t0 = $s1.getCharacter()
			beqz $a0, popCheck			# no new characters left to push
			beq $a0, $s3, popCheck 		# branch if new line
			addi $s4, $s4, 1			# i++
			jal push
			addi $s1, $s1, 1			# bump $s1 index
			j pushAllChars

		popCheck:
			lb $s6, 0($s2)				# $s6 = $s2.getCharacter()
			jal pop 					# pop character from stack
			move $t1, $v0				# $t1 = popped value
			
			bne $s6, $t1, checkMatch 	# branch if new line
			beq $s6, $s3, checkMatch	# check for new line
			addi $s4, $s4, -1			# i--
			addi $s2, $s2, 1			# bump $s1 index
			j popCheck

		checkMatch:
			seq $v0, $s4, $zero

		jr $s5

	push:						# push value to stack
		addi $sp, $sp, -4		# move the stack pointer
		sw $a0, 0($sp)			# store value on top of stack
		jr $ra		

	pop:						# pop value from top of stack
		move $s1, $ra			# save the return address
		jal isEmpty
		li $t0, 1
		beq $v0, $t0, noPop		# no pop if (stack empty)
		lb $v0, 0($sp)			# pop top of stack
		add $sp, $sp, 4			# clear value in stack
		noPop:
			jr $s1

	isEmpty:					# check to see if stack is empty
		seq $v0, $sp, $s0		# $v0 = (empty) ? 1 : 0
		jr $ra

exit:
	li $v0, 10				# 10: system service to exit
	syscall