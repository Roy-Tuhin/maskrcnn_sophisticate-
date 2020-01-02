#!/bin/bash

##----------------------------------------------------------
# cmake, ccmake
## Tested on Ubuntu 16.04
#
# Upgrade to latest version of cmake
# sudo apt install cmake the installed version was 3.5.1, [Ubuntu 16.04]
#
## http://www.cmake.org/download
## https://askubuntu.com/questions/355565/how-do-i-install-the-latest-version-of-cmake-from-the-command-line/865294
## https://cmake.org/Wiki/CMake_Useful_Variables
#
##----------------------------------------------------------


function cmake_upgrade() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  cmake --version

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${CMAKE_VER}" ]; then
    local CMAKE_VER="3.14"
    local CMAKE_BUILD="0"
    local CMAKE_REL="${CMAKE_VER}.${CMAKE_BUILD}"
    echo "Unable to get CMAKE_REL version, falling back to default version#: ${CMAKE_REL}"
  fi

  local DIR="cmake-${CMAKE_REL}"
  local PROG_DIR="${BASEPATH}/${DIR}"
  local FILE="${DIR}.tar.gz"

  local URL="https://cmake.org/files/v${CMAKE_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  # exit -1 #testing
  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo Not downloading as: ${HOME}/Downloads/${FILE} already exists!
  fi

  if [ ! -d ${PROG_DIR} ]; then
    # tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #verbose
    tar xfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #silent mode
    echo "Extracting File: ${HOME}/Downloads/${FILE} here: ${PROG_DIR}"
    echo "Extracting...DONE!"
  else
    echo "Extracted Dir already exists: ${PROG_DIR}"
  fi

  ## Install *-dev packages for maxium functionality support with cmake
  sudo -E apt install -y libncurses5-dev # BUILD_CursesDialog:ON, builds: ccmake
  sudo -E apt install -y libjsoncpp-dev #CMAKE_USE_SYSTEM_JSONCPP
  sudo -E apt install -y bzip2 libbz2-dev #CMAKE_USE_SYSTEM_BZIP2, CMAKE_USE_SYSTEM_LIBLZMA
  sudo -E apt install -y libarchive-dev #CMAKE_USE_SYSTEM_LIBARCHIVE
  sudo -E apt install -y librhash-dev	#CMAKE_USE_SYSTEM_LIBRHASH
  #sudo -E apt install -y libuv1-dev #CMAKE_USE_SYSTEM_LIBUV ## Compilation gave error

  cd ${PROG_DIR}
  ./bootstrap
  ccmake .

  # ccmake -D CMAKE_USE_SYSTEM_CURL=ON  \
  #   -D CMAKE_USE_SYSTEM_EXPAT=ON  \
  #   -D CMAKE_USE_SYSTEM_FORM=ON  \
  #   -D CMAKE_USE_SYSTEM_JSONCPP=ON  \
  #   -D CMAKE_USE_SYSTEM_LIBARCHIVE=OFF \
  #   -D CMAKE_USE_SYSTEM_LIBLZMA=ON \
  #   -D CMAKE_USE_SYSTEM_LIBRHASH=OFF \
  #   -D CMAKE_USE_SYSTEM_LIBUV=ON . 

  make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # # The cmake --version command only works after open a new terminal because cmake is installed under /usr/local/bin/ by default, not /usr/bin
  # bash cmake --version
  # ./configure --prefix=/usr/local --qt-gui

  # # https://ubuntuforums.org/showthread.php?t=1764127
  # sudo apt-get install qt4-qtconfig
  # ldd /usr/bin/qtconfig-qt4

  # # qtchooser -print-env
  # # QT_SELECT="qt5"
  # # QTTOOLDIR="/usr/lib/x86_64-linux-gnu/qt5/bin"
  # # QTLIBDIR="/usr/lib/x86_64-linux-gnu"

  ## sudo apt autoremove '.*qt5.*-dev'


  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  ## CMAKE_USE_SYSTEM_BZIP2           ON           
  ## bzip2 is a free and open-source file compression program that uses the Burrows–Wheeler algorithm. It only compresses single files and is not a file archiver. It is developed and maintained by Julian Seward
  ## --------
  ## CMAKE_USE_SYSTEM_JSONCPP         ON       
  ## https://en.wikiversity.org/wiki/JsonCpp
  ## the JsonCpp library (also called jsoncpp and json-cpp), JsonCpp is probably the most popular library for working with JSON databases in C++. It can parse and save databases, and provides an extensive library for accessing and manipulating their members. JsonCpp works with both files and strings. 
  ## --------
  ## CMAKE_USE_SYSTEM_LIBARCHIVE      ON      
  ## Libarchive is an open-source BSD-licensed C programming library that provides streaming access to a variety of different archive formats, including tar, cpio, pax, Zip, and ISO9660 images. The distribution also includes bsdtar and bsdcpio, full-featured implementations of tar and cpio that use libarchive.
  ## --------
  ## CMAKE_USE_SYSTEM_LIBLZMA         ON   
  ## https://github.com/libarchive/libarchive/wiki
  ## The Lempel–Ziv–Markov chain algorithm (LZMA) is an algorithm used to perform lossless data compression. It has been under development either since 1996 or 1998 and was first used in the 7z format of the 7-Zip archiver.
  ## --------
  ## CMAKE_USE_SYSTEM_LIBUV           OFF
  ## libuv is a multi-platform C library that provides support for asynchronous I/O based on event loops. It supports epoll, kqueue, Windows IOCP, and Solaris event ports.                                                                                                                                                       
  ## --------
  ## Successfully built with following configuation
  ## --------
  ## BUILD_CursesDialog               ON                                                                                                                                                           
  ## BUILD_QtDialog                   ON                                                                                                                                                          
  ## BUILD_TESTING                    OFF                                                                                                                                                          
  ## BZIP2_INCLUDE_DIR                BZIP2_INCLUDE_DIR-NOTFOUND                                                                                                                                   
  ## CMAKE_BUILD_TYPE                                                                                                                                                                              
  ## CMAKE_INSTALL_PREFIX             /usr/local                                                                                                                                                   
  ## CMAKE_USE_SYSTEM_BZIP2           ON           
  ## CMAKE_USE_SYSTEM_CURL            ON                                                                                                                                                          
  ## CMAKE_USE_SYSTEM_EXPAT           ON                                                                                                                                                          
  ## CMAKE_USE_SYSTEM_FORM            ON                                                                                                                                                          
  ## CMAKE_USE_SYSTEM_JSONCPP         ON       
  ## CMAKE_USE_SYSTEM_LIBARCHIVE      ON      
  ## CMAKE_USE_SYSTEM_LIBLZMA         ON   
  ## CMAKE_USE_SYSTEM_LIBRHASH        ON                                                                                                                                                          
  ## CMAKE_USE_SYSTEM_LIBUV           OFF
  ## CMAKE_USE_SYSTEM_ZLIB            ON                                                                                                                                                           
  ## CMake_RUN_CLANG_TIDY             OFF                                                                                                                                                          
  ## CMake_RUN_IWYU                   OFF                                                                                                                                                          
  ## CPACK_ENABLE_FREEBSD_PKG         OFF
  #
  ##----------------------------------------------------------
}

cmake_upgrade
