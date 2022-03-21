# Overview

YAML-Fortran is a library for reading YAML files in Fortran.
YAML is fully operational through three basic primitives: mappings
(hashes/dictionaries), sequences (arrays/lists) and scalars (strings/numbers).  This fortran
interface supports the extraction of these primitives. You can read more about the [YAML
specification here](https://yaml.org/spec/1.2.2/).

???+ info
    This library only supports YAML reading/parsing, not the creation or generation of YAML files.

This project depends on the C++ project [YAML-cpp](https://github.com/jbeder/yaml-cpp). A C wrapper is created
to connect Fortran with the YAML-cpp library and acts as a layer to broker data transformation between the yaml-cpp library and the Fortran destination.
As this thin wrapper layer is an interface to the yaml-cpp implementation, most users do not need to be famliar with
yaml-cpp in order to use the YAML Fortran library. This documentation should be all a developer needs in order to begin using it.

## Terminology

### Access Types
* **Handlers** are the YAML file pointers; see [YAMLHandler](interface.md#yamlhandler)
* **Sequences** are iterators, lists or arrays; see [YAMLSequence](interface.md#yamlsequence)
* **Maps** are key-value pairs; see [YAMLMap](interface.md#yamlmap)
* **Elements** are individual items in a YAMLSequence list; see [YAMLElement](interface.md#yamlelement)
* **Fields** are scalar values, matrices, or strings. They represent terminus data in the YAML file; see [YAMLField](interface.md#yamlfield)

## Building

```bash
$ mkdir ./build
$ cd build
$ cmake -DYAML_BUILD_SHARED_LIBS=ON ..
$ make
```
