cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_COMPILER "D:/mingw64/bin/g++.exe")
set(CMAKE_C_COMPILER "D:/mingw64/bin/gcc.exe")

project(lab01_ex3)

add_executable(lab01_ex3 linked_list.h linked_list.c test_linked_list.c)