cmake_minimum_required(VERSION 3.5)
project(yaml-test)
enable_language(Fortran)

include(CheckFortranCompilerFlag)
check_fortran_compiler_flag("-m64" HAS_FORTRAN_LINUX)  # gcc specific flags
check_fortran_compiler_flag("/Qm64" HAS_FORTRAN_WIN)  # MSVS specific flags

if(HAS_FORTRAN_LINUX)
    set(CMAKE_FORTRAN_FLAGS "${CMAKE_FORTRAN_FLAGS} -O3 -ggdb3 -cpp")
elseif(HAS_FORTRAN_WIN)
    set(CMAKE_FORTRAN_FLAGS "${CMAKE_FORTRAN_FLAGS} /O3")
endif()

message(STATUS "Compiling yaml-test with options ${CMAKE_FORTRAN_FLAGS}")

set_source_files_properties("./test-sequence.f90"
    PROPERTIES
        COMPILE_FLAGS "${CMAKE_FORTRAN_FLAGS}"
)
add_executable(test-sequence "./test-sequence.f90")
target_link_libraries(test-sequence yaml-interface)

set_source_files_properties("./test-map.f90"
    PROPERTIES
        COMPILE_FLAGS "${CMAKE_FORTRAN_FLAGS}"
)
add_executable(test-map "./test-map.f90")
target_link_libraries(test-map yaml-interface)


set_source_files_properties("./test-sequence-nest.f90"
    PROPERTIES
        COMPILE_FLAGS "${CMAKE_FORTRAN_FLAGS}"
)
add_executable(test-sequence-nest "./test-sequence-nest.f90")
target_link_libraries(test-sequence-nest yaml-interface)


set_source_files_properties("./test-sequence-map-pair.f90"
    PROPERTIES
        COMPILE_FLAGS "${CMAKE_FORTRAN_FLAGS}"
)
add_executable(test-sequence-map-pair "./test-sequence-map-pair.f90")
target_link_libraries(test-sequence-map-pair yaml-interface)


set_source_files_properties("./test-orcaflex.f90"
    PROPERTIES
        COMPILE_FLAGS "${CMAKE_FORTRAN_FLAGS}"
)
add_executable(test-orcaflex "./test-orcaflex.f90")
target_link_libraries(test-orcaflex yaml-interface)
