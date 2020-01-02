#!/bin/bash

##----------------------------------------------------------
### meshlab
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://www.meshlab.net
#
## Compiling from sources
## https://github.com/cnr-isti-vclab/meshlab/tree/master/src
#
## http://linuxg.net/how-to-install-meshlab-1-3-3-on-ubuntu-linux-mint-and-elementary-os-via-ppa/
## https://ci.appveyor.com/project/cignoni/meshlab
#
## meshlap_full.pro fails with error for plugin compilation
## https://github.com/cnr-isti-vclab/meshlab/blob/master/src/READit stME.md
#
## https://snapcraft.io/install/meshlab/ubuntu
#
##----------------------------------------------------------

function meshlab_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  # sudo -E apt-add-repository ppa:zarquon42/meshlab
  # sudo -E apt -y update
  # sudo -E apt -q -y install meshlab


  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  local DIR="meshlab"
  local PROG_DIR="${BASEPATH}/${DIR}"

  local URL="https://github.com/cnr-isti-vclab/${DIR}.git"

  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then  
    git -C ${PROG_DIR} || git clone --depth 1 ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  # https://github.com/cnr-isti-vclab/meshlab/pull/68

  # sudo apt-get install qt5-qmake g++ qtscript5-dev libqt5xmlpatterns5-dev libqt5opengl5-dev
  # qmake -qt=5 -v

  # git clone --depth 1 git@github.com:cnr-isti-vclab/meshlab.git
  # git clone --depth 1 git@github.com:cnr-isti-vclab/vcglib.git -b devel

  # cd meshlab

  # export QMAKE_FLAGS="-spec linux-g++ CONFIG+=release CONFIG+=qml_release CONFIG+=c++11QMAKE_CXXFLAGS+=-fPIC QMAKE_CXXFLAGS+=-std=c++11 QMAKE_CXXFLAGS+=-fpermissive INCLUDEPATH+=/usr/include/eigen3 LIBS+=-L`pwd`/lib/linux-g++"
  # export MAKE_FLAGS="-j${NUMTHREADS}"

  # cd ${PROG_DIR}/src/external
  # qmake -qt=5 external.pro $QMAKE_FLAGS && make $MAKE_FLAGS
  # cd ../common
  # qmake -qt=5 common.pro $QMAKE_FLAGS && make $MAKE_FLAGS
  # cd ..
  # qmake -qt=5 meshlab_mini.pro $QMAKE_FLAGS && make $MAKE_FLAGS
  # qmake -qt=5 meshlab_full.pro $QMAKE_FLAGS && make $MAKE_FLAGS

  # ## ./distrib/meshlab

  # cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  # https://github.com/cnr-isti-vclab/meshlab/issues/47
  # http://mpir.org/downloads.html

  ## Issue with vcglib
  ## https://github.com/cnr-isti-vclab/meshlab/issues/258
}

# meshlab_install


sudo apt -y install snapd
sudo snap -y install meshlab
