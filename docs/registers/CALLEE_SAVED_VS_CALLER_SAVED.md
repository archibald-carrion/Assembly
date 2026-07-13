# Callee-Saved vs Caller-Saved (Volatile) Registers in x86-64

This document explains the register calling conventions for the x86-64 ABI (Application Binary Interface), specifically focusing on the distinction between **callee-saved** (non-volatile) and **caller-saved** (volatile) registers.

> **Reference**: [x86-64 ABI Specification](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build) - System V AMD64 ABI

---

## Overview

In the x86-64 ABI, registers are categorized based on who is responsible for preserving their values across function calls:

| Category | Registers | Preservation Responsibility |
|----------|-----------|------------------------------|
| **Callee-Saved** (Non-volatile) | RBX, RBP, R12-R15 | Callee must preserve original values |
| **Caller-Saved** (Volatile) | RAX, RCX, RDX, RSI, RDI, R8-R11 | Caller must save if needed |
| **Special Purpose** | RSP, RIP, RFLAGS | Managed by hardware/ABI |

---

## Register Classification

### 🟢 Callee-Saved Registers (Non-Volatile)

These registers **MUST** be preserved by the called function (callee). If a function modifies any of these registers, it must save their original values on the stack and restore them before returning.

**x86-64 Callee-Saved Registers:**
- `RBX` - Base register
- `RBP` - Base pointer (frame pointer)
- `R12` - General purpose
- `R13` - General purpose
- `R14` - General purpose
- `R15` - General purpose

**Purpose:** Used for values that must persist across function calls, such as local variables in the caller that need to survive a function call.

**Example Use Case:**
```c
void caller() {
    long long important_value = 42;  // Stored in R12 by compiler
    callee();  // R12 will have same value after this call
    // important_value is still 42
}
```

### 🔴 Caller-Saved Registers (Volatile)

These registers **MAY** be modified by the called function without preservation. If the caller needs to preserve values in these registers across a function call, the caller must save them before the call and restore them afterward.

**x86-64 Caller-Saved Registers:**
- `RAX` - Return value (also used for computations)
- `RCX` - First argument, also used as counter in loops
- `RDX` - Second argument, also used in multiplication/division
- `RSI` - Third argument, source index for string operations
- `RDI` - Fourth argument, destination index for string operations
- `R8` - Fifth argument
- `R9` - Sixth argument
- `R10` - Temporary, used for static chain in some ABIs
- `R11` - Temporary

**Purpose:** Used for temporary values, function arguments, and return values. Optimized for performance as they don't require save/restore overhead.

**Example Use Case:**
```c
void caller() {
    long long temp = compute_something();  // Result in RAX
    // If we need temp after next call, we must save it
    long long saved = temp;
    another_function();
    // temp might be corrupted, but saved is safe
}
```

---

## Function Calling Convention

### Argument Passing (System V ABI)

Integer and pointer arguments are passed in registers in this order:

| Argument # | Register (64-bit) | Register (32-bit) | Register (16-bit) | Register (8-bit) |
|------------|-------------------|-------------------|-------------------|------------------|
| 1st | RDI | EDI | DI | DIL |
| 2nd | RSI | ESI | SI | SIL |
| 3rd | RDX | EDX | DX | DL |
| 4th | RCX | ECX | CX | CL |
| 5th | R8 | R8D | R8W | R8B |
| 6th | R9 | R9D | R9W | R9B |

**Additional arguments** are passed on the stack.

### Return Values

- **Scalar values** (integers, pointers): `RAX`
- **128-bit values**: `RAX:RDX`
- **Larger structures**: Returned via pointer (first argument is hidden pointer to return buffer)

### Stack Alignment

- The stack **MUST** be 16-byte aligned before a `CALL` instruction
- This is the caller's responsibility
- `RSP` must be a multiple of 16 when calling a function

---

## Why This Distinction Matters

### Performance Optimization

The callee-saved/caller-saved distinction enables efficient code generation:

1. **Callee-saved registers** are ideal for:
   - Local variables that need to persist across function calls
   - Values that are expensive to recompute
   - Loop invariants

2. **Caller-saved registers** are ideal for:
   - Temporary computations
   - Function arguments and return values
   - Values that don't need to survive function calls

### Code Size vs Speed Trade-off

