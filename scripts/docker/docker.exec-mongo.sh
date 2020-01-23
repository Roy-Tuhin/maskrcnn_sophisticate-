#!/usr/bin/env bash

### -------------------------------------------
## Docker execute command
## https://docs.docker.com/engine/reference/commandline/exec/
### -------------------------------------------

function exec_container_mongo() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/docker.config.sh
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/docker.config.mongo.sh

  if [ ! -z $1 ]; then
    local MONGO_DOCKER_CONTAINER_NAME=$1
  fi

  xhost +local:root 1>/dev/null 2>&1
  docker exec \
      -u $(id -u):$(id -g) \
      -it ${MONGO_DOCKER_CONTAINER_NAME} \
      /bin/bash
  xhost -local:root 1>/dev/null 2>&1
}

exec_container_mongo $1
