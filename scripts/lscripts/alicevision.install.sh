#!/bin/bash
##----------------------------------------------------------
# AliceVision
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/alicevision/AliceVision
#
## Dependencies
#
## Lemon:
##  - http://lemon.cs.elte.hu/trac/lemon/wiki/InstallLinux
##  - https://github.com/brrcrites/lemon
## SoPlex
##  - https://soplex.zib.de/
##  - SoPlex is an optimization package for solving linear programming problems (LPs) based on an advanced implementation of the primal and dual revised simplex algorithm. It provides special support for the exact solution of LPs with rational input data. It can be used as a standalone solver reading MPS or LP format files via a command line interface as well as embedded into other programs via a C++ class library
## uncertaintyTE
##  - https://github.com/alicevision/uncertaintyTE
#
## Only for Reference:
## - https://neos-server.org/neos/#solver
#
## What is the relation between BLAS, LAPACK and ATLAS
##  - https://stackoverflow.com/questions/17858104/what-is-the-relation-between-blas-lapack-and-atlas
##  - https://github.com/xianyi/OpenBLAS
#
## https://github.com/alicevision/AliceVision/blob/develop/INSTALL.md
## https://github.com/alicevision/AliceVisionDependencies/tree/master/ci
#
##----------------------------------------------------------


