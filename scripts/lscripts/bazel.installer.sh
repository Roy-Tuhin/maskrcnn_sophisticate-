#!/bin/bash

##----------------------------------------------------------
### tensorflow - CPU, GPU builds
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------
#
## Dependency for building tensorflow from source
#
## Install Bazel, required for building tensorflow using sources
## https://docs.bazel.build/versions/master/install-ubuntu.html
#
##----------------------------------------------------------


function bazel_install() {
  local SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  echo ${SCRIPTS_DIR}
  source ${SCRIPTS_DIR}/lscripts.config.sh

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

  local DIR="bazel"
  local PROG_DIR="${BASEPATH}/${DIR}"
  mkdir -p ${PROG_DIR}

  if [ -z ${BAZEL_VER} ]; then
    BAZEL_VER=1.1.0
  fi
  if [ -z ${BAZEL_URL} ]; then
    BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/${DIR}-${BAZEL_VER}-installer-linux-x86_64.sh"
  fi

  local URL=${BAZEL_URL}

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${PROG_DIR}/installer-${BAZEL_VER}.sh ]; then
    wget -O ${PROG_DIR}/installer-${BAZEL_VER}.sh ${URL} && \
    wget -O ${PROG_DIR}/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x ${PROG_DIR}/installer-${BAZEL_VER}.sh && \
    sudo ${PROG_DIR}/installer-${BAZEL_VER}.sh
  else
    sudo ${PROG_DIR}/installer-${BAZEL_VER}.sh
  fi

  ## for multiple version
  sudo mv /usr/local/lib/bazel /usr/local/lib/bazel-${BAZEL_VER}
  sudo ln -s /usr/local/lib/bazel-${BAZEL_VER} /usr/local/lib/bazel

  sudo update-alternatives --install /usr/local/bin/bazel bazel /usr/local/lib/bazel-${BAZEL_VER}/bin/bazel 200
  # sudo update-alternatives --config bazel
  echo "To configure multiple versions of bazel, Ref: ${SCRIPTS_DIR}/bazel-update-alternatives.sh"

  which bazel
  bazel version

}

bazel_install
