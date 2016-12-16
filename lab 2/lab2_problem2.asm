# Brian Patino
# CSE 2304 - Sec. 001
# Lab 2 - Problem 2
# 
# Note: I originally made this to include floating point values, 
# all fp code has been commented out and integers are used instead

.data 		# data section

inputPrompt: .asciiz "Enter a number to convert: "
processPrompt: .asciiz "Converting the number "
cToF: .asciiz "\nC to F is "
fToC: .asciiz "\nF to C is "

.text 		# text section

main:
	li $v0, 4				# 4: system service to display string
	la $a0, inputPrompt 	# $a0 = inputPrompt
	syscall

	li $v0, 5				# 5: systerm service to read integer
	syscall 				# reads to something

	move $s0, $v0			# store integer value

	li $v0, 4				# 4: system service to print string
	la $a0, processPrompt	# $a0= processPrompt
	syscall

	li $v0, 1				# 1: system service to print integer
	move $a0, $s0				# $a0 = original input
	syscall

	jal convertToFDisplay	# convert to Fahrenheit
	move $a0, $s0
	jal convertToCDisplay	# convert to Celsius 

	j exit

convertToFDisplay:
	move $t0, $a0			# store for usage
	#mtc1 $a0, $f0			# f0 = $a0
	#cvt.s.w $f0, $f0		# convert the previous integer to fp

	li $v0, 4				# 8: system service to print string
	la $a0, cToF 			# load up C t F is
	syscall 

	li $t1, 9
	mul $t0, $t1, $t0		# lo = 9*input
	#mflo $t0				# get the lo value

	li $t1, 5
	div $t0, $t1			# lo = $t0/5
	mflo $t0				# $t0 gets lo value

	addi $a0, $t0, 32		# add by 32 to result

	#li.s $f2, 1.8			# $f2 = 1.8
	#mul.s $f0, $f0, $f2		# $f0 = (c)*1.8
	#li.s $f2, 32.0
	#add.s $f12, $f0, $f2	# $f12 = (c*1.8) + 32

	li $v0, 1				# 1: system service to print int
	syscall

	j $ra
	
convertToCDisplay:
	move $t0, $a0			# store for usage
	#mtc1 $a0, $f0			# f0 = $a0
	#cvt.s.w $f0, $f0		# convert the previous integer to fp

	li $v0, 4				# 4: system service to print string
	la $a0, fToC			# $a0= F to C is 
	syscall

	addi $t0, $t0, -32		# start by substracting 32
	li $t1, 5
	mul	$t0, $t1, $t0		# $t0 = result * 5
	li $t1, 9
	div $t0, $t1			# lo = reult/9
	mflo $a0
	#li.s $f2, 1.8			# $f2 = 1.5
	#li.s $f4, 32.0			# f4 = 32.0
	#sub.s $f0, $f0, $f4		# $f0 = f-32
	#div.s $f12, $f0, $f2	# $f12 = (f-32)/1.8

	li $v0, 1				# 1: system service to print int
	syscall

	j $ra

exit:
	li $v0, 10				# 10: system service to exit
	syscall