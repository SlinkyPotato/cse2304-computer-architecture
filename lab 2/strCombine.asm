list: .space 512

strCombine:
		addi $sp, $sp, -4				# move stack pointer
		sw $s0, 0($sp)
		li $t1, 10						# $t1 = 10 (checkfor new line)
		la $s0, combinedString					# $s0 = array address

		# above value is kept since jal was not called	
		loopString:
			lb $t0, 0($a0)				# $t0 = '(character)'
			beqz $t0, addSpace			# add space on null
			sb $t0, 0($s0)				# $s0.addCharacter($t0)
			addi $a0, $a0, 1			# increase $a0 index by 1		
			addi $s0, $s0, 1			# increase $a2 index by 1
			j loopString				# loop until all characters are processed

		addSpace:
			bne $t2, $zero, exitStrCombine # exit if second run
			li $t0, ' '					# store space character
			sb $t0, 0($s0)				# store $t0 into 0($s0)
			addi $s0, $s0, 1			# increase index of $s0

		add $a0, $a1, $zero
		addi $t2, 1						# exit flag
		j loopString

		exitStrCombine:
			sb $zero, 0($s0)			# end string2
			jr $ra