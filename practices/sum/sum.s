#  C++ interface with assembly
#
#  First parameter  -> DI
#  Second parameter -> SI
#  Third parameter  -> DX
#  Fourth parameter -> CX
#  Fifth parameter  -> r8
#  Sixth parameter  -> r9
#  Next parameters on stack
#
#  Return value in AX
#
#  Use with test.cc
#
# Compile: gcc -g sumTest.cc sumar.s -o sumTest.out
# Run: ./sumTest.out
#
.text
.global sumar

sumar:				# parameter is in DI register
	cmp	$1, %rdi		# Check for base case (1 == n)
	jle	base			# Jump if less or equal
	push	%rdi			# Push parameter
	dec	%rdi			# n - 1
	call	sumar		# Call with n - 1
	pop	%rdi			# Recover parameter in DI
	add	%rdi, %rax	# Add terms AX += DI
	jmp	sumar_exit	# Exit function
    
base:
	mov	$1, %rax		# Base case, set AX = 1

sumar_exit:
	ret