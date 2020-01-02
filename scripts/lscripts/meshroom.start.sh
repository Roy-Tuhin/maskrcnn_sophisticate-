#!/bin/bash

##----------------------------------------------------------
# Meshroom
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## /codehub/external/meshroom/INSTALL.md
##
## https://github.com/alicevision/AliceVision
## https://github.com/alicevision/AliceVision/releases/download/v2.2.0/AliceVision-2.2.0-linux.tar.gz
#
## python bin/meshroom_photogrammetry --input INPUT_IMAGES_FOLDER --output OUTPUT_FOLDER
#
## https://github.com/alicevision/meshroom/issues/114
## Plugins loaded:  CameraCalibration, CameraInit, CameraLocalization, CameraRigCalibration, CameraRigLocalization, ConvertSfMFormat, DepthMap, DepthMapFilter, ExportAnimatedCamera, ExportColoredPointCloud, ExportMaya, FeatureExtraction, FeatureMatching, ImageMatching, ImageMatchingMultiSfM, KeyframeSelection, LDRToHDR, MeshDecimate, MeshDenoising, MeshFiltering, MeshResampling, Meshing, PrepareDenseScene, Publish, SfMAlignment, SfMTransform, StructureFromMotion, Texturing
## [2020-01-03 00:04:37,761][WARNING] == The following plugins could not be loaded ==
##   * simpleFarmSubmitter: No module named 'simpleFarm'
#
## http://www.world-machine.com/
## https://sketchfab.com/blogs/community/create-terrain-world-machine/
#
## https://blendermarket.com/products/Creating-3D-environments
#
## https://github.com/alicevision/meshroom
## https://www.youtube.com/watch?v=1D0EhSi-vvc
#
##----------------------------------------------------------


function meshroom_start() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local MESHROOM_HOME=/codehub/external/meshroom
  local ALICEVISION_HOME=/codehub/external/AliceVision-2.2.0
  local ALICEVISION_HOME_SRC=/codehub/external/AliceVision
  local TRAINEDVOCABULARYTREEDATA_HOME=/codehub/external/trainedVocabularyTreeData

  local PATH=${ALICEVISION_HOME}/bin:$PATH
  local LD_LIBRARY_PATH=${ALICEVISION_HOME}/lib:$LD_LIBRARY_PATH
  local ALICEVISION_SENSOR_DB=${ALICEVISION_HOME_SRC}/src/aliceVision/sensorDB/cameraSensors.db
  local ALICEVISION_VOCTREE=${TRAINEDVOCABULARYTREEDATA_HOME}/vlfeat_K80L3.SIFT.tree

  # # https://github.com/alicevision/qmlAlembic
  # QML2_IMPORT_PATH=/path/to/qmlAlembic/install/qml

  # # https://github.com/alicevision/QtOIIO
  # QT_PLUGIN_PATH=/path/to/QtOIIO/install
  # QML2_IMPORT_PATH=/path/to/QtOIIO/install/qml

  # # https://github.com/alicevision/QtAliceVision
  # QML2_IMPORT_PATH=/path/to/qtAliceVision/install/qml

  # PYTHONPATH=$PWD

  cd ${MESHROOM_HOME}
  python meshroom/ui

  ## command line pipeline
  ## python bin/meshroom_photogrammetry --input INPUT_IMAGES_FOLDER --output OUTPUT_FOLDER

}

meshroom_start
