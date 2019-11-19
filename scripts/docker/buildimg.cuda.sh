#/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"
source "${SCRIPTS_DIR}/lscripts/utils/common.sh"

# export IMAGE_NAME="nvidia/cuda"

# export OS="ubuntu16.04"
# export CUDA_VERSION="9.0"


# # export OS="ubuntu18.04"
# # export CUDA_VERSION="10.0"
# # export CUDNN_VERSION="7.6.4.38"

# docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-base-${OS}" "dist/${OS}/${CUDA_VERSION}/base"
# # docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-runtime-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "dist/${OS}/${CUDA_VERSION}/runtime"
# # docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "dist/${OS}/${CUDA_VERSION}/devel"

# # docker build -t "${IMAGE_NAME}:${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}" --build-arg "IMAGE_NAME=${IMAGE_NAME}" "dist/${OS}/${CUDA_VERSION}/devel/cudnn7"


# ## https://hub.docker.com/r/nvidia/cuda

# docker run --name cudnn-devel-u18.04 --gpus all -u $(id -u):$(id -g) -v /codehub:/codehub -it --rm nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04

###-------------------------------------

DOCKER_CMD="docker"
DOCKER_HOME="/home/${USER}"
# DOCKER_IMG="ai-devel-v1"
DOCKER_IMG="nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04"
DOCKER_PREFIX="codehub"

DOCKER_CONTAINER_NAME="${DOCKER_PREFIX}-cudnn-devel-u18.04"

WORK_BASE_PATH="/codehub"
SHM_SIZE=2G
DOCKER_LOCAL_HOST="${DOCKER_PREFIX}-docker"
SCRIPTS_BASE_PATH="/${DOCKER_PREFIX}-scripts"

DOCKER_VOLUMES=""
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${SCRIPTS_DIR}:${SCRIPTS_BASE_PATH}"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v /codehub:/codehub"
LOCAL_HOST=`hostname`

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
  echo "${envvars}"
}

# function port_maps() {
#   local mongo_db_ports="-p ${HOST_MONGODB_PORTS}:${DOCKER_MONGODB_PORTS}"
#   local docker_ports="${mongo_db_ports}"

#   echo "${docker_ports}"
# }

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


${DOCKER_CMD} ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null
if [ $? == 0 ]; then
  ${DOCKER_CMD} stop ${DOCKER_CONTAINER_NAME} 1>/dev/null
  ${DOCKER_CMD} rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null
fi

${DOCKER_CMD} run -d \
--name ${DOCKER_CONTAINER_NAME} \
--gpus all \
$(docker_envvars) \
$(local_volumes) \
-w ${WORK_BASE_PATH} \
--add-host ${LOCAL_HOST}:127.0.0.1 \
--add-host ${DOCKER_LOCAL_HOST}:127.0.0.1 \
--hostname ${DOCKER_LOCAL_HOST} \
--shm-size ${SHM_SIZE} \
${DOCKER_IMG}


if [ $? -ne 0 ];then
    error "Failed to start docker container \"${DOCKER_CONTAINER_NAME}\" based on image: $DOCKER_IMG"
    # exit 1
    return
fi

if [ "${USER}" != "root" ]; then
  docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "${SCRIPTS_BASE_PATH}/docker/docker.adduser.sh"
  docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chown -R ${USER}:${GRP} ${WORK_BASE_PATH}"
  docker exec ${DOCKER_CONTAINER_NAME} /bin/bash -c "chmod a+w ${WORK_BASE_PATH}"
fi


function main() {
    docker ps -a --format "{{.Names}}" | grep "${DOCKER_CONTAINER_NAME}" 1>/dev/null
    if [ $? == 0 ]; then
      docker stop ${DOCKER_CONTAINER_NAME} 1>/dev/null
      docker rm -f ${DOCKER_CONTAINER_NAME} 1>/dev/null
    fi

    info $(local_volumes)
    
    ##TODO: config file throws permission error
    # ${DOCKER_CMD} run -it -d --privileged \
    # ${DOCKER_CMD} run \
${DOCKER_CMD} run -it \
--name ${DOCKER_CONTAINER_NAME} \
--gpus all \
$(docker_envvars) \
$(local_volumes) \
-w ${WORK_BASE_PATH} \
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

    ok "Finished setting up ${DOCKER_CONTAINER_NAME} docker environment. Now you can enter with: \n source ${SCRIPTS_DIR}/docker/docker.exec.sh"
    ok "Enjoy!"
}


## docker run -dit --rm --name codehub-cudnn-devel-u18.04 --gpus all -e DOCKER_IMG=nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04 -e DISPLAY=:0.0  -e USER=baaz  -e DOCKER_USER=baaz -e DOCKER_USER_ID=1000 -e DOCKER_GRP=baaz -e DOCKER_GRP_ID=1000  -v /codehub/scripts:/codehub-scripts -v /codehub:/codehub -v /home/baaz/.cache:/home/baaz/.cache -v /dev:/dev -v /media:/media -v /tmp/.X11-unix:/tmp/.X11-unix:rw  -v /etc/localtime:/etc/localtime:ro  -v /usr/src:/usr/src  -v /lib/modules:/lib/modules -w /codehub --net `hostname` --add-host codehub-docker:127.0.0.1 --hostname codehub-docker  --shm-size 2G  nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04

## docker run --name cudnn-devel-u18.04 --gpus all -u $(id -u):$(id -g) -v /codehub:/codehub -it --rm ${DOCKER_IMG}

main
