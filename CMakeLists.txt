# CMakeList.txt : CMake project for vulkan_guide, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.20)

project ("vulkan_guide")


find_package(Vulkan REQUIRED)

add_subdirectory(third_party)

set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_SOURCE_DIR}/bin")

add_subdirectory(src)

find_program(GLSL_VALIDATOR glslangValidator
  HINTS
    /usr/local/bin
    /usr/bin
    $ENV{VULKAN_SDK}/bin
  REQUIRED
  DOC "Path to glslangValidator"
)
message(STATUS "glslangValidator found at: ${GLSL_VALIDATOR}")


file(GLOB_RECURSE GLSL_SOURCE_FILES
    "${PROJECT_SOURCE_DIR}/shaders/*.frag"
    "${PROJECT_SOURCE_DIR}/shaders/*.vert"
    "${PROJECT_SOURCE_DIR}/shaders/*.comp"
    )

foreach(GLSL ${GLSL_SOURCE_FILES})
  message(STATUS "BUILDING SHADER")
  get_filename_component(FILE_NAME ${GLSL} NAME)
  set(SPIRV "${PROJECT_SOURCE_DIR}/shaders/${FILE_NAME}.spv")
  message(STATUS ${GLSL})
  add_custom_command(
    OUTPUT ${SPIRV}
    COMMAND ${GLSL_VALIDATOR} -V ${GLSL} -o ${SPIRV}
    DEPENDS ${GLSL})
  list(APPEND SPIRV_BINARY_FILES ${SPIRV})
endforeach(GLSL)

add_custom_target(
    Shaders 
    DEPENDS ${SPIRV_BINARY_FILES}
    )

find_program(SLANG_COMPILER slangc 
  HINTS
    $ENV{VULKAN_SDK}/bin
  REQUIRED
  DOC "Path to slangc"
)
message(STATUS "slangc found at: ${SLANG_COMPILER}")

file(GLOB_RECURSE SLANG_SOURCE_FILES
    "${PROJECT_SOURCE_DIR}/shaders/*.slang"
    )

foreach(SLANG ${SLANG_SOURCE_FILES})
  message(STATUS "BUILDING SHADER")
  get_filename_component(FILE_NAME ${SLANG} NAME)
  set(SPIRV_SLANG "${PROJECT_SOURCE_DIR}/shaders/${FILE_NAME}.spv")
  message(STATUS ${SLANG})
  add_custom_command(
    OUTPUT ${SPIRV_SLANG}
    COMMAND ${SLANG_COMPILER} ${SLANG} -target spirv -o ${SPIRV_SLANG}
    DEPENDS ${SLANG})
  list(APPEND SPIRV_SLANG_BINARY_FILES ${SPIRV_SLANG})
  message(STATUS ${SPIRV_SLANG})
endforeach(SLANG)

add_custom_target(
    Shaders_slang 
    DEPENDS ${SPIRV_SLANG_BINARY_FILES}
    )
