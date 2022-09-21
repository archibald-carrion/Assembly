#
#
#

.text
.global bisiesto

bisiesto:
    # result in eax, remainder in edx
    mov     $100,    %ebx
    mov     %edi,  %eax
    mov     $0,    %edx
    div     %ebx 
    cmp     $0,     %edx
    je      test400

    mov     $4,    %ebx
    mov     %edi,  %eax
    mov     $0,    %edx
    div     %ebx 
    cmp     $0,     %edx
    je      esBisiesto
    jne     noBisiesto

test400:
    mov     $400,    %ebx
    mov     %edi,  %eax
    mov     $0,    %edx
    div     %ebx 
    cmp     $0,     %edx
    je      esBisiesto
    ret

esBisiesto:
    mov     $1,     %eax
    ret

noBisiesto:
    mov     $0,     %eax
    ret

# devuelve un 1 o un 0
# input %rdi
# input %rax
