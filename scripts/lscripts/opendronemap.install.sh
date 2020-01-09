#!/bin/bash

##----------------------------------------------------------
## OpenDroneMap
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/OpenDroneMap/OpenDroneMap
## https://github.com/OpenDroneMap/OpenDroneMap/wiki/Installation
#
##----------------------------------------------------------


function opendronemap_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${OpenDroneMap_REL}" ]; then
    local OpenDroneMap_REL="v0.9.1"
    echo "Unable to get OpenDroneMap_REL version, falling back to default version#: ${OpenDroneMap_REL}"
  fi

  local DIR="OpenDroneMap"
  local PROG_DIR="${BASEPATH}/${DIR}"

  local URL="https://github.com/OpenDroneMap/${DIR}.git"

  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then  
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  git pull
  git checkout ${OpenDroneMap_REL}

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  bash configure.sh install

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  cmake ..
  ccmake ..
  # make -j$NUMTHREADS
  # sudo make install -j$NUMTHREADS


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  ##---------------------
  ## Ubuntu 18.04 LTS
  ##---------------------

   # ** WARNING ** io features related to pcap will be disabled

   # ** WARNING ** io features related to png will be disabled

   # ** WARNING ** io features related to libusb-1.0 will be disabled

   # ** WARNING ** io features related to pcap will be disabled

   # ** WARNING ** io features related to png will be disabled

   # ** WARNING ** io features related to libusb-1.0 will be disabled

   # ** WARNING ** io features related to pcap will be disabled

   # ** WARNING ** io features related to png will be disabled

   # ** WARNING ** io features related to libusb-1.0 will be disabled

   # ** WARNING ** io features related to pcap will be disabled

   # ** WARNING ** io features related to png will be disabled

   # ** WARNING ** io features related to libusb-1.0 will be disabled

   # CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
   # Please set them or make sure they are set and tested correctly in the CMake files:
   # EXIV2_LIBRARY
   #     linked by target "odm_extract_utm" in directory /home/game1/softwares/OpenDroneMap/modules/odm_extract_utm

  # http://www.exiv2.org/

  # export LD_LIBRARY_PATH="/home/game1/softwares/exiv2-0.26-linux/dist/linux/lib:$LD_LIBRARY_PATH"

  # git clone https://github.com/Exiv2/exiv2


  ##---------------------
  ## Ubuntu 16.04 LTS
  ##---------------------

  # ** WARNING ** io features related to pcap will be disabled
  # ** WARNING ** io features related to png will be disabled
  # ** WARNING ** io features related to libusb-1.0 will be disabled
  # -- QHULL found (include: /usr/include, lib: optimized;/usr/lib/x86_64-linux-gnu/libqhull.so;debug;/usr/lib/x86_64-linux-gnu/libqhull.so)
  # -- looking for PCL_COMMON


  # CMake Error at modules/odm_25dmeshing/CMakeLists.txt:9 (find_package):
  #   Could not find a configuration file for package "VTK" that is compatible
  #   with requested version "7.1.1".

  #   The following configuration files were considered but not accepted:

  #     /usr/local/lib/cmake/vtk-8.1/VTKConfig.cmake, version: 8.1.0
  #     /usr/lib/vtk-5.10/VTKConfig.cmake, version: 5.10.1



  # CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
  # Please set them or make sure they are set and tested correctly in the CMake files:
  # EXIV2_LIBRARY
  #     linked by target "odm_extract_utm" in directory /home/thanos/softwares/OpenDroneMap/modules/odm_extract_utm

  # -- Configuring incomplete, errors occurred!
  # See also "/home/thanos/softwares/OpenDroneMap/build/CMakeFiles/CMakeOutput.log".
  # See also "/home/thanos/softwares/OpenDroneMap/build/CMakeFiles/CMakeError.log".
  # thanos@avengers:~/softwares/OpenDroneMap/build$ 
}

opendronemap_install

