cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_COMPILER "D:/mingw64/bin/g++.exe")
set(CMAKE_C_COMPILER "D:/mingw64/bin/gcc.exe")

project(hello)

add_executable(hello ex1.c ex1.h test_ex1.c)