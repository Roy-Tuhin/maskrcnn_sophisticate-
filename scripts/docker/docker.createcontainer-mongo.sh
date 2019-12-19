#!/usr/bin/env bash

##----------------------------------------------------------
### docker utility script
##----------------------------------------------------------
#
## References:
#
## https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash
#
## variable scopes
## https://stackoverflow.com/questions/30609973/bash-variable-scope-leak
## https://stackoverflow.com/questions/10806357/associative-arrays-are-local-by-default
#
## What Is /dev/shm And Its Practical Usage?
## https://www.cyberciti.biz/tips/what-is-devshm-and-its-practical-usage.html
#
# ulimit
## https://www.linuxhowtos.org/tips%20and%20tricks/ulimit.htm
## forkbomb
## https://de.wikipedia.org/wiki/Forkbomb
#
## Bash Special Variables
## https://stackoverflow.com/questions/5163144/what-are-the-special-dollar-sign-shell-variables#5163260
#
##----------------------------------------------------------
#
## Docker:
#
## docker.setup.sh
## docker.env.sh
## docker.adduser.sh
## docker.exec.sh
## common.sh
#
##----------------------------------------------------------
## Inspired by:
## https://github.com/ApolloAuto/apollo/tree/master/scripts
##----------------------------------------------------------


function docker_createcontainer_mongo() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  ## WHICHONE is $2
  source ${SCRIPTS_DIR}/docker.config.sh $2
  source ${SCRIPTS_DIR}/docker.config.mongo.sh
  source ${SCRIPTS_DIR}/docker.fn.sh

  ${DOCKER_CMD} --version

  if [ ! -z $1 ]; then
    MONGO_DOCKER_IMG=$1
  fi
  MONGO_DOCKER_CONTAINER_NAME="${MONGO_DOCKER_PREFIX}-${MONGO_DOCKER_IMG}"

  ${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${MONGO_DOCKER_CONTAINER_NAME}" 1>/dev/null

  if [ $? == 0 ]; then
    ${DOCKER_CMD} stop ${MONGO_DOCKER_CONTAINER_NAME} 1>/dev/null
    ${DOCKER_CMD} rm -f ${MONGO_DOCKER_CONTAINER_NAME} 1>/dev/null
  fi

  ${DOCKER_CMD} start ${MONGO_DOCKER_CONTAINER_NAME} 1>/dev/null



  function local_volumes_mongo() {
    ## $(uname -s) i.e. Linux 
    local volumes="$(local_volumes) ${MONGODB_VOLUMES} "

    echo "${volumes}"
  }


  function port_maps_mongo() {
    local docker_ports="${MONGO_DB_PORTS} "

    echo "${docker_ports}"
  }

  function docker_envvars_mongo() {
    local envvars="$(docker_envvars) ${MONGO_DOCKER_ENVVARS} "

    echo "${envvars}"
  }

  echo "local_volumes_mongo: $(local_volumes_mongo)"
  echo "port_maps_mongo: $(port_maps_mongo)"
  echo "docker_envvars_mongo: $(docker_envvars_mongo)"

  # https://docs.docker.com/network/host/
  ## WARNING: Published ports are discarded when using host network mode

  ##TODO: config file throws permission error
  echo "${DOCKER_CMD} run -d -it \
    --name ${MONGO_DOCKER_CONTAINER_NAME} \
    $(docker_envvars_mongo) \
    $(port_maps_mongo) \
    $(local_volumes_mongo) \
    $(restart_policy) \
    -w ${WORK_BASE_PATH} \
    --net host \
    --add-host ${LOCAL_HOST}:127.0.0.1 \
    --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
    --hostname ${DOCKER_LOCAL_HOST} \
    --shm-size ${SHM_SIZE} \
    ${MONGO_DOCKER_IMG}"

  ${DOCKER_CMD} run -d -it \
    --name ${MONGO_DOCKER_CONTAINER_NAME} \
    $(docker_envvars_mongo) \
    $(port_maps_mongo) \
    $(local_volumes_mongo) \
    $(restart_policy) \
    -w ${WORK_BASE_PATH} \
    --net host \
    --add-host ${LOCAL_HOST}:127.0.0.1 \
    --add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
    --hostname ${DOCKER_LOCAL_HOST} \
    --shm-size ${SHM_SIZE} \
    ${MONGO_DOCKER_IMG}

  ## https://unix.stackexchange.com/questions/7704/what-is-the-meaning-of-in-a-shell-script
  ## $? provide us the execution status of last execute command on prompt.
  ## Value '0' denotes that the command was executed successfuly and '1' is for not success.
  if [ $? -ne 0 ];then
      error "Failed to start docker container \"${MONGO_DOCKER_CONTAINER_NAME}\" based on image: ${MONGO_DOCKER_IMG}"
      # exit 1
      return
  fi

  # info "MONGODB_USER:MONGODB_USER_ID:: $MONGODB_USER:$MONGODB_USER_ID"
  # info "MONGODB_GRP:MONGODB_GRP_ID:: $MONGODB_GRP:$MONGODB_GRP_ID"

  # ${DOCKER_CMD} exec ${MONGO_DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.mongodb.userfix.sh"

  # ${DOCKER_CMD} exec -u ${USER} -it ${MONGO_DOCKER_CONTAINER_NAME} "${WORK_BASE_PATH}/scripts/bootstrap.sh"

  echo -e "Finished setting up ${MONGO_DOCKER_CONTAINER_NAME} docker environment. Now you can enter with:\n source $(pwd)/docker.exec-mongo.sh ${MONGO_DOCKER_CONTAINER_NAME}"
  echo "Enjoy!"

  
  if [ "${HUSER}" != "root" ]; then
    ${DOCKER_CMD} exec ${MONGO_DOCKER_CONTAINER_NAME} /bin/bash -c "source ${SCRIPTS_BASE_PATH}/docker/docker.adduser.sh"
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

docker_createcontainer_mongo $1 $2
