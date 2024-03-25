#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME=cloud_repo

docker exec --interactive --tty "${CONTAINER_NAME}" /bin/bash
