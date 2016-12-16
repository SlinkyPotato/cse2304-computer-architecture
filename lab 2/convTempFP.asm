convertToFDisplay:
	mtc1 $a0, $f0			# f0 = $a0
	cvt.s.w $f0, $f0		# convert the previous integer to fp

	li $v0, 4				# 8: system service to print string
	la $a0, cToF 			# load up C t F is
	syscall 

	li.s $f2, 1.8			# $f2 = 1.8
	mul.s $f0, $f0, $f2		# $f0 = (c)*1.8
	li.s $f2, 32.0
	add.s $f12, $f0, $f2	# $f12 = (c*1.8) + 32

	li $v0, 2				# 12: system service to print float
	syscall

	j $ra
	
convertToCDisplay:
	mtc1 $a0, $f0			# f0 = $a0
	cvt.s.w $f0, $f0		# convert the previous integer to fp

	li $v0, 4				# 4: system service to print string
	la $a0, fToC			# $a0= F to C is 
	syscall

	li.s $f2, 1.8			# $f2 = 1.5
	li.s $f4, 32.0			# f4 = 32.0
	sub.s $f0, $f0, $f4		# $f0 = f-32
	div.s $f12, $f0, $f2	# $f12 = (f-32)/1.8

	li $v0, 2				# 12: system service to print float
	syscall

	j $ra
