import os
import numpy as np
import cv2
import json
import sys
import random
sys.path.insert(1, '/aimldl-cod/external/detectron2')
from detectron2.structures import BoxMode
from detectron2.data import DatasetCatalog, MetadataCatalog
from detectron2.utils import visualizer
import itertools

from detectron2.data.datasets import register_coco_instances



register_coco_instances("coco2014_train", {}, "/aimldl-dat/data-public/ms-coco-1/annotations/instances_train2014.json", "/aimldl-dat/temp/coco_2014/train")

c_metadata = MetadataCatalog.get("coco2014_train")

img = cv2.imread("/aimldl-dat/temp/coco_2014/train/COCO_train2014_000000000009.jpg")
viz = visualizer.Visualizer(img[:, :, ::-1], metadata=c_metadata, scale=0.5)
vis = viz.draw_dataset_dict(d)
# vis.save("/aimldl-dat/temp/det02.jpg")
# cv2.imwrite("/aimldl-dat/temp/det01.jpg", vis.get_image()[:, :, ::-1])
cv2.imshow('', vis.get_image()[:, :, ::-1])
# cv2.imshow('', img)
cv2.waitKey(0)

