#!/bin/bash

##----------------------------------------------------------
## pgpointcloud
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/pgpointcloud/pointcloud
## A PostgreSQL extension for storing point cloud (LIDAR) data.
#
##----------------------------------------------------------
## Dependencies
##----------------------------------------------------------
#
## pg_regress
## https://stackoverflow.com/questions/37693416/how-can-i-get-pg-regress
##-- Setting POINTCLOUD build type - RelWithDebInfo
##-- Could NOT find CUnit (missing: CUNIT_LIBRARY CUNIT_INCLUDE_DIR) 
##-- Could NOT find LibGHT (missing: LIBGHT_LIBRARY LIBGHT_INCLUDE_DIR) 
##-- Could NOT find LazPerf (missing: LAZPERF_INCLUDE_DIR) 
#
## pointcloud/pgsql/pc_pgsql.h:14:22: fatal error: postgres.h: No such file or directory compilation terminated
#
## Could NOT find LibGHT (missing: LIBGHT_LIBRARY LIBGHT_INCLUDE_DIR) - Optional
## https://github.com/pramsey/libght/
## https://github.com/pgpointcloud/pointcloud/issues/196
#
##---------------------------------------


function pgpointcloud_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## Un-comment or install separately
  ## If followed the given sequence, this would already be installed

  # source ${LSCRIPTS}/libght.install.sh

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  sudo -E apt -q -y install postgresql-server-dev-all

  DIR="pointcloud"
  PROG_DIR="${BASEPATH}/${DIR}"

  URL="https://github.com/pgpointcloud/${DIR}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  ./autogen.sh
  ./configure
  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}
  # test
  make check -j${NUMTHREADS}

  cd ${LSCRIPTS}
}

pgpointcloud_install
