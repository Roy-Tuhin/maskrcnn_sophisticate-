#!/bin/bash

##----------------------------------------------------------
## GDAL
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## GDAL is a translator library for raster and vector geospatial data formats that is released under an X/MIT style Open Source license by the Open Source Geospatial Foundation.
##
## http://scigeo.org/articles/howto-install-latest-geospatial-software-on-linux.html#environment_vars
## https://milkator.wordpress.com/2014/05/06/set-up-gdal-on-ubuntu-14-04/
## http://trac.osgeo.org/gdal/wiki/DownloadSource
#
## https://trac.osgeo.org/gdal/wiki/BuildHints
#
##----------------------------------------------------------


function gdal_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  swig -version

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${GDAL_VER}" ]; then
    GDAL_VER="2.2.4"
    echo "Unable to get GDAL_VER version, falling back to default version#: ${GDAL_VER}"
  fi

  PROG='gdal'
  DIR="${PROG}-${GDAL_VER}"
  PROG_DIR="${BASEPATH}/${PROG}-${GDAL_VER}"
  FILE="${DIR}.tar.gz"

  URL="http://download.osgeo.org/gdal/${GDAL_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo Not downloading as: ${HOME}/Downloads/${FILE} already exists!
  fi

  if [ ! -d ${PROG_DIR} ]; then
    tar xvfz ${HOME}/Downloads/${FILE} -C ${BASEPATH}
  else
    echo "Extracted Dir already exists: ${PROG_DIR}"
  fi

  cd ${PROG_DIR}
  echo $(pwd)

  # ./configure --help

  # https://lists.osgeo.org/pipermail/gdal-dev/2011-March/028237.html
  make clean -j${NUMTHREADS}

  ./configure --with-pg=/usr/bin/pg_config \
    --with-python \
    --with-sfcgal \
    --with-qhull \
    --with-freexl \
    --with-libjson_c \
    --with-python \
    --with-java \
    --with-jvm_lib \
    --with-jvm_lib_add_rpath


  # ldd `which gdalinfo` | grep -i tif 

  # /home/alpha/softwares/gdal-2.2.4/.libs/libgdal.so: undefined reference to `TIFFNumberOfTiles@LIBTIFF_4.0'
  # collect2: error: ld returned 1 exit status
  # Use:
   # ./configure --with-pg=/usr/bin/pg_config \
   #  --with-python \
   #  --with-sfcgal \
   #  --with-qhull \
   #  --with-freexl \
   #  --with-libjson_c \
   #  --with-python \
   #  --with-java \
   #  --with-jvm_lib \
   #  --with-libtiff=internal \
   #  --with-geotiff=internal \
   #  --with-jvm_lib_add_rpath
    
  make -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}

  ##----------------------------------------------------------
  ## Build Logs and Errors
  ##----------------------------------------------------------

  # CXX/LD -o .build_release/examples/siamese/convert_mnist_siamese_data.bin
  # /usr/local/lib//.usr.//local./.lib//lib./.libgdal.so.20/:. .undefined/ libreference/ libgdal.so.20to:  `undefinedTIFFReadDirectory @referenceLIBTIFF_4.0 'to
  #  /`usrTIFFReadDirectory/@localLIBTIFF_4.0/'lib
  # //.usr.//local/.lib.//.lib.//libgdal.so.20.:. /undefinedlib /referencelibgdal.so.20 :to  undefined` TIFFClientdatareference@ LIBTIFF_4.0to' `TIFFClientdata
  # @/LIBTIFF_4.0usr'/
  # local//usrlib//local/.lib.//....//.lib.//libgdal.so.20lib:/ libgdal.so.20undefined:  referenceundefined  toreference  `toTIFFLastDirectory @`LIBTIFF_4.0TIFFLastDirectory'@
  # LIBTIFF_4.0/'usr
  # //localusr//liblocal//.lib.//....//.lib.//libgdal.so.20lib:/ libgdal.so.20undefined:  undefined referencereference  toto  `TIFFReadRGBAStripExt`@TIFFReadRGBAStripExtLIBTIFF_4.0@'LIBTIFF_4.0
  # '/
  # usr//usrlocal//locallib//lib./../../...//liblib//libgdal.so.20libgdal.so.20::  undefinedundefined  referencereference  toto  ``TIFFWriteEncodedStripTIFFWriteEncodedStrip@@LIBTIFF_4.0LIBTIFF_4.0''

  # ### Fix:
  # sudo apt remove --purge libgdal20

  # ## These are removed: kept here for reference as side effects are not known
  # gdal-bin* grass* grass-core* grass-gui* libgdal-dev* libgdal-java* libgdal20* liblas-c3* liblas3* libopencv-calib3d-dev* libopencv-calib3d3.2* libopencv-contrib-dev* libopencv-contrib3.2* libopencv-dev*
  #   libopencv-features2d-dev* libopencv-features2d3.2* libopencv-highgui-dev* libopencv-highgui3.2* libopencv-imgcodecs-dev* libopencv-imgcodecs3.2* libopencv-objdetect-dev* libopencv-objdetect3.2*
  #   libopencv-stitching-dev* libopencv-stitching3.2* libopencv-superres-dev* libopencv-superres3.2* libopencv-videoio-dev* libopencv-videoio3.2* libopencv-videostab-dev* libopencv-videostab3.2*
  #   libopencv-viz-dev* libopencv-viz3.2* libopencv3.2-java* libopencv3.2-jni* libqgis-3d3.2.2* libqgis-analysis3.2.2* libqgis-app3.2.2* libqgis-core3.2.2* libqgis-customwidgets* libqgis-gui3.2.2*
  #   libqgis-server3.2.2* libqgisgrass7-3.2.2* libqgispython3.2.2* libvtk6.3* libvtk7-dev* libvtk7-java* libvtk7-jni* libvtk7-qt-dev* libvtk7.1* libvtk7.1-qt* postgis* postgresql-10-postgis-2.4* python-gdal*
  #   python-qgis* python-qgis-common* python3-gdal* python3-vtk7* qgis* qgis-plugin-grass* qgis-provider-grass* qgis-providers* rasdaman* tcl-vtk7* vtk7*


  # /home/alpha/softwares/gdal-2.2.4/.libs/libgdal.so: undefined reference to `TIFFNumberOfTiles@LIBTIFF_4.0'
  # collect2: error: ld returned 1 exit status
  # Use:
   # ./configure --with-pg=/usr/bin/pg_config \
   #  --with-python \
   #  --with-sfcgal \
   #  --with-qhull \
   #  --with-freexl \
   #  --with-libjson_c \
   #  --with-python \
   #  --with-java \
   #  --with-jvm_lib \
   #  --with-libtiff=internal \
   #  --with-geotiff=internal \
   #  --with-jvm_lib_add_rpath

  # /home/game1/softwares/gdal-2.2.4/port/cplstringlist.lo \
  #     -rpath /usr/local/lib \
  #     -no-undefined \
  #     -version-info 23:3:3

  #   --with-php \
  # /bin/bash: php-config: command not found
  # gdal_wrap.cpp:742:10: fatal error: zend.h: No such file or directory
  #  #include "zend.h"
  #           ^~~~~~~~

  # --with-rasdaman

  ##----------------------------------------------------------
  ## Complete list of configuration options
  ##----------------------------------------------------------
  # ./configure   --with-pcre \
  #    --with-teigha \
  #    --with-teigha_plt \
  #    --with-idb \
  #    --with-sde \
  #    --with-sde_version \
  #    --with-epsilon \
  #    --with-webp \
  #    --with-geos \
  #    --with-sfcgal \
  #    --with-qhull \
  #    --with-opencl \
  #    --with-opencl_include \
  #    --with-opencl_lib \
  #    --with-freexl \
  #    --with-libjson_c \
  #    --with-pam \
  #   --enable_pdf_plugin \
  #    --with-poppler \
  #    --with-podofo \
  #    --with-podofo_lib \
  #    --with-podofo_extra_lib_for_test \
  #    --with-pdfium \
  #    --with-pdfium_lib \
  #    --with-pdfium_extra_lib_for_test \
  #    --with-static_proj4 \
  #    --with-gdal_ver \
  #    --with-macosx_framework \
  #    --with-perl \
  #    --with-php \
  #    --with-python \
  #    --with-java \
  #    --with-mdb \
  #    --with-jvm_lib \
  #    --with-jvm_lib_add_rpath \
  #    --with-rasdaman \
  #    --with-armadillo \
  #    --with-cryptopp \
  #    --with-mrf 
  #
  ##----------------------------------------------------------
  ## Configuration options Descriptions
  ##----------------------------------------------------------
  #
  # mrf - mrf - monochrome recursive format (compressed bitmaps). This program is part of Netpbm(1) MRF is a compressed format for bilevel (1-bit mono) images. 
  # cryptopp - Crypto++ Library is a free C++ class library of cryptographic schemes.
  # Armadillo - a high quality linear algebra library (matrix maths) for the C++ language, aiming towards a good balance between speed and ease of use
  # rasdaman - Rasdaman is an Array DBMS, that is: a Database Management System which adds capabilities for storage and retrieval of massive multi-dimensional arrays, such as sensor, image, and statistics data.
  #          - http://www.rasdaman.org/
  # sfcgal - SFCGAL is a C++ wrapper library around CGAL with the aim of supporting ISO 191007:2013 and OGC Simple Features for 3D operations.
  # pcre - Perl Compatible Regular Expressions is a library written in C, which implements a regular expression engine, inspired by the capabilities of the Perl programming language.
  # qhull - Qhull computes the convex hull, Delaunay triangulation, Voronoi diagram, halfspace intersection about a point, furthest-site Delaunay triangulation, and furthest-site Voronoi diagram
  #       - http://www.qhull.org/
  # geoos - GEOS stands for Geometry Engine Open Source
  # IDB - IBM Informix Database (driver support)
  #     - http://www.gdal.org/drv_idb.html
  # Teigha - DWG Support
  #        - http://www.gdal.org/ogr_feature_style.html
  #        - http://www.gdal.org/drv_dwg.html
  # WebP - WebP is a modern image format that provides superior lossless and lossy compression for images on the web. ... WebP lossy images are 25-34% smaller than comparable JPEG images at equivalent SSIM quality index. Lossless WebP supports transparency (also known as alpha channel) at a cost of just 22% additional bytes.
  #      - http://www.gdal.org/frmt_webp.html
  # Epsilon - The Epsilon library can be used for using wavelets in GDAL.
  # FreeXL - an open source library to extract valid data from within an Excel (.xls) spreadsheet. 
  # OpenCL - OpenCL™ (Open Computing Language) is the open, royalty-free standard for cross-platform, parallel programming of diverse processors found in personal computers, servers, mobile devices and embedded platforms.
  # Poppler - a PDF rendering library based on the xpdf-3.0 code base
  # Podofo - a library to work with the PDF file format and includes also a few tools. The name comes from the first two letters of each word in PDF's spelled-out form.
  # PDFium - an open-source PDF rendering
  #
  ##----------------------------------------------------------
}

gdal_install
