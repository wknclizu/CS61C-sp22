.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue
	add t0, a0, x0
	add t1, a1, x0
	add t2, a2, x0
	add t3, a3, x0
	addi sp, sp, -8
	sw t2, 0(sp)
	sw t3, 4(sp)
	addi t2, sp, 0
	addi t3, sp, 4

	#fopen
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw ra, 12(sp)
	sw t3, 16(sp)

	addi a1, x0, 1
	jal ra fopen
	blt a0, x0, exit_fopen

	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw ra, 12(sp)
	lw t3, 16(sp)
	addi sp, sp, 20

	# fwrite rows
	add t0, a0, x0
	add a1, t2, x0
	addi a2, x0, 1
	addi a3, x0, 4
	
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw ra, 12(sp)
	sw t3, 16(sp)

	jal ra fwrite
	addi t0, x0, 1
	bne a0, t0, exit_fwrite

	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw ra, 12(sp)
	lw t3, 16(sp)
	addi sp, sp, 20
	# end of fwrite

	# fwrite columns
	add a0, t0, x0
	add a1, t3, x0
	addi a2, x0, 1
	addi a3, x0, 4
	
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw ra, 12(sp)
	sw t3, 16(sp)

	jal ra fwrite
	addi t0, x0, 1
	bne a0, t0, exit_fwrite

	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw ra, 12(sp)
	lw t3, 16(sp)
	addi sp, sp, 20
	# end of fwrite

	lw t3, 0(t3s)
	lw t2, 0(t2)
	addi sp, sp, 8
	
	addi a0, t0, 0
	addi a1, t1, 0
	mul a2, t3, t2
	addi a3, x0, 4
	add t1, a2, x0
	ebreak

	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw ra, 8(sp)
	jal ra, fwrite
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw ra, 8(sp)
	addi sp, sp, 12
	bne t1, a0, exit_fwrite

	addi sp, sp, -4
	sw ra, 0(sp)
	addi a0, t0, 0
	jal ra, fclose
	bne a0, x0, exit_fclose
	lw ra, 0(sp)
	addi sp, sp, 4

	ret

exit_fopen:
	li a0, 27
	j exit

exit_fclose:
	li a0, 28
	j exit

exit_fwrite:
	li a0, 30
	j exit