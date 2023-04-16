.data
msg:	.asciiz	"Please enter the string:"
postfix: .space 200
my_str:	.space	100
postfix_msg:	.asciiz	"Conversion to postfix expression: "
newLine:	.asciiz	"\n"

.globl main

.text

main:
	li $v0, 4
	la $a0, msg
	syscall
	

	li $v0, 8
	la $a0, my_str
	li $a1, 100
	syscall
	
	

	la $s0, my_str
	la $s1, postfix
	
	addi $sp, $sp, -50
	add $fp, $sp, $zero
	addi $s2, $s2, 0

	

loop:
	
	lb $t0, ($s0)
	
	beq $t0, $zero, exit
	
	
	beq $t0, 0x28, push					#If the char is equal to (	
	beq $t0, 0x29, load_element			#If the char is equal to )
	beq $t0, 0x20, next_char			#If the char is equal to space
	beq $t0, 0x2B, operator				#If the char is equal to +
	beq $t0, 0x2D, operator				#If the char is equal to -
	
	jal add_postfix

add_postfix:
	sb $t0, ($s1)
	addi $s1, $s1, 1
	
	addi $s0, $s0, 1
	jal loop
next_char:	
	addi $s0, $s0, 1
	jal loop
push:
	beq $sp, -50, empty
	
	addi $sp, $sp, -1
	sb $t0, ($sp)

	addi $s2, $s2, 1
	addi $s0, $s0, 1
	jal loop
empty:
	addi $sp, $sp, -1
	sb $t0, ($sp)
	
	addi $s2, $s2, 1
	addi $s0, $s0, 1
	jal loop
operator:
	beq $sp, -50, empty
	
	lb $t1, ($sp)
	beq $t1, 0x2B, add_element
	beq $t1, 0x2D, add_element
	
	jal push
add_element:
	sb $t1, ($s1)
	addi $s1, $s1, 1
	
	addi $sp, $sp, 1
	addi $s2, $s2, -1
	
	jal operator
load_element:
	lb $t2, ($sp)
	bne $t2, 0x28, add_element_postfix
	
	jal pop
add_element_postfix:
	sb $t2, ($s1)
	addi $s1, $s1, 1
	
	addi $sp, $sp, 1
	addi $s2, $s2, -1
	
	jal load_element
pop:
	addi $sp, $sp, 1
	
	addi $s0, $s0, 1
	jal loop

pop_stack:
	sb $t0, ($s1)
	addi $s1, $s1, 1
	
	lb $t0, ($sp)
	beq $t0, $zero, exit
	addi $sp, $sp, 1
	
	jal pop_stack
exit:
	
	lb $t0, ($sp)
	bne $t0, $zero, pop_stack
	
	addi $sp, $sp, 50
	addi $fp, $fp, 50

	li $v0, 4
	la $a0, newLine
	syscall
	
	li$v0, 4
	la $a0, postfix_msg
	syscall
	
	li $v0, 4
	la $a0, postfix
	syscall
	
	
	
	li $v0, 10
	syscall