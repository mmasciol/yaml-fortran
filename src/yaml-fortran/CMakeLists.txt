cmake_minimum_required(VERSION 3.5)
project(yaml-interface)
enable_language(Fortran)

include(CheckFortranCompilerFlag)
check_fortran_compiler_flag("-m64" HAS_FORTRAN_LINUX)  # gcc specific flags
check_fortran_compiler_flag("/Qm64" HAS_FORTRAN_WIN)  # MSVS specific flags

if(HAS_FORTRAN_LINUX)
    set(CMAKE_FORTRAN_FLAGS "${CMAKE_FORTRAN_FLAGS} -O3 -ggdb3 -cpp")
elseif(HAS_FORTRAN_WIN)
    set(CMAKE_FORTRAN_FLAGS "${CMAKE_FORTRAN_FLAGS} /O3")
endif()

message(STATUS "Compiling yaml-fortran with options ${CMAKE_FORTRAN_FLAGS}")

set(src-pattern "*.f90")
file(GLOB yaml-f90-sources ${src-pattern})
set(YAML_F90_SOURCES ${yaml-f90-sources})
set_source_files_properties(${yaml-f90-sources} PROPERTIES COMPILE_FLAGS "${CMAKE_FORTRAN_FLAGS}")

add_library(yaml-interface ${YAML_F90_SOURCES})
target_link_libraries(yaml-interface yaml-wrapper)
