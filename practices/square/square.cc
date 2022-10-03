#include <iostream>

// g++ -g square.cc square.s

extern "C" int square(int);

int main(){
    int num = square(-5);
    std::cout<<num<<std::endl;
    return 0;
}