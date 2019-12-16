#!/bin/bash

##----------------------------------------------------------
## OpenCV Compile and Install
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## http://www.linuxfromscratch.org/blfs/view/cvs/general/opencv.html
## http://www.bogotobogo.com/OpenCV/opencv_3_tutorial_ubuntu14_install_cmake.php
## https://ubuntuforums.org/showthread.php?t=2219550
## https://unix.stackexchange.com/questions/242995/is-mkdir-p-totally-safe-when-creating-folder-already-exists
## https://stackoverflow.com/questions/15602059/git-shortcut-to-pull-with-clone-if-no-local-there-yet
## http://blog.aicry.com/ubuntu-14-04-install-opencv-with-cuda
#
##----------------------------------------------------------
## Download
##----------------------------------------------------------
## wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/3.2.0/opencv-3.2.0.zip
## wget https://github.com/opencv/opencv_contrib/archive/3.2.0.tar.gz -O opencv_contrib-3.2.0.tar.gz
#
## https://en.wikipedia.org/wiki/DICOM
## https://en.wikipedia.org/wiki/GDAL
## https://milkator.wordpress.com/2014/05/06/set-up-gdal-on-ubuntu-14-04/
## http://www.gdal.org/usergroup0.html
#
##----------------------------------------------------------
#
## E: The repository 'http://ppa.launchpad.net/grass/grass-stable/ubuntu bionic Release' does not have a Release file.
#
## E: Package 'libpng12-dev' has no installation candidate
## E: Unable to locate package libgstreamer0.10-dev
## E: Couldn't find any package by glob 'libgstreamer0.10-dev'
## E: Couldn't find any package by regex 'libgstreamer0.10-dev'
## E: Unable to locate package libgstreamer-plugins-base0.10-dev
## E: Couldn't find any package by glob 'libgstreamer-plugins-base0.10-dev'
## E: Couldn't find any package by regex 'libgstreamer-plugins-base0.10-dev'
#
#
## E: Unable to locate package libgstreamer0.10-dev
## E: Couldn't find any package by glob 'libgstreamer0.10-dev'
## E: Couldn't find any package by regex 'libgstreamer0.10-dev'
## E: Unable to locate package libgstreamer-plugins-base0.10-dev
## E: Couldn't find any package by glob 'libgstreamer-plugins-base0.10-dev'
## E: Couldn't find any package by regex 'libgstreamer-plugins-base0.10-dev'
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

if [ -z "$DIR" ]; then
  DIR='opencv'
fi

PROG_DIR="$BASEPATH/$DIR"

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

# COMPILE
mkdir $PROG_DIR/build
cd $PROG_DIR/build

## with GPU and CUDA
# cmake -D CMAKE_BUILD_TYPE=RELEASE \
#   -D CMAKE_INSTALL_PREFIX=/usr/local \
#   -D INSTALL_PYTHON_EXAMPLES=ON \
#   -D INSTALL_TESTS=ON \
#   -D WITH_1394=ON \
#   -D WITH_TBB=ON \
#   -D WITH_V4L=ON \
#   -D WITH_QT=ON \
#   -D WITH_GTK=ON \
#   -D WITH_VTK=ON \
#   -D WITH_OPENMP=ON \
#   -D WITH_OPENGL=ON \
#   -D WITH_OPENCL=ON \
#   -D WITH_JPEG=ON \
#   -D WITH_PNG=ON \
#   -D WITH_JASPER=ON \
#   -D WITH_ZLIB=ON \
#   -D WITH_GDAL=ON \
#   -D OPENCV_EXTRA_MODULES_PATH=$BASEPATH/opencv_contrib/modules \
#   -D ENABLE_FAST_MATH=ON \
#   -D ENABLE_PROFILING=ON \
#   -D ENABLE_CCACHE=ON \
#   -D WITH_CUBLAS=ON \
#   -D WITH_GDCM=ON \
#   -D WITH_NVCUVID=ON \
#   -D BUILD_SHARED_LIBS=ON \
#   -D BUILD_NEW_PYTHON_SUPPORT=ON \
#   -D BUILD_JPEG=ON \
#   -D BUILD_PNG=ON \
#   -D BUILD_JASPER=ON \
#   -D BUILD_ZLIB=ON \
#   -D BUILD_opencv_apps=ON \
#   -D BUILD_EXAMPLES=ON \
#   -D BUILD_PROTOBUF=OFF \
#   -D WITH_CUDA=ON \
#   -D CUDA_FAST_MATH=ON \
#   -D CUDA_NVCC_FLAGS=-D_FORCE_INLINES \
#   -D PROTOBUF_UPDATE_FILES=ON  ..