function alicevision_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## Dependencies
  # source ${LSCRIPTS}/cmake.upgrade.sh
  # source ${LSCRIPTS}/eigen.install.sh
  # source ${LSCRIPTS}/ceres-solver.install.sh
  # source ${LSCRIPTS}/opengv.install.sh
  # source ${LSCRIPTS}/geogram.install.sh
  # source ${LSCRIPTS}/popsift.install.sh
  # source ${LSCRIPTS}/OpenImageIO.install.sh
  # source ${LSCRIPTS}/magma.install.sh
  # source ${LSCRIPTS}/uncertaintyTE.install.sh
  # source ${LSCRIPTS}/popsift.install.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  # sudo apt -y install libpng-dev libjpeg-dev libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev
  # sudo apt -y install coinor-libcoinutils-dev coinor-libcoinutils3v5

  local PROG="AliceVision"
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
    git clone --recurse-submodules -j${NUMTHREADS} ${URL} ${PROG_DIR}
    # git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Git clone for ${URL} exists at: ${PROG_DIR}
  fi

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  ## export OPENGV_DIR="/usr/local"
  ## export OPENGV_INCLUDE_DIR="/usr/local/include"
  ## export OPENGV_LIBRARY="/usr/local/lib"

  ## -DALICEVISION_USE_OPENMP=ON \
  ## -DALICEVISION_REQUIRE_CERES_WITH_SUITESPARSE=OFF
  ## DALICEVISION_USE_OPENGV is optional, enabling it thrown error for opengv and eigen not found

  cmake -DCMAKE_BUILD_TYPE=Release \
    -DALICEVISION_BUILD_TESTS=ON \
    -DALICEVISION_BUILD_EXAMPLES=ON \
    -DALICEVISION_BUILD_DEPENDENCIES=OFF \
    -DALICEVISION_USE_RPATH=OFF \
    -DALICEVISION_USE_OCVSIFT=ON \
    -DAV_BUILD_CUDA=ON \
    -DALICEVISION_BUILD_SHARED=ON \
    -DALICEVISION_USE_OPENGV=ON \
    -DOPENGV_DIR:PATH=/usr/local \
    -DALICEVISION_REQUIRE_CERES_WITH_SUITESPARSE=ON \
    -DALICEVISION_USE_POPSIFT=ON \
    -DPopSift_DIR:PATH=/usr/local/lib/cmake/PopSift \
    -DALICEVISION_USE_OPENCV=ON \
    -DOpenCV_DIR:PATH=/usr/local/lib/cmake/opencv4 \
    -DALICEVISION_USE_RPATH=OFF \
    -DCMAKE_EXE_LINKER_FLAGS=-L/usr/local/lib \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_CXX_FLAGS=-I/usr/local/include \
    -DOPENIMAGEIO_LIBRARY:FILEPATH=/usr/local/lib/libOpenImageIO_Util.so \
    -DOPENIMAGEIO_LIBRARY_DIR_HINTS:PATH=/usr/local/lib \
    -DOPENIMAGEIO_INCLUDE_DIR:PATH=/usr/local/include \
    -DOPENGV_DIR:PATH=/usr/local \
    -DOPENGV_INCLUDE_DIR:PATH=/usr/local/include \
    -DOPENGV_LIBRARY:PATH=/usr/local/lib \
    -DEIGEN_INCLUDE_DIRS:PATH=/usr/local/include/eigen3 \
    -DCMAKE_MODULE_PATH:PATH=/usr/local/share/eigen3/cmake \
    -DCMAKE_C_FLAGS="-I/usr/local/include -L/usr/local/lib" ..


  # make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}





  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  # /usr/local/share/eigen3/cmake/Eigen3Config.cmake
  # https://riptutorial.com/cmake/example/22950/use-find-package-and-find-package--cmake-modules
  # /codehub/external/AliceVision/src/cmake/FindOpenGV.cmake


  # https://gist.github.com/italic-r/a045c122ef4a8be4a6357c937f45e393

  # https://github.com/alicevision/AliceVision/blob/develop/INSTALL.md
  # -- By default, Ceres required SuiteSparse to ensure best performances. if you explicitly need to build without it, you can use the option: -DALICEVISION_REQUIRE_CERES_WITH_SUITESPARSE=OFF

  # -- Could NOT find Alembic (missing: Alembic_DIR)
  # -- Could NOT find CCTag (missing: CCTag_DIR)


  # -- Looking for Eigen dependency...
  # CMake Warning at src/cmake/FindOpenGV.cmake:30 (FIND_PACKAGE):
  #   By not providing "FindEigen.cmake" in CMAKE_MODULE_PATH this project has
  #   asked CMake to find a package configuration file provided by "Eigen", but
  #   CMake did not find one.

  #   Could not find a package configuration file provided by "Eigen" with any of
  #   the following names:

  #     EigenConfig.cmake
  #     eigen-config.cmake

  #   Add the installation prefix of "Eigen" to CMAKE_PREFIX_PATH or set
  #   "Eigen_DIR" to a directory containing one of the above files.  If "Eigen"
  #   provides a separate development package or SDK, be sure it has been
  #   installed.
  # Call Stack (most recent call first):
  #   src/CMakeLists.txt:604 (find_package)
  # -- Did not find MOSEK header
  # -- Did not find MOSEK library
  # -- Could not find mosek library on this machine.
  # -- Trying to find package Ceres for aliceVision: 
  # -- By default, Ceres required SuiteSparse to ensure best performances. if you explicitly need to build without it, you can use the option: -DALICEVISION_REQUIRE_CERES_WITH_SUITESPARSE=OFF
  # -- Failed to find Ceres - Found Eigen dependency, but the version of Eigen found (3.3.7) does not exactly match the version of Eigen Ceres was compiled with (3.3.4). This can cause subtle bugs by triggering violations of the One Definition Rule. See the Wikipedia article http://en.wikipedia.org/wiki/One_Definition_Rule for more details
  # CMake Error at src/CMakeLists.txt:352 (find_package):
  #   Found package configuration file:

  #     /usr/local/lib/cmake/Ceres/CeresConfig.cmake

  #   but it set Ceres_FOUND to FALSE so package "Ceres" is considered to be NOT
  #   FOUND.



  ## Geogram is needed
  ## https://gforge.inria.fr/frs/?group_id=5833
  ## https://github.com/alicevision/geogram


  # -- Looking for UncertaintyTE.
  # -- UncertaintyTE headers not found!
  # -- UncertaintyTE library include not found
  # -- UncertaintyTE library not found
  # -- Could NOT find UncertaintyTE (missing: UNCERTAINTYTE_LIBRARY UNCERTAINTYTE_INCLUDE_DIR) 
  # CMake Error at /usr/share/cmake-3.10/Modules/FindPackageHandleStandardArgs.cmake:137 (message):
  #   Could NOT find Geogram (missing: GEOGRAM_LIBRARY GEOGRAM_INCLUDE_DIR)
  # Call Stack (most recent call first):
  #   /usr/share/cmake-3.10/Modules/FindPackageHandleStandardArgs.cmake:378 (_FPHSA_FAILURE_MESSAGE)
  #   src/cmake/FindGeogram.cmake:62 (find_package_handle_standard_args)
  #   src/CMakeLists.txt:632 (find_package)


  ##
  # -- Could NOT find GLPK (missing: GLPK_LIBRARY GLPK_INCLUDE_DIR GLPK_PROPER_VERSION_FOUND) (Required is at least version "4.33")
  # -- Could NOT find ILOG (missing: ILOG_CPLEX_LIBRARY ILOG_CPLEX_INCLUDE_DIR) 
  # -- Could NOT find COIN (missing: COIN_INCLUDE_DIR COIN_CBC_LIBRARY COIN_CBC_SOLVER_LIBRARY COIN_CGL_LIBRARY COIN_CLP_LIBRARY COIN_COIN_UTILS_LIBRARY COIN_OSI_LIBRARY COIN_OSI_CBC_LIBRARY COIN_OSI_CLP_LIBRARY) 
  # -- Could NOT find SOPLEX (missing: SOPLEX_LIBRARY SOPLEX_INCLUDE_DIR) 
  # -- Looking for sys/types.h
  # -- Looking for sys/types.h - not found
  # -- Looking for stdint.h
  # -- Looking for stdint.h - not found
  # -- Looking for stddef.h
  # -- Looking for stddef.h - not found
  # -- Check size of long long
  # -- Check size of long long - failed
  # -- Found OpenMP_C: -fopenmp  
  # -- Found OpenMP_CXX: -fopenmp  


  # http://4answered.com/questions/view/d44171/How-to-fix-error-bad-value-native-for-march-switch-and-mtune-switch

  # [  0%] Building CXX object src/dependencies/vectorGraphics/CMakeFiles/main_svgSample.dir/main.cpp.o
  # /home/alpha/softwares/AliceVision/src/dependencies/vectorGraphics/main.cpp:1:0: error: bad value (skylake) for -march= switch
  #   /*
  #  ^
  # src/dependencies/

  ##
  # /home/alpha/softwares/AliceVision/src/aliceVision/image/io.cpp:89:51: error: ‘const class OpenImageIO::v1_7::ParamValue’ has no member named ‘get_string’
  #      metadata.emplace(param.name().string(), param.get_string());


  # Scanning dependencies of target aliceVision_lInftyComputerVision
  # [ 59%] Building CXX object src/aliceVision/linearProgramming/lInfinityCV/CMakeFiles/aliceVision_lInftyComputerVision.dir/resection_kernel.cpp.o
  # /home/alpha/softwares/AliceVision/src/aliceVision/mesh/Texturing.cpp: In member function ‘void aliceVision::mesh::Texturing::saveAsOBJ(const boost::filesystem::path&, const string&, aliceVision::EImageFileType)’:
  # /home/alpha/softwares/AliceVision/src/aliceVision/mesh/Texturing.cpp:734:58: warning: format ‘%i’ expects argument of type ‘int’, but argument 3 has type ‘size_t {aka long unsigned int}’ [-Wformat=]
  #          fprintf(fobj, "usemtl TextureAtlas_%i\n", atlasID);
  #                                                           ^
  # /home/alpha/softwares/AliceVision/src/aliceVision/mesh/Texturing.cpp:765:58: warning: format ‘%i’ expects argument of type ‘int’, but argument 3 has type ‘size_t {aka long unsigned int}’ [-Wformat=]
  #          fprintf(fmtl, "newmtl TextureAtlas_%i\n", atlasID);



  # Scanning dependencies of target aliceVision_colorHarmonization
  # [ 62%] Building CXX object src/aliceVision/colorHarmonization/CMakeFiles/aliceVision_colorHarmonization.dir/GainOffsetConstraintBuilder.cpp.o
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::Header::type[abi:cxx11]() const'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::FrameBuffer::insert(char const*, Imf_2_3::Slice const&)'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::OutputFile::setFrameBuffer(Imf_2_3::FrameBuffer const&)'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::Header::hasTileDescription() const'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::TypedAttribute<Imath_2_3::Box<Imath_2_3::Vec2<int> > >::staticTypeName()'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::TimeCode::TimeCode(unsigned int, unsigned int, Imf_2_3::TimeCode::Packing)'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::TimeCode::seconds() const'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::TypedAttribute<Imf_2_3::TimeCode>::writeValueTo(Imf_2_3::OStream&, int) const'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::Header::Header(Imf_2_3::Header const&)'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::DeepTiledInputPart::setFrameBuffer(Imf_2_3::DeepFrameBuffer const&)'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::TimeCode::timeAndFlags(Imf_2_3::TimeCode::Packing) const'
  # /usr/local/lib/libOpenImageIO.so: undefined reference to `Imf_2_3::MultiPartOutputFile::MultiPartOutputFile(char const*, Imf_2_3::Header const*, int, bool, int)'
  # /usr/local/
}

alicevision_install
