#!/bin/bash

##----------------------------------------------------------
## Nvidia Graphics Card Driver Installation
## Steps for Manual Installation only
##----------------------------------------------------------

## How do I find out the model of my graphics card?

##01:00.0 VGA compatible controller: NVIDIA Corporation GK208 [GeForce GT 730] (rev a1)
lspci  -v -s  $(lspci | grep VGA | cut -d" " -f 1)
lspci | grep VGA
lspci | grep -i nvidia
sudo lswh -c video

## https://askubuntu.com/questions/5417/how-to-get-gpu-info/392944#392944
#01:00.0 VGA compatible controller: NVIDIA Corporation GK208 [GeForce GT 730] (rev a1) (prog-if 00 [VGA controller])
#	Subsystem: ZOTAC International (MCO) Ltd. Device 730b
#	Flags: bus master, fast devsel, latency 0, IRQ 28
#	Memory at db000000 (32-bit, non-prefetchable) [size=16M]
#	Memory at d0000000 (64-bit, prefetchable) [size=128M]
#	Memory at d8000000 (64-bit, prefetchable) [size=32M]
#	I/O ports at 3000 [size=128]
#	Expansion ROM at dc000000 [disabled] [size=512K]
#	Capabilities: <access denied>
#	Kernel driver in use: nouveau
##

## https://wiki.archlinux.org/index.php/NVIDIA
# NV108 (GK208) 	GeForce GT 630, 635, 640, 710M, 720M, 730M, 735M, 740M Quadro K510M, K610M


sudo apt-get remove nvidia* && sudo apt-get autoremove
sudo stop lightdm
sudo stop gdm
sudo stop kdm
#sudo apt-get install linux-headers-generic nvidia-current
#sudo nvidia-xconfig

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
#sudo apt-get -purge remove xserver-xorg-video-nouveau
sudo sh -c 'echo "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/disable-nouveau.conf'
sudo apt-get install nvidia-310

#https://devtalk.nvidia.com/default/topic/977617/cuda-driver-version-is-insufficient-for-cuda-runtime-version/

#>> https://askubuntu.com/questions/436488/install-nvidia-driver-for-cuda-to-use-gpu-option-in-blender-ubuntu-13-10-1



#https://askubuntu.com/questions/4662/where-is-the-x-org-config-file-how-do-i-configure-x-there

## Check nvidia libs to be purged
sudo apt-get -s purge 'nvidia-*'
sudo apt-get -s purge 'cuda*'
sudo apt-get -s purge 'cudnn*'
apt-get -s purge $(dpkg -l | awk '$2~/nvidia/ {print $2}')


# 1> apt-get repository based installation

# 2> Run File based installation
## Download appropriate Driver
# http://us.download.nvidia.com/XFree86/Linux-x86_64/387.22/NVIDIA-Linux-x86_64-387.22.run
## MANUAL Search
#http://www.nvidia.com/Download/index.aspx?lang=en-us


NVIDIA-Linux-x86_64-375.39.run

chmod +x NVIDIA-Linux-x86_64-375.39.run
sudo ./NVIDIA-Linux-x86_64-375.39.run

# 3> Along with cudatoolkit installation

## purge every nvidia
sudo apt-get purge 'nvidia-*'


# Cuda Installation
## https://stgraber.org/2017/03/21/cuda-in-lxd/
## Download Cuda Toolkit: https://developer.nvidia.com/cuda-downloads


### Ubuntu 16.04
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb

### Ubuntu 14.04
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1404_8.0.44-1_amd64.deb

sudo apt update

sudo dpkg -i cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64.deb
sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
sudo apt update
sudo apt install -y cuda-toolkit-9-1


## Meta Packages Available for CUDA 9.1
## Installs all CUDA Toolkit and Driver packages. Handles upgrading to the next version of the cuda package when it's released
## This does not install the latest version of Nvidia driver, hence not sugggested
sudo apt install cuda
## Installs all CUDA Toolkit packages required to develop CUDA applications. Does not include the driver.
sudo apt install -y cuda-toolkit-9-1

#$HOME/.bashrc

export CUDA_HOME=/usr/local/cuda-8.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDA_HOME}/lib64
export PATH=$PATH:${CUDA_HOME}/bin


export CUDA_HOME="/usr/local/cuda"
export PATH="/usr/local/cuda/bin:$PATH"
source $HOME/.bashrc

nvcc -V

#nvcc: NVIDIA (R) Cuda compiler driver
#Copyright (c) 2005-2016 NVIDIA Corporation
#Built on Tue_Jan_10_13:22:03_CST_2017
#Cuda compilation tools, release 8.0, V8.0.61


