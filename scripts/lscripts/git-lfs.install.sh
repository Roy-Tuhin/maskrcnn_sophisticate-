#!/bin/bash
##----------------------------------------------------------
# git-lfs
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://git-lfs.github.com/
#
## Git Large File Storage (LFS) replaces large files such as audio samples, videos, datasets, and graphics with text pointers inside Git, while storing the file contents on a remote server like GitHub.com or GitHub Enterprise.
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/lscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi
if [ -z "$GITLFS_VER" ]; then
  GITLFS_VER="v2.6.1"
  echo "Unable to get GITLFS_VER version, falling back to default version#: $GITLFS_VER"
fi

PROG='git-lfs'
OS_VER='linux-amd64'
DIR="$PROG-$OS_VER-$GITLFS_VER"
PROG_DIR="$BASEPATH/$PROG-$OS_VER-$GITLFS_VER"
FILE="$DIR.tar.gz"

URL="https://github.com/$PROG/$PROG/releases/download/$GITLFS_VER/$FILE"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c $URL -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $HOME/softwares/$PROG ]; then
  mkdir $BASEPATH/$PROG
  tar xvfz $HOME/Downloads/$FILE -C $BASEPATH/$PROG
else
  echo Extracted Dir already exists: $BASEPATH/$PROG
fi


export PATH=$PATH:$HOME/softwares/git-lfs

# cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------
