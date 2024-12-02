#include <iostream>

// forward declaration of the square function
extern "C" int square(int);

int main() {
    int input_number;

    std::cout << "Enter an integer: ";
    if (std::cin >> input_number) {
        int output_number = square(input_number);
        std::cout << output_number << std::endl;
    } else {
        std::cerr << "Invalid input. Please enter an integer." << std::endl;
    }

    return 0;
}