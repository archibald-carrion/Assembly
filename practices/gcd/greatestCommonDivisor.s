.text
.global greatestCommonDivisor

greatestCommonDivisor:
    # div src --> dividend in eax, divisor is src, remain is stored in edx, and result in eax
    mov     %edi,   %eax
    mov     %esi,   %ebx
    mov     $0,     %ecx
    ret

