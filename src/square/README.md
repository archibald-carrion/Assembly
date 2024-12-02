# Integer Square Function in x86 Assembly :computer:

This repository contains an implementation of a simple integer squaring function using x86 assembly and C++.

## Project Structure
- `square.cc`: C++ main program 
- `square.s`: x86-64 assembly implementation of the square function


## Key Components

#### Assembly Implementation (`square.s`)
- Squares the input integer value received in `%rdi` register
- Returns the squared value in `%rax` register

#### C++ Driver (`square.cc`)
- Calls the assembly square function
- Prints the result using standard stream



## Compiling and running the Program :wrench:

```bash
# Compile
g++ -g square.cc square.s -o square_program

# Execute
./square_program
```
## TODO :clipboard:
- [ ] Check for overflow in the assembly implementation (result of squaring less than given integer)