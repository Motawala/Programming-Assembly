#@Karan Patel
#Programming Assignment 1

#Variables
#$t0 = my_array
#$s0 = size
#$t2 = max Number

.data
my_array: .word	1, 2, 3, 4, 8, 9
size:	.word	5
#msg:	.asciiz	"Maximum Number: "

.text
.globl main
main:
	la $t0, my_array	#loads the array into $t0
	la $s0, size		#loads to the size of the array in $s0
	#la $t4, msg
	move $t1, $s0
	lw $t2, 0($t0)		#loads the 1st element of an array
	
getMax:
	#If the size of an array is 0 exit.
	beq $t1, $zero, end
	addi $t0, $t0, 4	#next element of the array
	lw $t3, ($t0)		#load the current element
	beq $t3, $zero, end  # check if the end of the array is reached
	bge $t2, $t3, greater
	move $t2, $t3		#Updates the max
 
	# decrement length of array
	addi $t1, $t1, -1
	j getMax
greater:
	addi $t1, $t1, -1
	bne $t1, $zero, getMax
		
#Exits the Program
end:	
li $v0, 1
move $a0, $t2
syscall			#Prints the Maximum Number
li $v0, 10
syscall