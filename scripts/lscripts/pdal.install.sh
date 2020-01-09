#!/bin/bash

##----------------------------------------------------------
## PDAL - Point Data Abstraction Library
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://www.pdal.io
## https://www.pdal.io/download.html#debian
#
## Dependencies
## https://pdal.io/development/compilation/dependencies.html
##
## Notes:
##  1. If you are building both of these libraries yourself, make sure you build GDAL using the “External libgeotiff” option, which will prevent the insanity that can ensue on some platforms
##----------------------------------------------------------


function pdal_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${PDAL_VER}" ]; then
    PDAL_MARJOR_VER="1.7"
    PDAL_BUILD="2"
    PDAL_VER="${PDAL_MARJOR_VER}.${PDAL_BUILD}"
    echo "Unable to get PDAL_VER version, falling back to default version#: ${PDAL_VER}"
  fi

  PROG='PDAL'
  DIR="${PROG}-${PDAL_VER}-src"
  PROG_DIR="${BASEPATH}/${PROG}-${PDAL_VER}-src"
  FILE="${DIR}.tar.gz"
  URL="http://download.osgeo.org/pdal/${FILE}"

  echo "${FILE}"
  echo "URL: $URL"
  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c $URL -P ${HOME}/Downloads
  else
    echo "Not downloading as: ${HOME}/Downloads/${FILE} already exists!"
  fi

  if [ ! -d ${BASEPATH}/${DIR} ]; then
    # tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #verbose
    tar xfz ${HOME}/Downloads/${FILE} -C ${BASEPATH} #silent mode
    echo "Extracting File: ${HOME}/Downloads/${FILE} here: ${BASEPATH}/${DIR}"
    echo "Extracting...DONE!"
  else
    echo "Extracted Dir already exists: ${BASEPATH}/${DIR}"
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  make clean -j${NUMTHREADS}

  cmake -D WITH_LAZPERF=ON \
        -D WITH_LZMA=ON \
        -D BUILD_PLUGIN_PGPOINTCLOUD=ON \
        -D BUILD_PGPOINTCLOUD_TESTS=ON \
        -D BUILD_PLUGIN_SQLITE=ON \
        -D BUILD_SHARED_LIBS=ON \
        -D BUILD_SQLITE_TESTS=ON \
        -D BUILD_PLUGIN_PYTHON=ON ..

  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}

  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  ### not required
  ## ccmake ..

  # BUILD_PLUGIN_CPD                 OFF                                                                                                                 
  # BUILD_PLUGIN_GEOWAVE             OFF                                                                                                                 
  # BUILD_PLUGIN_GREYHOUND           OFF                                                                                                                 
  # BUILD_PLUGIN_HEXBIN              ON                                                                                                                 
  # BUILD_PLUGIN_ICEBRIDGE           OFF                                                                                                                 
  # BUILD_PLUGIN_MATLAB              OFF                                                                                                                 
  # BUILD_PLUGIN_MBIO                OFF                                                                                                                 
  # BUILD_PLUGIN_MRSID               OFF                                                                                                                 
  # BUILD_PLUGIN_NITF                OFF                                                                                                                 
  # BUILD_PLUGIN_OCI                 OFF                                                                                                                 
  # BUILD_PLUGIN_OPENSCENEGRAPH      OFF    # enabling gives error, even when OPENSCENEGRAPH installed                                                                                                              
  # BUILD_PLUGIN_PCL                 OFF   

  # BUILD_PLUGIN_PYTHON              ON 
  # WITH_LAZPERF                     ON
  # WITH_LZMA                        ON
  # BUILD_PGPOINTCLOUD_TESTS         OFF # enabling gives error
  # WITH_TESTS                       OFF

  # Could NOT find Hexer (missing: HEXER_LIBRARY HEXER_INCLUDE_DIR)

  # [100%] Linking CXX shared library ../../lib/libpdal_plugin_kernel_density.so
  # [100%] Built target pdal_filters_additional_merge_test
  # [100%] Built target hexbintest
  # /usr/bin/x86_64-linux-gnu-ld: CMakeFiles/pdal_io_numpy_test.dir/__/plang/Environment.cpp.o: undefined reference to symbol 'dlopen@@GLIBC_2.2.5'
  # //lib/x86_64-linux-gnu/libdl.so.2: error adding symbols: DSO missing from command line
  # collect2: error: ld returned 1 exit status
  # plugins/python/io/CMakeFiles/pdal_io_numpy_test.dir/build.make:162: recipe for target 'bin/pdal_io_numpy_test' failed
  # make[2]: *** [bin/pdal_io_numpy_test] Error 1
  # CMakeFiles/Makefile2:618: recipe for target 'plugins/python/io/CMakeFiles/pdal_io_numpy_test.dir/all' failed
  # make[1]: *** [plugins/python/io/CMakeFiles/pdal_io_numpy_test.dir/all] Error 2
  # make[1]: *** Waiting for unfinished jobs....
  # [100%] Built target pdal_plugin_kernel_density
  # Makefile:162: recipe for target 'all' failed
  # make: *** [all] Error 2


  # -- The following features have been disabled:

  # * Bash completion, completion for PDAL command line
  # * CPD plugin, Coherent Point Drift (CPD) computes rigid or nonrigid transformations between point sets
  # * GeoWave plugin, Read and Write data using GeoWave
  # * Greyhound plugin, read points from a Greyhound server
  # * Hexbin plugin, determine boundary and density of a point cloud
  # * Icebridge plugin, read data in the Icebridge format
  # * Matlab plugin, write data to a .mat file
  # * MrSID plugin, read data in the MrSID format
  # * NITF plugin, read/write LAS data wrapped in NITF
  # * OpenSceneGraph plugin, read/write OpenSceneGraph objects
  # * PCL plugin, provides PCL-based readers, writers, filters, and kernels
  # * SQLite plugin, read/write SQLite objects
  # * RiVLib plugin, read data in the RXP format
  # * MBIO plugin, add features that depend on MBIO


  # ###---------------PDAL Ubuntu 18.04 LTS error

  # -- errors when enabling laz-perf. This is required for entwine to build.
  # # They have fixed it 15hrs back: backward compatibility fixes
  # https://github.com/hobu/laz-perf/tree/master/laz-perf
  # https://github.com/hobu/laz-perf/blob/master/laz-perf/factory.hpp
  # https://github.com/hobu/laz-perf/blob/master/laz-perf/io.hpp

  # /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp: In member function ‘void pdal::LasWriter::readyLazPerfCompression()’:
  # /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp:716:54: error: no matching function for call to ‘laszip::factory::record_schema::push(laszip::factory::record_item::<unnamed enum>)’
  #      schema.push(laszip::factory::record_item::POINT10);
  #                                                       ^
  # In file included from /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp:39:0:
  # /usr/local/include/laz-perf/factory.hpp:94:9: note: candidate: void laszip::factory::record_schema::push(const laszip::factory::record_item&)
  #     void push(const record_item& item) {
  #          ^~~~
  # /usr/local/include/laz-perf/factory.hpp:94:9: note:   no known conversion for argument 1 from ‘laszip::factory::record_item::<unnamed enum>’ to ‘const laszip::factory::record_item&’
  # /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp:718:58: error: no matching function for call to ‘laszip::factory::record_schema::push(laszip::factory::record_item::<unnamed enum>)’
  #          schema.push(laszip::factory::record_item::GPSTIME);
  #                                                           ^
  # In file included from /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp:39:0:
  # /usr/local/include/laz-perf/factory.hpp:94:9: note: candidate: void laszip::factory::record_schema::push(const laszip::factory::record_item&)
  #     void push(const record_item& item) {
  #          ^~~~
  # /usr/local/include/laz-perf/factory.hpp:94:9: note:   no known conversion for argument 1 from ‘laszip::factory::record_item::<unnamed enum>’ to ‘const laszip::factory::record_item&’
  # /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp:720:56: error: no matching function for call to ‘laszip::factory::record_schema::push(laszip::factory::record_item::<unnamed enum>)’
  #          schema.push(laszip::factory::record_item::RGB12);
  #                                                         ^
  # In file included from /home/game1/softwares/PDAL-1.7.1-src/io/LasWriter.cpp:39:0:
  # /usr/local/include/laz-perf/factory.hpp:94:9: note: candidate: void laszip::factory::record_schema::push(const laszip::factory::record_item&)
  #     void push(const record_item& item) {
  #          ^~~~
  # /usr/local/include/laz-perf/factory.hpp:94:9: note:   no known conversion for argument 1 from ‘laszip::factory::record_item::<unnamed enum>’ to ‘const laszip::factory::record_item&’
  # [ 52%] Building CXX object CMakeFiles/pdal_base.dir/io/OGRWriterV1.cpp.o
  # CMakeFiles/pdal_base.dir/build.make:1550: recipe for target 'CMakeFiles/pdal_base.dir/io/LasWriter.cpp.o' failed
  # make[2]: *** [CMakeFiles/pdal_base.dir/io/LasWriter.cpp.o] Error 1
  # make[2]: *** Waiting for unfinished jobs....
  # CMakeFiles/Makefile2:70: recipe for target 'CMakeFiles/pdal_base.dir/all' failed
  # make[1]: *** [CMakeFiles/pdal_base.dir/all] Error 2
  # Makefile:151: recipe for target 'all' failed
  # make: *** [all] Error 2

  # ###---------------PDAL previous

  # /usr/bin/x86_64-linux-gnu-ld: warning: liburiparser.so.0.7.8, needed by //usr/local/lib/libkmlbase.so.1, not found (try using -rpath or -rpath-link)

  # https://github.com/glfw/glfw/issues/808
  # https://github.com/filipwasil/fillwave/issues/58

  # sudo apt-get install pkg-config
  # pkg-config --libs glfw3
  # sudo apt install libglfw3 libglfw3-dev

  # [100%] Built target pdal_io_text_reader_test
  # /usr/bin/ld: CMakeFiles/pdal_io_numpy_test.dir/__/plang/Environment.cpp.o: undefined reference to symbol 'dlopen@@GLIBC_2.2.5'
  # //lib/x86_64-linux-gnu/libdl.so.2: error adding symbols: DSO missing from command line
  # collect2: error: ld returned 1 exit status
  # plugins/python/io/CMakeFiles/pdal_io_numpy_test.dir/build.make:128: recipe for target 'bin/pdal_io_numpy_test' failed
  # make[2]: *** [bin/pdal_io_numpy_test] Error 1
  # CMakeFiles/Makefile2:513: recipe for target 'plugins/python/io/CMakeFiles/pdal_io_numpy_test.dir/all' failed
  # make[1]: *** [plugins/python/io/CMakeFiles/pdal_io_numpy_test.dir/all] Error 2
  # make[1]: *** Waiting for unfinished jobs....
  # [100%] Built target pgpointcloudtest
  # Makefile:162: recipe for target 'all' failed
  # make: *** [all] Error 2

  # # In file included from /home/thanos/softwares/PDAL-1.7.1-src/plugins/geowave/io/GeoWaveReader.cpp:35:0:
  # # /home/thanos/softwares/PDAL-1.7.1-src/plugins/geowave/io/GeoWaveReader.hpp:42:74: fatal error: jace/proxy/mil/nga/giat/geowave/core/store/CloseableIterator.h: No such file or directory
  # # compilation terminated.
}

pdal_install
