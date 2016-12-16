# Lab 2 Hello World
.data
out: .asciiz "Hello world!\n"
.text
main:
	li $v0, 4 	#4 means we want to print the screen
	la $a0, out
	# li $t0, 0x10000000
	# sub $a0, $a0, $t0	#$a0 = $a0 - $t0
	syscall
exit:
	li $v0, 10
	syscall