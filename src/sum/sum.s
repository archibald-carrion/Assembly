#  First parameter  -> DI
#  Second parameter -> SI
#  Third parameter  -> DX
#  Fourth parameter -> CX
#  Fifth parameter  -> r8
#  Sixth parameter  -> r9
#  Next parameters on stack
#
#  Output in AX
#
.text
.global sum

sum:
	cmp	    $1,     %rdi		    # Check for base case (1 == n)
	jle	    base			        # Jump if less or equal
	push	%rdi			        # Push parameter
	dec	    %rdi			        # n - 1
	call	sum		                # Call with n - 1
	pop	    %rdi			        # Recover parameter in DI
	add	    %rdi,    %rax
	jmp	    exit	                # exit
    
base:
	mov	    $1,     %rax		    # Base case --> rax = 1

exit:
	ret
