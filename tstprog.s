.data
user_prompt:	.asciiz	"Enter the infix Expression: "
infix:	.space	50
postfix:	.asciiz	""
newLine:	.asciiz	"\n"

.globl main

.text

main:
	li $v0, 4						#Printing the user propmt for the Expression
	la $a0, user_prompt
	syscall
	
	li $v0, 8						#Taking the expression input from the user
	la $a0, infix					#Storing the user input in the infix variable
	li $a1, 50
	syscall

	la $s0, infix					#Load the infix expression.
	la $s1, postfix					#Intitialize postfix expression.

	
loop:
	addi $sp, $sp, -20				#Allocates the memory inside the stack
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	lb $t0, ($s0)					#Load the 1 character from the infix expression
	
	
	
	beq $t0, $zero, exit			#If the character is equal to zero --> exit.
	

	beq $t0, 0x20, next_char		#If the char is equal to space
	beq $t0, 0x2B, operator			#If the char is equal to +
	beq $t0, 0x2D, operator			#If the char is equal to -
	beq $t0, 0x2A, operator			#If the char is equal to *
	beq $t0, 0x2F, operator			#If the char is equal to /
	beq $t0, 0x28, push_op			#If the char is equal to (
	beq $t0, 0x29, pop_op			#If the char is equal to )
	
	jal add_operand


operator:
	#Check the precedence of the operator
	j next_char

next_char:
	
	#Moves onto the next char of the expression.
	sb $t0, ($s1)
	addi $s1, $s1, 1
	
	addi $s0, $s0, 1
	j loop
	
push_op:
	
	
	j next_char
pop_op:

	j next_char
pop_stack:
	
	j next_char
add_operand:
	
	
	j next_char
	
exit:
	
	jal printData
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	
	addi $sp, $sp, 20				#Deallocates the memory on stack
	
	#Exits the program
	li $v0, 10
	syscall
	
	
printData:
	#Prints the postfix expression
	li $v0, 4
	la $a0, postfix
	syscall
	
	
	
	j $ra
	
	