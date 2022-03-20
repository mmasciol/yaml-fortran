# Set default shell to bash
SHELL := /bin/bash -o pipefail

.PHONY: install-dependencies
	sudo apt-get update -y
	sudo apt-get install -y cmake
	sudo apt-get install -y gfortran

.PHONY: compile-yaml-fortran
compile-yaml-fortran: install-dependencies
	mkdir ./build
	cd build
	cmake -DYAML_BUILD_SHARED_LIBS=ON ..
	make -j10