# cmake -D CMAKE_BUILD_TYPE=RELEASE \
#   -D CMAKE_INSTALL_PREFIX=/usr/local \
#   -D INSTALL_PYTHON_EXAMPLES=ON \
#   -D INSTALL_TESTS=ON \
#   -D WITH_1394=ON \
#   -D WITH_TBB=ON \
#   -D WITH_V4L=ON \
#   -D WITH_QT=ON \
#   -D WITH_GTK=ON \
#   -D WITH_VTK=ON \
#   -D WITH_OPENMP=ON \
#   -D WITH_OPENGL=ON \
#   -D WITH_OPENCL=ON \
#   -D WITH_JPEG=ON \
#   -D WITH_PNG=ON \
#   -D WITH_JASPER=ON \
#   -D WITH_ZLIB=ON \
#   -D WITH_GDAL=ON \
#   -D WITH_PROTOBUF=ON \
#   -D OPENCV_EXTRA_MODULES_PATH=$BASEPATH/opencv_contrib/modules \
#   -D ENABLE_FAST_MATH=ON \
#   -D ENABLE_PROFILING=ON \
#   -D ENABLE_CCACHE=ON \
#   -D WITH_CUBLAS=ON \
#   -D WITH_GDCM=ON \
#   -D WITH_NVCUVID=ON \
#   -D BUILD_SHARED_LIBS=ON \
#   -D BUILD_NEW_PYTHON_SUPPORT=ON \
#   -D BUILD_JPEG=ON \
#   -D BUILD_PNG=ON \
#   -D BUILD_JASPER=ON \
#   -D BUILD_ZLIB=ON \
#   -D BUILD_opencv_apps=ON \
#   -D BUILD_EXAMPLES=ON \
#   -D BUILD_PROTOBUF=OFF \
#   -D PROTOBUF_UPDATE_FILES=OFF \
#   -D BUILD_opencv_dnn=ON \
#   -D BUILD_opencv_dnn_objdetect=ON \
#   -D BUILD_opencv_face=OFF \
#   -D BUILD_opencv_sfm=OFF \
#   -D OPENCV_DNN_OPENCL=OFF \
#   -D opencv_dnn_PERF_CAFFE=OFF \
#   -D opencv_dnn_PERF_CLCAFFE=OFF  ..



cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  -D INSTALL_TESTS=ON \
  -D WITH_1394=ON \
  -D WITH_TBB=ON \
  -D WITH_V4L=ON \
  -D WITH_QT=ON \
  -D WITH_GTK=ON \
  -D WITH_VTK=ON \
  -D WITH_OPENMP=ON \
  -D WITH_OPENGL=ON \
  -D WITH_OPENCL=ON \
  -D WITH_JPEG=ON \
  -D WITH_PNG=ON \
  -D WITH_JASPER=ON \
  -D WITH_ZLIB=ON \
  -D WITH_GDAL=ON \
  -D WITH_PROTOBUF=OFF \
  -D OPENCV_EXTRA_MODULES_PATH=$BASEPATH/opencv_contrib/modules \
  -D ENABLE_FAST_MATH=ON \
  -D ENABLE_PROFILING=ON \
  -D ENABLE_CCACHE=ON \
  -D WITH_CUBLAS=ON \
  -D WITH_GDCM=ON \
  -D WITH_NVCUVID=ON \
  -D BUILD_SHARED_LIBS=ON \
  -D BUILD_NEW_PYTHON_SUPPORT=ON \
  -D BUILD_JPEG=ON \
  -D BUILD_PNG=ON \
  -D BUILD_JASPER=ON \
  -D BUILD_ZLIB=ON \
  -D BUILD_opencv_apps=ON \
  -D BUILD_EXAMPLES=OFF \
  -D BUILD_PROTOBUF=OFF \
  -D PROTOBUF_UPDATE_FILES=OFF \
  -D BUILD_opencv_dnn=OFF \
  -D BUILD_opencv_dnn_objdetect=OFF \
  -D BUILD_opencv_face=OFF \
  -D BUILD_opencv_sfm=OFF \
  -D OPENCV_DNN_OPENCL=OFF \
  -D WITH_CUDA=ON \
  -D CUDA_FAST_MATH=OFF \
  -D WITH_IPP=OFF \
  -D opencv_dnn_PERF_CAFFE=OFF \
  -D ENABLE_PRECOMPILED_HEADERS=OFF \
  -D opencv_dnn_PERF_CLCAFFE=OFF  ..
