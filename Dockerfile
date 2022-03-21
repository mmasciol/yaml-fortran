FROM ubuntu:20.04

ENV TZ=US
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY requirements.txt requirements.txt
COPY Makefile Makefile
COPY pkg/markdown_fortran pkg/markdown_fortran

RUN apt-get update && apt-get -y install make
RUN make install-dependencies
RUN make python-venv

RUN rm -rf Makefile requirements.txt pkg/markdown_fortran
