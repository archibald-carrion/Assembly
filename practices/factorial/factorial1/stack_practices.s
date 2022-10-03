.text
.global main

main:
    mov $1011, %rax
    push    %rax
    call    calculus
    
    //pop %rbp
    push    %rcx
    lea message(%rip),  %rdi
    xor %eax,   %eax
    call    printf
    pop     %rcx

    call exit

calculus:
    push %rbp
    add $1011,  %eax
    jmp calcexit

calcexit:
    pop %rbp

exit:
    mov $60,    %eax
    xor %eax,   %eax
    syscall


.data
message:.asciz  "Hello World"    
