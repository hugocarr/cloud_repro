#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME=cloud_repo

cd $(git rev-parse --show-toplevel)

docker build --tag "${CONTAINER_NAME}" .

docker run \
    --detach \
    --name "${CONTAINER_NAME}" \
    --volume "$(git rev-parse --show-toplevel)":/cloud \
    "${CONTAINER_NAME}:latest" \
    tail -f /dev/null \
    > /dev/null
