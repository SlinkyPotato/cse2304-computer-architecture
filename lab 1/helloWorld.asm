# Lab 2 Hello World
.data # data section
out: .asciiz "Hello world!\n"
.text
main:
	li $v0, 4 	# Move 4 to register $v0. This is the system service to display string messages
	la $a0, out # put the address of the string to display in register $a00
	# li $t0, 0x10000000
	# sub $a0, $a0, $t0	#$a0 = $a0 - $t0
	syscall # System call to output str
exit:
	li $v0, 10 # Move 10 to register $v0. This is the system service to exit the program
	syscall # exit by Passing control back to the operating system