#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME=cloud_repo

cd $(git rev-parse --show-toplevel)

docker build --build-arg=user="${USER}" --build-arg=uid="${UID}" --tag "${CONTAINER_NAME}" .

docker run \
    --detach \
    --name "${CONTAINER_NAME}" \
    --volume "$(git rev-parse --show-toplevel)":/cloud \
    --env USER \
    --env UID \
    --add-host "${CONTAINER_NAME}:127.0.0.1" \
    --hostname="${CONTAINER_NAME}" \
    "${CONTAINER_NAME}:latest" \
    tail -f /dev/null \
    > /dev/null