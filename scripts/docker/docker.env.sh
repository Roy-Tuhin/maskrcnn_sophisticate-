#!/usr/bin/env bash

### -------------------------------------------
## Docker Global Variables 
### -------------------------------------------

DOCKER_CMD="docker"
DOCKER_HOME="/home/${USER}"

DOCKER_PREFIX="aimldl"
DOCKER_IMG="mongouid"
# DOCKER_IMG="mongo"
# DOCKER_IMG="ubuntu"
DOCKER_CONTAINER_NAME="${DOCKER_PREFIX}-${DOCKER_IMG}"

DOCKER_VOLUMES=""
# DOCKER_CONFIG_FILE=""

DOCKER_LOCAL_HOST="aimldl-docker"

## Working directory inside the container
SCRIPTS_BASE_PATH="/${DOCKER_PREFIX}-scripts"
DATA_BASE_PATH="/${DOCKER_PREFIX}-dat"
WORK_BASE_PATH="/${DOCKER_PREFIX}-cod"
CONF_BASE_PATH="/${DOCKER_PREFIX}-cfg"
MNT_BASE_PATH="/${DOCKER_PREFIX}-mnt"

## MongoDB configurations
HOST_MONGODB_PORTS="27017"
DOCKER_MONGODB_PORTS="27017"
MONGODB_CONFIG_FILE="${CONF_BASE_PATH}/config/mongod.conf"
# MONGO_INITDB_ROOT_USERNAME=""
# MONGO_INITDB_ROOT_PASSWORD=""
MONGODB_USER=$(id -un mongodb)
MONGODB_USER_ID=$(id -u mongodb)
MONGODB_GRP=$(id -gn mongodb)
MONGODB_GRP_ID=$(id -g mongodb)



## Map Data Volumens form host to inside docker container path
## Customise this as per the requirement
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DATA_BASE_PATH}:${DATA_BASE_PATH}"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${WORK_BASE_PATH}:${WORK_BASE_PATH}"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${CONF_BASE_PATH}:${CONF_BASE_PATH}"

DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DATA_BASE_PATH}/data-mongodb:/data"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DATA_BASE_PATH}/data-mongodb/db:/data/db"
DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${DATA_BASE_PATH}/data-mongodb/configdb:/data/configdb"
##TODO: config file throws permission error
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${MONGODB_CONFIG_FILE}:/etc/mongod.conf"

SHM_SIZE=2G

## Additional mapping if required:
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${HOME}/Downloads:/home/${USER}/Downloads"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${HOME}/Documents:/home/${USER}/Documents"
# DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${HOME}/softwares/linuxscripts:${DATA_BASEDIR}/linuxscripts"

if [ "${USER}" == "root" ];then
    DOCKER_HOME="/root"
fi

# ## TODO: docker commands
# # docker pull mongodb
# # sudo service docker start
# # docker container ls -a
# # docker inspect -f '{{.State.Running}}' ${DOCKER_IMG}
# # docker container start ${DOCKER_IMG}