# https://github.com/opencv/opencv/issues/10975
## -D WITH_PROTOBUF=ON is required for DNN


#   -D WITH_CUDA=ON \
#   -D CUDA_FAST_MATH=ON \
#   -D CUDA_NVCC_FLAGS=-D_FORCE_INLINES \
# BUILD_opencv_dnn                 OFF                                 
# BUILD_opencv_dnn_objdetect       OFF
# BUILD_opencv_face                OFF                                 
# BUILD_opencv_sfm                 OFF                               
# OPENCV_DNN_OPENCL                OFF                                
# opencv_dnn_PERF_CAFFE            OFF                                  
# opencv_dnn_PERF_CLCAFFE          OFF

##----------------------------------------------------------
# Install
##----------------------------------------------------------
## ccmake ..
make -j$NUMTHREADS
# sudo make install -j$NUMTHREADS


cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Logs
# ##----------------------------------------------------------


# [ 32%] Building CXX object modules/ts/CMakeFiles/opencv_ts.dir/src/ts_perf.cpp.o
# [ 32%] Linking CXX static library ../../lib/libopencv_ts.a
# [ 32%] Built target opencv_ts
# [ 32%] Processing OpenCL kernels (bioinspired)
# ../../../../lib/libopencv_imgcodecs.so.3.4.1: undefined reference to `GDALRasterBand::RasterIO(GDALRWFlag, int, int, int, int, void*, int, int, GDALDataType, long long, long long, GDALRasterIOExtraArg*)'
# collect2: error: ld returned 1 exit status
# modules/xobjdetect/tools/waldboost_detector/CMakeFiles/opencv_waldboost_detector.dir/build.make:91: recipe for target 'bin/opencv_waldboost_detector' failed
# make[2]: *** [bin/opencv_waldboost_detector] Error 1
# CMakeFiles/Makefile2:5920: recipe for target 'modules/xobjdetect/tools/waldboost_detector/CMakeFiles/opencv_waldboost_detector.dir/all' failed
# make[1]: *** [modules/xobjdetect/tools/waldboost_detector/CMakeFiles/opencv_waldboost_detector.dir/all] Error 2
# make[1]: *** Waiting for unfinished jobs....
# [ 32%] Building NVCC (Device) object modules/cudacodec/CMakeFiles/cuda_compile.dir/src/cuda/cuda_compile_generated_nv12_to_rgb.cu.o



# [ 15%] Building CXX object modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/src/loadsave.cpp.o
# In file included from /home/alpha/softwares/opencv/modules/imgcodecs/src/grfmts.hpp:53:0,
#                  from /home/alpha/softwares/opencv/modules/imgcodecs/src/loadsave.cpp:47:
# /home/alpha/softwares/opencv/modules/imgcodecs/src/grfmt_exr.hpp:52:10: fatal error: ImfChromaticities.h: No such file or directory
#  #include <ImfChromaticities.h>
#           ^~~~~~~~~~~~~~~~~~~~~
# compilation terminated.
# modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/build.make:62: recipe for target 'modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/src/loadsave.cpp.o' failed
# make[2]: *** [modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/src/loadsave.cpp.o] Error 1
# CMakeFiles/Makefile2:5502: recipe for target 'modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/all' failed
# make[1]: *** [modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/all] Error 2
# make[1]: *** Waiting for unfinished jobs....

