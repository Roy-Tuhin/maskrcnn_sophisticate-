#!/bin/bash

##----------------------------------------------------------
## redis
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker.
#
## https://github.com/antirez/redis-io
## wget -c http://download.redis.io/redis-stable.tar.gz
#
## https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
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

PROG='redis-stable'
DIR=$PROG
PROG_DIR="$BASEPATH/$PROG"
FILE="$PROG.tar.gz"

URL="http://download.redis.io/$FILE"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -f $HOME/Downloads/$FILE ]; then
  wget -c $URL -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $HOME/softwares/$DIR ]; then
  tar xvfz $HOME/Downloads/$FILE -C $HOME/softwares
else
  echo Extracted Dir already exists: $HOME/softwares/$DIR
fi

cd $PROG_DIR
make -j$NUMTHREADS
make test -j$NUMTHREADS
sudo make install

# cd $LINUX_SCRIPT_HOME

##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------
