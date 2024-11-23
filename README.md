# X86 Assembly algorithms and scripts collection

This repository contains a collection of algorithms implemented in x86 assembly language. Each implementation serves as both a practical tool and an educational resource for understanding low-level programming concepts.

## Currently Implemented Algorithms

### Linear Feedback Shift Register (LFSR)
A Linear Feedback Shift Register implementation in x86 assembly. LFSR is commonly used in cryptography, digital communications, and random number generation.

#### Features
- 

#### Usage
```bash
# Assemble the LFSR implementation
nasm -f elf32 lfsr.asm -o lfsr.o

# Link the object file
ld -m elf_i386 lfsr.o -o lfsr

# Run the program
./lfsr
```

#### Implementation Details
The LFSR implementation uses the following key components:
- Initial seed value storage
- Feedback polynomial calculation
- Bit shifting operations
- Result output handling

## Project Structure
```
.
├── README.md
├── src/
│   ├── lfsr/
│   │   ├── lfsr.asm
│   │   └── tests/
│   └── common/
│       └── utils.asm
├── docs/
│   └── algorithms/
└── tests/
```

## Requirements
- NASM (Netwide Assembler)
- GNU Linker (ld)
- x86 compatible system
- Linux operating system (for current implementations)

## Building and Testing
Each algorithm can be built individually using the provided build scripts:

```bash
# General build command format
./build.sh <algorithm_name>

# Example for LFSR
./build.sh lfsr
```

## Contributing
Contributions are welcome! To add a new algorithm:

1. Create a new directory under `src/` with your algorithm name
2. Implement your algorithm in x86 assembly
3. Add appropriate documentation in the `docs/algorithms/` directory
4. Create unit tests in the `tests/` directory
5. Update this README with your algorithm's description and usage instructions

Please ensure your code follows these guidelines:
- Well-commented assembly code
- Consistent naming conventions
- Proper error handling
- Test coverage for main functionality

## Planned Algorithms
The following algorithms are planned for future implementation:
- [ ] Fast Fourier Transform (FFT)
- [ ] AES Encryption/Decryption
- [ ] SHA-256 Hashing
- [ ] RSA Key Generation

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
For questions, suggestions, or contributions, please:
1. Open an issue in this repository
2. Submit a pull request
3. Contact the maintainers directly

## Acknowledgments
- Special thanks to contributors and maintainers
- Inspired by classic computer science algorithms
- Built with performance and education in mind