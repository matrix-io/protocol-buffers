cmake_minimum_required(VERSION 2.8)

project(matrixio_protos C CXX)

# Load GRPC macro
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

add_definitions(-std=c++11)

# Required packages to build
#find_package(Protobuf 3 REQUIRED)
find_package(GRPC REQUIRED)

# protoc program
find_program(PROTOC NAMES protoc)
if (NOT EXISTS ${PROTOC})
  message(FATAL_ERROR "The protoc program was not found")
endif()
message(STATUS "Found protoc program: " ${PROTOC})

# Language to generate
if (NOT DEFINED GEN_LANG)
  set(GEN_LANG "cpp")
endif()

# protoc grpc plugin
find_program(GRPC_PLUGIN NAMES "grpc_${GEN_LANG}_plugin")
if (NOT EXISTS ${GRPC_PLUGIN})
  message(WARNING "The grpc_${GEN_LANG}_plugin plugin was not found, \
                   the gRPC classes are not being generated")
else(EXISTS ${GRPC_PLUGIN})
  message(STATUS "Found grpc_${GEN_LANG}_plugin : " ${GRPC_PLUGIN})
endif()

# .proto file search directory
if (NOT DEFINED PROTO_SEARCH_PATH)
  set(PROTO_SEARCH_PATH ${CMAKE_CURRENT_SOURCE_DIR})
endif()

# protoc flags
set(PROTO_CFLAGS)
list(APPEND PROTOC_FLAGS "--proto_path=${PROTO_SEARCH_PATH}")
list(APPEND PROTOC_FLAGS "--${GEN_LANG}_out=${CMAKE_CURRENT_BINARY_DIR}") 

# Build grpc if the plugin is found
if (EXISTS ${GRPC_PLUGIN})
  list(APPEND PROTOC_FLAGS "--plugin=protoc-gen-grpc=${GRPC_PLUGIN}")
  list(APPEND PROTOC_FLAGS "--grpc_out=${CMAKE_CURRENT_BINARY_DIR}") 
endif()

# .proto relative paths
file(GLOB_RECURSE proto_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.proto)

# Absolute paths of .proto files to be passed to protoc program
set(ABSProtoFiles)
# Absolute paths of generated .h and .cc 
set(ProtoHeaders)
set(ProtoSources)

foreach(FNAME ${proto_files})
  # relative directory for .proto file
  get_filename_component(PROTO_PATH ${FNAME} DIRECTORY)
  # .proto name
  get_filename_component(PROTO_NAME ${FNAME} NAME_WE)
  # absolute directory and name of generated .h and .cc file
  set(GENERATED_PROTO_PATH "${CMAKE_CURRENT_BINARY_DIR}/${PROTO_PATH}/${PROTO_NAME}")

  list(APPEND ABSProtoFiles "${PROTO_SEARCH_PATH}/${FNAME}")
  list(APPEND ProtoHeaders "${GENERATED_PROTO_PATH}.pb.h")
  list(APPEND ProtoSources "${GENERATED_PROTO_PATH}.pb.cc")
  install (FILES ${GENERATED_PROTO_PATH}.pb.h DESTINATION include/${PROTO_PATH})

  # include grpc .h and .cc files if generated
  if (EXISTS ${GRPC_PLUGIN})
    list(APPEND ProtoHeaders "${GENERATED_PROTO_PATH}.grpc.pb.h")
    list(APPEND ProtoSources "${GENERATED_PROTO_PATH}.grpc.pb.cc")
    install (FILES "${GENERATED_PROTO_PATH}.grpc.pb.h" DESTINATION "include/${PROTO_PATH}")
  endif()
endforeach()

# Generate protos
add_custom_command(
  COMMAND ${PROTOC} ${PROTOC_FLAGS} ${ABSProtoFiles}
  OUTPUT ${ProtoSources} ${ProtoHeaders}
  COMMENT "Generating proto messages for matrix_io ..."
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_library(${PROJECT_NAME} ${ProtoHeaders} ${ProtoSources})

install(TARGETS ${PROJECT_NAME} DESTINATION lib)

