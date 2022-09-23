// g++ -g bisTest.cc leap_year.s -o bisTest.out

#include <stdio.h>
extern "C" int greatestCommonDivisor(int, int);


int main() {
    int result;
    int num1 = 10;
    int num2 = 12;
    result = greatestCommonDivisor(num1, num2);
    printf("The greatest common divisor of %d and %d is %d", num1, num2, result);
    return 0;
}