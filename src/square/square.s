
.text
.global square


square:
    mov     %rdi,   %rax
    mul     %rdi       # rax = rax * rdi
    ret


// specify to linker that stack is non-executable for security reasons
.section .note.GNU-stack,"",@progbits
