#!/usr/bin/env bash

### -------------------------------------------
## Docker execute command
## https://docs.docker.com/engine/reference/commandline/exec/
### -------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"
source "${SCRIPTS_DIR}/docker/docker.env-mongo.sh"

if [ ! -z $1 ]; then
  DOCKER_IMG=$1
  DOCKER_CONTAINER_NAME="${DOCKER_PREFIX}-${DOCKER_IMG}"
fi

xhost +local:root 1>/dev/null 2>&1
docker exec \
    -u $USER \
    -it ${DOCKER_CONTAINER_NAME} \
    /bin/bash
xhost -local:root 1>/dev/null 2>&1
