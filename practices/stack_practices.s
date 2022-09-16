.text
.global main

main:

    push    %rcx
    lea message(%rip),  %rdi
    xor %eax,   %eax
    call    printf
    pop     %rcx

    call exit

exit:
    mov $60,    %eax
    xor %eax,   %eax
    syscall


.data
message:.asciz  "Hello World"    
