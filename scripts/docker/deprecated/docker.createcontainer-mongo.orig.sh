#!/bin/bash

LINUX_VERSION="$(lsb_release -sr)"
LINUX_CODE_NAME=$(lsb_release -sc)
LINUX_ID=$(lsb_release -si) ## Ubuntu, Kali

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"
# echo "SCRIPTS_DIR: ${SCRIPTS_DIR}"

source "${SCRIPTS_DIR}/lscripts/utils/common.sh"
source "${SCRIPTS_DIR}/docker/docker.env-mongo.sh"

${DOCKER_CMD} --version

if [ ! -d "${HOME}/.cache" ];then
    mkdir "${HOME}/.cache"
fi

if [ ! -z $1 ]; then
  DOCKER_IMG=$1
  DOCKER_CONTAINER_NAME="${DOCKER_PREFIX}-${DOCKER_IMG}"
fi

DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${SCRIPTS_DIR}:${SCRIPTS_BASE_PATH}"

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


function port_maps() {
  local mongo_db_ports="-p ${HOST_MONGODB_PORTS}:${DOCKER_MONGODB_PORTS}"
  local docker_ports="${mongo_db_ports}"

  echo "${docker_ports}"
}


function configs() {
  local config_param=""

  if [ ! -z ${MONGODB_CONFIG_FILE} ]; then
    config_param="--config ${MONGODB_CONFIG_FILE}"
    info ${MONGODB_CONFIG_FILE}
  fi
  
  echo "${config_param}"
}

function docker_envvars() {
  local display=""

  if [[ -z ${DISPLAY} ]];then
      display=":0"
  else
      display="${DISPLAY}"
  fi

  local envvars=""

  envvars="${envvars} -e DOCKER_IMG=${DOCKER_IMG} "
  envvars="${envvars} -e DISPLAY=${display} "

  envvars="${envvars} -e USER=$USER "
  envvars="${envvars} -e DOCKER_USER=$USER "
  envvars="${envvars} -e DOCKER_USER_ID=$USER_ID "
  envvars="${envvars} -e DOCKER_GRP=$GRP "
  envvars="${envvars} -e DOCKER_GRP_ID=$GRP_ID "

  ## mongodb user fix
  envvars="${envvars} -e MONGODB_USER=$MONGODB_USER "
  envvars="${envvars} -e MONGODB_USER_ID=$MONGODB_USER_ID "
  envvars="${envvars} -e MONGODB_GRP=$MONGODB_GRP "
  envvars="${envvars} -e MONGODB_GRP_ID=$MONGODB_GRP_ID "

  echo "${envvars}"
}


function main() {
    docker ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null
    if [ $? == 0 ]; then
      docker stop ${DOCKER_CONTAINER_NAME} 1>/dev/null
      docker rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null
    fi

    info $(configs)
    info $(local_volumes)
    
    ##TODO: config file throws permission error
    # ${DOCKER_CMD} run -it -d --privileged \
    # ${DOCKER_CMD} run \
    ${DOCKER_CMD} run -d \
        --name ${DOCKER_CONTAINER_NAME} \
        $(docker_envvars) \
        $(port_maps) \
        $(local_volumes) \
        -w ${WORK_BASE_PATH} \
        --net host \
        --add-host ${LOCAL_HOST}:127.0.0.1 \
        --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
        --hostname ${DOCKER_LOCAL_HOST} \
        --shm-size ${SHM_SIZE} \
        ${DOCKER_IMG}

        # ${DOCKER_IMG} $(configs)

    
    if [ $? -ne 0 ];then
        error "Failed to start docker container \"${DOCKER_CONTAINER_NAME}\" based on image: $DOCKER_IMG"
        # exit 1
        return
    fi

    if [ "${USER}" != "root" ]; then
      docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.adduser.sh"
      docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chown -R ${USER}:${GRP} ${WORK_BASE_PATH}"
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

    ok "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with: \n source ${SCRIPTS_DIR}/docker/docker.exec-mongo.sh"
    ok "Enjoy!"
}


##----------------------------------------------------------
## execute main function call
##----------------------------------------------------------

main
