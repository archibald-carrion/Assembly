#!/bin/bash

# Build script for register convention examples
# This script builds all the assembly examples in this directory

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building x86-64 Register Convention Examples${NC}"
echo "================================================"

# Function to build a single example
build_example() {
    local name=$1
    local asm_file="${name}.asm"
    local obj_file="${name}.o"
    local exe_file="${name}"
    
    echo -e "\n${YELLOW}Building ${asm_file}...${NC}"
    
    # Assemble with NASM
    nasm -f elf64 "${asm_file}" -o "${obj_file}"
    
    # Link with GCC
    gcc -no-pie "${obj_file}" -o "${exe_file}"
    
    # Clean up object file
    rm "${obj_file}"
    
    echo -e "${GREEN}✓ Built ${exe_file}${NC}"
}

# Build all examples
examples=(
    "caller_saved_demo"
    "callee_saved_demo"
    "register_convention"
)

for example in "${examples[@]}"; do
    build_example "$example"
done

echo -e "\n${YELLOW}All examples built successfully!${NC}"
echo ""
echo "To run an example:"
echo "  ./caller_saved_demo"
echo "  ./callee_saved_demo"
echo "  ./register_convention"
echo ""
echo "To clean up:"
echo "  rm -f caller_saved_demo callee_saved_demo register_convention"
