# LFSR Assembly Implementation

This repository contains an implementation of a Linear Feedback Shift Register (LFSR) in x86 assembly language. The program generates pseudo-random numbers using the LFSR algorithm.

## Running the Program

There are two methods to run and analyze the program:

### Method 1: Direct Execution
```bash
# Assemble the code
nasm -f elf32 main.asm -o main.o

# Link the object file
ld -m elf_i386 main.o -o main

# Execute the program
./main
```

### Method 2: Debugging and Analysis with GDB
This method allows you to analyze the program execution step by step and monitor register values.

1. Assemble and link the program:
```bash
nasm -f elf32 main.asm -o main.o
ld -m elf_i386 main.o -o main
```

2. Start GDB:
```bash
gdb ./main
```

3. Inside GDB, use these commands:
```bash
# Set a breakpoint at the main loop
break main_loop

# Display registers window
layout regs

# Start the program
run
```

Note: You might see prompts to install additional GDB packages. You can safely decline these by pressing [n]. This won't affect the program's execution.

4. Viewing Results:
- The pseudo-random number will be displayed in the ebx register
- To generate the next number and continue to the next iteration, use:
```bash
continue
```

## Key concepts of the LFSR algorithm
### Basic terminology
