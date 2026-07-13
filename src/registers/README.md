# Register Usage Examples

This directory contains examples demonstrating the x86-64 register calling conventions, specifically the distinction between **callee-saved** (non-volatile) and **caller-saved** (volatile) registers as defined by the System V AMD64 ABI.

## Overview

In x86-64 assembly programming, understanding register conventions is crucial for writing correct and efficient code. The ABI defines which registers must be preserved by the called function (callee-saved) and which can be freely modified (caller-saved).

## Files in This Directory

### 📚 Documentation

- [`../../docs/registers/CALLEE_SAVED_VS_CALLER_SAVED.md`](../../docs/registers/CALLEE_SAVED_VS_CALLER_SAVED.md) - Comprehensive guide explaining the concepts with ABI references

### 💻 Example Programs

1. **`caller_saved_demo.asm`** - Demonstrates caller-saved (volatile) register usage
   - Shows how caller-saved registers can be modified by called functions
   - Demonstrates the caller's responsibility to save/restore if needed
   - Includes examples of proper preservation at call sites

2. **`callee_saved_demo.asm`** - Demonstrates callee-saved (non-volatile) register usage
   - Shows how callee-saved registers must be preserved by called functions
   - Demonstrates proper save/restore in function prologue/epilogue
   - Includes examples with multiple callee-saved registers

3. **`register_convention.asm`** - Complete example of proper register convention
   - Shows a well-structured function following all ABI rules
   - Demonstrates argument passing in registers
   - Shows return value in RAX
   - Includes nested function calls

## Quick Reference

### x86-64 Register Classification (System V ABI)

| Category | Registers | Who Preserves |
|----------|-----------|---------------|
| **Callee-Saved** | RBX, RBP, R12-R15 | Called function (callee) |
| **Caller-Saved** | RAX, RCX, RDX, RSI, RDI, R8-R11 | Calling function (caller) |
| **Special** | RSP, RIP, RFLAGS | Hardware/ABI |

### Argument Passing

| Argument # | Register |
|------------|----------|
| 1st | RDI |
| 2nd | RSI |
| 3rd | RDX |
| 4th | RCX |
| 5th | R8 |
| 6th | R9 |
| 7th+ | Stack |

### Return Values

- Scalar: `RAX`
- 128-bit: `RAX:RDX`
- Larger: Pointer to buffer (hidden first argument)

## Building the Examples

All examples can be built using NASM and linked with GCC:

```bash
# Build a single example
nasm -f elf64 caller_saved_demo.asm -o caller_saved_demo.o
gcc -no-pie caller_saved_demo.o -o caller_saved_demo

# Run the example
./caller_saved_demo
```

Or build all examples:

```bash
# Build all
for file in *.asm; do
    nasm -f elf64 $file -o ${file%.asm}.o
gcc -no-pie ${file%.asm}.o -o ${file%.asm}
done

# Clean up
rm *.o
```

## Key Concepts Demonstrated

### 1. Callee-Saved Registers (Non-Volatile)

These registers **must** be preserved by the called function:

```asm
my_function:
    push rbx         ; Save RBX
    push r12         ; Save R12
    ; ... use RBX, R12 ...
    pop r12          ; Restore R12
    pop rbx          ; Restore RBX
    ret
```

### 2. Caller-Saved Registers (Volatile)

These registers **can** be modified by called functions. Caller must save if needed:

```asm
caller:
    mov rax, important_value
    push rax         ; Save RAX
    call some_function
    pop rax          ; Restore RAX
```

### 3. Function Arguments

```asm
; Call function with 3 arguments
mov rdi, arg1
mov rsi, arg2
mov rdx, arg3
call my_function
```

### 4. Return Values

```asm
my_function:
    ; Compute result
    mov rax, result  ; Return in RAX
    ret
```

## ABI References

- [x86-64 ABI Specification (PDF)](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build)
- [x86-64 ABI GitLab Repository](https://gitlab.com/x86-psABIs/x86-64-ABI)
- [OSDev Wiki - System V ABI](https://wiki.osdev.org/System_V_ABI)

## Learning Path

1. **Start here**: Read the [comprehensive guide](../../docs/registers/CALLEE_SAVED_VS_CALLER_SAVED.md)
2. **Hands-on**: Run `caller_saved_demo.asm` to see volatile register behavior
3. **Hands-on**: Run `callee_saved_demo.asm` to see non-volatile register behavior
4. **Advanced**: Study `register_convention.asm` for complete convention example
5. **Experiment**: Modify the examples and observe the effects

## Common Mistakes to Avoid

❌ **Modifying callee-saved registers without saving**
```asm
; WRONG - RBX will be corrupted for caller
my_func:
    mov rbx, 42
    ret
```

✅ **Always save/restore callee-saved registers**
```asm
; CORRECT - RBX is preserved
my_func:
    push rbx
    mov rbx, 42
    pop rbx
    ret
```

❌ **Assuming caller-saved registers are preserved**
```asm
; WRONG - RAX might be modified by called function
caller:
    mov rax, value
    call some_func
    ; RAX might not be 'value' anymore
```

✅ **Save caller-saved registers at call site if needed**
```asm
; CORRECT - RAX is preserved
caller:
    push rax
    mov rax, value
    call some_func
    pop rax
```

❌ **Stack misalignment**
```asm
; WRONG - Stack might not be 16-byte aligned
caller:
    push rax
    call some_func  ; Requires 16-byte aligned stack
```

✅ **Maintain 16-byte stack alignment**
```asm
; CORRECT - Stack is properly aligned
caller:
    sub rsp, 8       ; Align stack
    push rax
    call some_func
    pop rax
    add rsp, 8
```
