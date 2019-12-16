#!/bin/bash
## A single place to put all the git clones URLs and setup steps

### -------------------------------------------
## external
### -------------------------------------------

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

echo "Cloning inside... ${SCRIPTS_DIR}/external"

cd ${SCRIPTS_DIR}/external

# ## py_faster_rcnn
# ### -------------------------------------------
# git clone https://github.com/rbgirshick/py-faster-rcnn.git

## semantic-search
### -------------------------------------------
git clone https://github.com/hundredblocks/semantic-search
# git clone https://github.com/mangalbhaskar/semantic-search.git cbir

### -------------------------------------------
## Forked from Matterport Mask_RCNN
## - using Keras with tensorflow
## git clone https://github.com/matterport/Mask_RCNN.git
### -------------------------------------------
# git clone https://github.com/mangalbhaskar/Mask_RCNN.git

### -------------------------------------------
## Mapping Challange - Mask RCNN
### -------------------------------------------
git clone https://github.com/crowdAI/mapping-challenge-starter-kit.git
git clone https://github.com/crowdai/crowdai-mapping-challenge-mask-rcnn
## best open solution more than 90% AP, and recall
git clone https://github.com/neptune-ml/open-solution-mapping-challenge.git

## 3D R2N2
### -------------------------------------------
# git clone https://github.com/chrischoy/3D-R2N2.git

## Pixel2Mesh
### -------------------------------------------
git clone https://github.com/nywang16/Pixel2Mesh.git

git clone https://github.com/MarvinTeichmann/MultiNet.git
# git clone https://github.com/georgesung/ssd_tensorflow_traffic_sign_detection.git
# git clone https://github.com/balancap/SSD-Tensorflow
# git clone https://github.com/ljanyst/ssd-tensorflow.git
# git clone https://github.com/tensorflow/models.git
# git clone https://github.com/thatbrguy/Pedestrian-Detector.git
# git clone https://github.com/fyu/dilation.git


## Traffic Sign Classification - examples
### -------------------------------------------
# git clone https://github.com/mangalbhaskar/deeplearning

## Towards End-to-End Lane Detection: an Instance Segmentation Approach
# git clone https://github.com/nikhilbv/lanenet-lane-detection.git

## Classes added to TuSimple dataset
# git clone https://github.com/nikhilbv/TuSimple-lane-classes.git

## tutorials
### -------------------------------------------
git clone https://github.com/Hvass-Labs/TensorFlow-Tutorials.git
git clone https://github.com/mnielsen/neural-networks-and-deep-learning.git


### -------------------------------------------
## tools
### -------------------------------------------

## tools: cloudy_vision
## commercial vision api implementation app
# git clone https://github.com/mangalbhaskar/cloudy_vision.git
# git clone https://github.com/mangalbhaskar/cloudy_vision_web.git

git clone https://github.com/cocodataset/cocoapi.git
# git clone https://github.com/mangalbhaskar/panopticapi.git
git clone https://github.com/cocodataset/panopticapi.git

## Annotation Tools
### -------------------------------------------

## via: VGG Image Annotation Tool - light web based weight tool
git clone https://github.com/ox-vgg/via.git

## scalable: for BDD dataset
git clone https://github.com/ucbdrive/scalabel.git

## public-code: for IDD dataset
git clone https://github.com/AutoNUE/public-code.git

## dlib
git clone https://github.com/davisking/dlib.git

## convert-caffe-to-tensorflow
# git clone https://github.com/ethereon/caffe-tensorflow.git
