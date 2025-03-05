cmake_minimum_required(VERSION 3.20)
project(check)

add_executable(check check.c warpcrt.c)
add_executable(check2 check2.cpp warpcrt.c)
