cmake_minimum_required(VERSION 3.20)
project(check)

enable_language(ASM)

set(crtfiles
    init_thr.S
    warpcrt.c)

add_executable(check check.c ${crtfiles})
add_executable(check2 check2.cpp ${crtfiles})
