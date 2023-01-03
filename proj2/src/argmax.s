.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
	# Prologue
	bge x0, a1, exit_argmax
	addi sp, sp, -20
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)

	li s0, 1
	mv s1, x0
	lw s2, 0(a0)

loop_start:
	bge s0, a1, loop_end
	slli s3, s0, 2
	add s3, s3, a0
	lw s3, 0(s3)
	bge s2, s3, loop_continue
	mv s2, s3
	mv s1, s0

loop_continue:
	addi s0, s0, 1
	j loop_start

loop_end:
	# Epilogue
	mv a0, s1
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	addi sp, sp, 20

	ret

exit_argmax:
	li a0, 36
	j exit