# http://www.r-tutor.com/gpu-computing/cuda-installation/cuda7.5-ubuntu




## https://askubuntu.com/questions/451672/installing-and-testing-cuda-in-ubuntu-14-04
## test if the drivers are working by going to your sample directory

cd /usr/local/cuda/samples
#sudo chown -R <username>:<usergroup> .
sudo chown -R $(whoami):$(whoami) .
cd 1_Utilities/deviceQuery
make
./deviceQuery    

##

# game@game-pc:/usr/local/cuda-8.0/samples/1_Utilities/deviceQuery$ ./deviceQuery 
# ./deviceQuery Starting...

#  CUDA Device Query (Runtime API) version (CUDART static linking)

# Detected 1 CUDA Capable device(s)

# Device 0: "GeForce GT 730"
#   CUDA Driver Version / Runtime Version          8.0 / 8.0
#   CUDA Capability Major/Minor version number:    3.5
#   Total amount of global memory:                 4043 MBytes (4239327232 bytes)
#   ( 2) Multiprocessors, (192) CUDA Cores/MP:     384 CUDA Cores
#   GPU Max Clock rate:                            902 MHz (0.90 GHz)
#   Memory Clock rate:                             800 Mhz
#   Memory Bus Width:                              64-bit
#   L2 Cache Size:                                 524288 bytes
#   Maximum Texture Dimension Size (x,y,z)         1D=(65536), 2D=(65536, 65536), 3D=(4096, 4096, 4096)
#   Maximum Layered 1D Texture Size, (num) layers  1D=(16384), 2048 layers
#   Maximum Layered 2D Texture Size, (num) layers  2D=(16384, 16384), 2048 layers
#   Total amount of constant memory:               65536 bytes
#   Total amount of shared memory per block:       49152 bytes
#   Total number of registers available per block: 65536
#   Warp size:                                     32
#   Maximum number of threads per multiprocessor:  2048
#   Maximum number of threads per block:           1024
#   Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
#   Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
#   Maximum memory pitch:                          2147483647 bytes
#   Texture alignment:                             512 bytes
#   Concurrent copy and kernel execution:          Yes with 1 copy engine(s)
#   Run time limit on kernels:                     Yes
#   Integrated GPU sharing Host Memory:            No
#   Support host page-locked memory mapping:       Yes
#   Alignment requirement for Surfaces:            Yes
#   Device has ECC support:                        Disabled
#   Device supports Unified Addressing (UVA):      Yes
#   Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
#   Compute Mode:
#      < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

# deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 8.0, CUDA Runtime Version = 8.0, NumDevs = 1, Device0 = GeForce GT 730
# Result = PASS
# cat /proc/driver/nvidia/version
########

## cuDNN Installation
#http://www.pyimagesearch.com/2016/07/04/how-to-install-cuda-toolkit-and-cudnn-for-deep-learning/

- download and extract cudnn. It has cuda directory and has includ and lib64 folders inside. Copy these folder files to the cuda installation directory

tar -zxf cudnn-7.5-linux-x64-v5.0-ga.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/


## tensorrt installation

sudo dpkg -i nv-gie-repo-ubuntu1404-ga-cuda8.0-gie1.0-20170116_6-1_amd64.deb
sudo apt update
sudo apt install libgie1

# game@game-pc:~/Downloads/TensorRT$ sudo apt install libgie1
# Reading package lists... Done
# Building dependency tree       
# Reading state information... Done
# The following extra packages will be installed:
#   libcudnn5
# The following NEW packages will be installed:
#   libcudnn5 libgie1
# 0 upgraded, 2 newly installed, 0 to remove and 19 not upgraded.
# Need to get 0 B/46.4 MB of archives.
# After this operation, 132 MB of additional disk space will be used.
# Do you want to continue? [Y/n] y
# Selecting previously unselected package libcudnn5.
# (Reading database ... 241833 files and directories currently installed.)
# Preparing to unpack .../libcudnn5_5.1.10-1+cuda8.0_amd64.deb ...
# Unpacking libcudnn5 (5.1.10-1+cuda8.0) ...
# Selecting previously unselected package libgie1.
# Preparing to unpack .../libgie1_1.1.2-1+cuda8.0_amd64.deb ...
# Unpacking libgie1 (1.1.2-1+cuda8.0) ...
# Setting up libcudnn5 (5.1.10-1+cuda8.0) ...
# Setting up libgie1 (1.1.2-1+cuda8.0) ...
# Processing triggers for libc-bin (2.19-0ubuntu6.11) ...
# /sbin/ldconfig.real: /usr/local/cuda-8.0/targets/x86_64-linux/lib/libcudnn.so.5 is not a symbolic link
#########


