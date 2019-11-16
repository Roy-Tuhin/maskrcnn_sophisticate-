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
## CUDA 8.0 GA2
## https://developer.nvidia.com/cuda-80-ga2-download-archive
## Base Installer
## wget -c https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
## wget -c https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb

#
## Patch 1 (Base Installer must be installed first)
## wget -c https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run
## wget -c https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64-deb
#
## Checksums
## https://developer.download.nvidia.com/compute/cuda/8.0/secure/Prod2/docs/sidebar/md5sum.txt?HbzrIx2LOBym_EMfTXT8oTdSSejhGzxLc_XvxAoLz0xl14UiRx7VuycZElFp_9MlBBBTypa4mpz2VQmvanEaMo2ZcgpgmG5Q6m6wCxVJjMne_1xx7ywf7V15TcWTEojaWMScxYZEt9CLmK_MYuYskqplDFo
#
## Installation Guide
## https://developer.download.nvidia.com/compute/cuda/8.0/secure/Prod2/docs/sidebar/CUDA_Installation_Guide_Linux.pdf?Yc0JYDoRaRvFcpuA36PKen1a3KFrw8xetQ_M7VJwbEY8AOK3bhw1pIVTyoZA8y8WHl-LnFy5uH49E_i5xSKTkLZiAHibNz5fjElUj6TZ-b9q50wl0r6xGpCRsMn21TAwf-IbEO4JhX3B4JQtD06VSr15vhcU-I-sMKhlZT1dZXhxoLTH4eShqpLwjw
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

CUDA_VER="8.0"
CUDA_REL="8-0"
# CUDA_REL=`echo $CUDA_VER | tr . -`
CUDA_OS_REL="1604"
CUDA_PCKG="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_REL-local_ga2_$CUDA_VER.61-1_amd64"
# CUDA_PCKG="cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb"
# cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
CUDA_PATCH="cuda-repo-ubuntu$CUDA_OS_REL-$CUDA_VER-local-cublas-performance-update_$CUDA_VER.61-1_amd64.deb"


echo "CUDA $CUDA_VER : Base Installer (Local deb file) : $CUDA_PCKG"
echo "CUDA $CUDA_VER : Patch (Local deb file) : $CUDA_PATCH"

if [ ! -f "$HOME/Downloads/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb" ]; then
  ### Ubuntu 16.04
  # CUDA_PCKG="cuda-repo-ubuntu1604_8.0.61-1_amd64.deb" # CUDA 8.0 package
  wget -c http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb -P $HOME/Downloads
  # wget -c https://developer.download.nvidia.com/compute/cuda/8.0/secure/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb -P $HOME/Downloads
  
  ### Ubuntu 14.04
  # CUDA_PCKG="cuda-repo-ubuntu1404_8.0.44-1_amd64.deb"
  # wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/$CUDA_PCKG -P $HOME/Downloads  
else
  echo Not downloading as: $HOME/Downloads/$CUDA_PCKG already exists!
fi

if [ ! -f $HOME/Downloads/$CUDA_PATCH ]; then
  ### Ubuntu 16.04
  ## CUDA 8.0 Patch
  wget -c https://developer.download.nvidia.com/compute/cuda/8.0/secure/Prod2/patches/2/$CUDA_PATCH -P $HOME/Downloads
  #wget -c https://developer.download.nvidia.com/compute/cuda/8.0/secure/Prod2/patches/2/cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb -P $HOME/Downloads  
else
  echo Not downloading as: $HOME/Downloads/$CUDA_PATCH already exists!
fi

# if [ -f $HOME/Downloads/$CUDA_PCKG ]; then
#   ## Remove Any existing CUDA and CUDNN installation
#   #sudo apt -s purge 'cuda*'
#   #sudo apt -s purge 'cudnn*'

#   # sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
#   # sudo dpkg -i cuda-repo-ubuntu1404_8.0.44-1_amd64.deb
#   #
#   sudo dpkg -i $HOME/Downloads/$CUDA_PCKG

#   #sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
#   sudo apt-key add /var/cuda-repo-$CUDA_REL-local/7fa2af80.pub

#   sudo -E apt update

#   #sudo -E apt -q -y install cuda-toolkit-9-1
#   sudo -E apt -q -y install cuda-toolkit-$CUDA_REL

#   ##----------------------------------------------------------
#   ## Meta Packages Available for CUDA 9.1
#   ## Refer CUDA Installation Manual
#   ##----------------------------------------------------------#
#   ## Installs all CUDA Toolkit and DriCUDA_VER packages.
#   ## Handles upgrading to the next CUDA_VERsion of the cuda package when it's CUDA_RELeased
#   ## This does not install the latest CUDA_VERsion of Nvidia driCUDA_VER, hence not sugggested
#   #
#   ## sudo -E apt -q -y install cuda
#   #
#   ## Installs all CUDA Toolkit packages required to develop CUDA applications. Does not include the driCUDA_VER.
#   #
#   ## sudo -E apt -q -y install cuda-toolkit-9-1
#   #
#   ##----------------------------------------------------------

#   ##----------------------------------------------------------
#   ### CUDA Config
#   ##----------------------------------------------------------
#   source  $LINUX_SCRIPT_HOME/cuda.config.sh
# fi


##----------------------------------------------------------
### cuDNN 4
##----------------------------------------------------------

# https://developer.nvidia.com/rdp/cudnn-archive
# https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v4/prod/install.txt?rs02egwgL-r_dGZJxYYqZBo_eyE2hc8CNYI525BHxbOtj1715xn-4JA9Bmmq-5Awgjd35tQqe8zRowkoHF5kqaAFcU_dN_xAS-q5tBkSt_U0iHsifJ8oV3gNVDJomryNDuL0Npbac3lilOX1uZoCz-EZgafTvM4f

# Re-link default to CUDA-9.0

sudo rm /usr/local/cuda
sudo ln -s /usr/local/cuda-9.0 /usr/local/cuda


cuDNN_4_PATH="$HOME/softwares/cudnn-7.0-linux-x64-v4.0-prod"
export LD_LIBRARY_PATH=$cuDNN_4_PATH:$LD_LIBRARY_PATH

sudo update-alternatives --config gcc


sudo rm /usr/local/cuda
sudo ln -s /usr/local/cuda-8.0 /usr/local/cuda
cuDNN_4_SAMPLE="$HOME/softwares/cudnn-sample-v4"
cd $cuDNN_4_SAMPLE/mnistCUDNN
make clean && make
./mnistCUDNN


# Add <installpath> to your build and link process by adding -I<installpath> to your compile
# line and -L<installpath> -lcudnn to your link line.


https://gist.github.com/acmiyaguchi/bc535ba23eabd3564edd73e491763d50
https://github.com/rbgirshick/py-faster-rcnn/issues/509