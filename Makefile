# Set default shell to bash
SHELL := /bin/bash -o pipefail

.PHONY: python-venv
python-venv:
	pip install virtualenv
	virtualenv .ci-venv
	.ci-venv/bin/pip install -r requirements.txt

# source ./.ci-venv/bin/activate

.PHONY: install-dependencies
install-dependencies:
	apt-get update
	apt-get install -y cmake g++ gcc gcovr gfortran ggcov git lcov make python-is-python3 python3-pip python3.8-venv tzdata valgrind

.PHONY: compile-yaml-fortran
compile-yaml-fortran:
	cmake -DYAML_BUILD_SHARED_LIBS=ON -B build
	make -C ./build -j4

.PHONY: make-documenation
make-documenation:
	mkdocs build --strict --config-file ./mkdocs.yml

.PHONY: test-execution
test-execution:
	cat ./bin/test.yaml
	./bin/test-map
	./bin/test-sequence
	./bin/test-sequence-nest
	./bin/test-sequence-map-pair