nvidia-smi -q | grep "Driver Version"


#DW_CUDA_ERROR: TensorRT: Compute capability 5.0 or higher required.

#/usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery

#http://stackoverflow.com/questions/11973174/what-does-compute-capability-mean-w-r-t-cuda

#http://cuda-programming.blogspot.in/2013/01/what-is-compute-capability-in-cuda.html
#https://web.stanford.edu/group/proclus/cgi-bin/mediawiki/index.php/Software-CUDA

## OpenCV on CUDA
#http://rolflussi.blogspot.in/2015_09_01_archive.html	
#
#http://textminingonline.com/dive-into-tensorflow-part-iii-gtx-1080-ubuntu16-04-cuda8-0-cudnn5-0-tensorflow

## Tensorflow
#https://www.tensorflow.org/install/install_linux
sudo apt install libcupti-dev

python -V
python3 -V

## OpenGL Installation
#https://en.wikibooks.org/wiki/OpenGL_Programming/Installation/Linux
#https://askubuntu.com/questions/389901/how-do-i-get-opengl-working-on-an-nvidia-geforce-gt-750m

glxinfo | grep OpenGL
#The program 'glxinfo' is currently not installed. You can install it by typing:
#sudo apt-get install mesa-utils
sudo -E apt -q -y install mesa-utils

##################
#game@game-pc:~/Documents/driveworks/bin$ glxinfo | grep OpenGL
#OpenGL vendor string: NVIDIA Corporation
#OpenGL renderer string: GeForce GT 730/PCIe/SSE2
#OpenGL core profile version string: 4.3.0 NVIDIA 375.51
#OpenGL core profile shading language version string: 4.30 NVIDIA via Cg compiler
#OpenGL core profile context flags: (none)
#OpenGL core profile profile mask: core profile
#OpenGL core profile extensions:
#OpenGL version string: 4.5.0 NVIDIA 375.51
#OpenGL shading language version string: 4.50 NVIDIA
#OpenGL context flags: (none)
#OpenGL profile mask: (none)
##################
#OpenGL extensions:
#
#
#
## Driverworks
# https://developer.nvidia.com/driveworks
#
#
#--
#https://developer.android.com/ndk/downloads/index.html
#============
#
#ERROR: /home/game/softwares/tensorflow/tensorflow/tools/pip_package/BUILD:114:1: no such package '@nasm//': java.io.IOException:
#Error downloading [
#https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2,
#http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2
#]
#
#to /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/nasm/nasm-2.12.02.tar.bz2: All mirrors are down: [java.lang.RuntimeException: Could not generate DH keypair] and referenced by '//tensorflow/tools/pip_package:licenses'
#ERROR: Analysis of target '//tensorflow/tools/pip_package:build_pip_package' failed; build aborted: no such package '@nasm//': java.io.IOException: Error downloading [https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2, http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2] to /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/nasm/nasm-2.12.02.tar.bz2: All mirrors are down: [java.lang.RuntimeException: Could not generate DH keypair]
#INFO: Elapsed time: 50.221s
#FAILED: Build did NOT complete successfully (104 packages loaded)
#
#Fix:
#https://github.com/tensorflow/tensorflow/issues/16862
#
#"https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2",  
#          "http://www.nasm.us/pub/nasm/releasebuilds/2.12.02/nasm-2.12.02.tar.bz2",
#          "http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2",
#
## Clone Repo give this error
#
#WARNING: /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/protobuf_archive/WORKSPACE:1: Workspace name in /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/protobuf_archive/WORKSPACE (@com_google_protobuf) does not match the name given in the repository's definition (@protobuf_archive); this will cause a build error in future versions
#WARNING: /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/grpc/WORKSPACE:1: Workspace name in /home/game/.cache/bazel/_bazel_game/0a0de1cc8da9b3ca31395362f91a467c/external/grpc/WORKSPACE (@com_github_grpc_grpc) does not match the name given in the repository's definition (@grpc); this will cause a build error in future versions
#ERROR: /home/game/softwares/tensorflow/tensorflow/tools/pip_package/BUILD:114:1: no such package '@boringssl//': java.io.IOException: thread interrupted and referenced by '//tensorflow/tools/pip_package:licenses'
#ERROR: Analysis of target '//tensorflow/tools/pip_package:build_pip_package' failed; build aborted: no such package '@boringssl//': java.io.IOException: thread interrupted
#INFO: Elapsed time: 80.787s
#FAILED: Build did NOT complete successfully (106 packages loaded)

