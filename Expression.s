.data
msg:	.asciiz	"Enter the Expression to be evaluated:"				#Message prompt for the user to enter the Expression
postfix: .space 200													#Store the postfix Expression
infix:	.space	100													#Stores the infix expression from the user
postfix_msg:	.asciiz	"Postfix expression =  "					#Message to display the postfix Expression
newLine:	.asciiz	"\n"											#Newline character to add a new line to the console
result_msg:	.asciiz	"Postfix evaluation =  "						#Message to print the evaluated expression on the console

.globl main

.text

main:
	li $v0, 4						#Prints the prompt message to enter the expression
	la $a0, msg
	syscall
	
	li $v0, 8						#Loads the entered expression
	la $a0, infix
	li $a1, 100
	syscall
	
	la $s0, infix					#Loads the infix expression
	la $s1, postfix					#Loads the postfix expression
	
	add $s2, $s2, $zero
	addi $sp, $sp, -55				#Allocating the space in stack and initializing the frame pointer
	add $fp, $sp, $zero
	lb $t0, 1($sp)
	lb $t1, 1($sp)
	lb $t2, 1($sp)
	lb $t3, 1($sp)
	lb $t4, 1($sp)
	lb $t5, 1($sp)
######################################################
#Loops over the infix expression and checks the chars#
######################################################
loop:
	
	lb $t0, ($s0)						#Loads the char from the infix expression
	
	beq $t0, $zero, clear_stack			#If the infix expresion ends exit
	
	
	beq $t0, 0x28, push					#If the char is equal to (	
	beq $t0, 0x29, load_stack			#If the char is equal to )
	beq $t0, 0x20, next_char			#If the char is equal to space
	beq $t0, 0x2B, operator				#If the char is equal to +
	beq $t0, 0x2D, operator				#If the char is equal to -
	
	jal add_postfix						#Adds the operands to the postfix expression
	

#####################################################
#Converts the Infix Expression to Postfix Expression#
#####################################################


add_postfix:
	sb $t0, ($s1)						#stores the char into the postix expression	
	addi $s1, $s1, 1					#Increments the postfix Expression
	
	addi $s0, $s0, 1
	jal loop
	
next_char:								#Moves to the next char in the infix expression
	addi $s0, $s0, 1
	jal loop
##############################################################
#Pushes the element into the stack for the postfix conversion#
##############################################################

push:									#Pushes the char into the stack
	beq $sp, $fp, empty
	
	addi $sp, $sp, -1
	sb $t0, ($sp)

	addi $s0, $s0, 1					#Increments the infix expression
	jal loop
empty:								
	addi $sp, $fp, -1					#If the stack is empty push to the stack
	sb $t0, ($sp)
	
	addi $s0, $s0, 1
	jal loop
#########################################################################
#Checks if the top of the stack is an operator pop that element and push#
#the current scanned operator into the stack.							#
#########################################################################
operator:								#Checks the conditions for the operators
	beq $sp, $fp, empty
	
	lb $t1, ($sp)
	beq $t1, 0x2B, add_element
	beq $t1, 0x2D, add_element
	
	jal push
add_element:							#Adds the scanned operator to the postfix expression
	sb $t1, ($s1)
	addi $s1, $s1, 1					#Increments the postfix Expression
	
	addi $sp, $sp, 1					#Increments the stack pointer
	
	jal operator
#####################################################################
#Pop the elements from the stack until the scanned element is a '('.#
#####################################################################

load_stack:								#Checks the condition for the cloasing bracket
	lb $t1, ($sp)
	bne $t1, 0x28, add_element_postfix
	
	jal pop
add_element_postfix:					#adds the scanned char to the postfix expression
	sb $t1, ($s1)					
	addi $s1, $s1, 1
	
	addi $sp, $sp, 1
	
	jal load_stack
pop:									#Pops the char from the stack
	addi $sp, $sp, 1
	
	addi $s0, $s0, 1
	jal loop
