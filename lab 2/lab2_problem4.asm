# Brian Patino
# CSE 2304 - Sec. 001
# Lab 2 - Problem 4

.data
	
	promptInput: .asciiz "Please enter 10 integers and press enter with each input:\n"
	displaySum: .asciiz "Sum of ten numbers: "
	displayMax: .asciiz "\nMaximum: "
	displayMin: .asciiz "\nMinimum: "
	displayMean: .asciiz "\nMean: "
	displayNeg: .asciiz "\nNumber of Negative numbers: "
	displayZero: .asciiz "\nNumber of Zeros: "
	displayPos: .asciiz "\nNumber of Positive Numbers: "

.text

main:
	li $v0, 4				# 4: system service to display string
	la $a0, promptInput 	# load prompt
	syscall

	li $t0, 9					# i = 10, loop counter
	
	loopInput:					# do-while loop
		li $v0, 5				# 5: system service to read int
		syscall

		move $t1, $v0			# current integer
		add $s0, $t1, $zero		# $t1 = sum of numbers

		slt $t2, $t1, $s1		# if (current < max)  
		beq $t2, $zero, max		# jump to set new max
		slt $t2, $t1, $s2		# if (current < min)
		beq $t2, $zero, checkSign 	# jump to continue to mean

		min:
			move $s2, $t1
			j checkSign

		max:
			move $s1, $t1		# set new max

		checkSign:
			bgez $t1, checkZPos	# branch if greater than or equal to zero

			addi $s3, $s3, 1	# increase negative number count
			j endCheck 			# jump to loop end check

			checkZPos:
				beqz $t1, addZero	# increase zero count

				addi $s5, $s5, 1	# increase positive number count
				j endCheck

				addZero:
					addi $s4, $s4, 1	# incraese positive number count

		endCheck:
			addi $t0, $t0, -1		# i++, increase counter by 1
			bgez $t0, loopInput		# loop if i >= 0

	mean:
		li.s $f0, 10.0
		mtc1 $s0, $f2			# f0 = $a0
		cvt.s.w $f2, $f2		# convert the sum integer to fp
		div.s $f12, $f2, $f0

	printValues:
		li $v0, 4				# 4: system service to display string
		la $a0, displaySum
		syscall

		li $v0, 1				# 1: system service to display int
		move $a0, $s0				# load 
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayMax
		syscall

		li $v0, 1				# 1: system service to display int
		move $a0, $s1				# load
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayMin
		syscall

		li $v0, 1				# 1: system service to display int
		move $a0, $s2			# load
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayMean
		syscall

		li $v0, 2				# 2: system service to display float
		syscall					# float already loaded, just print

		li $v0, 4				# 4: system service to display string
		la $a0, displayNeg
		syscall

		li $v0, 1				# 1: system service to display int
		move $a0, $s3			# load
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayZero
		syscall

		li $v0, 1				# 1: system service to display int
		move $a0, $s4				# load
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayPos
		syscall

		li $v0, 1				# 5: system service to display int
		move $a0, $s5				# load
		syscall
exit:
	li $v0, 10					# 10: system service to exit 
	syscall