cmake_minimum_required(VERSION 3.20)
project(check)

add_library(check check.c)
add_executable(check_exec check.c)
