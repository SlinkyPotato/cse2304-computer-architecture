# Brian Patino
# CSE 2304 - Sec. 001
# Lab 4 - Problem 1

.data
	
	promptInput: .asciiz "Please enter 10 numbers and press enter with each input:\n"
	displaySum: .asciiz "Sum of ten numbers: "
	displayAverage: .asciiz "\nAverage: "
	displayMax: .asciiz "\nMaximum: "
	displayMin: .asciiz "\nMinimum: "
	displayNeg: .asciiz "\nNumber of Negative numbers: "
	displayZero: .asciiz "\nNumber of Zeros: "
	displayPos: .asciiz "\nNumber of Positive Numbers: "

.text

main:
	li $v0, 4				# s4: system service to display string
	la $a0, promptInput 	# load prompt
	syscall

	li $t0, 9					# i = 10, loop counter
	
	loopInput:					# do-while loop
		li $v0, 6				# 5: system service to read int
		syscall

		# current number = $f0
		#mfc1.d $t0, $f0		# current number
		li.s $f30, 0.0
		add.s $f1, $f0, $f1	# $f0 = sum of numbers

		checkFirst:
			li $t9, 9
			slt $t8, $t0, $t9
			bne $t8, $zero, continue	# jump to set new max
			mov.s $f2, $f0
			mov.s $f3, $f0

		continue:
		#slt $t2, $f0, $s1		# if (current < max) 
		c.lt.s $f0, $f2         # $f2 = max
		bc1t max				# jump to set new max
		#slt $t2, $f0, $s2		# if (current < min)
		c.lt.s $f3, $f0 		# $f3 = min
		bc1t min
		#beq $t2, $zero, checkSign 	# jump to continue to mean

		min:
			mov.s $f2, $f0
			j checkSign

		max:
			mov.s $f3, $f0		# set new max

		checkSign:
			#bgez $f0, checkZPos	# branch if greater than or equal to zero
			c.lt.s $f30, $f0
			bc1t checkZPos

			addi $s3, $s3, 1	# increase negative number count
			j endCheck 			# jump to loop end check

			checkZPos:
				#beqz $f0, addZero	# increase zero count
				c.lt.s $f0, $f30
				bc1t addZero

				addi $s5, $s5, 1	# increase positive number count
				j endCheck

				addZero:
					addi $s4, $s4, 1	# incraese positive number count

		endCheck:
			addi $t0, $t0, -1		# i--, should loop 9 times
			bgez $t0, loopInput		# loop if i >= 0

	mean:
		li.s $f5, 10.0
		#mtc1 $f1, $f2			# f0 = $a0
		#cvt.s.w $f2, $f2		# convert the sum integer to fp
		div.s $f6, $f1, $f5

	printValues:
		li $v0, 4				# 4: system service to display string
		la $a0, displaySum
		syscall

		li $v0, 2				# 1: system service to display int
		mov.s $f12, $f1		# load sum of floats
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayMax
		syscall

		li $v0, 2				# 1: system service to display int
		mov.s $f12, $f2				# load
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayMin
		syscall

		li $v0, 2				# 1: system service to display float
		#move $a0, $s2			# load
		mov.s $f12, $f3
		syscall

		li $v0, 4				# 4: system service to display string
		la $a0, displayAverage
		syscall

		li $v0, 2				# 2: system service to display float
		mov.s $f12, $f6
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