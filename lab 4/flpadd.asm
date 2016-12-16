#--------------------------------
# CSE 2304 Lab Assignment 4
# Problem 2
#--------------------------------
# The numbers below are loaded into memory (the Data Segment)
# before your program runs.  You can use a lw instruction to
# load these numbers into a register for use by your code.
.data
blank:	.asciiz " "
newln:	.asciiz "\n"
hex:	.byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
atest:  .word 0x0 	# you can change this to anything you want
btest:  .word 0x0 	# you can change this to anything you want
smask:  .word 0x007FFFFF 	# MASK for significands
emask:  .word 0x7F800000 	# MASK for exponent
ibit:   .word 0x00800000 	# to append a leading 1
obit:   .word 0x01000000 	# to check overflow of sum of significands
endstr:    .asciiz "\nThe approximate value of e =  "
.text
# The main program computes e using the infinite series, and
# calls your flpadd function (below).
#
# PLEASE DO NOT CHANGE THIS PART OF THE CODE
#
# The code uses the registers as follows:
#    $s0 - 1 (constant integer)
#    $s1 - i (loop index variable)
#    $s2 - temp
#    $f0 - 1 (constant single precision float)
#    $f1 - e (result accumulator)
#    $f2 - 1/i!
#    $f3 - i!
#    $f4 - temp
main:
	li 		$s0,1				# load constant 1
	mtc1 	$s0,$f0				# copy 1 into $f0
	cvt.s.w $f0,$f0				# convert 1 to float
	mtc1 	$0, $f1				# zero out result accumulator
	li 		$s1,0				# initialize loop index
tloop:
	addi 	$s2,$s1,-11			# Have we summed the first 11 terms?
	beq 	$s2,$0,end			# If so, terminate loop
	bnez 	$s1,fact			# If this is not the first time, skip init
	mov.s 	$f3,$f0				# Initialize 0! = 1
	j dfact						# bypass fact
fact:
	mtc1	$s1,$f4				# copy i into $f4
	cvt.s.w $f4,$f4				# convert i to float
	mul.s   $f3,$f3,$f4			# update running fact
dfact:
	div.s   $f2,$f0,$f3			# compute 1/i!

	mfc1 	$a0,$f1				# These lines should do: add.s $f1,$f1,$f2
	mfc1	$a1,$f2				# You nned to do add.s with only integer registers
	jal flpadd					# This is where we call your function

	mtc1 	$v0,$f1				#/
	addi 	$s1,$s1,1			# increment i

	add 	$a0, $zero, $v0		# Print the bits from the returned value $v0
	jal 	print_bit			# Call your function print_bit
								# format is:   Sign  EXP  Significand
	la 		$a0, newln			# Load a newline into $a0 for printing
	li 		$v0, 4				# System call to print string
	syscall
	j tloop						# Continue calculating e
end:
	li 		$v0, 4
	la 		$a0, endstr
	syscall

	mov.s  $f12, $f1
	li     $v0, 2
	syscall

	li $v0, 10		# End the program
	syscall

# If you have trouble getting the right values from the program
# above, you can comment it out and do some simpler tests using
# the following program instead.  It allows you to add two numbers
# (specified as atest and btest, above), leaving the result in $v0.
# main:
# 	lw $a0,atest		# Load the 1st number into $a0 as an argument for flpadd
# 	lw $a1,btest		# Load the 2nd number into $a1 as an argument for flpadd
#
# 	li.s $f0, 0.1
# 	mfc1 $a0, $f0
# 	li.s $f1, 0.01
# 	mfc1 $a1, $f1
#
# 	jal flpadd		# Call flpadd
# 	mtc1 $v0,$f6		# Move the result from $v0 to $f6
# 	li $v0, 2		# System call to print float
# 	mov.s $f12, $f6		# Move value into $f12 to print
# 	syscall
# 	la $a0, newln		# Load a newline into $a0 for printing
# 	li $v0, 4		# System call to print string
# 	syscall
# 	mfc1 $a0,$f6		# Move the sum into $a0 to print the bits
# 	jal print_bit		# Call print_bit
# 	la $a0, newln		# Load a newline into $a0 for printing
# 	li $v0, 4		# System call to print string
# 	syscall
# 	la $a0, newln		# Load a newline into $a0 for printing
# 	li $v0, 4		# System call to print string
# 	syscall
# end:
# 	li $v0, 10		# End the program
# 	syscall
# Here is the function that performs floating point addition of
# single-precision numbers.  It accepts its arguments from
# registers $a0 and $a1, and leaves the sum in register $v0
# before returning.
#
# Make sure not to use any of the registers $s0-$s7, or any
# floating point registers, because these registers are used
# by the main program.  All of the registers $t0-$t9, however,
# are okay to use.
#
# YOU SHOULD NOT USE ANY OF THE MIPS BUILT-IN FLOATING POINT
# INSTRUCTIONS.  Also, don't forget to add comments to each line
# of code that you write.
#
# Remember the single precision format:
#          bit 31 = sign (1 bit)
#      bits 30-23 = exponent (8 bits)
#       bits 22-0 = significand (23 bits)
#
#	$t0 will hold the first number
#	$t1 will hold the second number
#	$t2 will hold the masks, leading 1 bit, and overflow checker bit
#	$t3 will hold the exponent of the first number
#	$t4 will hold the exponent of the second number
#	$t5 will hold the significand of the first number
#	$t6 will hold the significand of the second number
#	$t7 will hold the difference between the exponents
#	$t8 will hold the sum significand
#	$t9 will hold the final result
#Implement flpadd procedure

