project(malos_service C CXX)
cmake_minimum_required(VERSION 2.8)

add_definitions(-std=c++11)

FIND_LIBRARY(ZW_CMD_TOOL_LIB NAMES zw_cmd_tool)

add_executable(zwave_proto_gen  zwave_proto_gen.cpp)
  set_property(TARGET zwave_proto_gen  PROPERTY CXX_STANDARD 11)
  target_link_libraries(zwave_proto_gen ${ZW_CMD_TOOL_LIB})


