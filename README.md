[![CI](https://github.com/mmasciol/yaml-fortran/workflows/CI/badge.svg?event=push)](https://github.com/mmasciol/yaml-fortran/actions?query=event%3Apush+branch%3Amain+workflow%3ACI)
[![Coverage](https://codecov.io/gh/mmasciol/yaml-fortran/branch/main/graphs/badge.svg?token=RUQZ7NY0FU)](https://codecov.io/gh/mmasciol/yaml-fortran)
[![license](https://img.shields.io/github/license/mmasciol/map-plus-plus.svg)](https://img.shields.io/github/license/mmasciol/map-plus-plus)

# YAML Fortran library

A library to read `*.yaml` files in Fortran.
This project depends on [yaml-cpp](https://github.com/jbeder/yaml-cpp) and implements a thin wrapper layer to handle API calls with yaml-cpp.

## Examples
- [**YAML maps**](./test/test-map.f90)
- [**YAML sequences**](./test/test-sequence.f90)
- [**YAML sequence-map pairings**](./test/test-sequence-map-pair.f90)
- [**YAML nested sequences**](./test/test-sequence-nest.f90)

# Building

## Build on linux:

```bash
$ mkdir ./build
$ cd build
$ cmake -DYAML_BUILD_SHARED_LIBS=ON ..
$ make
```

## Build on windows:

```bash
> mkdir build
> cd build
> cmake -DYAML_BUILD_SHARED_LIBS=ON ..
```

Then open the visual studio project file `./build/fortran-yaml.sln` and compile.
The binary executables and libraries are archived in the `./bin` folder.
Be sure to the default project to one of the unit test cases in order to evaluate in a debugging session.
