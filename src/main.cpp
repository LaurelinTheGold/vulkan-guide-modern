#include <print>

#include "vk_engine.h"

int main(int argc, char *argv[]) {
  std::println("Hello World!");
  VulkanEngine engine;

  engine.init();
  std::println("done init!");

  engine.run();
  std::println("done run!");

  engine.cleanup();
  std::println("done cleanup!");

  return 0;
}
