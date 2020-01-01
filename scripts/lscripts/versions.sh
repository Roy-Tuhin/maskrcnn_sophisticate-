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
local NVIDIA_DRIVER_VER="387.22"
local NVIDIA_DRIVER_VER="390.42"
local NVIDIA_DRIVER_VER="390"

## default value for Ubuntu-18.04 LTS, CUDA 10 and tf 1.14 works with this version
## driver version 430  is not avaiable in apt repo by default, if required install it separately

## For CUDA 10.0 minimum nvidia driver requirement
local NVIDIA_DRIVER_VER="410"
local NVIDIA_DRIVER_VER="430"
local NVIDIA_DRIVER_VER="435"
# local NVIDIA_DRIVER_VER="440"

##----------------------------------------------------------
local CMAKE_VER="3.11"
local CMAKE_BUILD="0"
#
local CMAKE_VER="3.16"
local CMAKE_BUILD="0"
#
local CMAKE_REL="${CMAKE_VER}.${CMAKE_BUILD}"

##----------------------------------------------------------
## Docker version
##----------------------------------------------------------
## for Nvidia container runtime for GPU docker
local DOCKER_VERSION="19.03.1"

##----------------------------------------------------------
## PHP version
##----------------------------------------------------------
local PHP_VER="7.0"
local PHP_VER="7.1"
local PHP_VER="7.2"
#
##----------------------------------------------------------
## Node JS version
##----------------------------------------------------------
local NODEJS_VER=7
local NODEJS_VER=8
local NODEJS_VER=9
#
##----------------------------------------------------------
## JAVA JDK version
##----------------------------------------------------------
local JAVA_JDK_VER="8"
#JAVA_JDK_VER="9"
#
##----------------------------------------------------------
## http://faculty.cse.tamu.edu/davis/SuiteSparse/
local SUITE_PARSE_VER="5.3.0"
local SUITE_PARSE_VER="5.4.0"
#
##----------------------------------------------------------
## https://ceres-solver.googlesource.com/ceres-solver/
local CERES_SOLVER_REL="-1.10.0"
local CERES_SOLVER_REL_TAG="1.10.0"
#---
local CERES_SOLVER_REL="-1.14.0"
local CERES_SOLVER_REL_TAG="1.14.0"
#
##----------------------------------------------------------
## GIS, Computer Graphics - 2D/3D, Computer Vision
##----------------------------------------------------------
#
## https://github.com/google/protobuf
local PROTOBUF_REL="v3.11.2"
##----------------------------------------------------------
## http://download.osgeo.org/proj
local PROJ_VER="4.9.3"
local PROJ_VER="6.2.1"
##----------------------------------------------------------
## http://download.osgeo.org/libtiff/
local TIFF_VER="4.0.8"
## local TIFF_VER="4.0.9"
local TIFF_VER="4.1.0"
##----------------------------------------------------------
local GEOTIFF_VER="1.4.2"
local GEOTIFF_VER="1.5.1"
##----------------------------------------------------------
local LASzip_REL="3.4.3"
##----------------------------------------------------------
# git clone is working now and that is used in script
local LIBKML_REL="1.2.0"
local LIBKML_REL="1.3.0"
##----------------------------------------------------------
## http://download.osgeo.org/geos
local GEOS_VER="3.6.1"
local GEOS_VER="3.6.3"
local GEOS_VER="3.8.0"
##----------------------------------------------------------
## https://dl.bintray.com/boostorg/release/
local BOOST_VER="1.64.0"
#local BOOST_VER="1.67.0"
local BOOST_VER="1.72.0"
##----------------------------------------------------------
# https://gitlab.com/libeigen/eigen
local EIGEN_REL="3.3.5"
## after migration
local EIGEN_REL="3.3"
##----------------------------------------------------------
local MPIR_REL_TAG="mpir-3.0.0"
##----------------------------------------------------------
local LAZ_PERF_REL="1.3.0"
##----------------------------------------------------------
local LIBLAS_REL="1.8.1"
##----------------------------------------------------------
# git clone is used, mentioned here as alternative
local LASZIP_VER="2.2.0"
local LASZIP_VER="3.2.2"
##----------------------------------------------------------
local GEOWAVE_REL_TAG="v0.9.7"
##----------------------------------------------------------
## http://download.osgeo.org/gdal
local GDAL_VER="2.2.4"
local GDAL_VER="3.0.2"
##----------------------------------------------------------
## https://github.com/PointCloudLibrary/pcl/releases
local PCL_REL="pcl-1.9.1"
##----------------------------------------------------------
## http://download.osgeo.org/pdal/
local PDAL_MARJOR_VER="1.7"
local PDAL_BUILD="1"
local PDAL_BUILD="2"
local PDAL_VER="${PDAL_MARJOR_VER}.${PDAL_BUILD}"

## https://github.com/PDAL/PDAL/releases
## for git-install
local PDAL_REL="1.9.1"
local PDAL_REL="2.0.1"
##----------------------------------------------------------
local ENTWINE_VER="2.1.0"
##----------------------------------------------------------
local SIMPLE_WEB_SERVER_VER="v3.0.2"
##----------------------------------------------------------
# https://vtk.org/download/
local VTK_VER="7.1"
local VTK_BUILD="1"
local VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

local VTK_VER="8.1"
local VTK_BUILD="0"
local VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

local VTK_VER="8.2"
local VTK_BUILD="0"
local VTK_RELEASE="${VTK_VER}.${VTK_BUILD}"

# https://github.com/Kitware/VTK

##----------------------------------------------------------
# https://github.com/opencv/opencv/releases
local OpenCV_REL="3.3.0"
local OpenCV_REL="3.4.1"
local OpenCV_REL="3.4.2"
local OpenCV_REL="4.2.0"
##----------------------------------------------------------
local OpenSfM_REL="v0.3.0"
##----------------------------------------------------------
local OpenDroneMap_REL="v0.9.1"
##----------------------------------------------------------
local OpenImageIO_REL="Release-2.1.9.0"
##----------------------------------------------------------
# https://github.com/AcademySoftwareFoundation/openexr/releases
local OPENEXR_REL="v2.4.0"
##----------------------------------------------------------
# https://github.com/alembic/alembic/releases
local ALEMBIC_REL="1.7.12"
##----------------------------------------------------------
local GEOGRAM_VER="1.7.3"
##----------------------------------------------------------
local MESHROOM_REL="v2019.2.0"
##----------------------------------------------------------
local CloudCompare_REL="v2.10.3"
##----------------------------------------------------------
local HAROOPAD_VER="0.13.1"
##----------------------------------------------------------
# http://icl.utk.edu/projectsfiles/magma/downloads/
local MAGMA_VER="2.5.1"
local MAGMA_VER="2.5.2"
##----------------------------------------------------------
