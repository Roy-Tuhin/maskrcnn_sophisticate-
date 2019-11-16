#!/bin/bash

## Reference:
# Followed the steps given in following blogs:
# - https://www.learnopencv.com/installing-deep-learning-frameworks-on-ubuntu-with-cuda-support/

## install tensforflow from source for CUDA 9.1 support
# - http://www.python36.com/install-tensorflow141-gpu/
# - https://www.tensorflow.org/install/install_sources
#
## Troubleshooting
# 1. no such package '@nasm//': java.io.IOException: Error downloading
# https://github.com/tensorflow/tensorflow/issues/16862

# Nvidia Driver setup
# Manual Search
# http://www.nvidia.com/Download/index.aspx?lang=en-us

# sudo service lightdm stop
# chmod +x NVIDIA-Linux-x86_64-390.42.run
# sudo ./NVIDIA-Linux-x86_64-390.42.run
## https://en.wikipedia.org/wiki/Dynamic_Kernel_Module_Support

## Download Install CUDA
# * https://developer.nvidia.com/cuda-downloads
# * http://docs.nvidia.com/cuda/pdf/CUDA_Installation_Guide_Linux.pdf

sudo apt-get install -y build-essential cmake gfortran git pkg-config
sudo apt-get install -y python-dev software-properties-common wget vim

