cmake_minimum_required(VERSION 3.5)
project(fortran-yaml LANGUAGES CXX)
include(CheckCXXCompilerFlag)

add_subdirectory("./pkg/yaml-cpp")
add_subdirectory("./src/yaml-wrapper")
add_subdirectory("./src/yaml-fortran")
add_subdirectory("./test")

set_target_properties(yaml-cpp
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)

set_target_properties(yaml-wrapper
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)

set_target_properties(yaml-interface
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)

set_target_properties(test-sequence
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)

set_target_properties(test-map
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)


set_target_properties(test-sequence-nest
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)

set_target_properties(test-sequence-map-pair
    PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.so
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.a
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>  # for *.dll on windows
        PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
        COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/../bin$<0:>
)


set_target_properties(yaml-wrapper PROPERTIES FOLDER "yaml-fortran")
set_target_properties(yaml-interface PROPERTIES FOLDER "yaml-fortran")
set_target_properties(yaml-cpp PROPERTIES FOLDER "yaml-cpp")
set_target_properties(test-map PROPERTIES FOLDER "yaml-fortran/test")
set_target_properties(test-sequence PROPERTIES FOLDER "yaml-fortran/test")
set_target_properties(test-sequence-nest PROPERTIES FOLDER "yaml-fortran/test")
set_target_properties(test-sequence-map-pair PROPERTIES FOLDER "yaml-fortran/test")
set_target_properties(yaml-cpp-parse PROPERTIES FOLDER "yaml-cpp")
set_target_properties(yaml-cpp-read PROPERTIES FOLDER "yaml-cpp")
set_target_properties(yaml-cpp-sandbox PROPERTIES FOLDER "yaml-cpp")

target_include_directories(yaml-wrapper
    PRIVATE  "${PROJECT_BINARY_DIR}/yaml-cpp/include")

target_include_directories(test-map
    PRIVATE  "${PROJECT_BINARY_DIR}/src/yaml-fortran")

target_include_directories(test-sequence
    PRIVATE  "${PROJECT_BINARY_DIR}/src/yaml-fortran")

target_include_directories(test-sequence-nest
    PRIVATE  "${PROJECT_BINARY_DIR}/src/yaml-fortran")

target_include_directories(test-sequence-map-pair
    PRIVATE  "${PROJECT_BINARY_DIR}/src/yaml-fortran")


configure_file("${PROJECT_BINARY_DIR}/../test/test.yaml" "${PROJECT_BINARY_DIR}/../bin/test.yaml" COPYONLY)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
