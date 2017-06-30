cmake_minimum_required(VERSION 2.8)

add_definitions(-std=c++11)

project(build_protos C CXX)

find_package(Protobuf 3 REQUIRED)

find_package(GRPC REQUIRED)

# io.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  IO_PROTO_SRC
  IO_PROTO_HEADER
  io.proto)

# sense.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  SENSE_PROTO_SRC
  SENSE_PROTO_HEADER
  sense.proto)

# zwave_commands.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  ZWAVE_COMMANDS_PROTO_SRC 
  ZWAVE_COMMANDS_PROTO_HEADER 
  zwave_commands.proto)

# comm.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  COMM_PROTO_SRC
  COMM_PROTO_HEADER
  comm.proto)

# driver.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  DRIVER_PROTO_SRC
  DRIVER_PROTO_HEADER
  driver.proto)

# hal.proto
PROTOBUF_GENERATE_CPP(
  HAL_PROTO_SRC 
  HAL_PROTO_HEADER 
  hal.proto)

# Delete hearbeat.proto (Ask Sean).

# Just build all the protos.
set(build_protos_src
  ${IO_PROTO_SRC}
  ${ZWAVE_COMMANDS_PROTO_SRC}
  ${COMM_PROTO_SRC}
  ${SENSE_PROTO_SRC}
  ${DRIVER_PROTO_SRC}
)

add_library(build_protos ${build_protos_src})
target_link_libraries(build_protos ${PROTOBUF_LIBRARY})
set_property(TARGET build_protos PROPERTY CXX_STANDARD 11)