# https://answers.launchpad.net/ubuntu/+source/libxtst/+question/259047
# sudo apt -y install libopenexr-dev
# sudo apt install libwebp-dev

# [ 21%] Building CXX object modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/src/grfmt_webp.cpp.o
# /home/alpha/softwares/opencv/modules/imgcodecs/src/grfmt_webp.cpp:47:10: fatal error: webp/decode.h: No such file or directory
#  #include <webp/decode.h>
#           ^~~~~~~~~~~~~~~
# compilation terminated.
# modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/build.make:422: recipe for target 'modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/src/grfmt_webp.cpp.o' failed
# make[2]: *** [modules/imgcodecs/CMakeFiles/opencv_imgcodecs.dir/src/grfmt_webp.cpp.o] Error 1
# make[2]: *** Waiting for unfinished jobs....


# # https://stackoverflow.com/questions/40262928/error-compiling-opencv-fatal-error-stdlib-h-no-such-file-or-directory

# [ 10%] Building C object 3rdparty/libpng/CMakeFiles/libpng.dir/pngrio.c.o
# In file included from /usr/include/c++/6/ext/string_conversions.h:41:0,
#                  from /usr/include/c++/6/bits/basic_string.h:5420,
#                  from /usr/include/c++/6/string:52,
#                  from /usr/include/c++/6/stdexcept:39,
#                  from /usr/include/c++/6/array:39,
#                  from /home/alpha/softwares/opencv/modules/core/include/opencv2/core/cvdef.h:447,
#                  from /home/alpha/softwares/opencv/modules/core/include/opencv2/core.hpp:52,
#                  from /home/alpha/softwares/opencv/modules/highgui/include/opencv2/highgui.hpp:46,
#                  from /home/alpha/softwares/opencv/build/modules/highgui/precomp.hpp:45:
# /usr/include/c++/6/cstdlib:75:25: fatal error: stdlib.h: No such file or directory
#  #include_next <stdlib.h>

#---------

# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc:51:29: error: ‘SequenceNumber’ in namespace ‘google::protobuf::internal’ does not name a type
#  google::protobuf::internal::SequenceNumber ArenaImpl::lifecycle_id_generator_;
#                              ^~~~~~~~~~~~~~
# [  1%] Building C object 3rdparty/libjpeg-turbo/CMakeFiles/libjpeg-turbo.dir/src/jccolor.c.o
# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc: In member function ‘void google::protobuf::internal::ArenaImpl::Init()’:
# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc:68:43: error: ‘struct std::atomic<long int>’ has no member named ‘GetNext’
#    lifecycle_id_ = lifecycle_id_generator_.GetNext();
#                                            ^~~~~~~
# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc:69:31: error: ‘NoBarrier_Store’ is not a member of ‘google::protobuf::internal’
#    google::protobuf::internal::NoBarrier_Store(&hint_, 0);
#                                ^~~~~~~~~~~~~~~
# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc:70:31: error: ‘NoBarrier_Store’ is not a member of ‘google::protobuf::internal’
#    google::protobuf::internal::NoBarrier_Store(&threads_, 0);
#                                ^~~~~~~~~~~~~~~
# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc:76:5: error: ‘InitBlock’ was not declared in this scope
#      InitBlock(initial_block_, &thread_cache(), options_.initial_block_size);
#      ^~~~~~~~~
# /home/alpha/softwares/opencv/3rdparty/protobuf/src/google/protobuf/arena.cc:76:5: note: suggested alternative: ‘NewBlock’
#      InitBlock(initial_block_, &thread_cache(), options_.initial_block_size);
#      ^~~~~~~~~
#      NewBlock

#---------


# https://github.com/opencv/opencv/issues/8641

# Also you can try to disable IPPICV via cmake "-D WITH_IPP=OFF" ... option

