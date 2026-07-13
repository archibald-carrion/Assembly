;=============================================================================
; Callee-Saved (Non-Volatile) Registers Demonstration
; 
; This example demonstrates the usage of callee-saved registers in x86-64.
; Callee-saved registers (RBX, RBP, R12-R15) MUST be preserved by the
; called function if they are modified.
; 
; Reference: x86-64 ABI - https://gitlab.com/x86-psABIs/x86-64-ABI
;=============================================================================

section .data
    msg1        db  "Callee-Saved Register Demo", 0xA, 0
    msg2        db  "Loading value into RBX (callee-saved)", 0xA, 0
    msg3        db  "Before function call: RBX = ", 0
    msg4        db  "After function call: RBX = ", 0
    msg5        db  "Value WAS preserved (expected behavior)", 0xA, 0
    msg6        db  "The function properly saved and restored RBX", 0xA, 0
    msg7        db  "Demonstrating multiple callee-saved registers:", 0xA, 0
    msg8        db  "R12 = ", 0
    msg9        db  "R13 = ", 0
    msg10       db  "R14 = ", 0
    msg11       db  "R15 = ", 0
    newline     db  0xA, 0

section .text
    global _start
    extern printf, exit

;-----------------------------------------------------------------------------
; Main entry point
;-----------------------------------------------------------------------------
_start:
    ; Set up stack frame
    push rbp
    mov rbp, rsp

    ; Print introduction
    mov rdi, msg1
    call printf

    ; ========================================================================
    ; DEMONSTRATION 1: Callee-saved register preservation
    ; ========================================================================
    
    ; Load a value into RBX (callee-saved register)
    mov rbx, 0x123456789ABCDEF0
    
    mov rdi, msg2
    call printf
    
    ; Print value before call
    mov rdi, msg3
    call printf
    mov rdi, rbx
    call print_hex
    mov rdi, newline
    call printf
    
    ; Call a function that uses RBX internally
    ; The function MUST preserve RBX's value
    call use_rbx_internally
    
    ; Print value after call - it should be the same!
    mov rdi, msg4
    call printf
    mov rdi, rbx
    call print_hex
    mov rdi, newline
    call printf
    
    ; Explain what happened
    mov rdi, msg5
    call printf
    mov rdi, msg6
    call printf

    ; ========================================================================
    ; DEMONSTRATION 2: Multiple callee-saved registers
    ; ========================================================================
    
    mov rdi, msg7
    call printf
    
    ; Load values into all callee-saved registers
    mov rbx, 0xBBBBBBBBBBBBBBBB
    mov r12, 0xCCCCCCCCCCCCCCCC
    mov r13, 0xDDDDDDDDDDDDDDDD
    mov r14, 0xEEEEEEEEEEEEEEEE
    mov r15, 0xFFFFFFFFFFFFFFFF
    
    ; Call a function that uses all callee-saved registers
    call use_all_callee_saved
    
    ; Print values - they should all be preserved!
    mov rdi, msg8
    call printf
    mov rdi, r12
    call print_hex
    mov rdi, newline
    call printf
    
    mov rdi, msg9
    call printf
    mov rdi, r13
    call print_hex
    mov rdi, newline
    call printf
    
    mov rdi, msg10
    call printf
    mov rdi, r14
    call print_hex
    mov rdi, newline
    call printf
    
    mov rdi, msg11
    call printf
    mov rdi, r15
    call print_hex
    mov rdi, newline
    call printf

    ; Clean up and exit
    mov rsp, rbp
    pop rbp
    
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

;-----------------------------------------------------------------------------
; Function that uses RBX internally but preserves it
; This demonstrates proper callee-saved register handling
;-----------------------------------------------------------------------------
use_rbx_internally:
    ; Save RBX (callee-saved, so we MUST preserve it)
    push rbx
    
    ; Now we can safely use RBX for our own purposes
    mov rbx, 0xDEADBEEFCAFEBABE  ; Use RBX for internal computation
    
    ; Do some work with RBX...
    ; (In a real function, we'd do something useful here)
    
    ; Restore RBX before returning
    pop rbx
    
    ret

;-----------------------------------------------------------------------------
; Function that uses all callee-saved registers
; Demonstrates proper preservation of multiple registers
;-----------------------------------------------------------------------------
use_all_callee_saved:
    ; Save all callee-saved registers
    ; Note: RBP is also callee-saved, but we're using it as frame pointer
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    ; Now we can safely use all these registers
    mov rbx, 0x1111111111111111
    mov r12, 0x2222222222222222
    mov r13, 0x3333333333333333
    mov r14, 0x4444444444444444
    mov r15, 0x5555555555555555
    
    ; Do some work...
    ; For example, compute something using these registers
    add rbx, r12
    add rbx, r13
    add rbx, r14
    add rbx, r15
    
    ; Restore all callee-saved registers in reverse order
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    
    ret

;-----------------------------------------------------------------------------
; Helper function to print 64-bit hex value
; Input: RDI = value to print
;-----------------------------------------------------------------------------
print_hex:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    mov rax, rdi
    mov rcx, 16        ; 16 hex digits
    mov rsi, hex_buffer + 15
    
.print_loop:
    mov rbx, rax
    and rbx, 0xF
    mov dl, [hex_chars + rbx]
    mov [rsi], dl
    dec rsi
    shr rax, 4
    loop .print_loop
    
    ; Print the buffer
    mov rdi, hex_buffer
    call printf
    
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

section .data
    hex_chars    db  "0123456789ABCDEF"
    hex_buffer   db  "0000000000000000", 0

;-----------------------------------------------------------------------------
; IMPORTANT NOTES:
; 
; 1. This example demonstrates the CORRECT way to handle callee-saved registers.
;    The called functions save and restore RBX, R12-R15 before modifying them.
; 
; 2. Contrast this with caller_saved_demo.asm, where the caller is responsible
;    for saving/restoring registers.
; 
; 3. Build commands (same as caller_saved_demo.asm):
;   nasm -f elf64 callee_saved_demo.asm -o callee_saved_demo.o
;   gcc -no-pie callee_saved_demo.o -o callee_saved_demo
;-----------------------------------------------------------------------------