- Using callee-saved registers reduces code size (no need for caller to save/restore)
- But increases function prologue/epilogue overhead
- Using caller-saved registers increases code size (caller must save/restore)
- But reduces function call overhead

---

## Direct Quotes from x86-64 ABI Specification

From [Section 3.2.1 - Register Usage](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build):

> **Preserved Registers**: The registers RBX, RBP, and R12-R15 "belong" to the calling function and the called function is required to preserve their values. In other words, a called function must preserve these registers' values for its caller.

> **Scratch Registers**: The registers RAX, RCX, RDX, RSI, RDI, R8, R9, R10, and R11 are considered scratch and shall be saved by the caller if it desires to preserve their values across procedure invocations.

From [Section 3.2.3 - Parameter Passing](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build):

> The first six integer or pointer class arguments are passed in registers RDI, RSI, RDX, RCX, R8, and R9.

> When a function is called, space for four 8-byte parameters must be allocated on the stack by the caller. This space is used for the first four parameters if they are passed in memory instead of registers.

---

## Practical Implications

### For Assembly Programmers

When writing assembly functions:

1. **If you modify callee-saved registers**, you MUST:
   ```asm
   push rbx        ; Save RBX
   push rbp        ; Save RBP
   push r12        ; Save R12
   ; ... your code ...
   pop r12         ; Restore R12
   pop rbp         ; Restore RBP
   pop rbx         ; Restore RBX
   ```

2. **You can freely modify caller-saved registers** without saving them

3. **When calling other functions**, assume all caller-saved registers will be corrupted

### For C Programmers

Understanding these conventions helps with:
- Writing inline assembly
- Debugging optimized code
- Understanding compiler output
- Writing efficient code that cooperates with the ABI

---

## Common Pitfalls

### ❌ Pitfall 1: Modifying Callee-Saved Without Saving

```asm
; BAD: Modifies RBX without preserving it
my_function:
    mov rbx, 42      ; Overwrites caller's RBX!
    ; ... do work ...
    ret              ; RBX is corrupted for caller
```

**Fix:**
```asm
my_function:
    push rbx         ; Save RBX
    mov rbx, 42      ; Now safe to modify
    ; ... do work ...
    pop rbx          ; Restore RBX
    ret
```

### ❌ Pitfall 2: Assuming Caller-Saved Registers Are Preserved

```asm
caller:
    mov rax, 100     ; Important value in RAX
    call some_func    ; RAX might be modified!
    ; RAX might not be 100 anymore
```

**Fix:**
```asm
caller:
    push rax         ; Save RAX
    mov rax, 100
    call some_func
    pop rax          ; Restore RAX
```

### ❌ Pitfall 3: Stack Misalignment

```asm
caller:
    push rax         ; Stack is now 8-byte aligned (not 16!)
    call some_func   ; VIOLATION: Stack must be 16-byte aligned
```

**Fix:**
```asm
caller:
    sub rsp, 8       ; Align stack to 16 bytes
    push rax
    call some_func
    pop rax
    add rsp, 8
```

---

## Best Practices

1. **Use callee-saved registers for long-lived values** that need to persist across function calls
2. **Use caller-saved registers for temporary computations** and function arguments
3. **Always preserve callee-saved registers** if you modify them
4. **Save caller-saved registers at call sites** if their values are needed after the call
5. **Maintain 16-byte stack alignment** before all function calls
6. **Document your function's register usage** in comments
7. **Use the frame pointer (RBP)** for debugging, but consider omitting it in production for performance

---

## See Also

- [x86-64 ABI Official Specification](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build)
- [x86-64 ABI GitLab Repository](https://gitlab.com/x86-psABIs/x86-64-ABI)
- [System V ABI Documentation](https://www.uclibc.org/docs/psABI-x86_64.pdf)
- [OSDev Wiki - x86-64 Calling Convention](https://wiki.osdev.org/System_V_ABI)

---

## Examples in This Repository

See the [`../../src/registers/`](../../src/registers/) directory for practical examples demonstrating these concepts:

- [`caller_saved_demo.asm`](../../src/registers/caller_saved_demo.asm) - Demonstrates caller-saved register usage
- [`callee_saved_demo.asm`](../../src/registers/callee_saved_demo.asm) - Demonstrates callee-saved register usage
- [`register_convention.asm`](../../src/registers/register_convention.asm) - Complete example showing proper register handling
