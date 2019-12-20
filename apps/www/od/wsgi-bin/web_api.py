__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# Flask based web api
# Note: Redis server should be running, before running this script
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
# import flask
# from flask import request, redirect, url_for, send_from_directory

from flask import render_template
from flask import jsonify

from werkzeug import secure_filename
from flask import Response

import os
import sys
import time
import uuid
import io

import json
import cv2
import numpy as np
from PIL import Image

import logging
import logging.config

## This imports web application minimum configuration paths
import web_cfg

BASE_PATH_CONFIG = web_cfg.BASE_PATH_CONFIG
APP_ROOT_DIR = web_cfg.APP_ROOT_DIR

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(0, APP_ROOT_DIR)

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

import common
import img_common
import viz
import web_model

log.debug("sys.path: {}".format(sys.path))


def allowed_file(cfg, filename):
  fn, ext = os.path.splitext(os.path.basename(filename))
  return ext.lower() in cfg['APP']['ALLOWED_IMAGE_TYPE']


def get_model_details(app, request, api_model_key=None):
  """
  provide the model infomation that ais/are available for the prediction
  """
  appcfg = app.config['APPCFG']

  modelcfg = web_model.get_modelcfg(appcfg, api_model_key)
  if not modelcfg:
    res_code = 400
    modelcfg = {"error": "model not found."}
  else:
    res_code = 200

  # res = jsonify(modelcfg)
  # res.status_code = res_code
  res = Response(json.dumps(modelcfg), status=res_code, mimetype='application/json')

  log.debug("res: {}".format(res))
  return res


def get_vision_api_spec(app, request):
  """
  Publishes the specifications of the Vision API for a particular version
  Version in the URL only used for publishing specification
  Version 'v1' should not be used in the acutal API CALL
  @app.route(API_VISION_URL+'/v1')
  
  TODO:
  - set the proper response code
  """
  appcfg = app.config['APPCFG']

  res_code = 200
  res = jsonify(appcfg['APP']['API_DOC'])
  res.status_code = res_code

  return res


def get_vision_site(app, request):
  appcfg = app.config['APPCFG']
  API_VISION_URL = appcfg['APP']['API_VISION_URL']
  return '<h1>Coming Soong Vision API Web Site!</h1><p>Refer: '+API_VISION_URL+'<p>'


def upload_file(app, request):
  if request.method == 'POST':
    appcfg = app.config['APPCFG']
    modelinfo = app.config['MODELINFO']

    query_q = request.values.get("q")
    log.debug("query_q: {}".format(query_q))
    if query_q and query_q.split('-') and len(query_q.split('-'))==3:
      modelinfo = web_model.load_model(appcfg, query_q)

    image = request.files["image"]
    log.debug("image: {}".format(image))
    res = predict(appcfg, modelinfo, image, get_mask=False)
    return res

  return render_template('index.html')


def predict_any(app, request):
  appcfg = app.config['APPCFG']
  modelinfo = app.config['MODELINFO']

  query_q = request.values.get("q")
  log.debug("query_q: {}".format(query_q))
  if query_q and query_q.split('-') and len(query_q.split('-'))==3:
    modelinfo = web_model.load_model(appcfg, query_q)

  image = request.files["image"]
  log.debug("image: {}".format(image))

  return predict(appcfg, modelinfo, image, get_mask=False)


def predict_polygon(app, request):
  appcfg = app.config['APPCFG']
  modelinfo = app.config['MODELINFO']

  query_q = request.values.get("q")
  log.debug("query_q: {}".format(query_q))
  if query_q and query_q.split('-') and len(query_q.split('-'))==3:
    modelinfo = web_model.load_model(appcfg, query_q)

  image = request.files["image"]
  log.debug("image: {}".format(image))

  return predict(appcfg, modelinfo, image, get_mask=True)