# -- Could not find OpenBLAS include. Turning OpenBLAS_FOUND off
# -- Could not find OpenBLAS lib. Turning OpenBLAS_FOUND off
# -- Could NOT find Atlas (missing: Atlas_CLAPACK_INCLUDE_DIR) 


##---------------------
## Ubuntu 18.04 LTS
##---------------------

# [ 98%] Building CXX object modules/python2/CMakeFiles/opencv_python2.dir/__/src2/cv2.cpp.o
# In file included from /home/game1/softwares/opencv/modules/python/src2/cv2.cpp:30:0:
# /home/game1/softwares/opencv/build/modules/python_bindings_generator/pyopencv_generated_include.h:44:10: fatal error: opencv2/dnn/dict.hpp: No such file or directory
#  #include "opencv2/dnn/dict.hpp"
#           ^~~~~~~~~~~~~~~~~~~~~~
# compilation terminated.
# modules/python2/CMakeFiles/opencv_python2.dir/build.make:62: recipe for target 'modules/python2/CMakeFiles/opencv_python2.dir/__/src2/cv2.cpp.o' failed
# make[2]: *** [modules/python2/CMakeFiles/opencv_python2.dir/__/src2/cv2.cpp.o] Error 1
# CMakeFiles/Makefile2:22328: recipe for target 'modules/python2/CMakeFiles/opencv_python2.dir/all' failed
# make[1]: *** [modules/python2/CMakeFiles/opencv_python2.dir/all] Error 2
# make[1]: *** Waiting for unfinished jobs....



# -- The imported target "vtkgdcm" references the file
#    "/usr/lib/x86_64-linux-gnu/libvtkgdcm.so.2.8.4"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "vtkgdcmsharpglue" references the file
#    "/usr/lib/x86_64-linux-gnu/libvtkgdcmsharpglue.so"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "vtkgdcmJava" references the file
#    "/usr/lib/x86_64-linux-gnu/jni/libvtkgdcmJava.so"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "vtkgdcmPython" references the file
#    "/usr/lib/python/dist-packages/libvtkgdcmPython.so"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "vtkgdcmPythonD" references the file
#    "/usr/lib/x86_64-linux-gnu/libvtkgdcmPythonD.so.2.8.4"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmdump" references the file
#    "/usr/bin/gdcmdump"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmdiff" references the file
#    "/usr/bin/gdcmdiff"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmraw" references the file
#    "/usr/bin/gdcmraw"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmscanner" references the file
#    "/usr/bin/gdcmscanner"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmanon" references the file
#    "/usr/bin/gdcmanon"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmgendir" references the file
#    "/usr/bin/gdcmgendir"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmimg" references the file
#    "/usr/bin/gdcmimg"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmconv" references the file
#    "/usr/bin/gdcmconv"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmtar" references the file
#    "/usr/bin/gdcmtar"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcminfo" references the file
#    "/usr/bin/gdcminfo"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmscu" references the file
#    "/usr/bin/gdcmscu"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmxml" references the file
#    "/usr/bin/gdcmxml"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmpap3" references the file
#    "/usr/bin/gdcmpap3"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.

# -- The imported target "gdcmpdf" references the file
#    "/usr/bin/gdcmpdf"
# but this file does not exist.  Possible reasons include:
# * The file was deleted, renamed, or moved to another location.
# * An install or uninstall procedure did not complete successfully.
# * The installation package was faulty and contained
#    "/usr/lib/x86_64-linux-gnu/gdcm-2.8/GDCMTargets.cmake"
# but not all the files it references.


