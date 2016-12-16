# CSE 2304 - Sec. 001 -  Lab Assignment 1
# Part 3
# Brian Patino
.data # data section 

#int_value: .word 0

str.num2: .asciiz "Enter value for X: "
promptY: .asciiz "Enter value for Y: "
promptZ: .asciiz "Enter value for Z: "

.text
main:
#Print message (syscall 4)
addi $v0, $zero, 4
la $a0, str.num2
syscall

# Read number (syscall 5)
addi $v0, $zero, 5
syscall

# Print number (syscall 0)
add $a0, $zero, $v0  # Get number read from previous syscall and put it in $a0, argument for next syscall
addi $v0, $zero, 1   # Prepare syscall 0
syscall              # System call