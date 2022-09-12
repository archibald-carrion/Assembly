# @
# CI-0118
# Grupo 2
#
#    Quiz 1
#
# int Fibbonacci( int number ) {
#     if ( number <= 1 ) {	// Base cases
#        return number
#     } else {
#        return Fibonnacci( number - 1 ) + Fibbonacci( number - 2 );
#     }
# }
#

# note: el valor del cual se requiere calcular el fibonaci tiene que ser 
# puesto en el campo del valor en el cmp en fibbonacci
.text
.global main
main:
    mov     $1,     %ebx    # counter
    mov     $0,     %ecx    # numero inicial 1
    mov     $1,     %edx    # numero inicial 2 
    call    fibbonacci

    push    %rcx
    lea     message(%rip),  %rdi
    #mov    %eax,   %esi
    mov     %edx,   %esi
    xor	    %eax,   %eax	# is a variable argument function, so AL needs to be set
    call	printf
    pop	    %rcx

    # exit(0)
    mov     $60,    %eax
    xor     %edi,   %edi
    syscall

fibbonacci:
    inc     %ebx
    mov     %edx,   %eax
    add     %ecx,   %edx    # el resultado queda en edx
    mov     %eax,   %ecx 
    cmp     $10,   %ebx     # caso recursivo esta harcoded como valor de comparacion ($10)
    jne     fibbonacci      # llamado recursivo de la "function" fibbonacci
    ret

	.data
message:.asciz  "Fibb = %d\n", "\r"

