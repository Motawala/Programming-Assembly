.data
expression:	.asciiz	"4(3+(5*2))"


.globl main

.text

main:
	la $t0, expression
	lb $t1, ($t0)
	


	
loop:

	beq $t1, $zero, loop2
	
	addi $t2, $t1, 1			#Increment the ASCIIZ code by character 1
	sb $t2, ($t0)				#Store the modified variable in t1
	addi $t0, $t0, 1			#Move to the next character of the string
	lb $t1, ($t0)				#Load the next character into t0
	
	j loop
		 
		
loop2:
	la $t0, expression
	lb $t1, ($t0)
	li $t6, 0x30

	innerloop:
		beq $t1, $zero, exit

		addi $t2, $t1, -1			#Decrement the ASCIIZ code by character 1
		sb $t2, ($t0)				#Store the modified variable in t1
		slt $t3, $t6, $t2
		xori $t3, $t3, 0
		slti $t4, $t2, 0x3A
		and	$t5, $t3, $t4
		beq $t5, $zero, printData
	

		addi $t0, $t0, 1			#Move to the next character of the string
		lb $t1, ($t0)				#Load the next character into t0
		
		j innerloop
		
printData:

	li $v0, 1
	move $a0, $t2
	syscall
	
	j $ra

exit:

	
	
	li $v0, 10
	syscall