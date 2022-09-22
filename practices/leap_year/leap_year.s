.text
.global leapyear

leapyear:
    # result in eax, remainder in edx
    mov     $100,    %ebx
    mov     %edi,  %eax
    mov     $0,    %edx
    div     %ebx                    # first check
    cmp     $0,     %edx        
    je      test400

    mov     $4,    %ebx
    mov     %edi,  %eax
    mov     $0,    %edx
    div     %ebx                    # second check
    cmp     $0,     %edx
    je      isLeapyear
    jne     notLeapyear

test400:
    mov     $400,    %ebx
    mov     %edi,  %eax
    mov     $0,    %edx
    div     %ebx                    # third check
    cmp     $0,     %edx
    je      isLeapyear
    ret

isLeapyear:
    mov     $1,     %eax
    ret

notLeapyear:
    mov     $0,     %eax
    ret

# must return either 0 or 1
# input %rdi
# output %rax