### System Configurations
####**Verify You Have a Supported Version of Linux**
uname -m && cat /etc/*release
####**Verify the System has the Correct KernelHeaders and Development Packages Installed**
uname -r
sudo apt-get install linux-headers-$(uname -r)

### Developer toolchain versions
####**Verify the System Has gcc Installed**
gcc --version

sudo dpkg -i cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64.deb
#sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub
sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
sudo apt-get update
# sudo apt-get install cuda
sudo apt-get install cuda-toolkit-9-1


## Install cuDNN

sudo dpkg -i libcudnn7_7.1.2.21-1+cuda9.1_amd64.deb
sudo dpkg -i libcudnn7-dev_7.1.2.21-1+cuda9.1_amd64.deb
sudo dpkg -i libcudnn7-doc_7.1.2.21-1+cuda9.1_amd64.deb
cp -r /usr/src/cudnn_samples_v7/ /home/game/softwares/
cd /home/game/softwares/cudnn_samples_v7/
cd mnistCUDNN/
make clean && make
./mnistCUDNN

## Install requirements for DL Frameworks

sudo apt-get update
sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libopencv-dev

### Install python 2 and 3 along with other important packages like boost, lmdb, glog, blas etc.
sudo apt-get install -y --no-install-recommends libboost-all-dev doxygen
sudo apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev libblas-dev 
sudo apt-get install -y libatlas-base-dev libopenblas-dev libgphoto2-dev libeigen3-dev libhdf5-dev 
 
sudo apt-get install -y python-dev python-pip python-nose python-numpy python-scipy
sudo apt-get install -y python3-dev python3-pip python3-nose python3-numpy python3-scipy


## Enable Virtual Environments
# Refer: python.virtualenv-setup.install.sh
source python.virtualenv-setup.install.sh

## Install Deep Learning frameworks

### Install OpenCV 3.3
sudo apt-get remove x264 libx264-dev
sudo apt-get install -y checkinstall yasm
sudo apt-get install -y libjpeg8-dev libjasper-dev libpng12-dev
 
# If you are using Ubuntu 14.04
sudo apt-get install -y libtiff4-dev
 
# If you are using Ubuntu 16.04
sudo apt-get install -y libtiff5-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
 
sudo apt-get install -y libxine2-dev libv4l-dev
sudo apt-get install -y libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt-get install -y libqt4-dev libgtk2.0-dev libtbb-dev
sudo apt-get install -y libfaac-dev libmp3lame-dev libtheora-dev
sudo apt-get install -y libvorbis-dev libxvidcore-dev
sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get install -y x264 v4l-utils

### we install Tensorflow, Keras, PyTorch, dlib along with other standard Python ML libraries like numpy, scipy, sklearn etc.


# **Deep Learning Framework**
# * Caffe
# * Caffe2
# * Chainer
# * CNTK(Microsoft Cognitive Toolkit)
# * Deeplearning4j
# * Keras
# * MATLAB
# * MxNet
# * TensorFlow
# * Theano
# * Torch/PyTorch

echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"' >> ~/.bashrc
echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc
echo 'export PATH="/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
# Please set them or make sure they are set and tested correctly in the CMake files:
# CUDA_nppi_LIBRARY (ADVANCED)


# create a virtual environment for python 2
mkvirtualenv virtual-py2 -p python2
# Activate the virtual environment
workon virtual-py2
 
pip install numpy scipy matplotlib scikit-image scikit-learn ipython protobuf jupyter
 
# If you do not have CUDA installed
pip install tensorflow
# If you have CUDA installed
pip install tensorflow-gpu 

# https://pytorch.org
pip install Theano && pip install keras && pip install dlib && pip install http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp27-cp27mu-manylinux1_x86_64.whl


## pip3
pip install https://download.pytorch.org/whl/cu100/torch-1.1.0-cp37-cp37m-linux_x86_64.whl
pip install https://download.pytorch.org/whl/cu100/torchvision-0.3.0-cp37-cp37m-linux_x86_64.whl

deactivate


#ImportError: libcusolver.so.9.0: cannot open shared object file: No such file or directory
ldconfig -p | grep cuda

# Python 3.5.2 (default, Nov 23 2017, 16:37:01)
#https://www.tensorflow.org/install/install_linux
pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.6.0-cp35-cp35m-linux_x86_64.whl

## Driverworks
# https://developer.nvidia.com/driveworks

## CUDA version
nvcc --version
#Then:
dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb

#Then:
aptitude update

#Then:
aptitude install cuda-9-0


## cuDNN
# https://stackoverflow.com/questions/31326015/how-to-verify-cudnn-installation

## Alternative
sudo update-alternatives --config java

#-------------------------------------------------------------
#
## install tensforflow from source for CUDA 9.1 support
#
#-------------------------------------------------------------
#
#  http://www.python36.com/install-tensorflow141-gpu/
# https://www.tensorflow.org/install/install_sources
# https://taesikna.github.io/install_tensorflow.html

## Compilatation of TF 1.7 for CUDA 9.1 support

# Clonned github repo gives this error
# WARNING: /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/protobuf_archive/WORKSPACE:1: Workspace name in /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/protobuf_archive/WORKSPACE (@com_google_protobuf) does not match the name given in the repository's definition (@protobuf_archive); this will cause a build error in future versions
# WARNING: /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/grpc/WORKSPACE:1: Workspace name in /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/grpc/WORKSPACE (@com_github_grpc_grpc) does not match the name given in the repository's definition (@grpc); this will cause a build error in future versions
# ERROR: /home/game/softwares/tensorflow/tensorflow/tools/pip_package/BUILD:114:1: no such package '@boringssl//': java.io.IOException: thread interrupted and referenced by '//tensorflow/tools/pip_package:licenses'
# ERROR: Analysis of target '//tensorflow/tools/pip_package:build_pip_package' failed; build aborted: no such package '@boringssl//': java.io.IOException: thread interrupted
# INFO: Elapsed time: 80.787s
# FAILED: Build did NOT complete successfully (106 packages loaded)

git -C || git clone https://github.com/tensorflow/tensorflow.git
git checkout r1.7
cd tensorflow

## Notes:
# 1. Use the wget to get it from the archive
# 2. python2 and python3 support needs to be build separately and then install on virtaul python env respectively

#  Step: Configure Tensorflow from source:
wget https://github.com/tensorflow/tensorflow/archive/v1.7.0.zip
unzip v1.7.0.zip
cd tensorflow-1.7.0
./configure

# ```bash
# Do you wish to build TensorFlow with jemalloc as malloc support? [Y/n]: Y
# Do you wish to build TensorFlow with Google Cloud Platform support? [Y/n]: Y
# Do you wish to build TensorFlow with Hadoop File System support? [Y/n]: Y
# Do you wish to build TensorFlow with Amazon S3 File System support? [Y/n]: Y
# Do you wish to build TensorFlow with Apache Kafka Platform support? [y/N]: N
# Do you wish to build TensorFlow with XLA JIT support? [y/N]: N
# Do you wish to build TensorFlow with GDR support? [y/N]: N
# Do you wish to build TensorFlow with VERBS support? [y/N]: N
# Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: N
# Do you wish to build TensorFlow with CUDA support? [y/N]: Y
# Please specify the CUDA SDK version you want to use, e.g. 7.0. [Leave empty to default to CUDA 9.0]: 9.1
# Please specify the location where CUDA 9.1 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: /usr/local/cuda
# Please specify the cuDNN version you want to use. [Leave empty to default to cuDNN 7.0]: 7.1.2
# Please specify the location where cuDNN 7 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda]: /usr/lib/x86_64-linux-gnu
# Do you wish to build TensorFlow with TensorRT support? [y/N]: N
# Please note that each additional compute capability significantly increases your build time and binary size. [Default is: 5.0]: 6.1
# Do you want to use clang as CUDA compiler? [y/N]: N
# Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]: /usr/bin/gcc
# Do you wish to build TensorFlow with MPI support? [y/N]: N
# Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]: -march=native
# Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]:Y
# ```


## Additional support
# What is XLA?
## https://www.tensorflow.org/performance/xla/

# What is GDR?
## https://github.com/tensorflow/tensorflow/tree/master/tensorflow/contrib/gdr

# What is OpenCL SYCL?
## https://www.khronos.org/sycl
## https://stackoverflow.com/questions/41831214/what-is-sycl-1-2
# https://www.codeplay.com/portal/03-30-17-setting-up-tensorflow-with-opencl-using-sycl

## version checks
## cuDNN
# cat /usr/include/x86_64-linux-gnu/cudnn_v*.h | grep CUDNN_MAJOR -A 2  

## TensorRT - skipped as currently supports CUDA 9.0 only
# https://developer.nvidia.com/nvidia-tensorrt-download
# https://devblogs.nvidia.com/tensorrt-integration-speeds-tensorflow-inference/
# https://devblogs.nvidia.com/tensorrt-3-faster-tensorflow-inference/
# https://medium.com/@changrongko/nv-how-to-check-cuda-and-cudnn-version-e05aa21daf6c
sudo dpkg -i nv-tensorrt-repo-ubuntu1604-cuda9.0-rc-trt4.x.x.x-yyyymmdd_1-1_amd64.deb
sudo apt-get update
sudo apt-get install tensorrt

## Apache Kafka
# https://blog.cloudera.com/blog/2014/09/apache-kafka-for-beginners/

## CUDA compute capability
# https://en.wikipedia.org/wiki/CUDA
# GTX 1080 TI: 6.1

## What is MPI?
# https://en.wikipedia.org/wiki/Message_Passing_Interface
# https://github.com/tensorflow/tensorflow/tree/master/tensorflow/contrib/mpi

#If it says file already exits then ignore it. - skipped
#sudo ln -s /usr/local/cuda/include/crt/math_functions.hpp /usr/local/cuda/include/math_functions.hpp

# tensorflow/workspace.bzl

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

#To build a pip package for TensorFlow with GPU support, invoke the following command:
bazel build --config=opt --config=cuda --incompatible_load_argument_is_label=false //tensorflow/tools/pip_package:build_pip_package

bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.1 --copt=-msse4.2 --config=cuda -k //tensorflow/tools/pip_package:build_pip_package


bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package 

#The bazel build command builds a script named build_pip_package. Running this script as follows will build a .whl file within the /tmp/tensorflow_pkg directory:
##bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg

bazel-bin/tensorflow/tools/pip_package/build_pip_package

# Generate whl
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
# sudo pip2 install <pckNam_that_ws_generated_in_revious_step>



ANDROID_NDK_HOME
ANDROID_SDK_HOME

https://js.tensorflow.org/

## Python Issues
# https://stackoverflow.com/questions/42283426/pip-and-pip3-both-pointing-to-python3-5
# for i in pip pip3 python python3 ; do type $i ; done
#
# use pip2

## Install Caffee
http://caffe.berkeleyvision.org/install_apt.html
https://chunml.github.io/ChunML.github.io/project/Installing-Caffe-Ubuntu/