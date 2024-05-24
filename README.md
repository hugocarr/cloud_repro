# `cloud_repro`
This is a repro case for a problem I am having with a large memory usage in Bazel with Python requirements

## Repro steps

We do all of our work inside of a Docker container, so this repro case includes a Dockerfile and
scripts to work with it.

1. Run `scripts/setup.sh` to build and start the container

1. Run `scripts/shell.sh` to get a shell inside the container

1. Run `bazel run //:venv` to start using a LOT of memory
