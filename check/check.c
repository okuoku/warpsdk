#include <stdio.h>

int __attribute__((export_name ("main")))
main(int ac, char** av){
    printf("Hello!\n");
    return 0;
}
