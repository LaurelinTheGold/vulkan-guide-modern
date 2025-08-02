
#include "vk_engine.h"

int main(int argc, char *argv[]) {
  fmt::println("Hello World!");
  VulkanEngine engine;

  engine.init();
  fmt::println("done init!");

  engine.run();
  fmt::println("done run!");

  engine.cleanup();
  fmt::println("done cleanup!");

  return 0;
}
