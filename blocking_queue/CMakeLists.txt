cmake_minimum_required(VERSION 3.25)

project(blocking_queue LANGUAGES CXX)

add_executable(test_queue1 test_queue1.cpp)
add_executable(test_queue_threaded test_queue_threaded.cpp)
