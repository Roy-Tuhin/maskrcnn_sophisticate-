#!/bin/bash

# References:
# http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#proj
# https://support.hdfgroup.org/HDF5/

## get latest source code; check here:
# http://www.hdfgroup.org/ftp/HDF5/current/src/
# http://www.hdfgroup.org/HDF5/release/obtain5.html

source ./numthreads.sh ##NUMTHREADS
VER="1.8.11"
DIR="hdf5-$VER"
FILE="$DIR.tar.gz"
echo "$FILE"
threads=$NUMTHREADS
echo "Number of threads will be used: $NUMTHREADS"


#tar xvfz hdf5-1.8.11.tar.gz
#cd hdf5-1.8.11
# ugly hack for this version -- the INSTALL_VMS.txt file does not exist,
# but the installer may assume its presence (especially if using cmake),
# so create a blank file:
#touch release_docs/INSTALL_VMS.txt
#mkdir build


if [ ! -f $HOME/Downloads/$FILE ]; then
  wget http://www.hdfgroup.org/ftp/HDF5/current/src/$FILE -P $HOME/Downloads
else
  echo Not downloading as: $HOME/Downloads/$FILE already exists!
fi

if [ ! -d $HOME/softwares/$DIR ]; then
  tar xvfz $HOME/Downloads/$FILE -C $HOME/softwares
else
  echo Extracted Dir already exists: $HOME/softwares/$DIR
fi

cd $HOME/softwares/$DIR
echo $(pwd)
#mkdir build
#make -j$threads
## install into build dir
#make install
