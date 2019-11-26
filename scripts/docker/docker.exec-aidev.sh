#!/usr/bin/env bash

### -------------------------------------------
## Docker execute command
## https://docs.docker.com/engine/reference/commandline/exec/
### -------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
source "${SCRIPTS_DIR}/docker.env-aidev.sh"


if [ ! -z $1 ]; then
  DOCKER_CONTAINER_NAME=$1
fi

xhost +local:root 1>/dev/null 2>&1
docker exec \
    -u ${DUSER} \
    -it ${DOCKER_CONTAINER_NAME} \
    /bin/bash
xhost -local:root 1>/dev/null 2>&1