# -- Checking for module 'gstreamer-base-1.0'
# --   No package 'gstreamer-base-1.0' found
# -- Checking for module 'gstreamer-video-1.0'
# --   No package 'gstreamer-video-1.0' found
# -- Checking for module 'gstreamer-app-1.0'
# --   No package 'gstreamer-app-1.0' found
# -- Checking for module 'gstreamer-riff-1.0'
# --   No package 'gstreamer-riff-1.0' found
# -- Checking for module 'gstreamer-pbutils-1.0'
# --   No package 'gstreamer-pbutils-1.0' found
# -- Checking for module 'gstreamer-base-0.10'
# --   No package 'gstreamer-base-0.10' found
# -- Checking for module 'gstreamer-video-0.10'
# --   No package 'gstreamer-video-0.10' found
# -- Checking for module 'gstreamer-app-0.10'
# --   No package 'gstreamer-app-0.10' found
# -- Checking for module 'gstreamer-riff-0.10'
# --   No package 'gstreamer-riff-0.10' found
# -- Checking for module 'gstreamer-pbutils-0.10'
# --   No package 'gstreamer-pbutils-0.10' found

# -- IPPICV: Download: ippicv_2017u3_lnx_intel64_general_20180518.tgz
# https://github.com/opencv/opencv/issues/8641
# /home/game1/softwares/opencv/build/3rdparty/ippicv/ippicv_lnx

# -- Could not find OpenBLAS include. Turning OpenBLAS_FOUND off
# -- Could not find OpenBLAS lib. Turning OpenBLAS_FOUND off
# -- Could NOT find Atlas (missing: Atlas_CLAPACK_INCLUDE_DIR) 
# -- Could NOT find Flake8 (missing: FLAKE8_EXECUTABLE) 
# -- Could NOT find Matlab (missing: MATLAB_MEX_SCRIPT MATLAB_INCLUDE_DIRS MATLAB_ROOT_DIR MATLAB_LIBRARIES MATLAB_LIBRARY_DIRS MATLAB_MEXEXT MATLAB_ARCH MATLAB_BIN) 
# -- Performing Test HAVE_CXX_WNO_INCONSISTENT_MISSING_OVERRIDE - Failed
# -- Caffe:   NO
# Module opencv_ovis disabled because OGRE3D was not found
# -- No preference for use of exported gflags CMake configuration set, and no hints for include/library directories provided. Defaulting to preferring an installed/exported gflags CMake configuration if available.

# -- data: Download: face_landmark_model.dat
# CMake Warning at /home/game1/softwares/opencv/cmake/OpenCVDownload.cmake:190 (message):
#   data: Download failed: 28;"Timeout was reached"

#   For details please refer to the download log file:

#   /home/game1/softwares/opencv/build/CMakeDownloadLog.txt

# Call Stack (most recent call first):
#   /home/game1/softwares/opencv_contrib/modules/face/CMakeLists.txt:13 (ocv_download)


# CMake Warning at /home/game1/softwares/opencv_contrib/modules/face/CMakeLists.txt:26 (message):
#   Face: Can't get model file for face alignment.



# --   OpenCV modules:
# --     To be built:                 aruco bgsegm bioinspired calib3d ccalib core cvv datasets dnn dnn_objdetect dpm face features2d flann freetype fuzzy hdf hfs highgui img_hash imgcodecs imgproc java java_bindings_generator line_descriptor ml objdetect optflow phase_unwrapping photo plot python2 python3 python_bindings_generator reg rgbd saliency sfm shape stereo stitching structured_light superres surface_matching text tracking ts video videoio videostab viz xfeatures2d ximgproc xobjdetect xphoto
# --     Disabled:                    js world
# --     Disabled by dependency:      -
# --     Unavailable:                 cnn_3dobj cudaarithm cudabgsegm cudacodec cudafeatures2d cudafilters cudaimgproc cudalegacy cudaobjdetect cudaoptflow cudastereo cudawarping cudev matlab ovis
# --     Applications:                tests perf_tests examples apps
# --     Documentation:               NO
# --     Non-free algorithms:         NO

# -- Checking for modules 'tesseract;lept'
# --   No package 'tesseract' found
# --   No package 'lept' found
# -- Tesseract:   NO

# -- OpenCL samples are skipped: OpenCL SDK is required
# --     ccache:                      NO


# https://github.com/opencv/opencv_contrib/tree/master/modules/cnn_3dobj



# CMake Warning at cmake/OpenCVUtils.cmake:1306 (add_library):
#   Cannot generate a safe runtime search path for target opencv_imgcodecs
#   because files in some directories may conflict with libraries in implicit
#   directories:

