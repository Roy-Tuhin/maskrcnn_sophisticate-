#!/bin/bash

##----------------------------------------------------------
#
### CUDA
## Tested on Ubuntu 16.04 LTS
## Nvidia GTX 1080 Ti, Driver version 390.42, CUDA 9.0, 9.1
#
## Tested on Ubuntu 18.04 LTS
## Nvidia GeForce 940MX, Deriver version 390, CUDA 9.0, 9.1 on Dell Latitude 5580
#
##----------------------------------------------------------
#
## Cuda Installation
#
##----------------------------------------------------------
#
## https://www.pugetsystems.com/labs/hpc/How-to-install-CUDA-9-2-on-Ubuntu-18-04-1184/
## https://stgraber.org/2017/03/21/cuda-in-lxd/
## Download Cuda Toolkit:
## https://developer.nvidia.com/cuda-downloads
#
## CUDA 9.0
## https://developer.nvidia.com/cuda-90-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=deblocal
#
## CUDA 9.1
## https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=deblocal
#
## CUDA 9.2
## https://developer.nvidia.com/cuda-91-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=deblocal
#
## NOTE:
## Latest CUDA release may not be available with other pre-compiled frameworks like tensorflow etc.
## Hence, always better to check the compatibility with them.
## On a safer side take at least 1 or 2 release earlier.
#
## Multiple CUDA, CuDNN version configuration
## https://blog.kovalevskyi.com/multiple-version-of-cuda-libraries-on-the-same-machine-b9502d50ae77
### sudo ./cuda_8.0.61_375.26_linux.run --silent --toolkit --toolkitpath=/usr/local/cuda-8.0 --override
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

if [ -z "$CUDA_VER" ]; then
  CUDA_VER="9.0"
  CUDA_REL="9-0"
  # CUDA_REL=`echo $CUDA_VER | tr . -`
  CUDA_OS_REL="1604"
  CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_$CUDA_VER.176-1_amd64.deb"
  echo "Unable to get CUDA_VER version, falling back to default version#: $CUDA_VER"
fi


if [ -z "$CUDA_PCKG" ] || [ -z "$CUDA_URL" ]; then
  echo "Unable to get CUDA_PCKG!"
  CUDA_VER="9.0"
  CUDA_REL="9-0"
  # CUDA_REL=`echo $CUDA_VER | tr . -`
  CUDA_OS_REL="1604"
  CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_$CUDA_VER.176-1_amd64.deb"
  CUDA_URL="http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/$CUDA_PCKG"
  echo "Unable to get CUDA_VER version, falling back to default version#: $CUDA_VER"
fi

echo "CUDA_PCKG: $CUDA_PCKG"
echo "CUDA_URL: $CUDA_URL"

if [ ! -f $HOME/Downloads/$CUDA_PCKG ]; then
  ### Ubuntu 16.04
  # CUDA_PCKG="cuda-repo-ubuntu1604_8.0.61-1_amd64.deb" # CUDA 8.0 package
  wget -c $CUDA_URL -P $HOME/Downloads

  ### Ubuntu 14.04
  # CUDA_PCKG="cuda-repo-ubuntu1404_8.0.44-1_amd64.deb"
  # wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/$CUDA_PCKG -P $HOME/Downloads  
else
  echo Not downloading as: $HOME/Downloads/$CUDA_PCKG already exists!
fi

if [ -f $HOME/Downloads/$CUDA_PCKG ]; then
  ## Remove Any existing CUDA and CUDNN installation
  #sudo apt -s purge 'cuda*'
  #sudo apt -s purge 'cudnn*'

  # sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
  # sudo dpkg -i cuda-repo-ubuntu1404_8.0.44-1_amd64.deb
  #
  sudo dpkg -i $HOME/Downloads/$CUDA_PCKG

  #sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
  sudo apt-key add /var/cuda-repo-$CUDA_REL-local/7fa2af80.pub

  sudo -E apt update

  #sudo -E apt -q -y install cuda-toolkit-9-1
  sudo -E apt -q -y install cuda-toolkit-$CUDA_REL

  ##----------------------------------------------------------
  ## Meta Packages Available for CUDA 9.1
  ## Refer CUDA Installation Manual
  ##----------------------------------------------------------#
  ## Installs all CUDA Toolkit and DriCUDA_VER packages.
  ## Handles upgrading to the next CUDA_VERsion of the cuda package when it's CUDA_RELeased
  ## This does not install the latest CUDA_VERsion of Nvidia driCUDA_VER, hence not sugggested
  #
  ## sudo -E apt -q -y install cuda
  #
  ## Installs all CUDA Toolkit packages required to develop CUDA applications. Does not include the driCUDA_VER.
  #
  ## sudo -E apt -q -y install cuda-toolkit-9-1
  #
  ##----------------------------------------------------------

  ##----------------------------------------------------------
  ### CUDA Config
  ##----------------------------------------------------------
  source  $LINUX_SCRIPT_HOME/cuda.config.sh
fi
