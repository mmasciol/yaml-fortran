# Set default shell to bash
# SHELL := /bin/bash -o pipefail

#
# .virtualenv:
#     virtualenv -p python3 .virtualenv
#     . .virtualenv/bin/activate; \
#     pip install -r requirements.txt -r requirements_test.txt
#

.PHONY: install-dependencies
install-dependencies:
	apt-get install -y cmake
	apt-get install -y gfortran
	apt-get install -y g++
	apt-get install -y gcc

.PHONY: compile-yaml-fortran
compile-yaml-fortran:
	mkdir ./build
	ls -la
	pwd
	cd ./build
	pwd
	ls -la ../
	cmake -DYAML_BUILD_SHARED_LIBS=ON ..
	make -j10

.PHONY: make-documenation
make-documenation:
	mkdocs build --strict --config-file ./mkdocs.yml
