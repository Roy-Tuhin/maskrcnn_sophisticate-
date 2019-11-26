#!/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
source "${SCRIPTS_DIR}/docker.env-aidev.sh"

docker --version

function local_volumes() {
  ## $(uname -s) i.e. Linux 
  local volumes="${DOCKER_VOLUMES} -v ${HOME}/.cache:${DOCKER_HOME}/.cache \
    -v /dev:/dev \
    -v /media:/media \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/src:/usr/src \
    -v /lib/modules:/lib/modules"
  echo "${volumes}"
}


# function port_maps() {}


function docker_envvars() {
  local display=""

  if [[ -z ${DISPLAY} ]];then
      display=":0"
  else
      display="${DISPLAY}"
  fi

  local envvars=""

  # envvars="${envvars} -e DOCKER_IMG=${DOCKER_IMG} "
  envvars="${envvars} -e DISPLAY=${display} "

  # envvars="${envvars} -e USER=$DUSER "
  # envvars="${envvars} -e DOCKER_USER=$DUSER "
  # envvars="${envvars} -e DOCKER_USER_ID=$USER_ID "
  # envvars="${envvars} -e DOCKER_GRP=$GRP "
  # envvars="${envvars} -e DOCKER_GRP_ID=$GRP_ID "

  echo "${envvars}"
}


function restart_policy() {
  local restart
  restart="--restart always"

  echo "${restart}"
}


function main() {
    docker ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null
    if [ $? == 0 ]; then
      docker stop ${DOCKER_CONTAINER_NAME} 1>/dev/null
      docker rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null
    fi

    docker start ${DOCKER_CONTAINER_NAME} 1>/dev/null

    echo $(local_volumes)
    
    # https://docs.docker.com/network/host/
    ## WARNING: Published ports are discarded when using host network mode

    ##TODO: config file throws permission error
    echo "docker run -d -it \
      --gpus all \
      --name ${DOCKER_CONTAINER_NAME} \
      $(docker_envvars) \
      $(local_volumes) \
      $(restart_policy) \
      --net host \
      --add-host ${LOCAL_HOST}:127.0.0.1 \
      --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
      --hostname ${DOCKER_LOCAL_HOST} \
      --shm-size ${SHM_SIZE} \
      ${DOCKER_IMG}"

    docker run -d -it \
      --gpus all \
      --name ${DOCKER_CONTAINER_NAME} \
      $(docker_envvars) \
      $(local_volumes) \
      $(restart_policy) \
      --net host \
      --add-host ${LOCAL_HOST}:127.0.0.1 \
      --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
      --hostname ${DOCKER_LOCAL_HOST} \
      --shm-size ${SHM_SIZE} \
      ${DOCKER_IMG}

      # ${DOCKER_IMG} $(configs)

    ## https://unix.stackexchange.com/questions/7704/what-is-the-meaning-of-in-a-shell-script
    ## $? provide us the execution status of last execute command on prompt.
    ## Value '0' denotes that the command was executed successfuly and '1' is for not success.
    if [ $? -ne 0 ];then
        error "Failed to start docker container \"${DOCKER_CONTAINER_NAME}\" based on image: $DOCKER_IMG"
        # exit 1
        return
    fi

    if [ "${DUSER}" != "root" ]; then
      # docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.adduser.sh"
      docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chown -R ${DUSER}:${GRP} ${WORK_BASE_PATH}"
      docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chmod a+w ${WORK_BASE_PATH}"
      ##
      

      # ## testing
      # declare -a DATA_DIRS
      # DATA_DIRS=("${WORK_BASE_PATH}/test1"
      #            "${WORK_BASE_PATH}/test2")
      
      # for DATA_DIR in "${DATA_DIRS[@]}"; do
      #   docker exec ${DOCKER_CONTAINER_NAME} bash -c \
      #       "mkdir -p '${DATA_DIR}'; chown -R ${DOCKER_USER}:${DOCKER_GRP} '${DATA_DIR}'"
      #       "mkdir -p '${DATA_DIR}'; chmod a+rw -R '${DATA_DIR}'"
      # done
    fi

    # info "MONGODB_USER:MONGODB_USER_ID:: $MONGODB_USER:$MONGODB_USER_ID"
    # info "MONGODB_GRP:MONGODB_GRP_ID:: $MONGODB_GRP:$MONGODB_GRP_ID"

    # docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.mongodb.userfix.sh"

    # docker exec -u ${USER} -it ${DOCKER_CONTAINER_NAME} "${WORK_BASE_PATH}/scripts/bootstrap.sh"

    echo "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with: \n source ${SCRIPTS_DIR}/docker/docker.exec.sh"
    echo "Enjoy!"
}


##----------------------------------------------------------
## execute main function call
##----------------------------------------------------------

main
