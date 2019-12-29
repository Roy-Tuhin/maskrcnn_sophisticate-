#!/bin/bash

##----------------------------------------------------------
### PCL
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://pointclouds.org/downloads/linux.html
## As binaries
## sudo add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl
## sudo apt-get update
## sudo apt-get -y install libpcl-all
#
#-------------------------
#
## Setup Prerequisites
## https://larrylisky.com/2016/11/03/point-cloud-library-on-ubuntu-16-04-lts/
#
## References:
## http://www.pointclouds.org/downloads/linux.html
## http://www.cs.ubc.ca/research/flann/
#
##----------------------------------------------------------

function pcl_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${PCL_REL}" ]; then
    PCL_REL="pcl-1.9.1"
    echo "Unable to get PCL_REL version, falling back to default version#: ${PCL_REL}"
  fi

  ## Uncomment if not installed using pre.install.sh
  # source ./pcl.prerequisite.install.sh

  DIR="pcl"
  PROG_DIR="${BASEPATH}/${DIR}"

  URL="https://github.com/PointCloudLibrary/${DIR}.git"

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
  git pull
  git checkout ${PCL_REL}

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build

  ## GPU Build

  # sudo apt install -y libopenni0 libopenni-dev libopenni-sensor-pointclouds-dev

  cmake -D BUILD_CUDA=ON \
        -D BUILD_GPU=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_simulation=ON \
        -D WITH_DOCS=ON \
        -D BUILD_apps=ON \
        -D BUILD_apps_3d_rec_framework=ON \
        -D BUILD_apps_point_cloud_editor=ON \
        -D CUDA_SDK_ROOT_DIR=/usr/local/cuda \
        -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
        -D WITH_OPENNI=ON \
        -D WITH_OPENNI2=ON \
        -D BUILD_people=ON \
        -D BUILD_examples=OFF \
        -D WITH_TUTORIALS=ON ..

  # cmake ..
  # ccmake ..
  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}

  # ##----------------------------------------------------------
  # ## Build Logs
  # ##----------------------------------------------------------

  # ##----------------------------------------------------------
  # ## Ubuntu 18.04 LTS
  # ##----------------------------------------------------------
  # # so to fix this, just make gcc6 available
  # # first install gcc6 and g++6
  # sudo apt install -y gcc-6 g++-6
  # # next, link them into your cuda stack
  # sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc 
  # sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++

  # https://stackoverflow.com/questions/7832892/how-to-change-the-default-gcc-compiler-in-ubuntu/9103299#9103299

  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
  # sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
  # sudo update-alternatives --config gcc



  # Now, there is gcc-4.9 available for Ubuntu/precise.

  # Create a group of compiler alternatives where the distro compiler has a higher priority:

  # VER=4.6 ; PRIO=60
  # update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$VER $PRIO --slave /usr/bin/g++ g++ /usr/bin/g++-$VER
  # update-alternatives --install /usr/bin/cpp cpp-bin /usr/bin/cpp-$VER $PRIO

  # VER=4.9 ; PRIO=40
  # update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$VER $PRIO --slave /usr/bin/g++ g++ /usr/bin/g++-$VER
  # update-alternatives --install /usr/bin/cpp cpp-bin /usr/bin/cpp-$VER $PRIO




  ##----------------------------------------------------------
  ## Error Log
  ##----------------------------------------------------------


  ## building CUDA on Ubuntu 18.04 LTS gives compiler version error

  # sh: 1: latex: not found
  # error: Problems running latex. Check your installation or look for typos in _formulas.tex and check _formulas.log!
  # sh: 1: dvips: not found
  # error: Problems running dvips. Check your installation!


  # [  0%] Building CXX object gpu/containers/CMakeFiles/pcl_gpu_containers.dir/src/initialization.cpp.o
  # In file included from /usr/local/cuda/include/host_config.h:50:0,
  #                  from /usr/local/cuda/include/cuda_runtime.h:78,
  #                  from <command-line>:0:
  # /usr/local/cuda/include/crt/host_config.h:119:2: error: #error -- unsupported GNU version! gcc versions later than 6 are not supported!
  #  #error -- unsupported GNU version! gcc versions later than 6 are not supported!
  #   ^~~~~
  # In file included from /usr/local/cuda/include/host_config.h:50:0,
  #                  from /usr/local/cuda/include/cuda_runtime.h:78,
  #                  from <command-line>:0:
  # /usr/local/cuda/include/crt/host_config.h:119:2: error: #error -- unsupported GNU version! gcc versions later than 6 are not supported!
  #  #error -- unsupported GNU version! gcc versions later than 6 are not supported!


  # --   apps
  #        not building: 
  #        |_ 3d_rec_framework: OpenNI was not found or was disabled by the user.
  #        |_ cloud_composer: Cloud composer requires QVTK
  #        |_ in_hand_scanner: OpenNI was not found or was disabled by the user.
  #        |_ modeler: VTK was not built with Qt support.
  #        |_ optronic_viewer: VTK was not built with Qt support.
  #        |_ point_cloud_editor: No reason

  # https://packages.debian.org/sid/libs/libopenni0
  # https://packages.debian.org/sid/libs/libopenni2-0


  #-------------------------
  ##  Ubuntu 18.04 LTS
  #-------------------------
  # ##Ubuntu 18.04 LTS
  # sudo apt install -y libflann1.9 libflann-dev
  # #Ubuntu 18.04 LTS
  # sudo apt install -y libvtk7.1 libvtk7-dev libvtk7.1-qt libvtk7-qt-dev libvtk7-java libvtk7-jni

  # Err:12 http://ppa.launchpad.net/grass/grass-stable/ubuntu bionic Release       
  #   404  Not Found [IP: 91.189.95.83 80]

  # E: Unable to locate package libflann1.8
  # E: Couldn't find any package by glob 'libflann1.8'
  # E: Couldn't find any package by regex 'libflann1.8'


  # Package libvtk5-dev is not available, but is referred to by another package.
  # This may mean that the package is missing, has been obsoleted, or
  # is only available from another source
  # However the following packages replace it:
  #   libvtk7-dev:i386 libvtk6-dev:i386 libvtk7-dev libvtk6-dev

  # E: Unable to locate package libvtk5.10-qt4
  # E: Couldn't find any package by glob 'libvtk5.10-qt4'
  # E: Couldn't find any package by regex 'libvtk5.10-qt4'
  # E: Unable to locate package libvtk5.10
  # E: Couldn't find any package by glob 'libvtk5.10'
  # E: Couldn't find any package by regex 'libvtk5.10'
  # E: Package 'libvtk5-dev' has no installation candidate

  #-------------------------
  ## Debugging Issues faced
  #-------------------------

  ##1. This issue occured when trying to compile PCL on the mounted partition with NTFS filesystem
  ## Learning: Do not setup the machine with NTFS mount to be used for software installation, use ext4/ext3

  # # [ 66%] Built target pcl_poisson_reconstruction
  # # /usr/bin/ld: final link failed: No space left on device

  # # https://hpc.uni.lu/blog/2014/xfs-and-inode64/
  # # https://serverfault.com/questions/357367/xfs-no-space-left-on-device-but-i-have-850gb-available


  # # https://askubuntu.com/questions/863172/full-disk-problem-on-ubuntu-16-04-xenial-xerus/863194
  # sudo dumpe2fs /dev/sda3 | grep "Reserved block count"

  # # https://medium.com/@brucepomeroy/running-out-of-inodes-on-ubuntu-718aef71ac16

  # # Let’s see how many kernel versions we have headers for
  # # for i in /usr/src/*; do echo $i; find $i |wc -l; done
  # # sudo apt-get -f install
  # # sudo apt autoremove

  # # https://www.ivankuznetsov.com/2010/02/no-space-left-on-device-running-out-of-inodes.html
  # # inodes: http://www.linfo.org/inode.html

  # ## All about mounting filesystem
  # # https://medium.com/@swhp/auto-mount-ntfs-partition-on-slackware-machine-eddd71f68c6f
  # # https://linux.die.net/man/8/mount.ntfs-3g
  # # https://askubuntu.com/questions/113733/how-do-i-correctly-mount-a-ntfs-partition-in-etc-fstab
  # # /dev/disk/by-uuid/
  # # https://unix.stackexchange.com/questions/4402/what-is-a-superblock-inode-dentry-and-a-file
  # # https://unix.stackexchange.com/questions/4950/what-is-an-inode
  # # https://www.slideshare.net/lordamit1/ntfs-and-inode

  # # inodes
  # df -ih

  # # size/space
  # df -h
}

pcl_install
