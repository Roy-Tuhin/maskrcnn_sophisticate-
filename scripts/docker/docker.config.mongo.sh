MONGO_DOCKER_PREFIX="aimldl"
MONGO_DOCKER_IMG="mongouid"
MONGO_DOCKER_CONTAINER_NAME="${MONGO_DOCKER_PREFIX}-${MONGO_DOCKER_IMG}"
## MongoDB configurations
HOST_MONGODB_PORTS="27017"
DOCKER_MONGODB_PORTS="27017"
MONGODB_CONFIG_FILE="/codehub/config/mongod.conf"
# MONGO_INITDB_ROOT_USERNAME=""
# MONGO_INITDB_ROOT_PASSWORD=""
MONGODB_USER=$(id -un mongodb)
MONGODB_USER_ID=$(id -u mongodb)
MONGODB_GRP=$(id -gn mongodb)
MONGODB_GRP_ID=$(id -g mongodb)
#
MONGODB_VOLUMES=""
# MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat:/aimldl-dat "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat/data-mongodb:/data "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat/data-mongodb/db:/data/db "
MONGODB_VOLUMES="${MONGODB_VOLUMES} -v /aimldl-dat/data-mongodb/configdb:/data/configdb "
#
MONGO_DB_PORTS=""
MONGO_DB_PORTS="${MONGO_DB_PORTS} -p ${HOST_MONGODB_PORTS}:${DOCKER_MONGODB_PORTS}"
#
## mongodb user fix
MONGO_DOCKER_ENVVARS=""
MONGO_DOCKER_ENVVARS="${MONGO_DOCKER_ENVVARS} -e MONGODB_USER=${MONGODB_USER} "
MONGO_DOCKER_ENVVARS="${MONGO_DOCKER_ENVVARS} -e MONGODB_USER_ID=${MONGODB_USER_ID} "
MONGO_DOCKER_ENVVARS="${MONGO_DOCKER_ENVVARS} -e MONGODB_GRP=${MONGODB_GRP} "
MONGO_DOCKER_ENVVARS="${MONGO_DOCKER_ENVVARS} -e MONGODB_GRP_ID=${MONGODB_GRP_ID} "
