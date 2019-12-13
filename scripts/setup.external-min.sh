#!/bin/bash

### -------------------------------------------
## external
## - minimal external clones required for production setup
### -------------------------------------------


function create_setup_external_min() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/codehub.sh
  # codehub_main

  local extdir="/codehub/external"
  cd ${extdir}

  ### -------------------------------------------
  ## Forked from Matterport Mask_RCNN
  ## - using Keras with tensorflow
  ## git clone https://github.com/matterport/Mask_RCNN.git
  ### -------------------------------------------
  git clone https://github.com/mangalbhaskar/Mask_RCNN.git


  ### -------------------------------------------
  ## Lanenet
  ### -------------------------------------------
  ## Towards End-to-End Lane Detection: an Instance Segmentation Approach
  git clone https://github.com/nikhilbv/lanenet-lane-detection.git

  ## Classes added to TuSimple dataset
  git clone https://github.com/nikhilbv/TuSimple-lane-classes.git


  ### -------------------------------------------
  ## tools
  ### -------------------------------------------

  ## tools: cloudy_vision
  ## commercial vision api implementation app
  git clone https://github.com/mangalbhaskar/cloudy_vision.git
  git clone https://github.com/mangalbhaskar/cloudy_vision_web.git

}

create_setup_external_min
