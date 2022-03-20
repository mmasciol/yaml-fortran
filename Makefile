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
	apt-get update
	apt-get install -y cmake gfortran g++ git gcc tzdata

.PHONY: compile-yaml-fortran
compile-yaml-fortran:
	cmake -DYAML_BUILD_SHARED_LIBS=ON -B build
	make -C ./build -j4

.PHONY: make-documenation
make-documenation:
	mkdocs build --strict --config-file ./mkdocs.yml
