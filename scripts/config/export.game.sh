#!/bin/bash

##----------------------------------------------------------------
## Custom export and alias
##----------------------------------------------------------------

export LINUX_SCRIPT_HOME=$HOME/softwares/linuxscripts
# Virtual Environment Wrapper
#source /usr/local/bin/virtualenvwrapper.sh
#--
export PATH="$PATH:$HOME/softwares/linuxscripts"
#--
export CMAKE_ROOT="/usr/local"
export CMAKE_MODULE_PATH="/usr/local/share/cmake-3.11"
#--
export CUDA_HOME="/usr/local/cuda"
export PATH="/usr/local/cuda/bin:$PATH"
#--
export PATH="$HOME/softwares/proj-4.9.3/build/bin:$PATH"
export PATH="$HOME/softwares/tiff-4.0.8/build/bin:$PATH"
export PATH="$HOME/softwares/libgeotiff-1.4.2/build/bin:$PATH"
export PATH="$HOME/softwares/geos-3.6.1/build/bin:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
#--
export PATH="$PATH:$HOME/softwares/emsdk:$HOME/softwares/emsdk/clang/e1.37.36_64bit:$HOME/softwares/emsdk/node/8.9.1_64bit/bin:$HOME/softwares/emsdk/emscripten/1.37.36"
export EMSDK="$HOME/softwares/emsdk"
export EM_CONFIG="$HOME/.emscripten"
export BINARYEN_ROOT="$HOME/softwares/emsdk/clang/e1.37.36_64bit/binaryen"
export EMSCRIPTEN="$HOME/softwares/emsdk/emscripten/1.37.36"
#--
export FBX_SDK="$HOME/softwares/fbxsdk"
export FBX_SDK_LIBRARY_FILE="$HOME/softwares/fbxsdk/lib"
export FBX_SDK_INCLUDE_DIR="$HOME/softwares/fbxsdk/include"
#--
export ANDROID_SDK_ROOT="$HOME/android/sdk"
export ANDROID_NDK_ROOT="$HOME/android/ndk/android-ndk-r16b"
#--QT
#PATH="$HOME/softwares/qt5/qtbase/bin:$PATH"
PATH="/usr/local/bin:$PATH"
#--
#export PYTHONPATH="$PYTHONPATH:/usr/local/lib/python2.7/dist-packages"
#export PYTHONPATH="$PYTHONPATH:/usr/local/lib/python3.5/dist-packages"
#--
export LINUX_SCRIPTS_PATH="$HOME/softwares/linuxscripts/cmd"
export PATH="$LINUX_SCRIPTS_PATH:$PATH"
#--
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/amd64/server:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/hdf5/serial:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/gtk-2.0/modules:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/gtk-3.0/modules:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH="$HOME/softwares/qt5/qtbase/lib:$LD_LIBRARY_PATH"
#--Boost
#export BOOST_ROOT="$HOME/softwares/boost_1_67_0"
export BOOST_LIBRARYDIR="/usr/local/lib"
export BOOST_INCLUDEDIR="/usr/local/include"
#--

# bender
export PATH=$PATH:$HOME/softwares/blender
#
export PATH="$HOME/softwares/faber/build/scripts-2.7:$PATH"
NPM_PACKAGES=$HOME/.npm-packages
#PATH=/bin:$HOME/softwares/faber/build/scripts-2.7:$HOME/softwares/linuxscripts/cmd:/usr/local/bin:/usr/lib/jvm/java-8-openjdk-amd64/bin:$HOME/softwares/geos-3.6.1/build/bin:$HOME/softwares/libgeotiff-1.4.2/build/bin:$HOME/softwares/tiff-4.0.8/build/bin:$HOME/softwares/proj-4.9.3/build/bin:/usr/local/cuda/bin:$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/softwares/linuxscripts:$HOME/softwares/emsdk:$HOME/softwares/emsdk/clang/e1.37.36_64bit:$HOME/softwares/emsdk/node/8.9.1_64bit/bin:$HOME/softwares/emsdk/emscripten/1.37.36
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
export PATH=$PATH:/opt/sublime_text
##
source $HOME/Documents/ai-ml-dl/aimldl.env.sh
#
source /aimldl-cfg/aimldl.env.sh

##
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64"

export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export DEVICE="cuda"

## change the default shell prompt display path
source $LINUX_SCRIPT_HOME/ps1.sh
#
alias lt='ls -lrt'
alias scripts='cd $HOME/softwares/linuxscripts'
alias technotes='cd $HOME/Documents/content/technotes'
alias FileSync='$HOME/softwares/FreeFileSync/FreeFileSync'
alias technotes='cd $HOME/Documents/content/technotes'
alias lscripts='cd $LINUX_SCRIPT_HOME'
alias gccselect='source $LINUX_SCRIPT_HOME/gcc-select.sh'
alias getip='source $LINUX_SCRIPT_HOME/ip.sh'
