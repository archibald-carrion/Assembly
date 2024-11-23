; Rerefence about main registers in x86 architecture

;| 32bit |16-bit | 8-bit(each) |
;| EAX   | AX    |  AH  |  AL  |
;| EBX   | BX    |  BH  |  BL  |
;| ECX   | CX    |  CH  |  CL  |
;| EDX   | DX    |  DH  |  DL  |
;| ESI   |
;| EDI   |
;| ESP   |
;| EBP   |

section .data 
    COUNT equ 100	        ; amount of random numbers to generate           

section .bss
    numbers resb COUNT        

section .text
global _start

_start:
    mov ebx, 0x10101010         ; Initial seed in bl, must be non-null because algorithme always return 0
    mov ecx, COUNT              ; loop condition
    mov edx, 0b10110101        ; given polynbomial, harcoded

main_loop:
    ; LFSR implementation
    mov eax, ebx
    and eax, 0b1                ; get the least signifcant bit, which in the algorythm is the feedback bit
    
    shr ebx, 1                  ; shift right by 1 bit
    
    ; apply the xor only if the feedback bit is 1, else continue to next iteration
    test eax, eax
    ; if feedback bit is 0
    jz no_xor
    ; else execute xor of current numerito with the polynomial
    xor ebx, edx
    
no_xor: 
    ; as ecx is count reg, loop instruction decrement current value of ecx and loop is non-zero, else continue to exit_program section
    loop main_loop      

exit_program:
    mov eax, 1              
    xor ebx, ebx            
    int 0x80