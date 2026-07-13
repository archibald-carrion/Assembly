# X86 Assembly algorithms and scripts collection

This repository contains a collection of algorithms implemented in x86 assembly language. Each implementation serves as both a practical tool and an educational resource for understanding low-level programming concepts.

## Currently Implemented Algorithms

### Linear Feedback Shift Register (LFSR)
A Linear Feedback Shift Register implementation in x86 assembly. LFSR is commonly used in cryptography, digital communications, and random number generation.

### Integer Square Function
A simple integer squaring function implemented in x86 assembly. This function squares an integer input and returns the result.

### TODO: Add already implemented algorithms here

## Educational Resources

### 📚 Register Calling Conventions
New! Comprehensive guide and examples on **callee-saved vs caller-saved registers** in x86-64:
- **Documentation**: [`docs/registers/CALLEE_SAVED_VS_CALLER_SAVED.md`](docs/registers/CALLEE_SAVED_VS_CALLER_SAVED.md) - Complete explanation with ABI references
- **Examples**: See [`src/registers/`](src/registers/) for practical demonstrations
  - `caller_saved_demo.asm` - Caller-saved (volatile) register usage
  - `callee_saved_demo.asm` - Callee-saved (non-volatile) register usage
  - `register_convention.asm` - Complete ABI-compliant function example

> **Reference**: Based on the official [x86-64 ABI Specification](https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build) from the x86-psABIs project.

## Project Structure
```
.
├── README.md
├── src/
│   ├── lfsr/
│   ├── square/
│   ├── registers/          # NEW: Register convention examples
│   │   ├── README.md
│   │   ├── caller_saved_demo.asm
│   │   ├── callee_saved_demo.asm
│   │   └── register_convention.asm
│   └── ...
├── docs/
│   └── registers/          # NEW: Register convention documentation
│       └── CALLEE_SAVED_VS_CALLER_SAVED.md
├── resources/
└── rapsberrypi_mini_distro/
```

## Requirements, build, and execution
Each algorithm implementation contains its own set of requirements, build instructions, and execution steps. Please refer to the respective README files in each algorithm's directory for detailed information.

## Planned Algorithms
The following algorithms are planned for future implementation:
- [ ] Fast Fourier Transform (FFT)
- [ ] AES Encryption/Decryption
- [ ] SHA-256 Hashing
- [ ] RSA Key Generation
