#!/bin/bash

##----------------------------------------------------------
## Simple-Web-Server
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/eidheim/Simple-Web-Server
## A very simple, fast, multithreaded, platform independent HTTP and HTTPS server and client library implemented using C++11 and Asio (both Boost.Asio and standalone Asio can be used). Created to be an easy way to make REST resources available from C++ applications.
#
## C++ IDE supporting C++11/14/17: https://gitlab.com/cppit/jucipp.
#
##----------------------------------------------------------


function simple_webserver_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="$HOME/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${SIMPLE_WEB_SERVER_VER}" ]; then
    local SIMPLE_WEB_SERVER_VER="v3.0.2"
    echo "Unable to get SIMPLE_WEB_SERVER_VER version, falling back to default version#: ${SIMPLE_WEB_SERVER_VER}"
  fi

  local DIR="Simple-Web-Server"
  local PROG_DIR="${BASEPATH}/${DIR}"

  # local URL="https://github.com/eidheim/${DIR}.git"
  local URL="https://gitlab.com/eidheim/${DIR}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Gid clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  git pull
  git checkout ${SIMPLE_WEB_SERVER_VER}

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  cmake ..

  ### not required
  ## ccmake ..

  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}

  # Run the server and client examples: ./build/http_examples
  # Direct your favorite browser to for instance http://localhost:8080/
}

simple_webserver_install
