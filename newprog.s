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
	jal getMax
	
	
getMax:
	addi $sp, $sp, -16	#Allocates the memory inside the stack
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
	lw $t4, ($t0)				#Loads the second element of the array in t4
	bge $t3, $t4, greater		#if t3 is greater than t4, t5=0
	move $t3, $t4
	
	addi $t0, $t0, 4
	jal getMaxLoop
greater:
	addi $t0, $t0, 4		#loads the next element of the Array
	addi $t2, $t2, 1		#increment i by 1
	jal getMaxLoop

exitMax:
	li $v0, 1
	move $a0, $t3
	syscall
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	
	addi $sp, $sp, 16
	j $ra
	
end:
	addi $v0, $zero, 10
	syscall
	