flpadd: # Your code here
	move  $t0, $a0		# move first number to $t0
	move  $t1, $a1		# move second number to $t1

	lw $t2, emask 	# Step 1 #
	and $t3, $t0, $t2	# $t3 = ($t0 AND 0x7F800000)
	srl $t3, $t3, 23    # isolate exponent number

	and $t4, $t1, $t2   # $t4 = ($t1 AND 0x7F800000)
	srl $t4, $t4, 23	# isolate exponent number

	lw $t2, smask # Step 2: significand #
	lw $t9, ibit

	and $t5, $t0, $t2 	# $t5 = ($t0 AND 0x007FFFFF)
	or $t5, $t5, $t9  # append 1

	and $t6, $t0, $t2 	# $t6 = ($t1 AND 0x007FFFFF)
	or $t6, $t6, $t9  # append 1

	# check highest number #
	slt $t2, $t0, $t1 	# $t2 = (A < B) ? 1 : 0
	beq	$t2, $zero, aIsGreater  # if $t2 != 0 then A is greater

	# B is larger than A
	sub $t7, $t4, $t3	# $t7 = B - A
	srl $t8, $t5, $t7	# $t8 = A >> $t7
	add $t8, $t6, $t8
	move $t2, $t4		# $t2 = exponentB
	j checkOverflow

	aIsGreater:
		sub $t7, $t3, $t4 	# $t7 = exponentA - exponentB
		srl $t8, $t6, $t7	# $t8 = exponentB >> $t7
		add $t8, $t5, $t8
		move $t2, $t3		# $t2 = exponentA

	checkOverflow:
		lw $t0, obit				# $t
		slt $t9, $t8, $t0			# $t9 = (sum Significand < obit) ? 1 : 0
		bne $t9, $zero, stepEight 	# if 0 == 0 then overflow occured

		srl $t8, $t8, 1				# right shift by 1
		addi $t2, $t2, 1			# $t8 = $t8 + 1

	stepEight:
		sll $t8, $t8, 9		# strip leading 1 off sum significand
		srl $t8, $t8, 9		# shift sum significand back to proper place

	sll $t2, $t2, 23 		# shift exponent back in proper palce
	or $t9, $t8, $t2		# merge the significant result and result exponent
	move $v0, $t9			# return single-precision result
	j $ra

#implement print_bit procedure
print_bit: 			# Your code here
	move $t0, $a0	# $t0 = bits to be printed

	# sign bit #
	slt  $a0, $t0, $zero  # Check first number sign
	li  $v0, 1		# $v0 = 1 # 1: system service to print int
	syscall

	li	$v0, 4		# $v0 = 4
	la $a0, blank # $a0 = blank space
	syscall

	# exponents #
	sll $t1, $t0, 1		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	li $v0, 1			# 1: system service to print int
	syscall

	sll $t1, $t0, 2		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	syscall

	sll $t1, $t0, 3		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	syscall

	sll $t1, $t0, 4		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	syscall

	li $v0, 4			# 4: system service to print string
	la $a0, blank		# load blank space
	syscall

	sll $t1, $t0, 5		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	li $v0, 1			# 1: system service to print int
	syscall

	sll $t1, $t0, 6		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	syscall

	sll $t1, $t0, 7		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	syscall

	sll $t1, $t0, 8		# pluck off leading values
	srl $a0, $t1, 31	# bring exponent to front
	syscall

	li $v0, 4			# 4: system service to print string
	la $a0, blank		# load blank space
	syscall

	# mantissa #
	sll $t1, $t0, 9		# $t1 = #### ####  ...
	srl $a0, $t1, 31 	# 1 mantissa
	li $v0, 1
	syscall

	sll $t1, $t0, 10	# 2nd mantissa
	srl $a0, $t1, 31	# bring to front
	syscall

	sll $t1, $t0, 11 	# 3rd mantissa
	srl $a0, $t1, 31	# bring to front
	syscall

	sll $t1, $t0, 12	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 13	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 14	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 15	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 16	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 17	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 18	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 19	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 20	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 21	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 22	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 23	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 24	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 25	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 26	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 27	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 28	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 29	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 30	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	sll $t1, $t0, 31	# move mantissa left
	srl $a0, $t1, 31	# move mantissa to front
	syscall

	j $ra			# exit program
