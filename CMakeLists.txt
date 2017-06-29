cmake_minimum_required(VERSION 2.8)

# For GRPC.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

# Build protocol buffers just to check they compile without errors.

add_definitions(-std=c++11)
project(build_protos C CXX)

find_package(Protobuf 3 REQUIRED)

find_package(GRPC REQUIRED)

# vision.proto
PROTOBUF_GENERATE_CPP(
  VISION_PROTO_SRC 
  VISION_PROTO_HEADER 
  matrix/vision/v1/vision.proto)


# GRPC vision_service
PROTOBUF_GENERATE_CPP(
  VISION_GRPC_PROTO_SRC 
  VISION_GRPC_PROTO_HEADER 
  matrix/vision/v1/vision_service.proto)

PROTOBUF_GENERATE_GRPC_CPP(
  VISION_GRPC_SRC 
  VISION_GRPC_HEADER 
  matrix/vision/v1/vision_service.proto)

# GRPC recognition_service
PROTOBUF_GENERATE_CPP(
  RECOGNITION_GRPC_PROTO_SRC 
  RECOGNITION_GRPC_PROTO_HEADER 
  matrix/recognition/v1/recognition_service.proto)

PROTOBUF_GENERATE_GRPC_CPP(
  RECOGNITION_GRPC_SRC 
  RECOGNITION_GRPC_HEADER 
  matrix/recognition/v1/recognition_service.proto)

PROTOBUF_GENERATE_CPP(
  RECOGNITION_PROTO_SRC 
  RECOGNITION_PROTO_HEADER 
  matrix/recognition/v1/recognition.proto)

# io.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  IO_PROTO_SRC
  IO_PROTO_HEADER
  matrix/malos/v1/io.proto)

# sense.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  SENSE_PROTO_SRC
  SENSE_PROTO_HEADER
  matrix/malos/v1/sense.proto)

# zwave_commands.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  ZWAVE_COMMANDS_PROTO_SRC 
  ZWAVE_COMMANDS_PROTO_HEADER 
  matrix/malos/v1/zwave_commands.proto)

# comm.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  COMM_PROTO_SRC
  COMM_PROTO_HEADER
  matrix/malos/v1/comm.proto)

# driver.proto (MALOS)
PROTOBUF_GENERATE_CPP(
  DRIVER_PROTO_SRC
  DRIVER_PROTO_HEADER
  matrix/malos/v1/driver.proto)

# hal.proto
PROTOBUF_GENERATE_CPP(
  HAL_PROTO_SRC 
  HAL_PROTO_HEADER 
  matrix/malos/v1/hal.proto)

# Delete hearbeat.proto (Ask Sean).

# Just build all the protos.
set(build_protos_src
  ${IO_PROTO_SRC}
  ${COMM_PROTO_SRC}
  ${SENSE_PROTO_SRC}
  ${DRIVER_PROTO_SRC}
  ${VISION_PROTO_SRC}
  ${RECOGNITION_PROTO_SRC}
  ${ZWAVE_COMMANDS_PROTO_SRC}
)

add_library(build_protos ${build_protos_src})
target_link_libraries(build_protos ${PROTOBUF_LIBRARY})
set_property(TARGET build_protos PROPERTY CXX_STANDARD 11)
