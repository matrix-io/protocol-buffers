cmake_minimum_required(VERSION 2.8)
project(build_protos C CXX)

# For GRPC.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

find_package(Protobuf 3 REQUIRED)
find_package(GRPC REQUIRED)

# vision.proto
PROTOBUF_GENERATE_CPP(VISION_PROTO_SRC VISION_PROTO_HEADER vision.proto)

# GRPC vision_service
PROTOBUF_GENERATE_CPP(VISION_GRPC_PROTO_SRC VISION_GRPC_PROTO_HEADER vision_service.proto)
PROTOBUF_GENERATE_GRPC_CPP(VISION_GRPC_SRC VISION_GRPC_HEADER vision_service.proto)

set(build_protos_src
  ${IMAGE_DATASET_PROTO_SRC}
  ${VISION_PROTO_SRC}
  ${VISION_GRPC_SRC}
  ${VISION_GRPC_PROTO_SRC}
)

add_library(build_protos ${build_protos_src})
target_link_libraries(build_protos ${PROTOBUF_LIBRARY})
set_property(TARGET build_protos PROPERTY CXX_STANDARD 11)
