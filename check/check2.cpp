#include <iostream>

int __attribute__((export_name ("main")))
main(int ac, char** av){
  std::cout << "Hello!" << std::endl;
  return 0;
}
