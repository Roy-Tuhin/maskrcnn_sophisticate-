#!/bin/bash

LSCRIPTS=$(pwd)
#export PATH=$PATH:$LSCRIPTS
#echo "PATH: $PATH"
#echo "Inside dir: $LSCRIPTS"

cd $LSCRIPTS

##----------------------------------------------------------
## Deep Learning Frameworks
## For GPU based: Install Nvidia Driver
##----------------------------------------------------------


##----------------------------------------------------------
## -- caffe
##----------------------------------------------------------

## source caffe.source-install.sh  ## Ubuntu 16.04 LTS
source $LSCRIPTS/caffe.install.sh  ## Ubuntu 18.04 LTS

# ##----------------------------------------------------------
# ## -- tensorflow
# ##----------------------------------------------------------

# # ### ** Manual Install - don't run through script, look into script for reference only**
# # source $LSCRIPTS/tensorflow.install.sh
# # export TF_BINARY_URL="https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.9.0-cp36-cp36m-linux_x86_64.whl"

# # ###--download-cache
# # sudo pip3 install -d $HOME/Downloads/pip-cache $TF_BINARY_URL

###--Install from downloaded packages
cd $HOME/Downloads/pip-cache/tensorflow-gpu-py2
sudo pip2 install `ls -1 | tr '\n' ' '`
## pip install `ls -1 | tr '\n' ' '`

cd $HOME/Downloads/pip-cache/tensorflow-gpu-py3
sudo pip3 install `ls -1 | tr '\n' ' '`
## pip install `ls -1 | tr '\n' ' '`

# ##----------------------------------------------------------
# ## -- Keras
# ##----------------------------------------------------------

# ### Download and Install
# # source $LSCRIPTS/keras.install.sh

###--Install from downloaded packages
cd $HOME/Downloads/pip-cache/keras-py2
sudo pip2 install `ls -1 | tr '\n' ' '`
## pip install `ls -1 | tr '\n' ' '`

cd $HOME/Downloads/pip-cache/keras-py3
sudo pip3 install `ls -1 | tr '\n' ' '`
## pip install `ls -1 | tr '\n' ' '`


# ##----------------------------------------------------------
# ## -- Theano
# ##----------------------------------------------------------

sudo pip install Theano>=0.8
sudo pip3 install Theano>=0.8
## pip install Theano

# source $LSCRIPTS/theano.config.sh
