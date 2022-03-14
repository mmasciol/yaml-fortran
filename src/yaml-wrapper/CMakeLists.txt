# https://stackoverflow.com/questions/3742090/custom-directory-for-cmake-library-output
# https://github.com/robotology/how-to-export-cpp-library/blob/master/src/LibTemplateCMake/CMakeLists.txt

cmake_minimum_required(VERSION 3.5)
project(YAML_WRAPPER LANGUAGES CXX)

include(CheckCXXCompilerFlag)

check_cxx_compiler_flag("-m64" HAS_CXX_LINUX)  # gcc specific flags
check_cxx_compiler_flag("/GS" HAS_CXX_WIN)  # MSVS specific flags

if(HAS_CXX_LINUX)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -ggdb3")
elseif(HAS_CXX_WIN)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /O3")
endif()


set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")
message(STATUS "Compiling yaml-wrapper with options ${CMAKE_C_FLAGS}")

set(src-pattern "src/*.cc")
set(header-pattern "src/*.h")

file(GLOB yaml-cpp-sources ${src-pattern})
file(GLOB yaml-header-sources ${header-pattern})

set(YAML_WRAPPER_SOURCES ${yaml-cpp-sources})
set(YAML_WRAPPER_HEADERS ${yaml-header-sources})

add_library(yaml-wrapper SHARED ${YAML_WRAPPER_SOURCES} ${YAML_WRAPPER_HEADERS})
target_link_libraries(yaml-wrapper yaml-cpp)
