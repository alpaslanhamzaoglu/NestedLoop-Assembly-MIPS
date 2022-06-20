.data

array1: .word 1, 1, 2, 2, 3, 3, 4, 4, 5, 5
array2: .word 2, 2, 3, 3, 4, 4, 5, 5, 6, 6

tempArray1: .space 40 #for storing different elements in array1
tempArray2: .space 40 #for storing different elements in array2

message: .asciiz "The sum of the same elements is "

.text

main:
	la $a0, array1 
	la $a1, tempArray1 
      	jal DiffElement  
      	move $s0, $v0 
      	
      	la $a0, array2 
	la $a1, tempArray2 
      	jal DiffElement  
     	move $s1, $v0

     	la $a0, tempArray1
     	move $a1, $s0
     	la $a2, tempArray2
     	move $a3, $s1
     	
     	jal SumofElements
     	
     	move $t0, $v0
     	
     	la $a0, message
     	li $v0, 4
     	syscall	
     	
      	move $a0, $t0
      	li $v0,1
      	syscall
      	      	      	
      	li $v0, 10
      	syscall 
              
                            
DiffElement:
	li $s7, 10 		# size = 10
	li $s2, 0 		# i = 0
	li $s5, 0 		# counter = 0
	la $s4, ($a1)
L1: 				# 1st loop
	beq $s2, $s7, L5	# i != 10(size)
	li $s3, 0 		# j = 0
	
L2: 				# 2nd loop
	slt $t4, $s3, $s2
	beq $t4, $zero, L3	# j < i	
	
	add $t0, $s2, $s2	# 2i
	add $t0, $t0, $t0 	# 4i
	add $t0, $t0, $a0 	# &array[4i]
	lw $s6, 0($t0)		# array[4i]

	add $t2, $s3, $s3	# 2j
	add $t2, $t2, $t2 	# 4j
	add $t2, $t2, $a0	# &array[4j]
	lw $t2, 0($t2)		# array[4j]	
	
	beq $s6, $t2, L3	# array[4i] == array[4j]
	addi $s3, $s3, 1	# j++		
	b L2			
	
L3: 				# 2nd loop ends
	bne $s2, $s3, L4	# i == j (if)
	sw $s6, 0($s4)		# temparray[4counter] = array[4i]
	addi $s4, $s4, 4
	addi $s5, $s5, 1	# counter++
	
L4:				# if ends
	addi $s2, $s2, 1	# i++
	b L1

L5: 				#1st loop ends	
	addi $v0, $s5, 0
	jr $ra


SumofElements:	
	li $s2, 0		# i = 0
	li $v0, 0		# sum = 0
	
H1:				# 1st loop
	beq $s2, $a1, H5	# i != size(i)
	li $s3, 0		# j = 0
	
H2:				# 2nd loop
	beq $s3, $a3, H4	# j != size(j)
	
	add $t0, $s2, $s2	# 2i
	add $t0, $t0, $t0 	# 4i
	add $t0, $t0, $a0 	# &tempArray[4i]
	lw $t0, 0($t0)		# tempArray[4i]

	add $t2, $s3, $s3	# 2j
	add $t2, $t2, $t2 	# 4j
	add $t2, $t2, $a2	# &tempArray[4j]
	lw $t2, 0($t2)		# tempArray[4j]
	
	addi $s3, $s3, 1	# j++
	
	bne $t0, $t2, H2	# tempArray[4i] == tempArray[4j] (if)
	add $v0, $v0, $t0	# sum += tempArray[4i]
	
	b H2
	
H4:				# 2nd loop ends
	addi $s2, $s2, 1	# i++
	b H1		
				
H5:				# 1st loop ends
	jr $ra
