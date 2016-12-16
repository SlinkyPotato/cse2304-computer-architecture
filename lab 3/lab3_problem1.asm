# CSE 2304 Lab 3
# Problem 1
.data # Data declaration section
str1: .asciiz "Please Enter an Integer: "
str2: .asciiz "Output: "
.text
main: # Start of code section
li $v0, 4 # system call code for printing string = 4
la $a0, str1 # load address of string to be printed into $a0
syscall # call operating system to perform print operation
li $v0, 5 # read in integers
syscall
add $a1, $v0, $zero
li $v0, 4
la $a0, str1
syscall
li $v0, 5 # read in integers
syscall
move $a0, $v0
jal greater # Subroutine call
move $t0, $v0 # Save result here.
li $v0, 4
la $a0, str2
syscall
li $v0, 1 # system call code for print_int
move $a0, $t0
syscall
li $v0, 10 # exits program
syscall
#Implermentation of greater subroutine
greater:
bgt $a1, $a0, gt
beq $a1, $a0, eq
#Here we know that $a0 < $a1
li $v0, -1
jr $ra
gt: li $v0, 1
jr $ra
eq: li $v0,0
jr $ra
# END OF PROGRAM