#     runtime library [libgdal.so.20] in /usr/lib may be hidden by files in:
#       /usr/local/lib

#   Some of these libraries may not be found correctly.
# Call Stack (most recent call first):
#   cmake/OpenCVModule.cmake:915 (ocv_add_library)
#   cmake/OpenCVModule.cmake:847 (_ocv_create_module)
#   modules/imgcodecs/CMakeLists.txt:127 (ocv_create_module)









##---------------------
## Ubuntu 16.04 LTS
##---------------------

# https://www.webuildinternet.com/2016/06/28/installing-opencv-with-tesseract-text-module-on-ubuntu/
# https://www.pyimagesearch.com/2017/07/03/installing-tesseract-for-ocr/
#
# Install Tesseract dependencies to be able to build it with OpenCV.
#apt-get install -y tesseract-ocr libtesseract-dev libleptonica-dev


# -- Could NOT find Pylint (missing: PYLINT_EXECUTABLE) 
# -- Could NOT find Matlab (missing: MATLAB_MEX_SCRIPT MATLAB_INCLUDE_DIRS MATLAB_ROOT_DIR MATLAB_LIBRARIES MATLAB_LIBRARY_DIRS MATLAB_MEXEXT MATLAB_ARCH MATLAB_BIN) 

# -- Looking for ccache - not found
#sudo apt install ccache

# -- Looking for sys/videoio.h - not found

# -- Checking for module 'libavresample'
# --   No package 'libavresample' found

# -- Could NOT find Atlas (missing: Atlas_CLAPACK_INCLUDE_DIR) 
# -- Looking for sgemm_
# -- Looking for sgemm_ - found

# -- Caffe:   NO
# -- Protobuf:   NO
# https://github.com/google/protobuf

# --     ccache:                      NO

# --     Disabled:                    js world
# --     Disabled by dependency:      -
# --     Unavailable:                 cnn_3dobj dnn_modern java matlab ovis viz
# --     Applications:                tests perf_tests examples apps
# --     Documentation:               NO
# --     Non-free algorithms:         NO

# --     GTK+:                        NO
# --     VTK support:                 NO

# --     GDCM:                        NO
# http://gdcm.sourceforge.net/wiki/index.php/Main_Page
# GDCM is an open source implementation of the DICOM standard (Medical imaging)

# --       avresample:                NO

# --     libv4l/libv4l2:              NO

# --   Java:                          
# --     ant:                         NO
# --     JNI:                         NO
# --     Java wrappers:               NO
# --     Java tests:                  NO
# -- 
# --   Matlab:                        NO


#  Caffe_INCLUDE_DIR                Caffe_INCLUDE_DIR-NOTFOUND                                                                                                                                               
#  Caffe_LIBS                       Caffe_LIBS-NOTFOUND                                                                                                                                                      
#  Ceres_DIR                        Ceres_DIR-NOTFOUND  
#  HDF5_DIR                         HDF5_DIR-NOTFOUND 
#  Tesseract_INCLUDE_DIR            Tesseract_INCLUDE_DIR-NOTFOUND                                                                                                                                           
#  Tesseract_LIBRARY                Tesseract_LIBRARY-NOTFOUND                                                                                                                                               
#  VTK_DIR                          VTK_DIR-NOTFOUND                                                                                                                                                         
#  WEBP_INCLUDE_DIR                 WEBP_INCLUDE_DIR-NOTFOUND   

#  WITH_GSTREAMER                   ON                                                                                                                                                                       
#  WITH_GSTREAMER_0_10              OFF

#  WITH_XIMEA                       OFF                                                                                                                                                                      
#  WITH_XINE                        OFF                                                                                                                                                                      
#  opencv_dnn_PERF_CAFFE            OFF 


# # https://stackoverflow.com/questions/17386551/how-to-build-opencv-with-java-under-linux-using-command-linegonna-use-it-in-ma


#/home/game/softwares/opencv/build/modules/js/bindings.cpp:78:29: fatal error: emscripten/bind.h: No such file or directory compilation terminated.


