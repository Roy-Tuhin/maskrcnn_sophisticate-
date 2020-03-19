__author__ = 'saqibmobin'
__version__ = '1.0'

import os
import sys
import json
import cv2
import requests
from flask import Flask, request, jsonify, render_template

sys.path.insert(1, '/codehub/external/detectron2')
sys.path.insert(2, '/codehub/apps/detectron2')

from detectron2.config import config
from detectron2.data import MetadataCatalog
from detectron2.engine import DefaultPredictor

from hmd_detectron2 import convert_output_to_json

# (model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, colors=None, get_mask=False, class_names=None)

def inference(image):

  dataset_name = "inference"
  class_ids = ['signage', 'traffic_light', 'traffic_sign']
  id_map = {v: i for i, v in enumerate(class_ids)}
  metadata = MetadataCatalog.get(dataset_name).set(thing_classes=class_ids)
  metadata.thing_dataset_id_to_contiguous_id = id_map

  # MODEL_WEIGHTS_DIR = "/codehub/apps/detectron2/release"
  MODEL_WEIGHTS_DIR = "/aimldl-dat/release/detectron2/release"
  PROD_MODEL_WEIGHT = "model_final.pth"
  arch = "/codehub/cfg/arch/040320_160140-AIE1-01-detectron2.yml"

  log.debug("Metadata: {}".format(metadata))
  cfg = config.get_cfg()
  cfg.merge_from_file(arch)
  cfg.DATASETS.TEST = (dataset_name)
  cfg.OUTPUT_DIR = MODEL_WEIGHTS_DIR
  cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, PROD_MODEL_WEIGHT)

  predictor = DefaultPredictor(cfg)

  im = cv2.imread(image)
  outputs = predictor(im)

  jsonres = convert_output_to_json(outputs, image, metadata)
  print(jsonres)
  return jsonres

app = Flask(__name__)
# @app.route("/")
# def hello():
#   return "Image classification example\n"

# @app.route("/predict", methods=["GET"])
# def predict():
#   url = request.args.get('url')
#   json = inference(url)
#   return jsonify(json)
#   return json

# @app.route('/predict', methods=['POST'])
# def predict():
#   if request.method == 'POST':
#     file = request.json["url"]
#     json = inference(file)
#     return jsonify(json)

@app.route('/', methods=['GET', 'POST'])
def predict():
  if request.method == 'POST':
    folder = request.form["Folder"]
    json = inference(folder)
    return jsonify(json)
  return render_template("index.html")

if __name__ == '__main__':
  app.run()
