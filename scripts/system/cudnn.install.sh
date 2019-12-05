#!/bin/bash

##----------------------------------------------------------
### cuDNN Installation
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://developer.nvidia.com/cudnn
## cuDNN-Installation-Guide.pdf
#
## cuDNN for CUDA 9.0
## https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.1.4/prod/9.0_20180516/Ubuntu16_04-x64/libcudnn7_7.1.4.18-1_cuda9.0_amd64
## https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.1.4/prod/9.0_20180516/Ubuntu16_04-x64/libcudnn7-dev_7.1.4.18-1_cuda9.0_amd64
## https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v7.1.4/prod/9.0_20180516/Ubuntu16_04-x64/libcudnn7-doc_7.1.4.18-1_cuda9.0_amd64
#
## Dependencies: CUDA should be installed
#
## Download of cuDNN lib is through Nvidia login and hence `wget` option is not used
## cuDNN deb packages needs to be manually downloaded
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

if [ -z "$cuDNN_VER" ]; then
  cuDNN_VER=7
  cuDNN_RELEASE="7.1.4.18-1"
  echo "Unable to get cuDNN_VER version, falling back to default version#: $cuDNN_VER"
fi

if [ -z "$CUDA_VER" ]; then
  CUDA_VER="9.0"
  echo "Unable to get CUDA_VER version, falling back to default version#: $CUDA_VER"
fi

##----------------------------------------------------------
### Installing from a Debian File
##----------------------------------------------------------

if [ -z "$cuDNN_LIB" ]; then
  # Install runtime lib
  cuDNN_LIB="libcudnn${cuDNN_VER}_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
fi
if [ -z "$cuDNN_DEV_LIB" ]; then
  # Install developer lib
  cuDNN_DEV_LIB="libcudnn${cuDNN_VER}-dev_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
fi
if [ -z "$cuDNN_USR_GUIDE" ]; then  
  # Install code samples and the cuDNN Library User Guide
  cuDNN_USR_GUIDE="libcudnn${cuDNN_VER}-doc_${cuDNN_RELEASE}+cuda${CUDA_VER}_amd64.deb"
fi

if [ -f $HOME/Downloads/$cuDNN_LIB ]; then
  # Install runtime lib
  sudo dpkg -i $HOME/Downloads/$cuDNN_LIB
  # Install developer lib
  sudo dpkg -i $HOME/Downloads/$cuDNN_DEV_LIB
  
  # sudo dpkg -i libcudnn7-dev_7.1.4.18-1+cuda9.0_amd64.deb
  # Selecting previously unselected package libcudnn7-dev.
  # (Reading database ... 267361 files and directories currently installed.)
  # Preparing to unpack libcudnn7-dev_7.1.4.18-1+cuda9.0_amd64.deb ...
  # Unpacking libcudnn7-dev (7.1.4.18-1+cuda9.0) ...
  # Setting up libcudnn7-dev (7.1.4.18-1+cuda9.0) ...
  # update-alternatives: using /usr/include/x86_64-linux-gnu/cudnn_v7.h to provide /usr/include/cudnn.h (libcudnn) in auto mode


  # Install code samples and the cuDNN Library User Guide1
  sudo dpkg -i $HOME/Downloads/$cuDNN_USR_GUIDE
else
  echo "File Does NOT Exists: $HOME/Downloads/$cuDNN_LIB"
  echo "Additionally, aborting Installation for Dev Lib and User Guide"
  echo "Runtime Lib is required to install Dev lib and User Guide"
fi

## TODO: gcc should have been set to ver 6
# # Ubuntu 18.04 LTS
# if [[ $LINUX_VERSION == "18.04" ]]; then
#   echo $LINUX_VERSION
#   # so to fix this, just make gcc6 available
#   # first install gcc6 and g++6
#   sudo -E apt -q -y install gcc-6 g++-6
#   # next, link them into your cuda stack
#   sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc 
#   sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++
# fi


## TBD: verification pending

echo "/usr/src/cudnn_samples_v$cuDNN_VER"

sudo chown -R $(whoami):$(whoami) "/usr/src/cudnn_samples_v$cuDNN_VER"
cd "/usr/src/cudnn_samples_v$cuDNN_VER/mnistCUDNN"
make clean && make
./mnistCUDNN

echo "OR:"
echo "cp -r /usr/src/cudnn_samples_v$cuDNN_VER $BASEPATH"
echo "cd $BASEPATH/cudnn_samples_v$cuDNN_VER/mnistCUDNN"
echo "make clean && make"
echo "./mnistCUDNN"

