#!/bin/bash

## https://www.tensorflow.org/datasets/catalog/coco
## http://cocodataset.org/#download


mkdir -p /aimldl-dat/data-public/mscoco

cd /aimldl-dat/data-public/mscoco

## 2014
wget -c http://images.cocodataset.org/zips/test2014.zip
wget -c http://images.cocodataset.org/annotations/image_info_test2014.zip
