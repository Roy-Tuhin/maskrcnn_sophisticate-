#!/bin/bash

##----------------------------------------------------------
## suitesparse
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## Suitesparse Needed for solving large sparse linear systems.
## Optional for ceres-solver; strongly recomended for large scale bundle adjustment
#
## http://faculty.cse.tamu.edu/davis/suitesparse.html
## wget -c http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.3.0.tar.gz
#
## https://github.com/jluttine/suitesparse
#
## Tim Davis:
## http://faculty.cse.tamu.edu/davis/welcome.html
## https://www.mathworks.com/matlabcentral/profile/authors/45902-tim-davis
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
if [ -z "$SUITE_PARSE_VER" ]; then
  SUITE_PARSE_VER="5.3.0"
  echo "Unable to get SUITE_PARSE_VER version, falling back to default version#: $SUITE_PARSE_VER"
fi

sudo apt -y install libsuitesparse-dev

PROG='SuiteSparse'
DIR="$PROG-$SUITE_PARSE_VER"
PROG_DIR="$BASEPATH/$PROG-$SUITE_PARSE_VER"
FILE="$DIR.tar.gz"

URL="http://faculty.cse.tamu.edu/davis/SuiteSparse/$FILE"

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

## gcc-5
## Refer SutieSparse README.txt

# make -j$NUMTHREADS ## with demo
make library -j$NUMTHREADS ## without demo
sudo make install -j$NUMTHREADS INSTALL=/usr/local

cd $PROG_DIR/CHOLMOD
make -j$NUMTHREADS
make install

# cd $PROG_DIR/CHOLMOD/Demo
# wget -c https://sparse.tamu.edu/MM/ND/nd6k.tar.gz
# ./cholmod_l_demo < nd6k.mtx

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
##----------------------------------------------------------



# https://stackoverflow.com/questions/29481012/compiling-suitesparse-4-4-4-with-openblas-on-linux

# /usr/include/c++/6/initializer_list:97:3: error: template with C linkage
#    template<class _Tp>


# https://stackoverflow.com/questions/4877705/why-cant-templates-be-within-extern-c-blocks

# https://sparse.tamu.edu/MM/ND/nd6k.tar.gz


# https://github.com/PyMesh/PyMesh/issues/9
# https://stackoverflow.com/questions/13812185/how-to-recompile-with-fpic

# make[4]: Entering directory '/home/bhaskar/softwares/suitesparse/Mongoose/build'
# [ 86%] Building CXX object CMakeFiles/mongoose_unit_test_io.dir/Tests/Mongoose_UnitTest_IO_exe.o
# /usr/bin/ld: /usr/lib/gcc/x86_64-linux-gnu/5/../../../x86_64-linux-gnu/libsuitesparseconfig.a(SuiteSparse_config.o): relocation R_X86_64_PC32 against symbol `SuiteSparse_config' can not be used when making a shared object; recompile with -fPIC
# /usr/bin/ld: final link failed: Bad value
# collect2: error: ld returned 1 exit status
# CMakeFiles/mongoose_dylib.dir/build.make:823: recipe for target 'lib/libmongoose.so.2.0.2' failed



# https://stackoverflow.com/questions/38296756/what-is-the-idiomatic-way-in-cmake-to-add-the-fpic-compiler-option

# The compiler is complaining your suitesparse is compiled as a static library that cannot be linked with a dynamic library (http://stackoverflow.com/questions/13812185/how-to-recompile-with-fpic). One way around is to recompile suitesparse with -fPIC flag. Another way is to skip SparseSolver tool in PyMesh by commenting out line 90 and 91 in tools/CMakeLists.txt file.

# https://cmake.org/pipermail/cmake/2008-November/025303.html

# http://mathforum.org/kb/message.jspa?messageID=5848824