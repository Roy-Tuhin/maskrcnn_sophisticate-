#!/bin/bash

##----------------------------------------------------------
## libLAS
## Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://www.liblas.org
## https://github.com/libLAS/libLAS
#
##----------------------------------------------------------
## Change Log
##----------------------------------------------------------
## 2nd-Aug-2018
##---------------
## 1. Passed the required flags to cmake and hence ccmake is not required.
##    This is the step towards single script full-automation installation.
#
##----------------------------------------------------------


function libLAS_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  PROG='libLAS'
  DIR="${PROG}"
  PROG_DIR="${BASEPATH}/${PROG}"

  URL="https://github.com/libLAS/${PROG}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  cd ${PROG_DIR}
  git pull
  git checkout ${LIBLAS_REL}

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  cmake -D WITH_GDAL=ON \
        -D WITH_GEOTIFF=ON \
        -D WITH_LASZIP=OFF \
        -D WITH_PKGCONFIG=ON \
        -D WITH_TESTS=ON \
        -D WITH_UTILITIES=ON \
        -D CMAKE_CXX_STANDARD=11 \
        -D CMAKE_CXX_STANDARD_REQUIRED=ON \
        -D CMAKE_CXX_EXTENSIONS=OFF \
        -D GDAL_DIR=${BASEPATH}/gdal-${GDAL_VER} \
        -D PROJ4_DIR=${BASEPATH}/proj-${PROJ_VER} \
        -D TIFF_DIR=${BASEPATH}/tiff-${TIFF_VER} ..
        # -D LASzip_DIR=${BASEPATH}/LASzip \
      # -D ZLIB_DIR=${BASEPATH}/zlib

  # -D WITH_LASZIP=ON gives error
  # provide the path to gdal, laszip, proj4j, tiff source directory
  ## ccmake ..
  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}

# https://github.com/libLAS/libLAS/issues/140
# https://github.com/libLAS/libLAS/issues/164

# https://gitweb.gentoo.org/repo/gentoo.git/tree/sci-geosciences/liblas/files/liblas-1.8.1-fix-overload-call.patch
# change to
# double primemValue = poSRS->GetPrimeMeridian();
# double aUnit = poSRS->GetAngularUnits();

# comment OSRFixupOrdering()

# /codehub/external/libLAS/src/gt_citation.cpp:390:58: error: call of overloaded ‘GetPrimeMeridian(NULL)’ is ambiguous
#          double primemValue = poSRS->GetPrimeMeridian(NULL);

# /codehub/external/libLAS/src/gt_citation.cpp:393:55: error: call of overloaded ‘GetAngularUnits(NULL)’ is ambiguous
#              double aUnit = poSRS->GetAngularUnits(NULL);


# /codehub/external/libLAS/src/gt_wkt_srs.cpp:492:18: error: ‘class OGRSpatialReference’ has no member named ‘FixupOrdering’
#              oSRS.FixupOrdering();
#                   ^~~~~~~~~~~~~
# /codehub/external/libLAS/src/gt_wkt_srs.cpp:1093:10: error: ‘class OGRSpatialReference’ has no member named ‘FixupOrdering’
#      oSRS.FixupOrdering();

}

libLAS_install
