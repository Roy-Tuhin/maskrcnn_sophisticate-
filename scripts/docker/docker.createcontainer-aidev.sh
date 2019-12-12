#!/bin/bash

function docker_main() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${SCRIPTS_DIR}/docker.config.sh $2
  source ${SCRIPTS_DIR}/docker.fn.sh

  ${DOCKER_CMD} --version

  ## change image name
  if [ ! -z $1 ]; then
    DOCKER_CONTAINER_IMG=$1
  fi

  create_container

  userfix

}

## $1: imagename or imageid; $2: whichone
docker_main $1 $2
