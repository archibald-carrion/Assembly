.text
.global main
main:
    movq    %rsp, %rbp #for correct debugging
    mov     $4, %rax
    push    %rax
    call    factorial

    push	   %rcx
    lea	   message(%rip), %rdi
    mov    %rax, %rsi
    xor	   %rax, %rax	# is a variable argument function, so AL needs to be set
    call	   printf
    pop    %rcx

    # exit(0)
    mov     $60, %eax
    xor     %edi, %edi
    syscall

factorial:              # parameter is in the stack
    push    %rbp        # Save base pointer
    mov     %rsp, %rbp  # Move stack pointer SP to base pointer BP
    mov     16(%rbp),%rbx    # Get first parameter
    cmp     $2, %rbx    # Check for base case (2 == n)
    jne     next_fact   # Jump if not equal
    mov     $2, %rax    # Base case
    jmp     fact_exit   # Exit funtion

next_fact:
    dec     %rbx        # n - 1
    push    %rbx
    call    factorial   # Call with n - 1
    mov     16(%rbp), %rbx
    mul     %rbx
fact_exit:
    mov     %rbp, %rsp  # Restore stack pointer
    pop     %rbp        # Restore base pointer
    ret

	.data
message:.asciz  "Fact = %d\n", "\r"
