#include <stdio.h>

main(int argc, char ** argv) {
  void* addr = 0xfff0e00000;
  unsigned int HW_VERSION = ((unsigned int*) addr)[0];
  printf("HW_VERSION %d\n", HW_VERSION);
  return 0;
}