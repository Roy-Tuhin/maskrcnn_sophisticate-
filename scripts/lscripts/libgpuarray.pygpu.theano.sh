#!/bin/bash

##----------------------------------------------------------
## libgpuarray, pygpu
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://deeplearning.net/software/libgpuarray/installation.html#step-by-step-install
## https://github.com/roebius/deeplearning_keras2/issues/3
#
# 
## https://github.com/Theano/Theano/issues/6006
## https://stackoverflow.com/questions/43577788/error-loading-library-gpuarray-with-theano
## http://fileadmin.cs.lth.se/cs/Personal/Calle_Lejdfors/pygpu/
##
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

PROG='libgpuarray'
DIR="$PROG"
PROG_DIR="$BASEPATH/$PROG"

URL="https://github.com/Theano/$PROG.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Git clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

mkdir $PROG_DIR/build
cd $PROG_DIR/build
cmake -DCMAKE_BUILD_TYPE=Release ..

make -j$NUMTHREADS
sudo make install -j$NUMTHREADS
sudo ldconfig

## switch to virtual enviroment
## cd ..
python setup.py build
sudo python setup.py install

python3 setup.py build
sudo python3 setup.py install
# python setup.py install --user

## python prerequisites should be installed
## libnccl should be installed

## sudo pip2 install mako six nose
## sudo pip3 install mako six nose

## copy pygpu manually to virtualenv (as somehow it does nto get installed directly on virtualenv)
## Try copying:
## pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg
## OR
## pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg/pygpu

# cp -r /usr/local/lib/python3.6/dist-packages/pygpu-0.7.6+5.g8786e0f-py3.6-linux-x86_64.egg/pygpu $PY_VENV_PATH/py_3-6-5_2018-11-20/lib/python3.6/site-packages/.

# cp -r /usr/local/lib/python2.7/dist-packages/pygpu-0.7.6+5.g8786e0f-py2.7-linux-x86_64.egg/pygpu $PY_VENV_PATH/py_2-7-15_2018-11-20/lib/python2.7/site-packages/.

## Test
DEVICE="cuda" python -c "import pygpu;pygpu.test()"

cd $LINUX_SCRIPT_HOME


FILE=$HOME/.bashrc
LINE='export DEVICE="cuda"'
echo $LINE
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
