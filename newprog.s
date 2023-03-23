.data
MyArray:	.word	1, 3, 5, 10, 90, 8990
size:	.word	5
newLine:	.asciiz	"\n"

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
	add $v0, $zero, $t3			#Returns the max value to the caller function
	
	
	#addi $t2, $t2, 1		#increment i by 1
	#j getMaxLoop
	greater:
		addi $t2, $t2, 1		#increment i by 1
		bne $t2, $t1, getMaxLoop

exitMax:
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	
	addi $sp, $sp, 20
	j $ra
		
	
countSort:
	move $t1, $a1
	li $v0, 1
	move $a0, $t1
	syscall
	j $ra
	
radixSort:
	addi $sp, $sp, -20	#Allocates the memory inside the stack
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	
	add $a0, $zero, $s0		#Pass in the array as a0 to the getMax function
	add $a1, $zero, $s1		#Pass in the size of the array a1 to the getMax function
	jal getMax
	
	add $t0, $zero, $v0		#Loads the max value to a temp register t0
	addi $t1, $zero, 1		#initialize exp to 1 in a2
	jal radixSortLoop
	
	
radixSortLoop:
	
	div $t0, $t1			#Divide the max by exp
	mflo $t0				#Store the quotient in $t0
	slt $t3, $zero, $t0
	
	
	add $a0, $zero, $s0		#Pass in the argument array in Count Sort function
	add $a1, $zero, $s1		#Pass in the argument size of the array in Count Sort function
	add $a2, $zero, $t1		#Pass in the argument exp in the Count Sort function.
	bne $t3, $zero, exitRadixSort		#if the (m/exp)<0 exit the function.
	jal countSort			#Else call countSort function.
	

	addi $t4, $zero, 10		#adds 10 to the temp reg t4
	mul $t1, $t1, $t4		#increment the exp by exp*=10
	j radixSortLoop			#Loops back in to check the next condition.
	
	

exitRadixSort:
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	
	addi $sp, $sp, 20
	j $ra
	jal end



end:
	addi $v0, $zero, 10
	syscall
	