def predict(appcfg, modelinfo, image, get_mask=False):
  """Main function for AI API for prediction 
  """
  try:
    t0 = time.time()

    image_name = secure_filename(image.filename)
    log.debug("image.filename: {}".format(image_name))

    log.debug("modelinfo: {}".format(modelinfo))
    api_model_key = modelinfo['API_MODEL_KEY']
    dnnarch = modelinfo['DNNARCH']

    if image and allowed_file( appcfg, image_name):
      image_bytes = image.read()
      im_non_numpy = Image.open(io.BytesIO(image_bytes))

      ##TODO: from config derive if need to be resized and then send the resized image to api

      model = modelinfo['MODEL']
      modelcfg = modelinfo['MODELCFG']
      detect = modelinfo['DETECT']
      detect_with_json = modelinfo['DETECT_WITH_JSON']

      cc = None
      class_names = modelcfg['classes']

      t1 = time.time()
      time_taken_imread = (t1 - t0)
      log.debug('Total time taken in time_taken_imread: %f seconds' %(time_taken_imread))

      t2 = time.time()

      jsonres = detect_with_json(model, verbose=1, modelcfg=modelcfg, image_name=image_name, im_non_numpy=im_non_numpy, get_mask=get_mask, class_names=class_names)
      t3 = time.time()
      time_taken_in_detect_with_json = (t3 - t2)

      log.debug("jsonres: {}".format(jsonres))
      log.debug('Total time taken in detect with json: %f seconds' %(time_taken_in_detect_with_json))

      t4 = time.time()

      # uid = str(uuid.uuid4())
      uid = common.createUUID('pred')
      jsonres["filename"] = image_name
      jsonres["file_attributes"]["uuid"] = uid
      via_jsonres = {}
      via_jsonres[image_name] = jsonres
      json_str = common.numpy_to_json(via_jsonres)

      t5 = time.time()
      time_taken_res_preparation = (t5 - t4)
      log.debug('Total time taken in time_taken_res_preparation: %f seconds' %(time_taken_res_preparation))

      tt_turnaround = (t5 - t0)
      log.debug('Total time taken in tt_turnaround: %f seconds' %(tt_turnaround))

      res_code = 200
      # modelkeys = api_model_key.split('-')
      apires = {
        "api": None
        ,"type": api_model_key
        ,"dnnarch": dnnarch
        # ,"org_name": modelkeys[0]
        # ,"problem_id": modelkeys[1]
        # ,"rel_num": modelkeys[2]
        # ,"image_name": image
        ,"result": json.loads(json_str)
        ,'status_code': res_code
        ,'timings': {
          'image_read': time_taken_imread
          ,'detect_with_json': time_taken_in_detect_with_json
          ,'res_preparation': time_taken_res_preparation
          ,'tt_turnaround': tt_turnaround
        }
      }
    else:
      res_code = 400
      apires = {
        "api": None
        ,"type": api_model_key
        ,"dnnarch": dnnarch
        # ,"org_name": None
        # ,"problem_id": None
        # ,"rel_num": None
        # ,"image_name": None
        ,"result": None
        ,"error": "Invalid Image Type. Allowed Image Types are: {}".format(appcfg['APP']['ALLOWED_IMAGE_TYPE'])
        ,'status_code': res_code
        ,'timings': {
          'image_read': -1
          ,'detect': -1
          ,'res_preparation': -1
          ,'tt_turnaround': -1
        }
      }
  except Exception as e:
    log.error("Exception in detection", exc_info=True)
    res_code = 500
    apires = {
      "api": None
      ,"type": None
      ,"dnnarch": None
      ,"result": None
      ,"error": "Internal Error. Exception in detection."
      ,'status_code': res_code
      ,'timings': {
        'image_read': -1
        ,'detect': -1
        ,'res_preparation': -1
        ,'tt_turnaround': -1
      }
    }

  log.debug("apires: {}".format(apires))
  # res = Response(jsonify(apires), status=res_code, mimetype='application/json')
  # res = jsonify(apires)
  # res.status_code = res_code
  res = Response(json.dumps(apires), status=res_code, mimetype='application/json')

  log.debug("res: {}".format(res))
  return res


