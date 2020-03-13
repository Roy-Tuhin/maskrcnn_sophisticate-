__author__ = 'saqibmobin'
__version__ = '1.0'

import os
import sys
import json
import cv2

sys.path.insert(1, '/codehub/external/detectron2')

from detectron2.config import config
from detectron2.data import MetadataCatalog
from detectron2.engine import DefaultPredictor

sys.path.insert(2, '/codehub/apps/detectron2')

import convert_output_to_json
import Config

# (model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, colors=None, get_mask=False, class_names=None)
def inference(image):

  dataset_name = "inference"
  class_ids = ['signage', 'traffic_light', 'traffic_sign']
  id_map = {v: i for i, v in enumerate(class_ids)}
  metadata = MetadataCatalog.get(dataset_name).set(thing_classes=class_ids)
  metadata.thing_dataset_id_to_contiguous_id = id_map

  MODEL_WEIGHTS_DIR = 
  PROD_MODEL_WEIGHT = 

  log.debug("Metadata: {}".format(metadata))

  conf = Config(args, config)
  cfg = conf.merge(conf.arch, conf.cfg)
  cfg.DATASETS.TEST = (dataset_name)
  cfg.OUTPUT_DIR = MODEL_WEIGHTS_DIR
  cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, PROD_MODEL_WEIGHT)

  predictor = DefaultPredictor(cfg)

  im = cv2.imread(image)
  outputs = predictor(im)

  jsonres = convert_output_to_json(outputs, image, metadata)

  return jsonres
