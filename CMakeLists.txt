cmake_minimum_required(VERSION 2.8)

cmake_minimum_required(VERSION 2.8)

# For GRPC.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

add_definitions(-std=c++11)

project(build_protos C CXX)

include_directories(${CMAKE_BINARY_DIR})

set(PROTOBUF_IMPORT_DIRS ${PROJECT_SOURCE_DIR})

add_subdirectory(matrix)


