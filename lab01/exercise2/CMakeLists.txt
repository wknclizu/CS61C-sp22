cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_COMPILER "D:/mingw64/bin/g++.exe")
set(CMAKE_C_COMPILER "D:/mingw64/bin/gcc.exe")

project(test)

add_executable(test pwd_checker.c pwd_checker.h test_pwd_checker.c)