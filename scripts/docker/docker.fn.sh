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

    ## Ref: /codehub/external/tensorflow/tensorflow/tensorflow/tools/dockerfiles/README.md
    ## If you're BUILDING OR DEPLOYING DOCKER IMAGES, run as root with docker.sock:
    # -v /var/run/docker.sock:/var/run/docker.sock

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
  envvars="${envvars} -e HOST_PERMS=$(id -u):$(id -g) "
  envvars="${envvars} -e HUSER=${HUSER} "
  envvars="${envvars} -e HUSER_ID=${HUSER_ID} "
  envvars="${envvars} -e HUSER_GRP=${HUSER_GRP} "
  envvars="${envvars} -e HUSER_GRP_ID=${HUSER_GRP_ID} "
  envvars="${envvars} -e PY_VENV_PATH=${PY_VENV_PATH} "
  envvars="${envvars} -e PY_VENV_NAME=${PY_VENV_NAME} "

  echo "${envvars}"
}


function restart_policy() {
  local restart=""
  restart="--restart always"

  echo "${restart}"
}


function enable_nvidia_gpu() {
  local gpus=""
  gpus="--gpus all"

  echo "${gpus}"
}


function create_container_aidev() {
    ${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null

    if [ $? == 0 ]; then
      ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null
      ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null
    fi

    ${DOCKER_CMD} start ${DOCKER_CONTAINER_NAME} 1>/dev/null

    echo $(local_volumes)
    
    # https://docs.docker.com/network/host/
    ## WARNING: Published ports are discarded when using host network mode

    ##TODO: config file throws permission error
    echo "${DOCKER_CMD} run -d -it \
      $(enable_nvidia_gpu) \
      --name ${DOCKER_CONTAINER_NAME} \
      $(docker_envvars) \
      $(local_volumes) \
      $(restart_policy) \
      --net host \
      --add-host ${LOCAL_HOST}:127.0.0.1 \
      --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
      --hostname ${DOCKER_LOCAL_HOST} \
      --shm-size ${SHM_SIZE} \
      ${DOCKER_CONTAINER_IMG}"

    ${DOCKER_CMD} run -d -it \
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
      ${DOCKER_CONTAINER_IMG}

    ## https://unix.stackexchange.com/questions/7704/what-is-the-meaning-of-in-a-shell-script
    ## $? provide us the execution status of last execute command on prompt.
    ## Value '0' denotes that the command was executed successfuly and '1' is for not success.
    if [ $? -ne 0 ];then
        error "Failed to start docker container \"${DOCKER_CONTAINER_NAME}\" based on image: ${DOCKER_CONTAINER_IMG}"
        # exit 1
        return
    fi

    # info "MONGODB_USER:MONGODB_USER_ID:: $MONGODB_USER:$MONGODB_USER_ID"
    # info "MONGODB_GRP:MONGODB_GRP_ID:: $MONGODB_GRP:$MONGODB_GRP_ID"

    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.mongodb.userfix.sh"

    # ${DOCKER_CMD} exec -u ${USER} -it ${DOCKER_CONTAINER_NAME} "${WORK_BASE_PATH}/scripts/bootstrap.sh"

    echo -e "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with:\n source $(pwd)/docker.exec-aidev.sh ${DOCKER_CONTAINER_NAME}"
    echo "Enjoy!"
}


function userfix() {
  if [ "${HUSER}" != "root" ]; then
    ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "source ${SCRIPTS_BASE_PATH}/docker/docker.adduser.sh"
    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chown -R ${HUSER}:${HUSER_GRP} ${WORK_BASE_PATH}"
    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "[ -d ${WORK_BASE_PATH} ] && chown -R ${HUSER}:${HUSER_GRP} ${WORK_BASE_PATH} && \
    #   chmod a+w ${WORK_BASE_PATH}"
    # ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "[ -d ${OTHR_BASE_PATHS} ] && chown -R ${HUSER}:${HUSER_GRP} ${OTHR_BASE_PATHS} && \
    #   chmod a+w ${OTHR_BASE_PATHS}"

    # ## testing
    # declare -a DATA_DIRS
    # DATA_DIRS=("${WORK_BASE_PATH}/test1"
    #            "${WORK_BASE_PATH}/test2")
    
    # for DATA_DIR in "${DATA_DIRS[@]}"; do
    #   ${DOCKER_CMD} exec ${DOCKER_CONTAINER_NAME} bash -c \
    #       "mkdir -p '${DATA_DIR}'; chown -R ${DOCKER_USER}:${DOCKER_GRP} '${DATA_DIR}'"
    #       "mkdir -p '${DATA_DIR}'; chmod a+rw -R '${DATA_DIR}'"
    # done
  fi
}
