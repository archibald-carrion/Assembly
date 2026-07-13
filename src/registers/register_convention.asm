;=============================================================================
; Complete Register Convention Example
; 
; This example demonstrates a complete, well-structured x86-64 assembly function
; that properly follows the System V AMD64 ABI calling convention.
; 
; It shows:
; - Proper use of callee-saved registers (with save/restore)
; - Proper use of caller-saved registers (without preservation)
; - Function argument passing in registers
; - Return value in RAX
; - Stack alignment
; - Frame pointer usage
; 
; Reference: x86-64 ABI - https://gitlab.com/x86-psABIs/x86-64-ABI
;=============================================================================

section .data
    ; Test data
    test_value1   dq  10
    test_value2   dq  20
    test_value3   dq  30
    
    ; Messages
    msg_result    db  "Result: %lld", 0xA, 0
    msg_demo      db  "Register Convention Demo", 0xA, 0
    msg_arg1      db  "Argument 1 (RDI): %lld", 0xA, 0
    msg_arg2      db  "Argument 2 (RSI): %lld", 0xA, 0
    msg_arg3      db  "Argument 3 (RDX): %lld", 0xA, 0
    msg_callee    db  "Callee-saved registers preserved: RBX=%llx, R12=%llx", 0xA, 0

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
    
    ; Align stack to 16 bytes (required before calling functions)
    ; Since we pushed RBP (8 bytes), stack is already 16-byte aligned
    ; if it was 16-byte aligned before the call
    
    ; Print introduction
    mov rdi, msg_demo
    call printf

    ; ========================================================================
    ; DEMONSTRATION: Call a function with proper register usage
    ; ========================================================================
    
    ; Load arguments for our test function
    ; System V ABI: first 3 integer args in RDI, RSI, RDX
    mov rdi, [test_value1]   ; First argument
    mov rsi, [test_value2]   ; Second argument
    mov rdx, [test_value3]   ; Third argument
    
    ; Load values into callee-saved registers
    ; These should be preserved across the function call
    mov rbx, 0x1122334455667788
    mov r12, 0xAABBCCDDEEFF0011
    
    ; Call our example function
    ; The function will:
    ; - Use callee-saved registers (saving/restoring them)
    ; - Use caller-saved registers (freely modifying them)
    ; - Return result in RAX
    call example_function
    
    ; Print the result
    mov rdi, msg_result
    mov rsi, rax
    xor rax, rax        ; 0 floating point args for printf
    call printf
    
    ; Verify callee-saved registers are preserved
    mov rdi, msg_callee
    mov rsi, rbx
    mov rdx, r12
    xor rax, rax
    call printf

    ; Clean up and exit
    mov rsp, rbp
    pop rbp
    
    mov rax, 60
    xor rdi, rdi
    syscall

;-----------------------------------------------------------------------------
; example_function - Demonstrates proper register convention
; 
; Input:
;   RDI - First argument (a)
;   RSI - Second argument (b)
;   RDX - Third argument (c)
; 
; Output:
;   RAX - Result (a + b + c)
; 
; Registers used:
;   Callee-saved (preserved): RBX, R12, R13
;   Caller-saved (modified): RAX, RCX, R8-R11
;-----------------------------------------------------------------------------
example_function:
    ; Function prologue
    push rbp
    mov rbp, rsp
    
    ; Save callee-saved registers we'll use
    ; According to ABI, we MUST preserve: RBX, RBP, R12-R15
    ; RBP is already saved as frame pointer
    push rbx
    push r12
    push r13
    
    ; ========================================================================
    ; Now we can use all registers safely
    ; ========================================================================
    
    ; Use callee-saved registers for local variables
    ; These will be preserved across any function calls we make
    mov rbx, rdi        ; Save first arg in RBX (callee-saved)
    mov r12, rsi        ; Save second arg in R12 (callee-saved)
    mov r13, rdx        ; Save third arg in R13 (callee-saved)
    
    ; Use caller-saved registers for computations
    ; These can be freely modified
    mov rax, rbx        ; Start with first arg
    add rax, r12        ; Add second arg
    add rax, r13        ; Add third arg
    
    ; We could call another function here
    ; Since we're following the convention, callee-saved registers are safe
    ; and we can use caller-saved registers freely
    
    ; For demonstration, let's use some caller-saved registers
    mov rcx, 0xDEADBEEF  ; Modify RCX (caller-saved, no need to preserve)
    mov r8,  0xCAFEBABE  ; Modify R8 (caller-saved, no need to preserve)
    mov r9,  0x12345678  ; Modify R9 (caller-saved, no need to preserve)
    
    ; The result is already in RAX
    ; We don't need to do anything else with it
    
    ; ========================================================================
    ; Function epilogue - restore callee-saved registers
    ; ========================================================================
    
    ; Restore callee-saved registers in reverse order
    pop r13
    pop r12
    pop rbx
    
    ; Restore frame pointer
    mov rsp, rbp
    pop rbp
    
    ; Return - RAX contains the result
    ret

;-----------------------------------------------------------------------------
; additional_example - Shows nested function calls
; 
; This function calls another function, demonstrating that callee-saved
; registers are preserved even through nested calls.
;-----------------------------------------------------------------------------
additional_example:
    push rbp
    mov rbp, rsp
    
    ; Save callee-saved registers
    push rbx
    push r12
    
    ; Set up some values
    mov rbx, 0x100
    mov r12, 0x200
    
    ; Call another function
    ; Even though helper_function might use RBX and R12,
    ; it must preserve them, so they'll be the same after the call
    mov rdi, rbx
    mov rsi, r12
    call helper_function
    
    ; RBX and R12 should still have their original values
    ; RAX contains the result from helper_function
    
    ; Clean up
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

;-----------------------------------------------------------------------------
; helper_function - Simple helper that adds two numbers
;-----------------------------------------------------------------------------
helper_function:
    push rbp
    mov rbp, rsp
    
    ; We don't use any callee-saved registers here,
    ; but if we did, we'd save/restore them
    
    ; Just add the two arguments
    add rdi, rsi
    mov rax, rdi
    
    mov rsp, rbp
    pop rbp
    ret

;-----------------------------------------------------------------------------
; Build commands:
;   nasm -f elf64 register_convention.asm -o register_convention.o
;   gcc -no-pie register_convention.o -o register_convention
; 
; This example demonstrates:
; 1. Proper function prologue/epilogue
; 2. Callee-saved register preservation
; 3. Caller-saved register usage
; 4. Argument passing in registers
; 5. Return value in RAX
; 6. Stack alignment
;-----------------------------------------------------------------------------
