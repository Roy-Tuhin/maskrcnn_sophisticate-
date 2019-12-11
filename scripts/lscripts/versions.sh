#!/bin/bash

##----------------------------------------------------------
### version - version variables for the installed softwares
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS, Kali Linux 2019.1
##----------------------------------------------------------
#
## NOTE: Last one is what is used if not commented#
#
##----------------------------------------------------------


##----------------------------------------------------------
## Nvidia GPU Driver
##----------------------------------------------------------
NVIDIA_DRIVER_VER="387.22"
NVIDIA_DRIVER_VER="390.42"
NVIDIA_DRIVER_VER="390"

## default value for Ubuntu-18.04 LTS, CUDA 10 and tf 1.14 works with this version
## driver version 430  is not avaiable in apt repo by default, if required install it separately

## For CUDA 10.0 minimum nvidia driver requirement
NVIDIA_DRIVER_VER="410"

##----------------------------------------------------------
## Docker version
##----------------------------------------------------------
## for Nvidia container runtime for GPU docker
DOCKER_VERSION="19.03.1"

##----------------------------------------------------------
## PHP version
##----------------------------------------------------------
PHP_VER="7.0"
PHP_VER="7.1"
PHP_VER="7.2"
#
##----------------------------------------------------------
## Node JS version
##----------------------------------------------------------
NODEJS_VER=7
NODEJS_VER=8
NODEJS_VER=9
#
##----------------------------------------------------------
## JAVA JDK version
##----------------------------------------------------------
JAVA_JDK_VER="8"
#JAVA_JDK_VER="9"
#
##----------------------------------------------------------
SUITE_PARSE_VER="5.3.0"
#
##----------------------------------------------------------
CERES_SOLVER_REL="-1.10.0"
CERES_SOLVER_REL_TAG="1.10.0"
#---
CERES_SOLVER_REL="-1.14.0"
CERES_SOLVER_REL_TAG="1.14.0"
#
##----------------------------------------------------------
## GIS, Computer Graphics - 2D/3D, Computer Vision
##----------------------------------------------------------
PROJ_VER="4.9.3"
TIFF_VER="4.0.8"
# TIFF_VER="4.0.9"
GEOTIFF_VER="1.4.2"
#
GEOS_VER="3.6.1"
GEOS_VER="3.6.3"
#
BOOST_VER="1.64.0"
#BOOST_VER="1.67.0"
#
EIGEN_REL_TAG="3.3.5"
#
MPIR_REL_TAG="mpir-3.0.0"
#
LAZ_PERF_REL_TAG="1.3.0"
# git clone is working now and that is used in script
LIBKML_VER="1.2.0"
LIBKML_VER="1.3.0"
#
# git clone is used, mentioned here as alternative
LASZIP_VER="2.2.0"
LASZIP_VER="3.2.2"
#
GEOWAVE_REL_TAG="v0.9.7"
#
GDAL_VER="2.2.4"
#
PDAL_VER="1.7"
PDAL_BUILD="1"
PDAL_RELEASE="${PDAL_VER}.${PDAL_BUILD}"
##
VTK_VER="7.1"
VTK_BUILD="1"
VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

VTK_VER="8.1"
VTK_BUILD="0"
VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"
#
OpenCV_VER_CHECKOUT="3.3.0"
OpenCV_VER_CHECKOUT="3.4.1"
OpenCV_VER_CHECKOUT="3.4.2"
#
HAROOPAD_VER="0.13.1"
#
MAGMA_VER="2.5.0-rc1"

