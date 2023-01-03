.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

	# Error checks
	bge x0, a1, exit_matmul
	bge x0, a2, exit_matmul
	bge x0, a4, exit_matmul
	bge x0, a5, exit_matmul
	bne a2, a4, exit_matmul

	# Prologue
	addi sp, sp, -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)

	li s0, 0
	li t0, 0		# t0 represent the offset from a0
	li t3, 0		# t3 represent the offset from d
	slli t1, a2, 2	# the size of one row

outer_loop_start:
    ebreak
	bge s0, a1, outer_loop_end
	mv s1, x0

inner_loop_start:
	bge s1, a5, inner_loop_end

	addi sp, sp, -44
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw a4, 20(sp)
	sw a5, 24(sp)
	sw a6, 28(sp)
	sw t0, 32(sp)
	sw t1, 36(sp)
	sw t3, 40(sp)

	ebreak
	# prepare to jump to dot
	slli t2, s1, 2	# offset from a3
	add a0, a0, t0	# add offset from a0
	add a1, a3, t2  # add offset from a3
	# mv a2, a2
	li a3, 1		
	mv a4, a5		# the stride of a3

	jal ra dot  	# jump to dot and save position to ra
    
    ebreak
	lw t3, 40(sp)
	lw a6, 28(sp)
	slli t4, t3, 2
	add t4, t4, a6
	sw a0, 0(t4)
	addi t3, t3, 1

	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw a4, 20(sp)
	lw a5, 24(sp)
	lw t0, 32(sp)
	lw t1, 36(sp)
	addi sp, sp, 44
	
	addi s1, s1, 1
	j inner_loop_start

inner_loop_end:
	addi s0, s0, 1
	add t0, t0, t1
	j outer_loop_start

outer_loop_end:
	# Epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp, 20

	ret

exit_matmul:
	li a0, 38
	j exit