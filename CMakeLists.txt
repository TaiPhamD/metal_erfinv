cmake_minimum_required(VERSION 3.16)
project(metal_erfinv)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -stdlib=libc++ -framework Metal -framework Foundation -framework Cocoa")


if("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    # print exact name of compiler id
    message(STATUS "Compiler ID: ${CMAKE_CXX_COMPILER_ID}")
endif()


execute_process( COMMAND ${CMAKE_CXX_COMPILER} --version OUTPUT_VARIABLE clang_full_version_string )
string(REGEX REPLACE "Apple (.*) version ([0-9]+\\.[0-9]+).*" "\\2" CLANG_VERSION_STRING ${clang_full_version_string})
message( STATUS "CLANG_VERSION_STRING:         " ${CLANG_VERSION_STRING} )

# Compile Metal shader
set(SHADER_SOURCE "${CMAKE_SOURCE_DIR}/erfinv.metal")
set(ERFINV_LIBRARY "${CMAKE_BINARY_DIR}/erfinv.metallib")
add_custom_command(
    OUTPUT ${ERFINV_LIBRARY}
    COMMAND xcrun -sdk macosx metal ${SHADER_SOURCE} -o ${ERFINV_LIBRARY}
    DEPENDS ${SHADER_SOURCE}
    COMMENT "Compiling Metal shader"
)
add_custom_target(shader DEPENDS ${ERFINV_LIBRARY})

# Executable
# add_executable(metal_erfinv main.mm)
add_library(metal_erfinv SHARED main.mm)
add_dependencies(metal_erfinv shader)
target_compile_definitions(metal_erfinv PRIVATE ERFINV_LIBRARY="${ERFINV_LIBRARY}")
