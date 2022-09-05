/* Testing Code */

#include <limits.h>
int test_bitAnd(int x, int y)
{
  return x&y;
}
int test_bitXor(int x, int y)
{
  return x^y;
}
int test_isEqual(int x, int y)
{
  return x == y;
}
int test_evenBits(void) {
  int result = 0;
  int i;
  for (i = 0; i < 32; i+=2)
    result |= 1<<i;
  return result;
}
int test_fitsBits(int x, int n)
{
  int TMin_n = -(1 << (n-1));
  int TMax_n = (1 << (n-1)) - 1;
  return x >= TMin_n && x <= TMax_n;
}






int test_bitMask(int highbit, int lowbit)
{
  int result = 0;
  int i;
  for (i = lowbit; i <= highbit; i++)
    result |= 1 << i;
  return result;
}
int test_conditional(int x, int y, int z)
{
  return x?y:z;
}
int test_reverseBytes(int x)
{
  union U {
    int result;
    char byte[4];
  };
  union U u;
  int temp;
  u.result = x;
  temp = u.byte[0];
  u.byte[0] = u.byte[3];
  u.byte[3] = temp;
  temp = u.byte[1];
  u.byte[1] = u.byte[2];
  u.byte[2] = temp;
  return u.result;
}
int test_bang(int x)
{
  return !x;
}
int test_bitCount(int x) {
  int result = 0;
  int i;
  for (i = 0; i < 32; i++)
    result += (x >> i) & 0x1;
  return result;
}
int test_isZero(int x) {
  return x == 0;
}
int test_isNegative(int x) {
  return x < 0;
}
int test_multFiveEights(int x)
{
  return 5./8 * x;
}
int test_sum3(int x, int y, int z)
{
  return x+y+z;
}
int test_addOK(int x, int y)
{
  int sum = x+y;
  return !(x < 0 && y < 0 && sum >= 0) && !(x > 0 && y > 0 && sum <= 0);
}
int test_isLess(int x, int y)
{
  return x < y;
}
int test_abs(int x) {
  return (x < 0) ? -x : x;
}
int test_isNonZero(int x)
{
  return x!=0;
}
int test_tc2sm(int x) {
  int sign = x < 0;
  int mag = x < 0 ? -x : x;
  return (sign << 31) | mag;
}
