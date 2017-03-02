#include <iostream>
#include <set>
#include <string>
#include <valarray>

extern "C" {
#include <zwaveip/zw_cmd_tool.h>
}

int main() {
  int n;
  std::valarray<const char*> names(512);
  std::set<std::string> class_names;
  std::set<std::string> cmd_names;

  n = zw_cmd_tool_get_command_class_names(&names[0]);

  for (auto& class_name :
       std::valarray<const char*>(names[std::slice(0, n, 1)])) {
    class_names.insert(std::string(class_name));
  }

  int index = 0;
  std::cout << "enum EnumZWaveClassType {" << std::endl;
  for (auto& class_name : class_names) {
    std::cout << "  " << class_name << " = " << (++index) << ";" << std::endl;
  }
  std::cout << "}" << std::endl << std::endl;

  for (auto& class_name : class_names) {
    const zw_command_class* p_class_class =
        zw_cmd_tool_get_class_by_name(class_name.c_str());

    n = zw_cmd_tool_get_cmd_names(p_class_class, &names[0]);

    for (auto& cmd_name :
         std::valarray<const char*>(names[std::slice(0, n, 1)])) {
      cmd_names.insert(std::string(cmd_name));
    }

// TODO (andres.calderon@admobilize.com):  use parameter definition
#if 0
    for (auto& cmd_name : cmd_names) {
      std::cout << "\t" << cmd_name << std::endl;
      const zw_command* p_zw_command =
          zw_cmd_tool_get_cmd_by_name(p_class_class, cmd_name);

      n = zw_cmd_tool_get_param_names(p_zw_command, &names[0]);
      param_names = std::valarray<const char*>(names[std::slice(0, n, 1)]);

      for (auto& param_name : param_names) {
        std::cout << "\t\t" << param_name << std::endl;
      }
    }
#endif
  }

  index = 0;
  std::cout << "enum EnumZWaveCommandType {" << std::endl;
  for (auto& cmd_name : cmd_names) {
    std::cout << "  " << cmd_name << " = " << (++index) << ";" << std::endl;
  }
  std::cout << "}" << std::endl << std::endl;
}