def predictq(app, request):
  """Predict images for high performance throughput (least response time) using redis queue

  Credit: https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/

  Redis will act as our temporary data store on the server. Images will come in to the server via a variety of methods such as cURL, a Python script, or even a mobile app.

  Furthermore, images could come in only every once in awhile (a few every hours or days) or at a very high rate (multiple per second). We need to put the images somewhere as they queue up prior to being processed. Our Redis store will act as the temporary storage.

  In order to store our images in Redis, they need to be serialized. Since images are just NumPy arrays, we can utilize base64 encoding to serialize the images. Using base64 encoding also has the added benefit of allowing us to use JSON to store additional attributes with the image. Similarly, we need to deserialize our image prior to passing them through our model.

  Ref:
  https://stackoverflow.com/questions/26998223/what-is-the-difference-between-contiguous-and-non-contiguous-arrays
  """
  try:
    t0 = time.time()
    rdb = app.config['RDB']
    appcfg = app.config['APPCFG']
    DBCFG = appcfg['APP']['DBCFG']
    REDISCFG = DBCFG['REDISCFG']

    image = request.files["image"]

    image_name = secure_filename(image.filename)
    api_model_key = ''
    dnnarch = ''

    if image and allowed_file( appcfg, image_name):
      image_bytes = image.read()
      im_non_numpy = Image.open(io.BytesIO(image_bytes))

      # im = np.array(im_non_numpy)
      im = img_common.prepare_image(im_non_numpy)

      # ensure our NumPy array is C-contiguous as well,
      # otherwise we won't be able to serialize it
      im = im.copy(order="C")
      im_shape = im.shape

      log.info("Before Encoding:...")
      log.info("type(im), im_shape: {}, {}".format(type(im), im_shape))

      im = img_common.base64_encode_numpy_array_to_string(im)

      log.info("After Encoding:...")
      log.info("type(im): {}".format(type(im)))

      # generate an ID for the classification then add the
      # uuid  + image to the queue
      uid = common.createUUID()
      d = {
        "id": uid
        ,'image': im
        ,'shape': im_shape
        ,'image_name': image_name
      }
      rdb.rpush(REDISCFG['image_queue'], json.dumps(d))

      res_code = 200
      apires = {
        "api": None
        ,"type": api_model_key
        ,"dnnarch": dnnarch
        # ,"org_name": modelkeys[0]
        # ,"problem_id": modelkeys[1]
        # ,"rel_num": modelkeys[2]
        # ,"image_name": image
        ,"result": []
        ,'status_code': res_code
        ,'timings': {
          'image_read': -1
          ,'detect_with_json': -1
          ,'res_preparation': -1
          ,'tt_turnaround': -1
        }
      }

      t1 = time.time()
      time_taken_imread = (t1 - t0)
      log.debug('Total time taken in time_taken_imread: %f seconds' %(time_taken_imread))
      # keep looping until our model server returns the output predictions
      while True:
        # Attempt to grab the output predictions
        output = rdb.get(uid)

        # Check to see if our model has classified/detected the input image
        if output is not None:
          # Add the output predictions to our data dictionary so we can return it to the client
          output = output.decode("utf-8")
          apires['result'] = json.loads(output)

          rdb.delete(uid)
          break
        
        # Sleep for a small amount to give the model a chance to classify/detect the input image
        time.sleep(REDISCFG['client_sleep'])


      t5 = time.time()
      tt_turnaround = (t5 - t0)
      log.debug('Total time taken in tt_turnaround: %f seconds' %(tt_turnaround))

      apires['timings']['time_taken_imread'] = time_taken_imread
      apires['timings']['tt_turnaround'] = tt_turnaround
    else:
      res_code = 400
      apires = {
        "api": None
        ,"type": api_model_key
        ,"dnnarch": dnnarch
        # ,"org_name": None
        # ,"problem_id": None
        # ,"rel_num": None
        # ,"image_name": None
        ,"result": None
        ,"error": "Invalid Image Type. Allowed Image Types are: {}".format(appcfg['APP']['ALLOWED_IMAGE_TYPE'])
        ,'status_code': res_code
        ,'timings': {
          'image_read': -1
          ,'detect': -1
          ,'res_preparation': -1
          ,'tt_turnaround': -1
        }
      }
  except Exception as e:
    log.error("Exception in detection", exc_info=True)
    res_code = 500
    apires = {
      "api": None
      ,"type": None
      ,"dnnarch": None
      ,"result": None
      ,"error": "Internal Error. Exception in detection."
      ,'status_code': res_code
      ,'timings': {
        'image_read': -1
        ,'detect': -1
        ,'res_preparation': -1
        ,'tt_turnaround': -1
      }
    }

  log.debug("apires: {}".format(apires))
  # res = Response(jsonify(apires), status=res_code, mimetype='application/json')
  # res = jsonify(apires)
  # res.status_code = res_code
  res = Response(json.dumps(apires), status=res_code, mimetype='application/json')

  log.debug("res: {}".format(res))

  return res


def tdd_api(app, request):
  """
  Used for API Development and Testing
  """
  log.debug("----------------------------->")
  log.debug("request: {}".format(request))
  log.debug("request.files: {}".format(request.files))
  image = request.files["image"]
  image_name = secure_filename(image.filename)
  log.debug("image.filename: {}".format(image_name))
  # image_name = secure_filename(request.files['filename'])
  # image_bytes = image.read()
  # im = np.array(Image.open(io.BytesIO(image_bytes)))
  return image_name


def load_model_stress_test(app):
  """
  multiple model loading stree test

  TODO:
  - loading of different model gives OOM errors for GPU
  """
  log.debug("----------------------------->")
  appcfg = app.config['APPCFG']

  API_DEFAULT_MODEL_KEY = appcfg['APP']['API_DEFAULT_MODEL_KEY']
  api_model_keys = [API_DEFAULT_MODEL_KEY]

  ## TODO: check why OOM error for the last model; does loading another model does not clean up the previous memory
  api_model_keys = [
    "matterport-coco_things-1",
    "vidteq-bsg-1",
    "vidteq-coco_things-1",
    "vidteq-hmd-1",
    "vidteq-hmd-2",
    "vidteq-hmd-3",
    "vidteq-road_asphalt-1",
    "vidteq-road_segmentation-1",
    "vidteq-traffic_sign_detection-5",
    "vidteq-tsdr-1" 
  ]

  for api_model_key in api_model_keys:
    modelinfo = web_model.load_model(appcfg, api_model_key)


def parse_args():
  import argparse
  from argparse import RawTextHelpFormatter
  
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='AI API Web Server\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument('--tdd'
    ,dest='tdd_mode'
    ,help='Runs the Test Driven Development entry point, to quickly test the functionalities'
    ,action='store_true')
  
  args = parser.parse_args()    

  return args
