#!/bin/bash

function local_volumes() {
  ## $(uname -s) i.e. Linux 
  local volumes="${DOCKER_VOLUMES} "

  volumes="${volumes} -v ${HUSER_HOME}/.cache:${HUSER_HOME}/.cache"
  volumes="${volumes} -v /dev:/dev \
    -v /media:/media \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/src:/usr/src \
    -v /lib/modules:/lib/modules"

  echo "${volumes}"
}


function port_maps() {
  local docker_ports="${DOCKER_PORTS} "

  echo "${docker_ports}"
}


function docker_envvars() {
  local envvars="${DOCKER_ENVVARS} "

  envvars="${envvars} -e DOCKER_IMG=${DOCKER_IMG} "
  envvars="${envvars} -e DISPLAY=${DDISPLAY} "
  envvars="${envvars} -e HUSER=${HUSER} "
  envvars="${envvars} -e HUSER_ID=${HUSER_ID} "
  envvars="${envvars} -e HUSER_GRP=${HUSER_GRP} "
  envvars="${envvars} -e HUSER_GRP_ID=${HUSER_GRP_ID} "

  echo "${envvars}"
}


function restart_policy() {
  local restart
  restart="--restart always"

  echo "${restart}"
}
