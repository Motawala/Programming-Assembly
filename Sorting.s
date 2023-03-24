.data
MyArray:	.word	10000, 3, 5, 10, 90, 8990, 4 ,2 , 1, 9
size:	.word	10
newLine:	.asciiz	"\n"
spaceComma: .asciiz	" "
Max:		.asciiz	"Max Number: "

#$s0, MyArray
#$s1, size
.globl main

.text
main:
	
	la $s0, MyArray		#Loads the Array inside s0
	lw $s1, size		#Loads the size of the array in s1
	la $s2, newLine		#Loads the new Line character in s3
	
	add $a0, $zero, $s0		#Pass in the array as a0 to the getMax function
	add $a1, $zero, $s1		#Pass in the size of the array a1 to the getMax function
	jal radixSort
	
	
	addi $v0, $zero, 10
	syscall
	
	
getMax:
	addi $sp, $sp, -20	#Allocates the memory inside the stack
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	add $t0, $zero, $a0		#Storing the array in t0
	add $t1, $zero, $a1		#Storing the size in t1
	
	addi $t2, $zero, 0		#initialize i to 0
	lw $t3,  0($t0)			#Load the first element of the array in $t3
	jal getMaxLoop
	
getMaxLoop:
	beq $t1, $t2, exitMax		#if the size of the array is equal to i exit Max
	addi $t0, $t0, 4
	lw $t4, ($t0)				#Loads the second element of the array in t4
	bge $t3, $t4, greater		#if t3 is greater than t4, t5=0
	move $t3, $t4
	
	
greater:
	addi $t2, $t2, 1		#increment i by 1
	bne $t2, $t1, getMaxLoop
		
exitMax:
	
	add $v0, $zero, $t3			#Returns the value of the Max

	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	
	addi $sp, $sp, 20			#Deallocates the memory in the stack
	j $ra
	
	
	
radixSort:
	addi $sp, $sp, -20	#Allocates the memory inside the stack
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	add $a0, $zero, $s0		#passes the array as an argument in the getMax function
	add $a1, $zero, $s1		#passes the array size as an argument in the getMax
	jal getMax
	add $t0, $zero, $v0		#Max value in the array returned from the getMax function
	add $s3, $zero, $v0
	
	addi $t1, $zero, 1		#Initialize the value of exp to 1
	
	jal radixSortLoop		#Call radixSort


radixSortLoop:
	div $t0, $t1			#Divides the Max by exp
	mflo $t4				#Stores the quotient
	
	addi $t2, $zero, 10			
	mult $t1, $t2			#Multplies the exp by 10
	mflo $t1				#Stores its value in $t1


	add $a1, $zero, $t1
	bge $t4, $zero, countSort	#Checks if m/exp > 0 
	slt $t4, $zero, $t4
	bne $t4, $zero, exitRadixSort			#Else calls the exit function
	#or, $zero, $zero, $zero
	
	
countSort:
	
	addi $sp, $sp, -60				#Allocates the memory for the array in stack
	sw $ra, 56($sp)
	
	li $t0, 0						#Initialize the value that is to be stored in the Array
	li $t1,0						#The index of the current element set to 0
	
	addi $t3, $zero, 0				#Initialize i to 0
	
	jal addZeros					#Calls addElements to add 0s to the count Array
	
	
	
	#=======================================
	addi $sp, $sp, -24				#Allocates the memory for the array in stack
	sw $ra, 20($sp)
	
	addi $t0, $zero, 0				#Initialize i to 0
	add $t1, $zero, $a1				#exp from the radixSort
	add $t2, $zero, $v0				#The count Array
	
	#jal loop1
	
	jal exitCountSort
	
loop1:
	slt $t3, $t0, $s1				#checks i<n
	
	add $t4, $s0, 4					#getting the offset of the array 
	lw $t5, ($t4)					#loading the element in t5
	div $t5, $t2					#arr[i]/exp
	mflo $t5						#Stores the quotient from the above expression
	
	add $t6, $t2, 4					#getting the offset of the count Array
	sw $t5, ($t6)					#loading the element of the count array.
	

	jal exitLoop1					
	

	
exitLoop1:
	lw $ra, 20($sp)
	addi $sp, $sp, 24				#Deallocates the memory for the Count array in the stack.
	
	j $ra

addZeros:
	add $t2, $sp, $t1				#getting the offset of the Array
	sw $t0, ($t2)					#Storing zero
	addi $t1, $t1, 4				#incrementing the offset of the Array
	addi $t3, $t3, 1				#Incrementing the counter variable
	bne $t3, $s1, addZeros			#loop over again
		
	add $v0, $zero, $t2
	j $ra
	
	


exitCountSort:
	
	slt $t4, $zero, $t4				#If the result of m/exp is > 0 jump back to the radixSort
	bne $t4, $zero, radixSortLoop
	or, $zero, $zero, $zero			#no operations
	
	lw $ra, 56($sp)
	addi $sp, $sp, 60				#Deallocates the memory for the Count array in the stack.
	
	
exitRadixSort:
	add $a0, $zero, $s0			#Passing in the array inside the printData function
	add $a1, $zero, $s1			#Passing in the size of the array inside the print Data function
	add $a2, $zero, $s3
	jal printData				#Calling the printData function
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	
	
	addi $sp, $sp, 20			#Deallocates the memory in the stack
	j $ra
	
	jal end


printData:
	addi $sp, $sp, -24	#Allocates the memory inside the stack
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t5, 20($sp)

	add $t0, $zero, $a0		#Store the array arg in t0
	add $t1, $zero, $a1		#Store the size of the Array arg in t1
	add $t5, $zero, $a2		#Stores the maximum Value
	
	addi $t1, $t1, 1
	
	add $t2, $zero, 0		#Initializes the counter variable to 0
	
	li $v0, 4
	la $a0, newLine
	syscall
	
printDataLoop:
	lw $t4, ($t0)			#Loads the elements of the array into a temp registers
	addi $t0, $t0, 4		#Moves on to the next element in the array.
	
	li $v0, 1				#Prints the elements of the Array
	move $a0, $t4
	syscall
	
	li $v0, 4
	la $a0, spaceComma
	syscall
	
	addi $t2, $t2, 1				#increments the counter variable.
	bne $t2, $t1, printDataLoop		#Call the printDataLoop until the counter is not equal to the size
	
	li $v0, 4						#Prints the newLine
	la $a0, newLine
	syscall
	
	li $v0, 4						#Prints the Maximum Number message
	la $a0, Max
	syscall
	
	li $v0, 1						#Prints the Maximum Number
	move $a0, $t5
	syscall
	
	jal exitPrintData
	

exitPrintData:		
	li $v0, 4				#Prints a newline after an array is printed
	la $a0, newLine
	syscall
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t5, 20($sp)
	
	addi $sp, $sp, 24			#Deallocates the memory in stack
		
	jal end

end:
	addi $v0, $zero, 10			#Exits the program.
	syscall
	