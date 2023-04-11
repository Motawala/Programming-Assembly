.data
infix:	.asciiz	"4(3+2)"
newLine:	.asciiz	"\n"

.globl main

.text

main:
	la $s0, infix
	
loop:
	lb $t0, ($s0)
	
	beq $t0, $zero, exit
	
	jal next_char
	
next_char:
	addi $s0, $s0, 1
	jal printData
	
	
printData:
	li $v0, 11
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	j loop
	
exit:
	li $v0, 10
	syscall