clear_stack:							#clears the stack used for converting the postfix expression
	lb $t0, ($sp)
	bne $t0, $zero, pop_stack			#If the stack is not empty add the elements from the stack to postfix

	addi $sp, $sp, 55					#Deallocate the memory from the stack and heap
	addi $fp, $fp, 55
	
	la $s1, postfix
	jal assign_space					#Assign the memory in stack for evaluating postfix

##########################################################
#Evaluates the Postfix Expression and Displays the result#
##########################################################
assign_space:
	addi $sp, $sp, 50					#assign memory in stack and heap
	add $fp, $sp, $zero

	jal evaluate_postfix
#######################################################################################################################
#If its a number push it into the stack and if its an operator pop 2 elements from the stack and perform the operation#
#######################################################################################################################

evaluate_postfix:
	lb $t2, ($s1)						#Loads the char from the postfix expression
	
	
	beq $t2, 0x2B, add_op				#If the char is + pop two elements from stack and add them
	beq $t2, 0x2D, sub_op				#If the char is - pop two elements from stack and subtract them
	beq $t2, 0xA, dealloacte_space		#If the char is null or newLine deallocate the stack memory and display the results
	beq $t2, 0x0, dealloacte_space
	
	beq $t2, $zero, dealloacte_space
	
	jal push_operand
push_operand:
	addi $sp, $sp, -1					#If the char is a number push it into the stack
	addi $t2, $t2, -48
	sb $t2, ($sp)
	
	addi $s1, $s1, 1					#Increment the postfix expression
	jal evaluate_postfix
add_op:
	lb $t3, ($sp)						#Loads the number from the stack
	addi $sp, $sp, 1
	
	lb $t4, ($sp)						#Loads the 2nd number from the stack
	addi $sp, $sp, 1
	
	add $t5, $t3, $t4					#Add the elements and push the results into the stack
	
	addi $s1, $s1, 1
	addi $sp, $sp, -1					#Decrementing the stack pointer
	
	sb $t5, ($sp)
	
	jal evaluate_postfix
sub_op:
	lb $t3, ($sp)						#Load the first element from the stack
	addi $sp, $sp, 1
	
	lb $t4, ($sp)						#Load the 2nd element from the stack
	addi $sp, $sp, 1
	
	sub	$t5, $t4, $t3					#perform - operation on the 2 elements
	
	
	addi $s1, $s1, 1
	addi $sp, $sp, -1
	sb $t5, ($sp)						#Push the results into the stack
	
	jal evaluate_postfix

	#jal add_results
dealloacte_space:
	lb $t2, ($sp)						#pop the result from the stack
	add $s2, $zero, $t2					#add the result to a saved register
	
	addi $sp, $sp, 1
	
	addi $sp, $sp, 50					#Deallocate the memory from the stack and heap
	addi $fp, $fp, 50				
	
	jal exit							#Exit the program and print the results
	
pop_stack:								#Pops the remaining elements from the stack
	sb $t0, ($s1)
	addi $s1, $s1, 1
	
	lb $t0, ($sp)						#Loads the elements from the stack
	beq $t0, $zero, clear_stack
	addi $sp, $sp, 1
	
	jal pop_stack
exit:									#Exits the program and prints the data
	li $v0, 4	
	la $a0, newLine						#Adds a newline to the output
	syscall	
	
	li$v0, 4					
	la $a0, postfix_msg					#Prints the postfix expression message
	syscall
	
	li $v0, 4
	la $a0, postfix						#Prints the postfix expression
	syscall
	
	li $v0, 4
	la $a0, newLine						#Adds the newline to the output
	syscall

	li $v0, 4
	la $a0, result_msg					#Displays the evaluated expression message
	syscall
	
	li $v0, 1	
	move $a0, $s2						#Prints the result to the screen
	syscall

	li $v0, 10
	syscall								#Exits the program