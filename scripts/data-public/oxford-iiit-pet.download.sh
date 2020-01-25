#!/bin/bash

## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/preparing_inputs.md
## http://www.robots.ox.ac.uk/~vgg/data/pets/

mkdir -p /aimldl-dat/data-public/oxford-iiit-pet

cd /aimldl-dat/data-public/oxford-iiit-pet

if [ ! -f images.tar.gz ]; then
  wget -c http://www.robots.ox.ac.uk/~vgg/data/pets/data/images.tar.gz
  tar -xvf images.tar.gz
fi

if [ ! -f annotations.tar.gz ]; then
  wget -c http://www.robots.ox.ac.uk/~vgg/data/pets/data/annotations.tar.gz
  tar -xvf annotations.tar.gz
fi
