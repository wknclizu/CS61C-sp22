.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
	addi sp, sp, -44
	sw s1, 0(sp)
	sw s2, 4(sp)
	sw s3, 8(sp)
	sw s4, 12(sp)
	sw s5, 16(sp)
	sw s6, 20(sp)
	sw s7, 24(sp)
	sw s8, 28(sp)
	sw s9, 32(sp)
	sw s10, 36(sp)
	sw s11, 40(sp)

	addi t0, x0, 5
	bne a0, t0, exit_Incorrect_Number

	# Read pretrained m0

	# allocate the space for rows
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, x0, 4
	jal ra, malloc
	addi t0, x0, 0
	beq a0, t0, exit_malloc
	addi s1, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	# end

	# allocate the space for columns
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, x0, 4
	jal ra, malloc
	addi t0, x0, 0
	beq a0, t0, exit_malloc
	addi s2, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	# end

	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	lw a0, 4(a1)
	addi a1, s1, 0
	addi a2, s2, 0 # gugugu
	ebreak
	jal ra, read_matrix
	addi s3, a0, 0
	# s1: A pointer to m0's row in memory
	# s2: A pointer to m0's col in memory
	# s3: A pointer to m0 in memory
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	# m0 end

	# Read pretrained m1

	# allocate the space for rows
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, x0, 4
	jal ra, malloc
	addi t0, x0, 0
	beq a0, t0, exit_malloc
	addi s4, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
		# end

	# allocate the space for columns
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, x0, 4
	jal ra, malloc
	addi t0, x0, 0
	beq a0, t0, exit_malloc
	addi s5, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
		# end

	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	# addi a0, a1, 8
	lw a0, 8(a1)
	addi a1, s4, 0
	addi a2, s5, 0
	jal ra, read_matrix
	addi s6, a0, 0
	# s4: A pointer to m1's row in memory
	# s5: A pointer to m1's col in memory
	# s6: A pointer to m1 in memory
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	# m1 end


	# Read input matrix
	# allocate the space for rows
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, x0, 4
	jal ra, malloc
	addi t0, x0, 0
	beq a0, t0, exit_malloc
	addi s7, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
		# end

	# allocate the space for columns
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, x0, 4
	jal ra, malloc
	addi t0, x0, 0
	beq a0, t0, exit_malloc
	addi s8, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
		# end

	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	# addi a0, a1, 12
	lw a0, 12(a1)
	addi a1, s7, 0
	addi a2, s8, 0
	jal ra, read_matrix
	addi s9, a0, 0
	# s7: A pointer to input's row in memory
	# s8: A pointer to input's col in memory
	# s9: A pointer to input in memory
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	# input matrix end

	# store the address of the malloced memory
	addi sp, sp, -24
	sw s1, 0(sp)
	sw s2, 4(sp)
	sw s4, 8(sp)
	sw s5, 12(sp)
	sw s7, 16(sp)
	sw s8, 20(sp)

	lw s1, 0(s1)
	lw s2, 0(s2)
	lw s4, 0(s4)
	lw s5, 0(s5)
	lw s7, 0(s7)
	lw s8, 0(s8)

	# Compute h = matmul(m0, input)
	# allocate the memory
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	mul t0, s1, s8
	slli t0, t0, 4
	addi a0, t0, 0
	jal ra, malloc
	beq a0, x0, exit_malloc
	addi s10, a0, 0
	# s10: A pointer to the address of matmul(m0, input)
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16

	# do matmul
	# spare the space
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	mul a0, s1, s8
	slli a0, a0, 4
	jal ra, malloc
	beq a0, x0, exit_malloc
	addi s10, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	# end

	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, s3, 0
	addi a1, s1, 0
	addi a2, s2, 0
	addi a3, s9, 0
	addi a4, s7, 0
	addi a5, s8, 0
	addi a6, s10, 0
	jal ra, matmul
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	

	# Compute h = relu(h)
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, s10, 0
	# after matmul, the size of the matrix is [m0's row * input's col]
	mul a1, s1, s8
	jal ra, relu
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16


	# Compute o = matmul(m1, h)
	# allocate the space
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	mul a0, s4, s8 # the size after mul is s4 * s8
	slli a0, a0, 2
	jal ra, malloc
	beq a0, x0, exit_malloc
	addi s11, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16

	# do the mul
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, s6, 0
	addi a1, s4, 0
	addi a2, s5, 0
	addi a3, s10, 0
	addi a4, s1, 0
	addi a5, s8, 0
	addi a6, s11, 0
	jal ra, matmul
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16


	# Write output matrix o
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	lw a0, 16(a1)
	addi a1, s11, 0
	addi a2, s4, 0
	addi a3, s8, 0
	jal ra, write_matrix
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	

	# Compute and return argmax(o)
	addi sp, sp, -16
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw ra, 12(sp)

	addi a0, s11, 0
	mul a1, s4, s8
	jal ra, argmax
	# a0 is the index of the largest num
	addi t0, a0, 0
	
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16

	# If enabled, print argmax(o) and newline
	# print int
	bne a2, x0, skip_print
	addi sp, sp, -8
	sw ra, 0(sp)
	sw t0, 4(sp)

	addi a0, t0, 0
	jal ra, print_int

	lw ra, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8

	# print '\n'
	addi sp, sp, -8
	sw ra, 0(sp)
	sw t0, 4(sp)

	li a0, '\n'
	jal ra, print_char

	lw ra, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8

skip_print:
	# load the value of saved address
	lw s1, 0(sp)
	lw s2, 4(sp)
	lw s4, 8(sp)
	lw s5, 12(sp)
	lw s7, 16(sp)
	lw s8, 20(sp)
	addi sp, sp, 24

	addi sp, sp, -8
	sw ra, 0(sp)
	sw t0, 4(sp)

	jal ra, free_memory

	lw ra, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8

	lw s1, 0(sp)
	lw s2, 4(sp)
	lw s3, 8(sp)
	lw s4, 12(sp)
	lw s5, 16(sp)
	lw s6, 20(sp)
	lw s7, 24(sp)
	lw s8, 28(sp)
	lw s9, 32(sp)
	lw s10, 36(sp)
	lw s11, 40(sp)
	addi sp, sp, 44
	addi a0, t0, 0

	ret

free_memory:
	addi sp, sp, -4
	sw ra, 0(sp)

	addi a0, s1, 0
	jal ra, free
	addi a0, s2, 0
	jal ra, free
	addi a0, s3, 0
	jal ra, free
	addi a0, s4, 0
	jal ra, free
	addi a0, s5, 0
	jal ra, free
	addi a0, s6, 0
	jal ra, free
	addi a0, s7, 0
	jal ra, free
	addi a0, s8, 0
	jal ra, free
	addi a0, s9, 0
	jal ra, free
	addi a0, s10, 0
	jal ra, free
	addi a0, s11, 0
	jal ra, free

	lw ra, 0(sp)
	addi sp, sp, 4
	ret

exit_malloc:
	li a0, 26
	j exit

exit_Incorrect_Number:
	li a0, 31
	j exit