cd $LINUX_SCRIPT_HOME


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

# ##----------------------------------------------------------
## TBD: some bugs in copy and check
# ##----------------------------------------------------------

# if [ -d /usr/src/cudnn_samples_v$cuDNN_VER ]; then
#   # verify
#   cp -r /usr/src/cudnn_samples_v$cuDNN_VER $BASEPATH
# else
#   echo "Directory ALREADY Exists: $BASEPATH/cudnn_samples_v$cuDNN_VER"
# fi
# if [ -d $BASEPATH/cudnn_samples_v$cuDNN_VER/mnistCUDNN ]; then
#   # verify
#   cd $BASEPATH/cudnn_samples_v$cuDNN_VER/mnistCUDNN
#   make clean && make
#   ./mnistCUDNN
# else
#   echo "Directory Does NOT Exists: $BASEPATH/cudnn_samples_v$cuDNN_VER/mnistCUDNN"
# fi


# https://devtalk.nvidia.com/default/topic/1032269/cuda-9-gcc-7-compatibility-with-nvcc/



##----------------------------------------------------------
### cuDNN Verification
##----------------------------------------------------------

# cudnn_samples_v7/mnistCUDNN$ make clean && make
# rm -rf *o
# rm -rf mnistCUDNN
# /usr/local/cuda/bin/nvcc -ccbin g++ -I/usr/local/cuda/include -IFreeImage/include  -m64    -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_53,code=compute_53 -o fp16_dev.o -c fp16_dev.cu
# In file included from /usr/local/cuda/include/host_config.h:50:0,
#                  from /usr/local/cuda/include/cuda_runtime.h:78,
#                  from <command-line>:0:
# /usr/local/cuda/include/crt/host_config.h:121:2: error: #error -- unsupported GNU version! gcc versions later than 6 are not supported!
#  #error -- unsupported GNU version! gcc versions later than 6 are not supported!
#   ^~~~~
# Makefile:203: recipe for target 'fp16_dev.o' failed
# make: *** [fp16_dev.o] Error 1

# cudnn_samples_v7/mnistCUDNN$ gcc --version
# gcc (Ubuntu 7.3.0-16ubuntu3) 7.3.0
# Copyright (C) 2017 Free Software Foundation, Inc.
# This is free software; see the source for copying conditions.  There is NO
# warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

##----------------------------------------------------------
### Installing from a Tar File
##----------------------------------------------------------

# # http://www.pyimagesearch.com/2016/07/04/how-to-install-cuda-toolkit-and-cudnn-for-deep-learning/
# - download and extract cudnn. It has cuda directory and has includ and lib64 folders inside. Copy these folder files to the cuda installation directory

# tar -zxf cudnn-7.5-linux-x64-v5.0-ga.tgz
# cd cuda
# sudo cp lib64/* /usr/local/cuda/lib64/
# sudo cp include/* /usr/local/cuda/include/


# ## tensorrt installation

# sudo dpkg -i nv-gie-repo-ubuntu1404-ga-cuda8.0-gie1.0-20170116_6-1_amd64.deb
# sudo apt update
# sudo apt install libgie1

# # game@game-pc:~/Downloads/TensorRT$ sudo apt install libgie1
# # Reading package lists... Done
# # Building dependency tree       
# # Reading state information... Done
# # The following extra packages will be installed:
# #   libcudnn5
# # The following NEW packages will be installed:
# #   libcudnn5 libgie1
# # 0 upgraded, 2 newly installed, 0 to remove and 19 not upgraded.
# # Need to get 0 B/46.4 MB of archives.
# # After this operation, 132 MB of additional disk space will be used.
# # Do you want to continue? [Y/n] y
# # Selecting previously unselected package libcudnn5.
# # (Reading database ... 241833 files and directories currently installed.)
# # Preparing to unpack .../libcudnn5_5.1.10-1+cuda8.0_amd64.deb ...
# # Unpacking libcudnn5 (5.1.10-1+cuda8.0) ...
# # Selecting previously unselected package libgie1.
# # Preparing to unpack .../libgie1_1.1.2-1+cuda8.0_amd64.deb ...
# # Unpacking libgie1 (1.1.2-1+cuda8.0) ...
# # Setting up libcudnn5 (5.1.10-1+cuda8.0) ...
# # Setting up libgie1 (1.1.2-1+cuda8.0) ...
# # Processing triggers for libc-bin (2.19-0ubuntu6.11) ...
# # /sbin/ldconfig.real: /usr/local/cuda-8.0/targets/x86_64-linux/lib/libcudnn.so.5 is not a symbolic link
# #########


