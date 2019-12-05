#!/bin/bash

##----------------------------------------------------------
### CUDA Config
## Tested on Ubuntu 16.04
## Nvidia GTX 1080 Ti, Driver 390.42, CUDA 9.1
#
## execute the script with `source` command
## example:
## source cuda.config.sh
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

#FILE=$HOME/.bashrc
FILE=$BASHRC_FILE

if [ -z "$CUDA_VER" ]; then
    CUDA_VER="9.0"
fi

# LINE='export CUDA_HOME="/usr/local/cuda-'$CUDA_VER'"'
LINE='export CUDA_HOME="/usr/local/cuda"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE='export PATH="/usr/local/cuda/bin:$PATH"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE='export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64"'
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

# this will work only if the script is invoked with `source` command
source $FILE

echo ""
echo "Checking...CUDA_HOME..."
echo $CUDA_HOME
echo ""

if [ -z "$CUDA_HOME" ]; then
  echo "Run manually or open the new shell"
  echo "source ~/.bashrc"
  echo "Exporting the ENV variables: CUDA_HOME, PATH, LD_LIBRARY_PATH"
  #
  source $FILE
  export CUDA_HOME="/usr/local/cuda"
  export PATH="/usr/local/cuda/bin:$PATH"
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64"
fi

echo ""
echo "Check the CUDA compiler version"
nvcc -V
echo ""

## Test if the drivers are working by going to your sample directory
echo "Test if the drivers are working by going to your sample directory"
echo "Compiling: $CUDA_HOME/samples/1_Utilities/deviceQuery"
echo ""

cd $CUDA_HOME/samples
#sudo chown -R <username>:<usergroup> .
sudo chown -R $(whoami):$(whoami) .
cd 1_Utilities/deviceQuery
make
./deviceQuery    

echo ""
echo "cat /proc/driver/nvidia/version"
echo ""
cat /proc/driver/nvidia/version

cd $LINUX_SCRIPT_HOME

##----------------------------------------------------------
## Dell Latitude 5580 Log
##----------------------------------------------------------
# ./deviceQuery Starting...

#  CUDA Device Query (Runtime API) version (CUDART static linking)

# Detected 1 CUDA Capable device(s)

# Device 0: "GeForce 940MX"
#   CUDA Driver Version / Runtime Version          9.1 / 9.1
#   CUDA Capability Major/Minor version number:    5.0
#   Total amount of global memory:                 2004 MBytes (2101870592 bytes)
#   ( 4) Multiprocessors, (128) CUDA Cores/MP:     512 CUDA Cores
#   GPU Max Clock rate:                            861 MHz (0.86 GHz)
#   Memory Clock rate:                             2505 Mhz
#   Memory Bus Width:                              64-bit
#   L2 Cache Size:                                 1048576 bytes
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
#   Supports Cooperative Kernel Launch:            No
#   Supports MultiDevice Co-op Kernel Launch:      No
#   Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
#   Compute Mode:
#      < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

# deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 9.1, CUDA Runtime Version = 9.1, NumDevs = 1
# Result = PASS

# cat /proc/driver/nvidia/version

# NVRM version: NVIDIA UNIX x86_64 Kernel Module  390.48  Thu Mar 22 00:42:57 PDT 2018
# GCC version:  gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)
########
##----------------------------------------------------------




##----------------------------------------------------------
##
##----------------------------------------------------------
## Sample Output of running the above command: Only for reference purpose
# ./deviceQuery Starting...

#  CUDA Device Query (Runtime API) version (CUDART static linking)

# Detected 1 CUDA Capable device(s)

# Device 0: "GeForce GTX 1080 Ti"
#   CUDA Driver Version / Runtime Version          9.1 / 9.1
#   CUDA Capability Major/Minor version number:    6.1
#   Total amount of global memory:                 11177 MBytes (11720130560 bytes)
#   (28) Multiprocessors, (128) CUDA Cores/MP:     3584 CUDA Cores
#   GPU Max Clock rate:                            1759 MHz (1.76 GHz)
#   Memory Clock rate:                             5505 Mhz
#   Memory Bus Width:                              352-bit
#   L2 Cache Size:                                 2883584 bytes
#   Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
#   Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
#   Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
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
#   Concurrent copy and kernel execution:          Yes with 2 copy engine(s)
#   Run time limit on kernels:                     Yes
#   Integrated GPU sharing Host Memory:            No
#   Support host page-locked memory mapping:       Yes
#   Alignment requirement for Surfaces:            Yes
#   Device has ECC support:                        Disabled
#   Device supports Unified Addressing (UVA):      Yes
#   Supports Cooperative Kernel Launch:            Yes
#   Supports MultiDevice Co-op Kernel Launch:      Yes
#   Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
#   Compute Mode:
#      < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

# deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 9.1, CUDA Runtime Version = 9.1, NumDevs = 1
# Result = PASS
########
##----------------------------------------------------------
