.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
	# Prologue
	add t0, a0, x0
	add t1, a1, x0
	add t2, a2, x0

	#fopen
	addi sp, sp, -16
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw ra, 12(sp)

	addi a1, x0, 0
	jal ra fopen
	blt a0, x0, exit_fopen

	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16

	# fread rows
	add t0, a0, x0
	add a1, t1, x0
	addi a2, x0, 4
	
	addi sp, sp, -16
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw ra, 12(sp)

	jal ra fread
	addi t0, x0, 4
    ebreak
	bne a0, t0, exit_fread

	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	lw t1, 0(t1)
	# end of fread
	# t1 stores the value of rows

	# fread columns
	add a0, t0, x0
	add a1, t2, x0
	addi a2, x0, 4
	addi sp, sp, -16
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw ra, 12(sp)

	jal ra fread
	addi t0, x0, 4
	bne a0, t0, exit_fread

	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	lw t2, 0(t2)
	# end of fead
	# t2 stores the value of columns
    ebreak

	mul t3, t1, t2
	slli t3, t3, 2
	addi sp, sp, -16
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	sw s3, 12(sp)
	add s0, t0, x0 # s0: the file descriptor 
	add s1, t1, x0 # s1: the value of rows
	add s2, t2, x0 # s2: the value of cols

	addi sp, sp, -4
	sw ra, 0(sp)
	add a0, t3, x0
	jal ra, malloc
	beq a0, x0, exit_malloc
	add s3, a0, x0 # s3: the beginning address of the array
	lw ra, 0(sp)
	addi sp, sp, 4

	addi t1, x0, 0
	addi t3, x0, 0

loop_1:
	bge t1, s1, loop_1_end
	addi t2, x0, 0

loop_2:
	beq t2, s2, loop_2_end

	addi sp, sp, -16
	sw t1, 0(sp)
	sw t2, 4(sp)
	sw t3, 8(sp)
	sw ra, 12(sp)

	add a0, s0, x0
	add a1, s3, t3
	addi a2, x0, 4
	jal ra, fread
	addi t0, x0, 4
	bne a0, t0, exit_fread

	lw t1, 0(sp)
	lw t2, 4(sp)
	lw t3, 8(sp)
	lw ra, 12(sp)
	addi sp, sp, 16
	addi t3, t3, 4

	addi t2, t2, 1
	j loop_2

loop_2_end:

	addi t1, t1, 1
	j loop_1
	
loop_1_end:

	# Epilogue
	addi sp, sp, -4
	sw ra, 0(sp)
	addi a0, s0, 0
	jal ra, fclose
	bne a0, x0, exit_fclose
	lw ra, 0(sp)
	addi sp, sp, 4

	addi a0, s3, 0

	lw s0, 0(sp)
	lw s1, 4(sp)
	lw s2, 8(sp)
	lw s3, 12(sp)
	addi sp, sp, 16

	ret

exit_malloc:
	li a0, 26
	j exit

exit_fopen:
	li a0, 27
	j exit

exit_fclose:
	li a0, 28
	j exit

exit_fread:
	li a0, 29
	j exit