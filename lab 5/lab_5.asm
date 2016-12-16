#--------------------------------
# Brian Patino
# CSE 2304 Sec. 001
# Lab Assignment 5
# Quick Sort
#--------------------------------
# The numbers below are loaded into memory (the Data Segment)
# before your program runs.  You can use a lw instruction to
# load these numbers into a register for use by your code.
.data

arr:			   .space 40     # store 4 * (10 elements)
# arr:			   .float	5.2, 2.4, 6.7, 1.9, 3.8, 4.7, 7.1, 8.3, 9.6, 10.9
length:		   .word 	10
spa:			   .asciiz ", "
newLine:	   .asciiz "\n"
arrayPrompt: .asciiz "Original Array: "
sortedArrayString: .asciiz "\nSorted Array: "
testArrayPrompt: .asciiz "Array: "
inputPropmt: .asciiz "Enter 10 single point numbers to sort: "
done:        .asciiz "Array sorted. Thank you."

.text
main:
#########################
# li $v0, 4 # print string
# la $a0, arrayPrompt
# syscall
# li $a0, 1
# li $a1, 2
# jal swap
# la $a0, arr         # $a0 = sorted array
# jal printArray
#/#######################
  li $v0, 4             # 4: system service to print strings
  la $a0, inputPropmt   # load input prompt
  syscall

  la $t0, arr           # $t0 = arr
  li $t1, 0             # i = 0
  lw $t2, length        # $t2 = length

  li $v0, 6             # 6: system service to read floating point
  loopInputFloat:
    syscall
    sll $t3, $t1, 2     # $t2 = i * 4
    add $t3, $t0, $t3   # add index and value to later store
    s.s $f0, 0($t3)     # arry[$0] = $f0

    addi $t1, $t1, 1         # i++
    slt $t3, $t1, $t2   # $t3 = (i < length) ? 1 : 0
    bne $t3, $zero, loopInputFloat # exit if i not less than length

  li $v0, 4           # 4: system service to print strings
  la $a0, arrayPrompt
  syscall

  la $a0, arr         # $a0 = arr address
  jal printArray

  # li $s0, 0           # $s0 = depth of stack
  la $a0, arr         # $a0 = array
  li $a1, 0           # $a1 = first index in array
  li $a2, 9           # $a2 = last index in array

  jal quicksort       # quick sort the array

  li $v0, 4           # 4: system service to print string
  la $a0, sortedArrayString
  syscall

  la $a0, arr         # $a0 = sorted array
  jal printArray      # print sorted array

  j exit            # exit program

  #### Quick sort Function ###
  # $a0: float nums[]
  # $a1: int first index
  # $a2: int last index
  quicksort:
    addi $sp, $sp, -16 # make space in stack
    sw $a0, 0($sp)    # store num[] in stack
    sw $a1, 4($sp)     # store first index of array in stack
    sw $a2, 8($sp)     # store last index of array in stack
    sw $ra, 12($sp)   # store return address

    slt $t3, $a1, $a2  # $t3 = (first < last) ? 1 : 0
    bne $t3, $zero, continue

    j exitQuickSort

    continue:

      jal partition
      move $t0, $v0       # p = return value of partition

      lw $a0, 0($sp)
      lw $a1, 4($sp)
      addi $a2, $t0, -1   # $a2 = p - 1

      jal quicksort

      lw $a0, 0($sp)      # $a0 = array address

      addi $a1, $s1, 1    # $a1 = p + 1

      lw $a2, 8($sp)      # $a2 = last index of array in stack

      jal quicksort

    exitQuickSort:
      lw $ra, 12($sp)     # $ra = return address of quicksort

      addi $sp, $sp, 16   # restore stack
      j $ra

  partition:
    move $s0, $a0   # $s0 = a[]
    move $s1, $a1   # $s1 = first
    move $s2, $a2   # $s2 = last
    move $s3, $ra   # $s3 = $ra

    sll $t0, $s2, 2         # $t0 = last * 4
    add $t0, $s0, $t0     # $t0 = &A[last]
    # l.s $f0, 0($s2)       # (pivot) $s2 = A[last]
    l.s $f0, 0($t0)       # (pivot) $f0 = A[last]

    move $s4, $a1        # $s4 = i = first
    move $s5, $a1        # $s5 = j = first to last
    partForLoop:
      addi $t0, $s2, -1  # $t0 = last - 1
      sle $t0, $s5, $t0   # if (j <= last - 1) ? 1 : 0
      beq $t0, $zero, exitPartLoop # if ($t0 == 0) then skip loop
        sll $t1, $s5, 2     # $t1 = j * 4 (offset)
        add $t0, $s0, $t1  # $t0 = &A[j]
        l.s $f2, 0($t0)     # $t0 = A[j]

        c.le.s $f2, $f0    # $25 (FCCR) = (A[j] <= pivot) ? 1 : 0
        bc1f incrementJ
          move $a0, $s4      # $a0 = index i
          move $a1, $s5      # $a1 = index j
          jal swap

          addi $s4, $s4, 1   # $s3++, i++
        incrementJ:
          addi $s5, $s5, 1   # $s4++, j++
        j partForLoop
    exitPartLoop:
      move $a0, $s4       # $a0 = i
      move $a1, $s2       # $a1 = last
      jal swap
    move $ra, $s3         # $ra = stored return address
    move $v0, $s4         # $v0 = i
    j $ra

exit:
  li $v0, 4     # 4: system service to print string
  la $a0, done  # load done string
  syscall

	li $v0, 10
	syscall

printArray:
	li $t0, 0 			# print index
  la $t1, arr
	la $t2, length	# $t2 = array.length
	lw $t2, 0($t2)
	addi $t2, $t2, -1 # length offset -1
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
