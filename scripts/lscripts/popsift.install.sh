#!/bin/bash
##----------------------------------------------------------
# popsift
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/alicevision/popsift
## PopSift is an implementation of the SIFT algorithm in CUDA. PopSift tries to stick as closely as possible to David Lowe's famous paper (Lowe, D. G. (2004). Distinctive Image Features from Scale-Invariant Keypoints. International Journal of Computer Vision, 60(2), 91–110. doi:10.1023/B:VISI.0000029664.99615.94), while extracting features from an image in real-time at least on an NVidia GTX 980 Ti GPU.
#
##----------------------------------------------------------



function popsift_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## upgrade to cmake 3.16.0
  ## https://codeyarns.com/2019/03/20/caffe-cuda_cublas_device_library-error/
  # source ${LSCRIPTS}/cmake.upgrade.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  sudo apt install libdevil-dev

  local PROG="popsift"
  local DIR="${PROG}"
  local PROG_DIR="${BASEPATH}/${PROG}"

  local URL="https://github.com/alicevision/${PROG}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    ## git version 1.6+
    # git clone --recursive ${URL}

    ## git version >= 2.8
    # git clone --recurse-submodules -j8 ${URL} ${PROG_DIR}
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  cmake ..

  # cmake -D BUILD_SHARED_LIBS=ON \
  #   -D CMAKE_EXE_LINKER_FLAGS=-L/usr/local/lib \
  #   -D CMAKE_INSTALL_PREFIX=/usr/local \
  #   -D CMAKE_CXX_FLAGS=-I/usr/local/include \
  #   -D CMAKE_C_FLAGS="-I/usr/local/include -L/usr/local/lib" ..

  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  # libIL.so: undefined reference to `TIFFSetErrorHandler@LIBTIFF_4.0'

  # https://codeyarns.com/2019/03/20/caffe-cuda_cublas_device_library-error/

  # CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
  # Please set them or make sure they are set and tested correctly in the CMake files:
  # CUDA_cublas_device_LIBRARY (ADVANCED)
  #     linked by target "popsift" in directory /codehub/external/popsift/src

  # -- Configuring incomplete, errors occurred!
  # See also "/codehub/external/popsift/build/CMakeFiles/CMakeOutput.log".
  # See also "/codehub/external/popsift/build/CMakeFiles/CMakeError.log".

}

popsift_install