# nvidia-smi -q | grep "Driver Version"


# DW_CUDA_ERROR: TensorRT: Compute capability 5.0 or higher required.

# /usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery

# http://stackoverflow.com/questions/11973174/what-does-compute-capability-mean-w-r-t-cuda


# http://cuda-programming.blogspot.in/2013/01/what-is-compute-capability-in-cuda.html
# https://web.stanford.edu/group/proclus/cgi-bin/mediawiki/index.php/Software-CUDA

# ## OpenCV on CUDA
# http://rolflussi.blogspot.in/2015_09_01_archive.html    

# http://textminingonline.com/dive-into-tensorflow-part-iii-gtx-1080-ubuntu16-04-cuda8-0-cudnn5-0-tensorflow

# ## Tensorflow
# #https://www.tensorflow.org/install/install_linux
# sudo apt install libcupti-dev

# python -V
# python3 -V

# ## OpenGL Installation
# #https://en.wikibooks.org/wiki/OpenGL_Programming/Installation/Linux
# #https://askubuntu.com/questions/389901/how-do-i-get-opengl-working-on-an-nvidia-geforce-gt-750m

# glxinfo | grep OpenGL
# #The program 'glxinfo' is currently not installed. You can install it by typing:
# #sudo apt-get install mesa-utils
# sudo -E apt -q -y install mesa-utils

# ##################
# #game@game-pc:~/Documents/driveworks/bin$ glxinfo | grep OpenGL
# #OpenGL vendor string: NVIDIA Corporation
# #OpenGL renderer string: GeForce GT 730/PCIe/SSE2
# #OpenGL core profile version string: 4.3.0 NVIDIA 375.51
# #OpenGL core profile shading language version string: 4.30 NVIDIA via Cg compiler
# #OpenGL core profile context flags: (none)
# #OpenGL core profile profile mask: core profile
# #OpenGL core profile extensions:
# #OpenGL version string: 4.5.0 NVIDIA 375.51
# #OpenGL shading language version string: 4.50 NVIDIA
# #OpenGL context flags: (none)
# #OpenGL profile mask: (none)
# ##################
# OpenGL extensions:



# ## Driverworks
# # https://developer.nvidia.com/driveworks


# --
# https://developer.android.com/ndk/downloads/index.html
# ============

# ERROR: /home/game/softwares/tensorflow/tensorflow/tools/pip_package/BUILD:114:1: no such package '@nasm//': java.io.IOException:
# Error downloading [
# https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2,
# http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2
# ]

# to /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/nasm/nasm-2.12.02.tar.bz2: All mirrors are down: [java.lang.RuntimeException: Could not generate DH keypair] and referenced by '//tensorflow/tools/pip_package:licenses'
# ERROR: Analysis of target '//tensorflow/tools/pip_package:build_pip_package' failed; build aborted: no such package '@nasm//': java.io.IOException: Error downloading [https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2, http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2] to /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/nasm/nasm-2.12.02.tar.bz2: All mirrors are down: [java.lang.RuntimeException: Could not generate DH keypair]
# INFO: Elapsed time: 50.221s
# FAILED: Build did NOT complete successfully (104 packages loaded)

# Fix:
# https://github.com/tensorflow/tensorflow/issues/16862

# "https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2",  
#           "http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2",
#           "http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2",

# ## Clone Repo give this error

# WARNING: /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/protobuf_archive/WORKSPACE:1: Workspace name in /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/protobuf_archive/WORKSPACE (@com_google_protobuf) does not match the name given in the repository's definition (@protobuf_archive); this will cause a build error in future versions
# WARNING: /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/grpc/WORKSPACE:1: Workspace name in /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/grpc/WORKSPACE (@com_github_grpc_grpc) does not match the name given in the repository's definition (@grpc); this will cause a build error in future versions
# ERROR: /home/game/softwares/tensorflow/tensorflow/tools/pip_package/BUILD:114:1: no such package '@boringssl//': java.io.IOException: thread interrupted and referenced by '//tensorflow/tools/pip_package:licenses'
# ERROR: Analysis of target '//tensorflow/tools/pip_package:build_pip_package' failed; build aborted: no such package '@boringssl//': java.io.IOException: thread interrupted
# INFO: Elapsed time: 80.787s
# FAILED: Build did NOT complete successfully (106 packages loaded)
