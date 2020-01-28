#!/bin/bash

## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/preparing_inputs.md

mkdir -p /aimldl-dat/data-public/VOC

cd /aimldl-dat/data-public/VOC

## VOC2007
if [ ! -f VOCtrainval_06-Nov-2007.tar ]; then
  wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtrainval_06-Nov-2007.tar
  tar -xvf VOCtrainval_06-Nov-2007.tar
fi
if [ ! -f VOCtest_06-Nov-2007.tar ]; then
  wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
  tar -xvf VOCtest_06-Nov-2007.tar
fi
if [ ! -f VOCdevkit_08-Jun-2007.tar ]; then
  wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCdevkit_08-Jun-2007.tar
  tar -xvf VOCdevkit_08-Jun-2007.tar
fi

## VOC2012
if [ ! -f VOCtrainval_11-May-2012.tar ]; then
  wget -c http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar
  tar -xvf VOCtrainval_11-May-2012.tar
fi
