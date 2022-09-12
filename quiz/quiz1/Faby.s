.text
.global main
main:

    mov     $10, %eax
    call    fibbonacci

    push        %rcx
    lea        message(%rip), %rdi
    mov       %eax, %esi
    xor        %eax, %eax    # is a variable argument function, so AL needs to be set
    call        printf
    pop        %rcx

    # exit(0)
    mov     $60, %eax
    xor     %edi, %edi
    syscall

fibbonacci:            # parameter is in AX register
    call CasoMayor
    ret

CasoMayor: 
    cmp $1, %EAX
    mov %eax, %ecx
    dec %eax
    sub $2, %ecx
    add %eax, %ecx
    JA CasoMayor
    ret 

    .data
message:.asciz  "Fibb = %d\n", "\r"
