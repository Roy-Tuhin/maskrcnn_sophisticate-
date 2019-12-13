__author__ = 'mangalbhaskar; nikhil'
__version__ = '1.0'
"""
# lanenet
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar, nikhil
# --------------------------------------------------------
"""
import os
import sys
import time
from importlib import import_module
import logging
import numpy as np
from PIL import Image
import cv2

## custom imports
import common
import apputil


import tensorflow as tf

## arch specific code
from config import global_config
from lanenet_model import lanenet
from lanenet_model import lanenet_postprocess

log = logging.getLogger('__main__.'+__name__)


def train(model, dataset_train, dataset_val, cmdcfg):
  """train function definition and comments under Mask_RCNN/mrcnn/model.py for customization
  """
  log.info("---------------------------->")
  log.info("cmdcfg: {}".format(cmdcfg))


def prepare_image(im_non_numpy):
  im = np.array(im_non_numpy)
  return im


def detect(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, im=None):
  pred_json = detect_with_json(model, verbose=verbose, modelcfg=modelcfg, image_name=image_name, im_non_numpy=im_non_numpy)
  return [pred_json]


def detect_batch(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None):
  return detect(model, verbose=verbose, modelcfg=modelcfg, image_name=image_name, im_non_numpy=im_non_numpy)


def detect_with_json(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, colors=None, get_mask=False, class_names=None):
  CFG = global_config.cfg
  weights_path = modelcfg['weights_path']
  postprocess_result = None

  ## TODO: check if im.shape is not a valid shape then only resize
  im_non_numpy = im_non_numpy.resize((1280,720), Image.ANTIALIAS)
  log.info("Resized_image_shape : {}".format(im_non_numpy.size))
  im_src = np.array(im_non_numpy)
  im = cv2.resize(im_src, (512, 256), interpolation=cv2.INTER_LINEAR)
  im = im / 127.5 - 1.0

  input_tensor = tf.placeholder(dtype=tf.float32, shape=[1, 256, 512, 3], name='input_tensor')
  binary_seg_ret, instance_seg_ret = model.inference(input_tensor=input_tensor, name='lanenet_model')
  postprocessor = lanenet_postprocess.LaneNetPostProcessor()

  # Set sess configuration
  sess_config = tf.ConfigProto()
  sess_config.gpu_options.per_process_gpu_memory_fraction = CFG.TEST.GPU_MEMORY_FRACTION
  sess_config.gpu_options.allow_growth = CFG.TRAIN.TF_ALLOW_GROWTH
  sess_config.gpu_options.allocator_type = 'BFC'

  sess = tf.Session(config=sess_config)
  saver = tf.train.Saver()

  with sess.as_default():
    saver.restore(sess=sess, save_path=weights_path)

    binary_seg_image, instance_seg_image = sess.run(
      [binary_seg_ret, instance_seg_ret],
      feed_dict={input_tensor: [im]}
    )

    postprocess_result = postprocessor.postprocess(
      image_name=image_name,
      binary_seg_result=binary_seg_image[0],
      instance_seg_result=instance_seg_image[0],
      source_image=im_src
    )

  sess.close()
  pred_json = postprocess_result['pred_json']
  pred_json = convert_to_via(pred_json)

  pred_json["file_attributes"] = {
    'width' : 1280,
    'height' : 720
  }
  return pred_json

def convert_to_via(pred_json):
  x = pred_json['x_axis']
  y = pred_json['y_axis']

  regions = []
  shape_attributes = {
    'all_points_x' : None,
    'all_points_y' : None,
    "name": "polyline"
  }
  for i in range(len(x)):
    shape_attributes['all_points_x'] = x[i]
    shape_attributes['all_points_y'] = y[i]
    one = {'region_attributes' : {}, 'shape_attributes' : shape_attributes}
    regions.append(one)
  ## Filters
  pred_json.pop('x_axis', None)
  pred_json.pop('y_axis', None)
  pred_json.pop('image_name', None)
  pred_json.pop('run_time', None)
  pred_json['regions'] = regions
  return pred_json


def load_model_and_weights(mode, cmdcfg, appcfg):
  """
  Load the model and weights

  Preferences
  Device to load the neural network on.
  Useful if you're training a model on the same
  machine, in which case use CPU and leave the
  GPU for training.
  values: '/cpu:0' or '/gpu:0'
  """
  log.info("load_model_and_weights:----------------------------->")

  device = appcfg['APP']['DEVICE']
  dnncfg = get_dnncfg(cmdcfg['config'])
  log.info("device: {}".format(device))
  log.info("dnncfg: {}".format(dnncfg))

  model = None
  log_dir_path = apputil.get_abs_path(appcfg, cmdcfg, 'AI_LOGS')
  # with tf.device(device):
  #   model = modellib.MaskRCNN(mode=mode, config=dnncfg, model_dir=log_dir_path)

  # weights = cmdcfg['weights']
  # if weights and weights.lower() == "last":
  #     weights_path = model.find_last()
  # else:
  #   weights_path = cmdcfg['weights_path']

  # log.debug("Loading weights from weights_path: {}".format(weights_path))

  # ## TODO: pass this error to the router for API consumption
  # if not os.path.exists(weights_path) or not os.path.isfile(weights_path):
  #   raise Exception('weights_path does not exists: {}'.format(weights_path))

  # if mode == appcfg['APP']['TRAIN_MODE']:
  #   model.load_weights(weights_path, by_name=cmdcfg['load_weights']['by_name'], exclude=cmdcfg['load_weights']['exclude'])
  # elif mode == appcfg['APP']['TEST_MODE']:
  #   model.load_weights(weights_path, by_name=cmdcfg['load_weights']['by_name'])

  # log.info("Loaded weights successfully from weights_path: {}".format(weights_path))



  net = lanenet.LaneNet(phase='test', net_flag='vgg')
  return net


def get_dnncfg(cfg_config):
  """Load the DNN Configuration Dynamically
  """
  dnncfg = None

  return dnncfg


def create_modelinfo(mi):
  """create modelinfo configuration in consistent way
  """
  from modelinfo import modelcfg

  modelinfocfg = {k: mi[k] if k in mi else modelcfg[k] for k in modelcfg.keys()}
  timestamp = common.timestamp()
  modelinfocfg['problem_id'] = 'rld'
  modelinfocfg['rel_num'] = modelinfocfg['timestamp'] = timestamp
  modelinfocfg['model_info'] = apputil.get_modelinfo_filename(modelinfocfg)

  log.info("modelinfocfg: {}".format(modelinfocfg))

  return modelinfocfg


def tdd(path, weights_path):
  from tools import test_lanenet
  test_lanenet.test_lanenet(path, weights_path)
  return
