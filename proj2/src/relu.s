.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue
	bge x0, a1, exit_relu
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)

	mv s0, x0
	mv s1, a0

loop_start:
	bge s0, a1, loop_end
	slli s2, s0, 2
	add s2, s2, s1
	lw a0, 0(s2)
	bge a0, x0, loop_continue
	sw x0, 0(s2)

loop_continue:
	addi s0, s0, 1
	j loop_start

loop_end:
	# Epilogue
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16

	ret

exit_relu:
	li a0, 36
	j exit