#  Swap Function Test
#  An unsorted list with 10 elements.
#  The two inputs are stored in $a0 and $a1.
#  swap function should return the swaped array.
#######################################################################
.data
arr:			.float	1.3, -0.6, -9.8, 5.5, 3.2, -2.4, 4.4, -1.6, -2.02, 1.0
length:			.word 	10
get_index1:		.asciiz	"Please input the first index: "
get_index2:		.asciiz	"Please input the second index: "
spa:			.asciiz ", "
newLine:			.asciiz "\n"
arrayPrompt: 	.asciiz "\nOriginal Array: "
.text
main:
	# Get the first index from user
	li   $v0, 4
	la   $a0, get_index1
	syscall
	li   $v0, 5
	syscall
	move $s1, $v0

	# Get the second index from user
	li   $v0, 4
	la   $a0, get_index2
	syscall
	li   $v0, 5
	syscall
	move $s2, $v0

	# print original array
	la $a0, arr
	jal printArray

	continue:
		# swap function
		move $a0, $s1
		move $a1, $s2
		jal swap 				# Here is your function

		move $a0, $v0
		jal printArray

		j exit

printArray:
	li $t0, 0 			# print index
	move $t1, $a0		# $t0 = array
	la $t2, length	# $t2 = array.length
	lw $t2, 0($t2)
	addi $t2, $t2 -1

	li $v0, 4				# 4: system service to print string
	la $a0, arrayPrompt
	syscall

	loop:
		li $v0, 2					# $v0 = 2
		sll $t3, $t0, 2		# $t3 = $t0 * 4 (array offset)
		add $t4, $t3, $t1
		l.s $f12, 0($t4)	# $f12 = array[0]
		syscall

		slt $t3, $t0, $t2					# $t3 = (index < 10) ? 1 : 0
		beq	$t3, $zero, exitFunc	# if $t3 == $zero then continue

		li $v0, 4				# 4: system service to print string
		la $a0, spa			# $a0 = ', '
		syscall

		addi $t0, $t0, 1	# $t0++
		j loop

	exitFunc:
		li $v0, 4				# 4: system service to print string
		la $a0, newLine			# $a0 = '\n'
		syscall

		j $ra

exit:
	li   $v0, 10
	syscall

#######################################################################

swap:
	la $t0, arr       # $t0 = array
  sll $t1, $a0, 2   # $t1 = index1 * 4
  sll $t2, $a1, 2   # $t2 = index2 * 4

	add $t1, $t0, $t1
  lw 	$t3, 0($t1)		# $t3 = array[$a0]

	add $t2, $t0, $t2
	lw 	$t4, 0($t2)		# $t4 = array[$a1]

	sw 	$t3, 0($t2)		# array[$a1] = $t3
	sw  $t4, 0($t1)		# array[$a0] = $t4

	move $v0, $t0
	jr   $ra
