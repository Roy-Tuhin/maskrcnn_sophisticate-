#!/bin/bash

##----------------------------------------------------------
## ceres-solver
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
## Ceres Solver is an open source C++ library for modeling and solving large, complicated optimization problems. It can be used to solve Non-linear Least Squares problems with bounds constraints and general unconstrained optimization problems. It is a mature, feature rich, and performant library that has been used in production at Google since 2010
## - A Nonlinear Least Squares Minimizer
#
## http://ceres-solver.org/
## http://ceres-solver.org/installation.html#linux
#
## https://ceres-solver.googlesource.com/ceres-solver
#
##----------------------------------------------------------
## Dependencies
# If you have followed the Software Installation Sequence
# all dependencies would already be installed, if not it will
# be installed by this script
#
##----------------------------------------------------------
# # CMake
# sudo apt install cmake
# # google-glog + gflags
# sudo apt install libgoogle-glog-dev
# # BLAS & LAPACK
# sudo apt install libatlas-base-dev
# # Eigen3
# sudo apt install libeigen3-dev
# # SuiteSparse and CXSparse (optional)
# # - If you want to build Ceres as a *static* library (the default)
# #   you can use the SuiteSparse package in the main Ubuntu package
# #   repository:
# sudo apt install libsuitesparse-dev
# # - However, if you want to build Ceres as a *shared* library, you must
# #   add the following PPA:
# sudo add-apt-repository ppa:bzindovic/suitesparse-bugfix-1319687
# sudo apt update
# sudo apt install libsuitesparse-dev
##----------------------------------------------------------

## Check for the required dependencies, install if required
#apt-cache policy libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev
#apt-cache policy libgoogle-glog-dev libatlas-base-dev libeigen3-dev libsuitesparse-dev | cut -d' ' -f1 |tr '\n' ' '

# sudo -E apt install -y libsuitesparse-dev

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

if [ -z "$CERES_SOLVER_REL" ]; then
  CERES_SOLVER_REL="-1.14.0"
  CERES_SOLVER_REL_TAG="1.14.0"
  echo "Unable to get CERES_SOLVER_REL version, falling back to default version#: $CERES_SOLVER_REL"
fi

sudo apt -y install libsuitesparse-dev

# CERES_SOLVER_REL=""
# CERES_SOLVER_REL="-1.10.0"
# CERES_SOLVER_REL="-1.14.0"
DIR="ceres-solver"
PROG_DIR="$BASEPATH/$DIR$CERES_SOLVER_REL"

URL="https://ceres-solver.googlesource.com/$DIR"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
  cd $PROG_DIR
  git checkout $CERES_SOLVER_REL_TAG
else
  echo Gid clone for $URL exists at: $PROG_DIR
fi

# http://faculty.cse.tamu.edu/davis/suitesparse.html

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build

cd $PROG_DIR/build
cmake .. -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC

## not required
# ccmake ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------


 # -- Failed to find SuiteSparse - Did not find CHOLMOD header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CHOLMOD library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find SUITESPARSEQR header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find SUITESPARSEQR library (required SuiteSparse component).


## when enabling SuiteSparse
## ceres to be built with suitesparse for alicevision compilation

 # -- Found Eigen version 3.3.4: /usr/include/eigen3

 # -- Enabling use of Eigen as a sparse linear algebra library.

 # -- Found LAPACK library: /usr/lib/x86_64-linux-gnu/libopenblas.so;/usr/lib/x86_64-linux-gnu/libopenblas.so

 # -- Failed to find SuiteSparse - Did not find AMD header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find AMD library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CAMD header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CAMD library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find COLAMD header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find COLAMD library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CCOLAMD header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CCOLAMD library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CHOLMOD header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find CHOLMOD library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find SUITESPARSEQR header (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Did not find SUITESPARSEQR library (required SuiteSparse component).

 # -- Failed to find SuiteSparse - Failed to find either: SuiteSparse_config header & library (should be present in all SuiteSparse >= v4 installs), or UFconfig header (should be present in all SuiteSparse < v4
 # installs).

 # -- Did not find all SuiteSparse dependencies, disabling SuiteSparse support.

 # -- Failed to find CXSparse - Could not find CXSparse include directory, set CXSPARSE_INCLUDE_DIR to directory containing cs.h

 # -- Did not find CXSparse, Building without CXSparse.

 # -- Found Google Flags header in: /usr/include, in namespace: google

 # -- Compiling minimal glog substitute into Ceres.

 # -- Using minimal glog substitute (include): internal/ceres/miniglog

 # -- Max log level for minimal glog substitute: 2
