## Utilities
git lfs install && git lfs fetch


## Shell Script Snippets
ostype=$(uname -s) ## Linux, Darwin

function show_usage() {
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -C                     Pull docker image from China mirror.
    -h, --help             Display this help and exit.
    -t, --tag <version>    Specify which version of a docker image to pull.
    -l, --local            Use local docker image.
    stop                   Stop all running Apollo containers.
EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
    -C|--docker-cn-mirror)
        INCHINA="yes"
        ;;
    -image)
        echo -e "\033[093mWarning\033[0m: This option has been replaced by \"-t\" and \"--tag\", please use the new one.\n"
        show_usage
        ;;
    -t|--tag)
        VAR=$1
        [ -z $VERSION_OPT ] || echo -e "\033[093mWarning\033[0m: mixed option $VAR with $VERSION_OPT, only the last one will take effect.\n"
        shift
        VERSION_OPT=$1
        [ -z ${VERSION_OPT// /} ] && echo -e "Missing parameter for $VAR" && exit 2
        [[ $VERSION_OPT =~ ^-.* ]] && echo -e "Missing parameter for $VAR" && exit 2
        ;;
    dev-*) # keep backward compatibility, should be removed from further version.
        [ -z $VERSION_OPT ] || echo -e "\033[093mWarning\033[0m: mixed option $1 with -t/--tag, only the last one will take effect.\n"
        VERSION_OPT=$1
        echo -e "\033[93mWarning\033[0m: You are using an old style command line option which may be removed from"
        echo -e "further versoin, please use -t <version> instead.\n"
        ;;
    -h|--help)
        show_usage
        ;;
    -l|--local)
        LOCAL_IMAGE="yes"
        ;;
    --map)
        map_name=$2
        shift
        source ${APOLLO_ROOT_DIR}/docker/scripts/restart_map_volume.sh \
            "${map_name}" "${VOLUME_VERSION}"
        ;;
    stop)
  stop_containers
  exit 0
  ;;
    *)
        echo -e "\033[93mWarning\033[0m: Unknown option: $1"
        exit 2
        ;;
    esac
    shift
done


## Docker Snippets
function stop_containers() {
  running_containers=$(docker ps --format "{{.Names}}")

  for i in ${running_containers[*]}
  do
    if [[ "$i" =~ $docker_container_prefix* ]];then
      printf %-*s 70 "stopping container: $i ..."
      docker stop $i > /dev/null
      if [ $? -eq 0 ];then
        printf "\033[32m[DONE]\033[0m\n"
      else
        printf "\033[31m[FAILED]\033[0m\n"
      fi
    fi
  done
}


info "Start docker container based on local image : $IMG"
docker pull $IMG

DEFAULT_MAPS=(
  sunnyvale_big_loop
  sunnyvale_hdl128
  sunnyvale_loop
  sunnyvale_with_two_offices
  san_mateo
  san_mateo_hdl64
)
MAP_VOLUME_CONF=""

map_version="latest"

VOLUME_VERSION="latest"

for map_name in ${DEFAULT_MAPS[@]}; do
  # source ${APOLLO_ROOT_DIR}/docker/scripts/restart_map_volume.sh ${map_name} "${VOLUME_VERSION}"


  MAP_VOLUME="apollo_map_volume-${map_name}_${USER}"
  if [[ ${MAP_VOLUME_CONF} == *"${MAP_VOLUME}"* ]]; then
    echo "Map ${map_name} has already been included!"
  else
    docker stop ${MAP_VOLUME} > /dev/null 2>&1

    MAP_VOLUME_IMAGE=${DOCKER_REPO}:map_volume-${map_name}-${map_version}
    docker pull ${MAP_VOLUME_IMAGE}
    docker run -it -d --rm --name ${MAP_VOLUME} ${MAP_VOLUME_IMAGE}
    MAP_VOLUME_CONF="${MAP_VOLUME_CONF} --volumes-from ${MAP_VOLUME}"
  fi
done
MAP_VOLUME="apollo_map_volume-${map_name}_${USER}"
MAP_VOLUME_CONF="${MAP_VOLUME_CONF} --volumes-from ${MAP_VOLUME}"

LOCALIZATION_VOLUME=apollo_localization_volume_$USER
docker stop ${LOCALIZATION_VOLUME} > /dev/null 2>&1

LOCALIZATION_VOLUME_IMAGE=${DOCKER_REPO}:localization_volume-${ARCH}-latest
docker pull ${LOCALIZATION_VOLUME_IMAGE}
docker run -it -d --rm --name ${LOCALIZATION_VOLUME} ${LOCALIZATION_VOLUME_IMAGE}

YOLO3D_VOLUME=apollo_yolo3d_volume_$USER
docker stop ${YOLO3D_VOLUME} > /dev/null 2>&1

YOLO3D_VOLUME_IMAGE=${DOCKER_REPO}:yolo3d_volume-${ARCH}-latest
docker pull ${YOLO3D_VOLUME_IMAGE}
docker run -it -d --rm --name ${YOLO3D_VOLUME} ${YOLO3D_VOLUME_IMAGE}

${DOCKER_CMD} run -it \
        -d \
        --privileged \
        --name $APOLLO_DEV \
        ${MAP_VOLUME_CONF} \
        --volumes-from ${LOCALIZATION_VOLUME} \
        --volumes-from ${YOLO3D_VOLUME} \
        -e DISPLAY=$display \
        -e DOCKER_USER=$USER \
        -e USER=$USER \
        -e DOCKER_USER_ID=$USER_ID \
        -e DOCKER_GRP="$GRP" \
        -e DOCKER_GRP_ID=$GRP_ID \
        -e DOCKER_IMG=$IMG \
        -e USE_GPU=$USE_GPU \
        $(local_volumes) \
        --net host \
        -w /apollo \
        --add-host in_dev_docker:127.0.0.1 \
        --add-host ${LOCAL_HOST}:127.0.0.1 \
        --hostname in_dev_docker \
        --shm-size 2G \
        --pid=host \
        -v /dev/null:/dev/raw1394 \
        $IMG \
        /bin/bash


docker_container_prefix="apollo_"
AIMLDL_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
BASE_DIR='aimldl'

if [ ! -e /$BASE_DIR ]; then
    sudo ln -sf ${AIMLDL_ROOT_DIR} /$BASE_DIR
fi