cmake_minimum_required(VERSION 2.8)

# For GRPC.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

add_definitions(-std=c++11)

project(build_protos C CXX)

find_package(Protobuf 3 REQUIRED)

find_package(GRPC REQUIRED)

file(GLOB_RECURSE proto_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.proto)

set(ABSProtoFiles)
set(ProtoHeaders)
set(ProtoSources)
include_directories(${CMAKE_BINARY_DIR})

foreach(FNAME ${proto_files})
  get_filename_component(PROTO_PATH ${FNAME} DIRECTORY)
  get_filename_component(PROTO_NAME ${FNAME} NAME_WE)
  list(APPEND ABSProtoFiles "${CMAKE_SOURCE_DIR}/${FNAME}")
  list(APPEND ProtoHeaders "${CMAKE_BINARY_DIR}/${PROTO_PATH}/${PROTO_NAME}.pb.h")
  list(APPEND ProtoSources "${CMAKE_BINARY_DIR}/${PROTO_PATH}/${PROTO_NAME}.pb.cc")
endforeach()

add_custom_command(
  COMMAND protoc -I ${CMAKE_CURRENT_SOURCE_DIR} --cpp_out ./ ${ABSProtoFiles}
  OUTPUT ${ProtoSources} ${ProtoHeaders}
  COMMENT "Generating code for ${ProtoName}."
)

add_library(${PROJECT_NAME} ${ProtoHeaders} ${ProtoSources})
