cmake_minimum_required(VERSION 3.7)

# For GRPC.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

add_definitions(-std=c++11)

project(build_protos C CXX)

find_package(Protobuf 3 REQUIRED)

find_package(GRPC REQUIRED)

set(PROTOBUF_GENERATE_CPP_APPEND_PATH OFF)

file(GLOB_RECURSE proto_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.proto)

message(STATUS "Compiling proto messages: " ${proto_files})

protobuf_generate_cpp(ProtoSources ProtoHeaders ${proto_files})

#######################################################################
#include_directories(
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/vision/v1
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/recognition/v1
#)

#file(GLOB ProtoHeaders "*.h")
#file(GLOB ProtoSources "*.cc")

##ADD_LIBRARY(protoBinding ${HDRS} ${SRCS})
##add_subdirectory(${CMAKE_CURRENT_BINARY_DIR})

##set(PROTOBUF_IMPORT_DIRS 
##  ${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1
##  ${CMAKE_CURRENT_BINARY_DIR}/matrix_io/vision/v1
##  ${CMAKE_CURRENT_BINARY_DIR}/matrix_io/recognition/v1
##    CACHE INTERNAL "Path to generated protobuf files.")



#set(ProtoHeaders
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/comm.pb.h
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/driver.pb.h  
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/io.pb.h
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/sense.pb.h
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/zwave_commands.pb.h
#)
#set(ProtoSources
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/comm.pb.cc
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/driver.pb.cc  
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/io.pb.cc
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/sense.pb.cc
  #${CMAKE_CURRENT_BINARY_DIR}/matrix_io/malos/v1/zwave_commands.pb.cc
#)

message(STATUS "ProtoHeaders --->  " ${ProtoHeaders})
message(STATUS "ProtoSources --->  " ${ProtoSources})
message(STATUS "PROTOBUF_IMPORT_DIRS --->  " ${PROTOBUF_IMPORT_DIRS})

add_executable(myexe ${TestRunner})
add_custom_command(
    OUTPUT ${TestRunner}
    COMMAND deps/cxxtest-4.4/bin/cxxtestgen --error-printer -o "${TestRunner}" src/My_test_suite.h
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)

add_library(${PROJECT_NAME} ${ProtoSources} ${ProtoHeaders})

target_link_libraries(${PROJECT_NAME} PUBLIC ${PROTOBUF_LIBRARIES})