# sudo apt-get install ant
# set JAVA_HOME env variable
# source ./java.config.sh
# sudo apt-get install python-gdcm gdcm-doc


##----------------------------------------------------------
# CONFIGURE LIBRARY SEARCH PATH
##----------------------------------------------------------
#echo '/usr/local/lib' | sudo tee -a /etc/ld.so.conf.d/opencv.conf  
#sudo ldconfig  
#printf '# OpenCV\nPKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig\nexport PKG_CONFIG_PATH\n' >> ~/.bashrc  
#source ~/.bashrc 


# CMakeFiles/example_gpu_driver_api_multi.dir/driver_api_multi.cpp.o: In function `destroyContexts()':
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:152: undefined reference to `cuCtxDestroy_v2'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:153: undefined reference to `cuCtxDestroy_v2'
# CMakeFiles/example_gpu_driver_api_multi.dir/driver_api_multi.cpp.o: In function `Worker::operator()(int) const':
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:119: undefined reference to `cuCtxPushCurrent_v2'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:146: undefined reference to `cuCtxPopCurrent_v2'
# CMakeFiles/example_gpu_driver_api_multi.dir/driver_api_multi.cpp.o: In function `main':
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:91: undefined reference to `cuInit'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:95: undefined reference to `cuDeviceGet'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:96: undefined reference to `cuCtxCreate_v2'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:99: undefined reference to `cuCtxPopCurrent_v2'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:102: undefined reference to `cuDeviceGet'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:103: undefined reference to `cuCtxCreate_v2'
# /home/game/softwares/opencv/samples/gpu/driver_api_multi.cpp:105: undefined reference to `cuCtxPopCurrent_v2'
# collect2: error: ld returned 1 exit status
# samples/gpu/CMakeFiles/example_gpu_driver_api_multi.dir/build.make:125: recipe for target 'bin/example_gpu_driver_api_multi' failed
# make[2]: *** [bin/example_gpu_driver_api_multi] Error 1
# CMakeFiles/Makefile2:39347: recipe for target 'samples/gpu/CMakeFiles/example_gpu_driver_api_multi.dir/all' failed
# make[1]: *** [samples/gpu/CMakeFiles/example_gpu_driver_api_multi.dir/all] Error 2
# make[1]: *** Waiting for unfinished jobs....
# [ 86%] Building CXX object samples/gpu/CMakeFiles/example_gpu_performance.dir/performance/performance.cpp.o
# [ 86%] Built target opencv_perf_superres
# [ 86%] Built target example_gpu_hog
# [ 86%] Linking CXX executable ../../bin/example_gpu_generalized_hough
# [ 86%] Linking CXX executable ../../bin/example_gpu_stereo_multi
# [ 86%] Linking CXX executable ../../bin/example_gpu_cascadeclassifier_nvidia_api
# [ 86%] Linking CXX executable ../../bin/example_gpu_opticalflow_nvidia_api
# [ 86%] Built target example_gpu_generalized_hough
# Scanning dependencies of target opencv_videostab
# [ 86%] Linking CXX executable ../../bin/performance_gpu
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/inpainting.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/motion_stabilizing.cpp.o
# [ 87%] Built target example_gpu_stereo_multi
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/global_motion.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/deblurring.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/outlier_rejection.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/log.cpp.o
# [ 87%] Built target example_gpu_cascadeclassifier_nvidia_api
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/wobble_suppression.cpp.o
# [ 87%] Built target example_gpu_opticalflow_nvidia_api
# [ 87%] Built target example_gpu_performance
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/fast_marching.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/optical_flow.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/stabilizer.cpp.o
# [ 87%] Building CXX object modules/videostab/CMakeFiles/opencv_videostab.dir/src/frame_source.cpp.o
# [ 87%] Linking CXX shared library ../../lib/libopencv_videostab.so
# [ 87%] Built target opencv_videostab
# Makefile:160: recipe for target 'all' failed
# make: *** [all] Error 2
# game@game-pc:~/softwares/opencv/build$ 
