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
import tensorflow as tf

## custom imports
import common
import apputil

## arch specific code
from config import global_config
from lanenet_model import lanenet
# from lanenet_model import lanenet_postprocess

# ## To disable tensorflow debugging logs
# # https://stackoverflow.com/questions/35911252/disable-tensorflow-debugging-information
# logging.getLogger('tensorflow').setLevel(logging.ERROR)
# os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

log = logging.getLogger('__main__.'+__name__)


def load_graph(weights_path):
  with tf.gfile.GFile(weights_path, "rb") as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())

  with tf.Graph().as_default() as graph:
    tf.import_graph_def(graph_def, name="")
  return graph


def get_dnncfg(cfg_config):
  """Load the DNN Configuration Dynamically
  """
  dnncfg = None

  return dnncfg


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
  # # with tf.device(device):
  # #   model = modellib.MaskRCNN(mode=mode, config=dnncfg, model_dir=log_dir_path)

  # # weights = cmdcfg['weights']
  # # if weights and weights.lower() == "last":
  # #     weights_path = model.find_last()
  # # else:
  # #   weights_path = cmdcfg['weights_path']

  # # log.debug("Loading weights from weights_path: {}".format(weights_path))

  # # ## TODO: pass this error to the router for API consumption
  # # if not os.path.exists(weights_path) or not os.path.isfile(weights_path):
  # #   raise Exception('weights_path does not exists: {}'.format(weights_path))

  # # if mode == appcfg['APP']['TRAIN_MODE']:
  # #   model.load_weights(weights_path, by_name=cmdcfg['load_weights']['by_name'], exclude=cmdcfg['load_weights']['exclude'])
  # # elif mode == appcfg['APP']['TEST_MODE']:
  # #   model.load_weights(weights_path, by_name=cmdcfg['load_weights']['by_name'])

  # # log.info("Loaded weights successfully from weights_path: {}".format(weights_path))


  ## used earlier for loading the model in the ckpt format
  ## Ref: lanenet-lane-detection/tools/predict.py
  # net = lanenet.LaneNet(phase='test', net_flag='vgg')

  weights_path = cmdcfg['weights_path']
  log.debug("Loading weights from weights_path: {}".format(weights_path))

  graph = load_graph(weights_path)

  return graph


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


def prepare_image(im_non_numpy):
  im = np.array(im_non_numpy)
  return im


def train(model, dataset_train, dataset_val, cmdcfg):
  """train function definition and comments under Mask_RCNN/mrcnn/model.py for customization
  """
  log.info("---------------------------->")
  log.info("cmdcfg: {}".format(cmdcfg))

  from tools import train


def detect(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, im=None):
  pred_json = detect_with_json(model, verbose=verbose, modelcfg=modelcfg, image_name=image_name, im_non_numpy=im_non_numpy)
  return [pred_json]


def detect_batch(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None):
  return detect(model, verbose=verbose, modelcfg=modelcfg, image_name=image_name, im_non_numpy=im_non_numpy)


def detect_with_json(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, colors=None, get_mask=False, class_names=None):
  CFG = global_config.cfg
  # weights_path = modelcfg['weights_path']
  
  t_start = time.time()
  
  # lanenet_postprocess_mod = import_module("lanenet_model."+'lanenet_postprocess_'+orientation)
  lanenet_postprocess_mod = get_postprocess(modelcfg)

  postprocess_result = None

  ## TODO: check if im.shape is not a valid shape then only resize
  im_non_numpy = im_non_numpy.resize((1280,720), Image.ANTIALIAS)
  log.info("Resized_image_shape : {}".format(im_non_numpy.size))
  im_src = np.array(im_non_numpy)
  im = cv2.resize(im_src, (512, 256), interpolation=cv2.INTER_LINEAR)
  im = im / 127.5 - 1.0

  graph = model

  input_tensor = graph.get_tensor_by_name("lanenet/input_tensor:0")
  binary_seg_ret = graph.get_tensor_by_name("lanenet/final_binary_output:0")
  instance_seg_ret = graph.get_tensor_by_name("lanenet/final_pixel_embedding_output:0")

  postprocessor = lanenet_postprocess_mod.LaneNetPostProcessor()

  # Set sess configuration
  sess_config = tf.ConfigProto()
  sess_config.gpu_options.per_process_gpu_memory_fraction = CFG.TEST.GPU_MEMORY_FRACTION
  sess_config.gpu_options.allow_growth = CFG.TRAIN.TF_ALLOW_GROWTH
  sess_config.gpu_options.allocator_type = 'BFC'


  with tf.Session(graph=graph, config=sess_config) as sess:
    binary_seg_image, instance_seg_image = sess.run(
      [binary_seg_ret, instance_seg_ret],
      feed_dict={input_tensor: [im]}
    )

  postprocess_result = postprocessor.postprocess(
    image_name=image_name,
    binary_seg_result=binary_seg_image,
    instance_seg_result=instance_seg_image,
    source_image=im_src
  )

  sess.close()
  pred_json = postprocess_result['pred_json']

  label = modelcfg['classes'][1] if modelcfg and modelcfg['classes'] and len(modelcfg['classes']) > 1 else modelcfg['problem_id']
  pred_json = convert_to_via(pred_json, label)

  pred_json["file_attributes"] = {
    'width' : 1280,
    'height' : 720
  }

  t_cost = time.time() - t_start
  log.info('Single imgae inference cost time: {:.5f}s'.format(t_cost))
  
  return pred_json


def convert_to_via(pred_json, label='lane'):
  """
  Converts lanenet output to via format
  """
  x = pred_json['x_axis']
  y = pred_json['y_axis']
  regions = []
  for i in range(len(x)):
    regions.append({
      'region_attributes': {
        'label': label
      }
      ,'shape_attributes': {
        'all_points_x': x[i]
        ,'all_points_y': y[i]
        ,"name": "polyline"
      }
    })

  return { "regions": regions }

  ## TODO: cleanup
  # ## Filters
  # pred_json.pop('x_axis', None)
  # pred_json.pop('y_axis', None)
  # pred_json.pop('image_name', None)
  # pred_json.pop('run_time', None)
  # pred_json['regions'] = regions

  # return pred_json

def get_postprocess(modelcfg):
  problem_id = modelcfg['problem_id']
  if problem_id == 'rld' or 'rbd':
    orientation = 'vLine'
  else:
    orientation = 'hLine'
  return import_module("lanenet_model."+'lanenet_postprocess_'+orientation)


def tdd(path, weights_path):
  from tools import test_lanenet
  test_lanenet.test_lanenet(path, weights_path)
  return
