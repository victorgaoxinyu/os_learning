int main()
{
  int x = 1;
  char *y = (char*)&x;
  printf("%c\n", *y+48);
}
/*
if little endian, x in mem

  +----+----+----+----+
  |0x01|0x00|0x00|0x00|
  +----+----+----+----+
  A
  |
  &x

if big endian

  +----+----+----+----+
  |0x00|0x00|0x00|0x01|
  +----+----+----+----+
  A
  |
 &x

*y + 48 is to convert the number to ascii char, 48 is ascii val for 0.

so 1+0 = 1, means little endian, 0+0 = 0, means big endian
*/
