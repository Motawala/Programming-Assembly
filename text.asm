#@Karan Patel
#Programming Assignment 1

#Variables
#$t0 = my_array
#$t1 = length
#$t2  = max
#$t3 = counter

.data
my_array: .word	1, 2, 3, 4, 8, 9
size:	.word	5

.text
.globl main
main:
	la $t0, my_array
	la $s0, size
	move $t1, $s0
	lw $t2, 0($t0)
	
	loop:
		#If the size of an array is 0 exit.
		beq $t1, $zero, end
		addi $t0, $t0, 4	#next element of the array
		lw $t3, ($t0)		#load the current element
		beq $t3, $zero, end  # check if the end of the array is reached
		bge $t2, $t3, greater
		move $t2, $t3
  
		# decrement length of array
		addi $t1, $t1, -1
		j loop
	greater:
		addi $t1, $t1, -1
		bne $t1, $zero, loop
		
		

	end:
	li $v0, 1
	move $a0, $t2
	syscall
		li $v0, 10
		syscall