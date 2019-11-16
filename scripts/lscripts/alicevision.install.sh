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
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

sudo apt -y install libpng-dev libjpeg-dev libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev
sudo apt -y install coinor-libcoinutils-dev coinor-libcoinutils3v5

PROG="AliceVision"
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/alicevision/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  git clone --recurse-submodules -j8 $URL $PROG_DIR
  # git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake ..
# make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS

# cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------

## ceres with suitesparse should be build

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