#include <iostream>

/**
 * to compile -->  gcc -g sum.cc sum.s -o code.out
 * to execute -->  ./code.out
 */

extern "C" int sum(int);

/**
 * @brief main function of sum.cc file
 */
int main() {
    int result;
    int limit = 10;
    result = sum(limit);
    std::cout<<result<<std::endl;
    return 0;
}