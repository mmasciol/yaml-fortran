# YAML Fortran library


## To build on linux:

```bash
$ mkdir ./build
$ cd build
$ cmake -DYAML_BUILD_SHARED_LIBS=ON ..
$ make
```

## To build on windows:

```bash
> mkdir build
> cd build
> cmake -DYAML_BUILD_SHARED_LIBS=ON ..
```

Then open the visual studio project file `./build/fortran-yaml.sln` and compile.
The binary executables and libraries are archived in the `./bin` folder.
Be sure to the default project to one of the unit test cases in order to evaluate in a debugging session.

# Unit Test Cases
- [**YAML maps**](./yaml-fortran/test/test-map.f90)
- [**YAML sequences**](./yaml-fortran/test/test-sequence.f90)
- [**YAML sequence-map pairings**](./yaml-fortran/test/test-sequence-map-pair.f90)
- [**YAML nested sequences**](./yaml-fortran/test/test-sequence-nest.f90)
