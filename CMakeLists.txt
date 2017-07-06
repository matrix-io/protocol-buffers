cmake_minimum_required(VERSION 2.8)

project(matrixio_protos C CXX)

# Load GRPC macro
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

add_definitions(-std=c++11)

find_package(Protobuf 3 REQUIRED)

find_package(GRPC REQUIRED)

# Language to generate
set(GEN_LANG "cpp")
# protoc program
set(PROTOC /usr/local/bin/protoc)
# protoc grpc plugin
set(GRPC_PLUGIN "/usr/local/bin/grpc_${GEN_LANG}_plugin")
# .proto file search directory
set(PROTO_SEARCH_PATH ${CMAKE_CURRENT_SOURCE_DIR})

# protoc flags
set(PROTO_CFLAGS)
list(APPEND PROTOC_FLAGS "--proto_path=${PROTO_SEARCH_PATH}")
list(APPEND PROTOC_FLAGS "--${GEN_LANG}_out=${CMAKE_CURRENT_BINARY_DIR}") 
list(APPEND PROTOC_FLAGS "--grpc_out=${CMAKE_CURRENT_BINARY_DIR}") 
list(APPEND PROTOC_FLAGS "--plugin=protoc-gen-grpc=${GRPC_PLUGIN}")

file(GLOB_RECURSE proto_files ABSOLUTE ${CMAKE_CURRENT_SOURCE_DIR} *.proto)

set(ABSProtoFiles)
set(ProtoHeaders)
set(ProtoSources)

foreach(FNAME ${proto_files})
  get_filename_component(PROTO_PATH ${FNAME} DIRECTORY)
  get_filename_component(PROTO_NAME ${FNAME} NAME_WE)
  list(APPEND ABSProtoFiles ${FNAME})
  string(REPLACE ${PROTO_SEARCH_PATH} ${CMAKE_CURRENT_BINARY_DIR} GEN_OUT ${PROTO_PATH})
  list(APPEND ProtoHeaders "${GEN_OUT}/${PROTO_NAME}.pb.h")
  list(APPEND ProtoSources "${GEN_OUT}/${PROTO_NAME}.pb.cc")
endforeach()

add_custom_command(
  COMMAND ${PROTOC} ${PROTOC_FLAGS} ${ABSProtoFiles}
  OUTPUT ${ProtoSources} ${ProtoHeaders}
  COMMENT "Generating code for ${ProtoName}."
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_library(${PROJECT_NAME} ${ProtoHeaders} ${ProtoSources})
