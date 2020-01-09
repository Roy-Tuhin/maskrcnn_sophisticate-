#!/bin/bash

##----------------------------------------------------------
## OpenSfM
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://github.com/mapillary/OpenSfM
## http://opensfm.readthedocs.io/en/latest/building.html
#
##----------------------------------------------------------
## Dependencies
##----------------------------------------------------------
# OpenCV
# - boost_1_64_0 is preferred
# - boost_1_67_0 has some bug because of which OpenGV does not compiles, though there's a fork repo that fixed it
# OpenGV
# Ceres Solver
# Boost Python
# NumPy, SciPy, Networkx, PyYAML, exifread
#
#
## https://github.com/mapillary/OpenSfM/blob/master/Dockerfile
## https://github.com/paulinus/opensfm-docker-base/blob/master/Dockerfile.python3
#
##----------------------------------------------------------


function OpenSfM_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="$HOME/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${OpenSfM_REL}" ]; then
    local OpenSfM_REL="2.0.1"
    echo "Unable to get OpenSfM_REL version, falling back to default version#: ${OpenSfM_REL}"
  fi

  local DIR="OpenSfM"
  local PROG_DIR="${BASEPATH}/${DIR}"

  local URL="https://github.com/mapillary/${DIR}.git"

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

  ## pybind11 as third party module
  git submodule update --init --recursive
  git checkout ${OpenSfM_REL}

  ## sudo pip install -r requirements.txt
  python setup.py build

  cd ${LSCRIPTS}

  ##----------------------------------------------------------
  ## Build Logs
  ##----------------------------------------------------------

  # http://ceres-solver.org/nnls_solving.html?highlight=normal%20equations

  # int Solver::Options::num_linear_solver_threads
  # Default: -1

  # This field is deprecated, and is ignored by Ceres. Solver::Options::num_threads controls threading for all of Ceres Solver. This setting is scheduled to be removed in 1.15.0.

  # Number of threads used by the linear solver.

  ## Lines in following file is commented out, and comilation is successful
  # /home/game1/softwares/OpenSfM/opensfm/src/bundle.h
  #   //options.num_linear_solver_threads = num_threads_;

  # home/game1/softwares/OpenSfM/opensfm/src/reconstruction_alignment.h
  #   //options.num_linear_solver_threads = 8;

  ##---------------------
  ## Ubuntu 18.04 LTS
  ##---------------------

  # In file included from /home/game1/softwares/OpenSfM/opensfm/src/csfm.cc:9:0:
  # /home/game1/softwares/OpenSfM/opensfm/src/bundle.h: In member function ‘void BundleAdjuster::Run()’:
  # /home/game1/softwares/OpenSfM/opensfm/src/bundle.h:1401:13: error: ‘struct ceres::Solver::Options’ has no member named ‘num_linear_solver_threads’; did you mean ‘linear_solver_type’?
  #      options.num_linear_solver_threads = num_threads_;
  #              ^~~~~~~~~~~~~~~~~~~~~~~~~
  #              linear_solver_type
  # In file included from /home/game1/softwares/OpenSfM/opensfm/src/csfm.cc:12:0:
  # /home/game1/softwares/OpenSfM/opensfm/src/reconstruction_alignment.h: In member function ‘void ReconstructionAlignment::Run()’:
  # /home/game1/softwares/OpenSfM/opensfm/src/reconstruction_alignment.h:438:13: error: ‘struct ceres::Solver::Options’ has no member named ‘num_linear_solver_threads’; did you mean ‘linear_solver_type’?
  #      options.num_linear_solver_threads = 8;
  #              ^~~~~~~~~~~~~~~~~~~~~~~~~
  #              linear_solver_type
  # CMakeFiles/csfm.dir/build.make:62: recipe for target 'CMakeFiles/csfm.dir/csfm.cc.o' failed
  # make[2]: *** [CMakeFiles/csfm.dir/csfm.cc.o] Error 1
  # CMakeFiles/Makefile2:179: recipe for target 'CMakeFiles/csfm.dir/all' failed
  # make[1]: *** [CMakeFiles/csfm.dir/all] Error 2
  # Makefile:94: recipe for target 'all' failed
  # make: *** [all] Error 2
  # Building package
  # usage: setup.py [global_opts] cmd1 [cmd1_opts] [cmd2 [cmd2_opts] ...]
  #    or: setup.py --help [cmd1 cmd2 ...]
  #    or: setup.py --help-commands
  #    or: setup.py cmd --help

  # error: no commands supplied
}

OpenSfM_install
