[![CI](https://github.com/mmasciol/yaml-fortran/workflows/CI/badge.svg?event=push)](https://github.com/mmasciol/yaml-fortran/actions?query=event%3Apush+branch%3Amain+workflow%3ACI)
[![Coverage](https://codecov.io/gh/mmasciol/yaml-fortran/branch/main/graphs/badge.svg?token=RUQZ7NY0FU)](https://codecov.io/gh/mmasciol/yaml-fortran)
[![license](https://img.shields.io/github/license/mmasciol/map-plus-plus.svg)](https://github.com/mmasciol/yaml-fortran/blob/main/LICENSE)

# YAML Fortran library

A library to read `*.yaml` files in Fortran.
This project depends on [yaml-cpp](https://github.com/jbeder/yaml-cpp) and implements a thin wrapper layer to handle API calls with yaml-cpp.

This library's documentation is located at [www.yaml-fortran.com](http://www.yaml-fortran.com).

## Examples
- [**YAML maps**](./test/test-map.f90)
- [**YAML sequences**](./test/test-sequence.f90)
- [**YAML sequence-map pairings**](./test/test-sequence-map-pair.f90)
- [**YAML nested sequences**](./test/test-sequence-nest.f90)

# Building

This project relies on two packages existing inside the `./pkg/` directory: [yaml-cpp](https://github.com/jbeder/yaml-cpp) and [mkdocs-fortran](https://github.com/mmasciol/mkdocs-fortran). You need to pull these git submodules before building otherwise the build will fail. You can do this with the following command (both windows and linux): 

```bash
$ git submodule init
$ git submodule update
```

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
