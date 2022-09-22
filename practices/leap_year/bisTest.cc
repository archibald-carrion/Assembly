/**
 *   to compile: g++ -g bisTest.cc leap_year.s -o bisTest.out
 *   to run: ./bisTest.out
 */
#include <iostream>
extern "C" int leapyear(int);
/**
 * declaration that the routine is define in "link time"
 * the function name "leapyear" must be the same as the assembly routine and must be global
 */
int main(int arguments, char **values)
{
   int result;
   int n = 2022;
   const char *msg[] = {" no", ""};

   if (arguments > 1)
   {                       // Check for argument
      n = atoi(values[1]); // Convert argument to number
   }

   result = leapyear(n); // Call assembly routine
   if (result)
   {
      msg[0] = 0;
   }

   std::cout << "The year " << n << msg[result] << " is a leap year" << std::endl;

   return 0;
}
