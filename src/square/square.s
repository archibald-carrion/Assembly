
.text
.global square


square:
    mov     %rdi,   %rax
    mul     %rdi
    ret
