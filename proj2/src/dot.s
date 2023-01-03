.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
	# Prologue
	bge x0, a2, exit_dot1
	bge x0, a3, exit_dot2
	bge x0, a4, exit_dot2

	addi sp, sp, -24
	sw ra, 0(sp)
	sw s0, 4(sp)
	sw s1, 8(sp)
	sw s2, 12(sp)
	sw s3, 16(sp)
	sw s4, 20(sp)
	
	li s0, 0
	li s2, 0
	li s3, 0
	li s4, 0


loop_start:
	slli t3, s3, 2
	slli t4, s4, 2
	add t3, t3, a0
	add t4, t4, a1
	lw t3, 0(t3)
	lw t4, 0(t4)
	mul t3, t3, t4
	add s0, s0, t3

	add s3, s3, a3
	add s4, s4, a4
	addi s2, s2, 1
	bge s2, a2, loop_end
	j loop_start

loop_end:
	# Epilogue
	mv a0, s0
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	lw s3, 16(sp)
	lw s4, 20(sp)
	addi sp, sp, 24

	ret
exit_dot1:
	li a0, 36
	j exit
exit_dot2:
	li a0, 37
	j exit