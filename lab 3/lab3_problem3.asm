# Brian Patino
# CSE 2304 - Sec. 001
# Lab 3 - Problem 3

.data 			# data section

testPrompt:	.asciiz "This app tests push, pop, and isEmpty subroutines with the integer 12\n"

.text			# text section

main:
	move $s0, $sp				# stack size base value (I did not put anything in stack)

	li $v0, 4					# 4: system service to print string
	la $a0, testPrompt 			# load test Prompt
	syscall

	li $a0, 12					# $a0 = 12, test value

	jal PUSH					# test push
	jal POP						# test pop
	
	move $a0, $v0				# load test value
	li $v0, 1					# 1: system service to print int
	syscall
	j exit

	PUSH:						# push value to stack
		addi $sp, $sp, -4		# move the stack pointer
		sw $a0, 0($sp)			# store value on top of stack
		jr $ra		

	POP:						# pop value from top of stack
		move $s1, $ra			# save the return address
		jal ISEMPTY
		li $t0, 1
		beq $v0, $t0, nopop		# no pop if (stack empty)
		lw $v0, 0($sp)			# pop top of stack
		add $sp, $sp, 4			# clear value in stack
		nopop:
			move $ra, $s1		# $ra = pop return address
			jr $ra

	ISEMPTY:					# check to see if stack is empty
		seq $v0, $sp, $s0		# $v0 = (empty) ? 1 : 0
		jr $ra

exit:
	li $v0, 10					# 10: system service to exit app
	syscall