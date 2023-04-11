
.data
my_str:	.space	50
msg:	.asciiz	"Please enter the string:"
postfix: .asciiz ""

.globl main

.text

main:
	li $v0, 4
	la $a0, msg
	syscall
	

	li $v0, 8
	la $a0, my_str
	li $a1, 50
	syscall
	
	li $v0,	4
	la $a0, my_str
	syscall

	la $s0, my_str
	la $s1, postfix
	addi $sp, $sp, 100
	add $fp, $sp, $zero

	
loop:
	
	lb $t0, ($s0)
	beq $t0, $zero, exit
	
	beq $t0, 0x28, push
	beq $t0, 0x29, push
	beq $t0, 0x20, next_char		#If the char is equal to space
	beq $t0, 0x2B, operator			#If the char is equal to +
	beq $t0, 0x2D, operator			#If the char is equal to -
	beq $t0, 0x2A, operator			#If the char is equal to *
	beq $t0, 0x2F, operator			#If the char is equal to /
	
	jal operand
	
operator:
	
	
	beq $sp, $fp, empty
	
	beq $t0, 0x28, push
	beq $t0, 0x29, push
	beq $t0, 0x2B, check_stack
	beq $t0, 0x2D, check_stack
	
	j loop
	

operand:
	sb $t0, ($s1)
	addi $s1, $s1, 1
	
	addi $s0, $s0, 1
	j loop
	
push:
	
	addi $sp, $sp, -1
	sb $t0, ($sp)
	
	lb $t0, ($sp)
	addi $sp, $sp, 1
	
	addi $s0, $s0, 1
	j loop
	
check_stack:

	lb $t1, ($sp)								#Loads the first element in the stack
	
	
	beq $t1, 0x2B, pop_operator					#Checks if the element is +
	beq $t1, 0x2D, pop_operator					#Checks if the element is -

	
pop_operator:
	
	sb $t1, ($s1)								#Store the poped element in the postfix expression
	addi $s1, $s1, 1							#Incremets the postfix expression


	
	addi $sp, $sp, -1
	sb $t0, ($sp)								#pops the element from the stack
	
	
	lb $t0, ($sp)
	
	add $s0, $s0, 1
	j loop
empty:
	
	addi $sp, $sp, -1
	sb $t0, ($sp)
	
	addi $s0, $s0, 1
	
	j loop
next_char:
	addi $s0, $s0, 1
	j loop
	
pop_out:
	lb $t0, ($sp)
	
	sb $t0, ($s1)
	addi $s1, $s1, 1
	beq $sp, $fp, pop_out
	jal exit
exit:
	beq $sp, $fp, pop_out
	addi $sp, $sp, -100
	addi $fp, $fp, -100	

	
	
	li $v0, 10
	syscall