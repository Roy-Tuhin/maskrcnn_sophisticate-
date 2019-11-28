#!/bin/bash

##----------------------------------------------------------
### tensorflow - CPU, GPU builds
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Dependency for building tensorflow from source
#
## Install Bazel, required for building tensorflow using sources
## https://docs.bazel.build/versions/master/install-ubuntu.html
#
##----------------------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

function bazel_install() {
  echo $SCRIPTS_DIR

  # # echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
  # # curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -

  # # sudo apt-get update && sudo apt-get install bazel

  # # # Error troubleshooting
  # # # https://askubuntu.com/questions/769467/can-not-install-openjdk-9-jdk-because-it-tries-to-overwrite-file-aready-includ
  # # #sudo apt-get -o Dpkg::Options::="--force-overwrite" install /var/cache/apt/archives/openjdk-9-jdk_9~b114-0ubuntu1_amd64.deb

  # # #sudo apt-get upgrade bazel

  ## /codehub/scripts/docker/dockerfiles/aidev-devel-gpu.Dockerfile
  # # ARG BAZEL_URL=${BAZEL_URL}
  # # RUN mkdir -p ${DOCKER_BASEPATH}/bazel && \
  # #     wget -O ${DOCKER_BASEPATH}/bazel/installer.sh ${BAZEL_URL} && \
  # #     wget -O ${DOCKER_BASEPATH}/bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
  # #     chmod +x ${DOCKER_BASEPATH}/bazel/installer.sh && \
  # #     ${DOCKER_BASEPATH}/bazel/installer.sh && \
  # #     rm -f ${DOCKER_BASEPATH}/bazel/installer.sh



  source $SCRIPTS_DIR/config.custom.sh

  local DIR="bazel"
  local PROG_DIR="$BASEPATH/$DIR"
  mkdir -p ${PROG_DIR}

  if [ -z ${BAZEL_VERSION} ]; then
    BAZEL_VERSION=1.1.0
  fi

  local URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/${DIR}-${BAZEL_VERSION}-installer-linux-x86_64.sh"

  echo "Number of threads will be used: $NUMTHREADS"
  echo "BASEPATH: $BASEPATH"
  echo "URL: $URL"
  echo "PROG_DIR: $PROG_DIR"

  if [ ! -f ${PROG_DIR}/installer-${BAZEL_VERSION}.sh ]; then
    wget -O ${PROG_DIR}/installer-${BAZEL_VERSION}.sh ${URL} && \
    wget -O ${PROG_DIR}/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x ${PROG_DIR}/installer-${BAZEL_VERSION}.sh && \
    sudo ${PROG_DIR}/installer-${BAZEL_VERSION}.sh
  else
    sudo ${PROG_DIR}/installer-${BAZEL_VERSION}.sh
  fi

}

bazel_install
