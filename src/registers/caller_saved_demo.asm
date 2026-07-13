;=============================================================================
; Caller-Saved (Volatile) Registers Demonstration
; 
; This example demonstrates the usage of caller-saved registers in x86-64.
; Caller-saved registers (RAX, RCX, RDX, RSI, RDI, R8-R11) can be freely
; modified by called functions without preservation.
; 
; Reference: x86-64 ABI - https://gitlab.com/x86-psABIs/x86-64-ABI
;=============================================================================

section .data
    msg1        db  "Caller-Saved Register Demo", 0xA, 0
    msg2        db  "Before function call: RAX = ", 0
    msg3        db  "After function call: RAX = ", 0
    msg4        db  "Value was NOT preserved (expected behavior)", 0xA, 0
    msg5        db  "To preserve, caller must save/restore", 0xA, 0
    msg6        db  "Demonstrating proper preservation:", 0xA, 0
    msg7        db  "After preservation: RAX = ", 0
    newline     db  0xA, 0

section .text
    global _start
    extern printf, exit

;-----------------------------------------------------------------------------
; Main entry point
;-----------------------------------------------------------------------------
_start:
    ; Set up stack frame (optional but good practice)
    push rbp
    mov rbp, rsp

    ; Print introduction
    mov rdi, msg1
    call printf

    ; ========================================================================
    ; DEMONSTRATION 1: Caller-saved register without preservation
    ; ========================================================================
    
    ; Load a value into RAX (caller-saved register)
    mov rax, 0x123456789ABCDEF0
    
    ; Print value before call
    mov rdi, msg2
    call printf
    mov rdi, rax
    call print_hex
    mov rdi, newline
    call printf
    
    ; Call a function that modifies RAX
    ; Since RAX is caller-saved, the function is allowed to modify it
    call modify_rax
    
    ; Print value after call - it will be different!
    mov rdi, msg3
    call printf
    mov rdi, rax
    call print_hex
    mov rdi, newline
    call printf
    
    ; Explain what happened
    mov rdi, msg4
    call printf
    mov rdi, msg5
    call printf

    ; ========================================================================
    ; DEMONSTRATION 2: Proper preservation by caller
    ; ========================================================================
    
    mov rdi, msg6
    call printf
    
    ; Load a value into RAX
    mov rax, 0xFEDCBA9876543210
    
    ; Save RAX before calling (caller's responsibility)
    push rax
    
    ; Call function that modifies RAX
    call modify_rax
    
    ; Restore RAX after call
    pop rax
    
    ; Print value - it should be preserved!
    mov rdi, msg7
    call printf
    mov rdi, rax
    call print_hex
    mov rdi, newline
    call printf

    ; ========================================================================
    ; DEMONSTRATION 3: Multiple caller-saved registers
    ; ========================================================================
    
    ; Load values into multiple caller-saved registers
    mov rax, 0xAAAAAAAA
    mov rcx, 0xBBBBBBBB
    mov rdx, 0xCCCCCCCC
    mov rsi, 0xDDDDDDDD
    
    ; Save all registers we want to preserve
    push rax
    push rcx
    push rdx
    push rsi
    
    ; Call function that modifies all caller-saved registers
    call modify_all_caller_saved
    
    ; Restore all registers
    pop rsi
    pop rdx
    pop rcx
    pop rax
    
    ; At this point, RAX, RCX, RDX, RSI should have their original values
    ; (This is verified by the fact that we can use them)

    ; Clean up and exit
    mov rsp, rbp
    pop rbp
    
    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

;-----------------------------------------------------------------------------
; Function that modifies RAX (caller-saved, so this is allowed)
;-----------------------------------------------------------------------------
modify_rax:
    ; Overwrite RAX with a new value
    ; This is perfectly valid since RAX is caller-saved
    mov rax, 0xDEADBEEFCAFEBABE
    ret

;-----------------------------------------------------------------------------
; Function that modifies multiple caller-saved registers
;-----------------------------------------------------------------------------
modify_all_caller_saved:
    ; Modify all caller-saved registers
    ; The caller is responsible for saving/restoring if needed
    mov rax, 0x1111111111111111
    mov rcx, 0x2222222222222222
    mov rdx, 0x3333333333333333
    mov rsi, 0x4444444444444444
    mov rdi, 0x5555555555555555
    mov r8,  0x6666666666666666
    mov r9,  0x7777777777777777
    mov r10, 0x8888888888888888
    mov r11, 0x9999999999999999
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
; Note: To assemble and link this program, you'll need to link with libc
; 
; Build commands:
;   nasm -f elf64 caller_saved_demo.asm -o caller_saved_demo.o
;   gcc -no-pie caller_saved_demo.o -o caller_saved_demo
; 
; Or use ld directly (but you need to provide libc):
;   nasm -f elf64 caller_saved_demo.asm -o caller_saved_demo.o
;   ld -o caller_saved_demo caller_saved_demo.o -lc -I /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2
;-----------------------------------------------------------------------------
