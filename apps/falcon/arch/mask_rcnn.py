__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# mask_rcnn
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys
import datetime
import time
import json

from importlib import import_module
from collections import defaultdict

import logging
import tensorflow as tf

import numpy as np
import pandas as pd

## custom imports
import common
import apputil
import viz

## arch specific code
from mrcnn import model as modellib
from mrcnn import utils
from mrcnn.config import Config

log = logging.getLogger('__main__.'+__name__)

# this = sys.modules[__name__]


class InferenceConfig(Config):
  """Mask R-CNN
  Dynamic loading of the config using a dictionary object
  ## Ref:
  ## How to creating-class-instance-properties-from-a-dictionary?
  ## https://stackoverflow.com/questions/1639174/creating-class-instance-properties-from-a-dictionary
  #
  ## How to invoke the super constructor?
  ## https://stackoverflow.com/questions/2399307/how-to-invoke-the-super-constructor#2399332
  ------------------------------------------------------------
  """
  def __init__(self, dictionary):
    for k,v in dictionary.items():
      setattr(self, k, v)
    super(InferenceConfig, self).__init__()


def get_dnncfg(cfg_config):
  """Load the DNN Configuration Dynamically
  """
  dnncfg = InferenceConfig(cfg_config)
  dnncfg.display()

  ## Ref: Mask_RCNN/mrcnn/model.py", @build: line 1857
  log.info("Image size must be dividable by 2 multiple times at least 6 times!")

  dims = [(2**6)*i for i in range(1,50) if (2**6)*i < 1080]
  ## [64, 128, 192, 256, 320, 384, 448, 512, 576, 640, 704, 768, 832, 896, 960, 1024]
  res = [{'w':i,'h':dims[j],'ap':round(i/dims[j],2)} for j in range(0,len(dims)) for i in dims[j:] if 1.6 < round(i/dims[j],1) < 1.9 ]
  # [{'w': 320, 'h': 192, 'ap': 1.67}, {'w': 448, 'h': 256, 'ap': 1.75}, {'w': 576, 'h': 320, 'ap': 1.8}, {'w': 640, 'h': 384, 'ap': 1.67}, {'w': 704, 'h': 384, 'ap': 1.83}, {'w': 768, 'h': 448, 'ap': 1.71}, {'w': 896, 'h': 512, 'ap': 1.75}, {'w': 960, 'h': 576, 'ap': 1.67}, {'w': 1024, 'h': 576, 'ap': 1.78}]
  log.info("For Image: WxH=1920x1080 and AP=1.78, re-sized h,w can be: {}".format(res))

  h, w = dnncfg.IMAGE_SHAPE[:2]
  if h / 2**6 != int(h / 2**6) or w / 2**6 != int(w / 2**6):
      raise Exception("Image size must be dividable by 2 at least 6 times "
                      "to avoid fractions when downscaling and upscaling."
                      "For example, use 256, 320, 384, 448, 512, ... etc. ")

  ## TODO: check for:
  ## WEIGHTS_PATH in all cases - training or prediction
  ## Annotation files in case of training

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

  log_dir_path = apputil.get_abs_path(appcfg, cmdcfg, 'AI_LOGS')
  with tf.device(device):
    model = modellib.MaskRCNN(mode=mode, config=dnncfg, model_dir=log_dir_path)

  weights = cmdcfg['weights']
  if weights and weights.lower() == "last":
      weights_path = model.find_last()
  else:
    weights_path = cmdcfg['weights_path']

  log.debug("Loading weights from weights_path: {}".format(weights_path))

  ## TODO: pass this error to the router for API consumption
  if not os.path.exists(weights_path) or not os.path.isfile(weights_path):
    raise Exception('weights_path does not exists: {}'.format(weights_path))

  ## TODO: uncoment only for testing
  # model.set_log_dir(weights_path)

  if mode == appcfg['APP']['TRAIN_MODE']:
    model.load_weights(weights_path, by_name=cmdcfg['load_weights']['by_name'], exclude=cmdcfg['load_weights']['exclude'])
  elif mode == appcfg['APP']['TEST_MODE']:
    model.load_weights(weights_path, by_name=cmdcfg['load_weights']['by_name'])

  log.info("Loaded weights successfully from weights_path: {}".format(weights_path))

  return model


def create_modelinfo(mi):
  """create modelinfo configuration in consistent way
  """
  from modelinfo import modelcfg

  modelinfocfg = {k: mi[k] if k in mi else modelcfg[k] for k in modelcfg.keys()}
  timestamp = common.timestamp()
  modelinfocfg['problem_id'] = 'ods'
  modelinfocfg['rel_num'] = modelinfocfg['timestamp'] = timestamp
  modelinfocfg['model_info'] = apputil.get_modelinfo_filename(modelinfocfg)

  log.info("modelinfocfg: {}".format(modelinfocfg))

  return modelinfocfg


def prepare_image(im_non_numpy, target=None):
  """
  im_non_numpy is created using PIL
    ```python
    from PIL import Image

    image = request.files["image"]
    image_bytes = image.read()
    im_non_numpy = Image.open(io.BytesIO(image_bytes))
    ```
  target = (IMAGE_WIDTH, IMAGE_HEIGHT)

  Ref: https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/

  TODO: Image normalization
  """
  # if the image mode is not RGB, convert it
  if im_non_numpy.mode != "RGB":
    im_non_numpy = im_non_numpy.convert("RGB")

  if target:
    # resize the input image and preprocess it
    im_non_numpy = im_non_numpy.resize(target)

  im = np.array(im_non_numpy)
  return im


# def load_image_gt_without_resizing(dataset, datacfg, config, image_id):
#   """Inspired from load_image_gt, but does not re-size the image
#   """

#   # Load image and mask
#   image = dataset.load_image(image_id, datacfg, config)
#   mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg, config)
#   # Note that some boxes might be all zeros if the corresponding mask got cropped out.
#   # and here is to filter them out
#   _idx = np.sum(mask, axis=(0, 1)) > 0
#   mask = mask[:, :, _idx]
#   class_ids = class_ids[_idx]
  
#   # Bounding boxes. Note that some boxes might be all zeros
#   # if the corresponding mask got cropped out.
#   # bbox: [num_instances, (y1, x1, y2, x2)]
#   bbox = utils.extract_bboxes(mask)

#   # Active classes
#   # Different datasets have different classes, so track the
#   # classes supported in the dataset of this image.
#   active_class_ids = np.zeros([dataset.num_classes], dtype=np.int32)
#   source_class_ids = dataset.source_class_ids[dataset.image_info[image_id]["source"]]
#   active_class_ids[source_class_ids] = 1
  
#   # return image, class_ids, bbox, mask
#   return image, class_ids, bbox, mask, active_class_ids


def class_ids_of_model_to_dataset(class_names_dataset, class_ids_dataset, class_names_model, class_ids_model):
  """Map the model's class ids to dataset classids
  given that label names matches lexically and are also case sensitive

  if ground truth (gt) dataset has subset of classids
  wrt to the model being evaluated, remove the predictions of classes which
  are not present in the gt dataset, otherwise those extra
  classses are considered as false positive during evaluation,
  and hence evaluation metric cannot be used to asses actual goodness

  return the respective prediction array after filtering predictions for the
  classes which are not present in the dataset but are predicted by the model
  """

  ## class_ids of the model would be different than the class_ids of the dataset, even though
  ## they may haev sharing text labels (lbl_id)

  ## 1. get the class names in the model which are common with the dataset
  class_names_common_model_indices = np.where(np.in1d(class_names_model, class_names_dataset))[0]
  class_names_common = class_names_model[class_names_common_model_indices]

  log.info("class_names_dataset: {}".format(class_names_dataset))
  log.info("class_ids_dataset: {}".format(class_ids_dataset))
  log.info("class_names_model: {}".format(class_names_model))
  log.info("class_ids_model: {}".format(class_ids_model))

  log.info("class_names_common: {}".format(class_names_common))
  log.info("class_names_common_model_indices: {}".format(class_names_common_model_indices))

  class_ids_common_model = class_ids_model[class_names_common_model_indices]

  class_names_common_dataset_indices = np.where(np.in1d(class_names_dataset, class_names_model))[0]
  class_ids_common_dataset = class_ids_dataset[class_names_common_dataset_indices]

  log.info("class_names_common_dataset_indices: {}".format(class_names_common_dataset_indices))
  log.info("class_ids_common_dataset: {}".format(class_ids_common_dataset))
  log.info("class_ids_common_model: {}".format(class_ids_common_model))

  gt_to_model_map = dict(zip(class_ids_common_dataset, class_ids_common_model))
  return class_names_common, class_ids_common_dataset, class_ids_common_model, gt_to_model_map


def train(model, dataset_train, dataset_val, cmdcfg):
  """API
  train function definition and comments under Mask_RCNN/mrcnn/model.py for customization
  """
  log.info("---------------------------->")
  log.info("cmdcfg: {}".format(cmdcfg))
  schedule = cmdcfg.schedules
  for stage in schedule:
    log.debug(cmdcfg)

    model.train(
      train_dataset=dataset_train
      ,val_dataset=dataset_val
      ,datacfg=cmdcfg
      ,learning_rate=stage.learning_rate
      ,epochs=stage.epochs
      ,layers=stage.layers
      ,stage=stage
      ,augmentation=None
      ,custom_callbacks=None
      ,no_augmentation_sources=None
    )


def detect(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, im=None):
  """API
  """
  if im_non_numpy:
    im = prepare_image(im_non_numpy)

  r = model.detect([im], verbose)
  return r


def detect_batch(model, verbose=1, modelcfg=None, batch=None, imagenames=None, colors=None, get_mask=False, class_names=None):
  """API
  """
  log.info("len(batch): {}".format(len(batch)))

  # log.info("len(imagenames): {}".format(len(imagenames)))
  # assert len(batch) == len(imagenames)

  total_items = len(batch)
  res = []
  cc = None

  r = model.detect(batch, verbose)

  if class_names:
    if not colors:
      colors = viz.random_colors(len(class_names))
    cc = dict(zip(class_names, colors))

  for i in range(total_items):
    jsonres = viz.get_detections(
      batch[i]
      ,r[i]['rois']
      ,r[i]['masks']
      ,r[i]['class_ids']
      ,class_names
      ,r[i]['scores']
      ,colors=cc
      ,get_mask=get_mask
    )

    uid = common.createUUID('pred')
    # image_name = imagenames[i]
    image_name = uid
    jsonres["filename"] = image_name
    jsonres["file_attributes"]["uuid"] = uid
    via_jsonres = {}
    via_jsonres[image_name] = jsonres
    json_str = common.numpy_to_json(via_jsonres)

    res.append(json.loads(json_str))

  return res


def detect_with_json(model, verbose=1, modelcfg=None, image_name=None, im_non_numpy=None, colors=None, get_mask=False, class_names=None):
  """API
  """
  im = prepare_image(im_non_numpy)
  r = model.detect([im], verbose)[0]

  cc = None
  if class_names:
    if not colors:
      colors = viz.random_colors(len(class_names))
    cc = dict(zip(class_names, colors))

  jsonres = viz.get_detections(
    im
    ,r['rois']
    ,r['masks']
    ,r['class_ids']
    ,class_names
    ,r['scores']
    ,colors=cc
    ,get_mask=get_mask
  )
  return jsonres


def compute_ap_of_per_image_over_dataset(detection_on_dataset):
  """
  detection_on_dataset is [{},{}...N=total_num_images]
  each has has different keys, values for each key is a list with `n` items in that list,
  where `n` is the total number of iou_thresholds against which evaluation was done
  
  Ideally, `n` will be 10 where iou_thresholds range from 0.5 to 0.95, incremented by 0.05

  """

  ## calculate stats for per image
  ### mean
  mean_ap_of_per_image = np.mean(np.array([item['ap_per_image'] for item in detection_on_dataset]), axis=0)
  mean_f1_of_per_image = np.mean(np.array([item['f1_per_image'] for item in detection_on_dataset]), axis=0)
  mean_recall_bbox_of_per_image = np.mean(np.array([item['recall_bbox'] for item in detection_on_dataset]), axis=0)

  ### sum
  total_pred_match_total_annotation_of_per_image = np.sum(np.array([item['pred_match_total_annotation'] for item in detection_on_dataset]), axis=0)

  log.info("mean_ap_of_per_image: {}".format(mean_ap_of_per_image))
  log.info("mean_f1_of_per_image: {}".format(mean_f1_of_per_image))
  log.info("mean_recall_bbox_of_per_image: {}".format(mean_recall_bbox_of_per_image))
  log.info("total_pred_match_total_annotation_of_per_image: {}".format(total_pred_match_total_annotation_of_per_image))

  return mean_ap_of_per_image, mean_f1_of_per_image, mean_recall_bbox_of_per_image, total_pred_match_total_annotation_of_per_image


def compute_ap_dataset(detection_on_dataset, iou_thresholds):
  """Calculate mAP over entire dataset for all the iou_thresholds

  We merge the gt and pred at the image items as boundary
  It can be thought of creating a panorama by sticking all images from left most (first image) to right most (last image)
  horizonal stacking of the ground trurh and respective predictions for each image needs to have respective offsets
  for the gt_match and pred_match as they store the indices of each other at the position of the match within them.

  This needs to be for all the iou_thresholds in one go only, else it becomes too complicated wuth many for loops
  """

  size = len(iou_thresholds)
  gt_offset = np.zeros(size, dtype=int)
  pred_offset = np.zeros(size, dtype=int)
  gt_match_stacks = np.array(size*[[]])
  pred_match_stacks = np.array(size*[[]])
  pred_match_scores_stacks = np.array(size*[[]])

  total = len(detection_on_dataset)
  for i, item in enumerate(detection_on_dataset):
    gt_match = np.array(item['gt_match'])
    pred_match = np.array(item['pred_match'])
    pred_match_scores = np.array(item['pred_match_scores'])
    log.info("len(gt_match), type(gt_match), gt_match: {},{},{}".format(len(gt_match), type(gt_match), gt_match))
    log.info("len(pred_match), type(pred_match), pred_match: {},{},{}".format(len(pred_match), type(pred_match), pred_match))
    log.info("len(pred_match_scores), type(pred_match_scores), pred_match_scores: {},{},{}".format(len(pred_match_scores), type(pred_match_scores), pred_match_scores))

    gt_match_len = np.array([ len(a) for a in gt_match ])
    pred_match_len = np.array([ len(a) for a in pred_match ])
    log.info("gt_match_len: {}".format(gt_match_len))
    log.info("pred_match_len: {}".format(pred_match_len))

    assert len(gt_match_len) == len(pred_match_len)
    assert len(gt_offset) == len(pred_offset) == len(gt_match) == len(pred_match)

    log.info("i: {}".format(i))

    gt_indices = [np.where(a>-1)[0] for a in gt_match]
    pred_indices = [np.where(a>-1)[0] for a in pred_match]

    log.info("gt_indices: {}".format(gt_indices))
    log.info("pred_indices: {}".format(pred_indices))

    if i == 0 or i == (total - 1):
      log.info("skip applying of the offet for 1st and last item: {}".format(i))
    else:
      for j, idx in enumerate(gt_indices):
        gt_match[j][idx] = gt_offset[j]+gt_match[j][idx]

      for j, idx in enumerate(pred_indices):
        pred_match[j][idx] = pred_offset[j]+pred_match[j][idx]


    gt_offset = gt_offset + gt_match_len
    log.info("gt_offset: {}".format(gt_offset))

    pred_offset = pred_offset + pred_match_len
    log.info("pred_offset: {}".format(pred_offset))

    log.info("gt_match_stacks.shape, gt_match.shape: {}, {}".format(gt_match_stacks.shape, gt_match.shape))
    log.info("pred_match_stacks.shape, pred_match.shape: {}, {}".format(pred_match_stacks.shape, pred_match.shape))
    log.info("pred_match_scores_stacks.shape, pred_match_scores.shape: {}, {}".format(pred_match_scores.shape, pred_match_scores.shape))

    ## TODO: if imae has zero prediction, it throws Exception because all zero collapses to single value, and hstack dimension mismatch occurs
    gt_match_stacks = np.hstack([gt_match,gt_match_stacks])
    pred_match_stacks = np.hstack([pred_match,pred_match_stacks])
    pred_match_scores_stacks = np.hstack([pred_match_scores,pred_match_scores_stacks])

  log.info("gt_match_stacks: {}".format(gt_match_stacks))
  log.info("pred_match_stacks: {}".format(pred_match_stacks))
  log.info("pred_match_scores_stacks: {}".format(pred_match_scores_stacks))

  assert size == len(gt_match_stacks) == len(pred_match_stacks) == len(pred_match_scores_stacks)

  _mAPs = []
  _precisions = []
  _recalls = []
  for k in range(size):
    gt_match_stack = gt_match_stacks[k]
    pred_match_stack = pred_match_stacks[k]

    log.info("gt_match_stack.shape: {}".format(gt_match_stack.shape))
    log.info("pred_match_stack.shape: {}".format(pred_match_stack.shape))

    gt_matches = np.hstack(gt_match_stack)
    pred_matches = np.hstack(pred_match_stack)
    _pred_match_scores = np.hstack(pred_match_scores_stacks)

    ## TODO: sort based on pred_score
    mAP, precisions, recalls = utils.compute_ap_given_the_matches(gt_matches, pred_matches)
    log.info("mAP, precisions, recalls: {},{},{}".format(mAP, precisions, recalls))
    _mAPs.append(mAP)
    _precisions.append(precisions)
    _recalls.append(recalls)

  log.info("_mAPs, _precisions, _recalls: {},{},{}".format(_mAPs, _precisions, _recalls))

  return _mAPs, _precisions, _recalls


def evaluate(mode, cmdcfg, appcfg, modelcfg, dataset, datacfg, class_names, reportcfg, get_mask=True, auto_show=False):
  """API
  Execute the evaluation and generates the evaluation reports classification report
  with differet scores confusion matrix summary report

  Ref:
  https://github.com/matterport/Mask_RCNN/blob/master/samples/shapes/train_shapes.ipynb
  """
  log.info("---------------------------->")

  dnncfg = get_dnncfg(cmdcfg.config)
  model = load_model_and_weights(mode, cmdcfg, appcfg)

  save_viz_and_json = reportcfg['save_viz_and_json']
  evaluate_no_of_result = reportcfg['evaluate_no_of_result']
  filepath = reportcfg['filepath']
  evaluate_run_summary = reportcfg['evaluate_run_summary']

  log.info("evaluate_no_of_result: {}".format(evaluate_no_of_result))

  detection_on_dataset = []
  ## TODO: put at right place
  iou_threshold_input = reportcfg['iou_threshold']
  # iou_thresholds = None
  # iou_thresholds = iou_thresholds or np.arange(0.5, 1.0, 0.05)
  iou_thresholds = np.arange(0.5, 1.0, 0.05)
  size = len(iou_thresholds)
  _mAPs, _precisions, _recalls = size*[None], size*[None], size*[None]
  gt_total_annotation = 0
  pred_total_annotation = 0
  remaining_num_images = -1
  image_ids = dataset.image_ids
  num_images = len(image_ids)
  pred_match_total_annotation = []

  colors = viz.random_colors(len(class_names))
  log.info("len(colors), colors: {},{}".format(len(colors), colors))

  cc = dict(zip(class_names,colors))

  ## for some reasons if gets an error in iterating through dataset, all the hardwork is lost,
  ## therefore, save the data to disk in finally clause
  via_jsonres = {}
  imagelist = []

  class_ids_dataset = dataset.class_ids
  class_names_model = modelcfg['classes']
  class_ids_model = np.arange(len(class_names_model))

  log.debug("class_names dataset: {}".format(class_names))
  log.debug("class_names_model: {}".format(class_names_model))
  log.debug("class_ids_dataset: {}".format(class_ids_dataset))
  log.debug("class_ids_model: {}".format(class_ids_model))

  ## class_names consists of BG at index 0
  ## class_names_model consists of BG at index 0
  class_ids_map = False
  class_names_common = class_names.copy()
  if class_names != modelcfg['classes']:
    class_ids_map = True
    class_names_common, class_ids_common_dataset, class_ids_common_model, gt_to_model_map = class_ids_of_model_to_dataset(np.array(class_names), class_ids_dataset, np.array(class_names_model), class_ids_model)

    log.info("class_names_common: {}".format(class_names_common))
    log.info("class_ids_common_dataset: {}".format(class_ids_common_dataset))
    log.info("class_ids_common_model: {}".format(class_ids_common_model))
    ## TODO: Exception handling: if class_ids_of_model_to_dataset length is 1 then only BG is common

  class_names = np.array(class_names)

  T0 = time.time()

  try:
    for i, image_id in enumerate(image_ids):
      log.debug("-------")

      filepath_image_in = dataset.image_reference(image_id)
      image_filename = filepath_image_in.split(os.path.sep)[-1]
      image_name_without_ext = image_filename.split('.')[0]

      imagelist.append(filepath_image_in)
      log.debug("Running on {}".format(image_filename))

      if evaluate_no_of_result == i:
        log.info("evaluate_no_of_result reached: i: {}\n".format(i))
        break

      remaining_num_images = evaluate_no_of_result if evaluate_no_of_result and evaluate_no_of_result > 0 else num_images
      remaining_num_images = remaining_num_images - i - 1
      log.info("To be evaluated remaining_num_images:...................{}".format(remaining_num_images))

      t0 = time.time()

      # im, gt_class_ids, gt_boxes, gt_masks, gt_active_class_ids = load_image_gt_without_resizing(dataset, datacfg, dnncfg, image_id)
      im, gt_image_meta, gt_class_ids, gt_boxes, gt_masks = modellib.load_image_gt(dataset, datacfg, dnncfg, image_id, use_mini_mask=False)
      molded_images = np.expand_dims(modellib.mold_image(im, dnncfg), 0)

      if class_ids_map:
        log.debug("Before gt_class_id_map...:")
        log.debug("len(gt_class_ids): {}\nTotal Unique classes: len(set(gt_class_ids)): {}\ngt_class_ids: {}".format(len(gt_class_ids), len(set(gt_class_ids)), gt_class_ids))

        for _i, gt_id in enumerate(gt_class_ids):
          gt_class_ids[_i] = gt_to_model_map[gt_id]

        log.debug("After gt_class_id_map...:")
        log.debug("len(gt_class_ids): {}\nTotal Unique classes: len(set(gt_class_ids)): {}\ngt_class_ids: {}".format(len(gt_class_ids), len(set(gt_class_ids)), gt_class_ids))

      t1 = time.time()
      time_taken_imread = (t1 - t0)
      log.debug('Total time taken in time_taken_imread: %f seconds' %(time_taken_imread))

      gt_total_annotation += len(gt_class_ids)

      log.info("\nGround Truth-------->")

      log.info("i,image_id:{},{}".format(i,image_id))

      log.debug("len(gt_boxes), gt_boxes.shape, type(gt_boxes): {},{},{}".format(len(gt_boxes), gt_boxes.shape, type(gt_boxes)))
      log.debug("len(gt_masks), gt_masks.shape, type(gt_masks): {},{},{}".format(len(gt_masks), gt_masks.shape, type(gt_masks)))
      
      log.debug("gt_boxes: {}".format(gt_boxes))
      log.debug("gt_masks: {}".format(gt_masks))

      log.info("--------")

      # Detect objects
      ##---------------------------------------------
      t2 = time.time()

      r = detect(model, im=im, verbose=1)[0]
      ## N - total number of predictions
      ## (N, 4)
      pred_boxes = r['rois']
      ## (H, W, N)
      pred_masks =  r['masks']
      ## N
      pred_class_ids = r['class_ids']
      ## N
      pred_scores = r['scores']

      log.debug("Prediction on Groud Truth-------->")
      log.debug('len(r): {}'.format(len(r)))
      log.debug("len(gt_class_ids), gt_class_ids: {},{}".format(len(gt_class_ids), gt_class_ids))
      log.debug("len(pred_class_ids), pred_class_ids, type(pred_class_ids): {},{},{}".format(len(pred_class_ids), pred_class_ids, type(pred_class_ids)))
      log.debug("len(pred_scores), pred_scores: {},{}".format(len(pred_scores), pred_scores))
      log.debug("len(pred_boxes), pred_boxes.shape, type(pred_boxes): {},{},{}".format(len(pred_boxes), pred_boxes.shape, type(pred_boxes)))
      log.debug("len(pred_masks), pred_masks.shape, type(pred_masks): {},{},{}".format(len(pred_masks), pred_masks.shape, type(pred_masks)))
      log.debug("--------")

      if class_ids_map:
        pred_class_ids_common_model_indices = np.where(np.in1d(pred_class_ids, class_ids_common_model))[0]
        class_ids_common_model_pred_class_ids_indices = np.where(np.in1d(class_ids_common_model, pred_class_ids))[0]
        # pred_class_ids_common_dataset_indices = np.where(np.in1d(class_ids_common_dataset, pred_class_ids_common_model_indices))[0]

        pred_boxes = pred_boxes[pred_class_ids_common_model_indices]
        pred_masks =  pred_masks[..., pred_class_ids_common_model_indices]
        pred_class_ids = pred_class_ids[pred_class_ids_common_model_indices]
        
        pred_scores = pred_scores[pred_class_ids_common_model_indices]

        log.debug("Prediction on Groud Truth: After Model class filtering-------->")
        log.debug('len(r): {}'.format(len(r)))
        log.debug("len(pred_class_ids_common_model_indices), pred_class_ids_common_model_indices: {},{}".format(len(pred_class_ids_common_model_indices), pred_class_ids_common_model_indices))

        log.debug("len(class_ids_common_model_pred_class_ids_indices), class_ids_common_model_pred_class_ids_indices: {},{}"
          .format(len(class_ids_common_model_pred_class_ids_indices), class_ids_common_model_pred_class_ids_indices))

        log.debug("len(class_ids_common_dataset[class_ids_common_model_pred_class_ids_indices]), class_ids_common_dataset[class_ids_common_model_pred_class_ids_indices]: {},{}"
          .format(len(class_ids_common_dataset[class_ids_common_model_pred_class_ids_indices]), class_ids_common_dataset[class_ids_common_model_pred_class_ids_indices]))

        log.debug("len(gt_class_ids), gt_class_ids: {},{}".format(len(gt_class_ids), gt_class_ids))
        log.debug("len(pred_class_ids), pred_class_ids, type(pred_class_ids): {},{},{}".format(len(pred_class_ids), pred_class_ids, type(pred_class_ids)))
        log.debug("len(pred_scores), pred_scores: {},{}".format(len(pred_scores), pred_scores))
        log.debug("len(pred_boxes), pred_boxes.shape, type(pred_boxes): {},{},{}".format(len(pred_boxes), pred_boxes.shape, type(pred_boxes)))
        log.debug("len(pred_masks), pred_masks.shape, type(pred_masks): {},{},{}".format(len(pred_masks), pred_masks.shape, type(pred_masks)))
        log.debug("--------")


      pred_total_annotation += len(pred_class_ids)

      t3 = time.time()
      time_taken_in_detect = (t3 - t2)
      log.info('TIME_TAKEN_IN_DETECT:%f seconds' %(time_taken_in_detect))

      t4 = time.time()

      ## TODO: gt via_json resp and pred via jsn res separate data strucure
      ## TODO: mAP calculation for per class and over enitre dataset

      ## TODO: this does not help; need to flatten the all ground truts for eniter dataset.
      ## np.zeros(len(gt_for_all_images)), ideally same number of predictions sohuld be there
      ## Insort; have to re-write the compute_matches function for entire dataset

      evaluate_run_summary['images'].append(image_filename)
      # evaluate_run_summary['gt_boxes'].append(gt_boxes)
      evaluate_run_summary['gt_class_ids'].append(list(gt_class_ids))
      # evaluate_run_summary['gt_masks'].append(gt_masks)
      # evaluate_run_summary['pred_boxes'].append(pred_boxes)
      evaluate_run_summary['pred_class_ids'].append(list(pred_class_ids))
      evaluate_run_summary['pred_scores'].append(list(pred_scores))
      # evaluate_run_summary['pred_masks'].append(pred_masks)
      evaluate_run_summary['gt_total_annotation_per_image'].append(len(gt_class_ids))
      evaluate_run_summary['pred_total_annotation_per_image'].append(len(pred_class_ids))

      detection_on_dataset_item = defaultdict(list)
      __pred_match_total_annotation = np.zeros([len(iou_thresholds)], dtype=int)
  
      for count, iou_threshold in enumerate(iou_thresholds):
        log.info("count, iou_threshold: {}, {}".format(count, iou_threshold))

        ## Compute Average Precision at a set IoU threshold
        ## --------------------------------------------
        AP_per_image, precisions, recalls, gt_match, pred_match, overlaps, pred_match_scores, pred_match_class_ids = utils.compute_ap(
          gt_boxes, gt_class_ids, gt_masks,
          pred_boxes, pred_class_ids, pred_scores, pred_masks,
          iou_threshold=iou_threshold)

        __pred_match_total_annotation[count] += len(pred_match_class_ids)

        ## compute and returns f1 score metric
        ## --------------------------------------------
        f1_per_image = utils.compute_f1score(precisions, recalls)

        ## Compute the recall at the given IoU threshold. It's an indication
        ## of how many GT boxes were found by the given prediction boxes.
        ## --------------------------------------------
        recall_bbox, positive_ids_bbox = utils.compute_recall(gt_boxes, pred_boxes, iou_threshold)

        # log.info("len(precisions),precisions: {},{}".format(len(precisions), precisions))
        # log.info("len(recalls),recalls: {},{}".format(len(recalls), recalls))
        # log.info("len(pred_match_class_ids),pred_match_class_ids: {},{}".format(len(pred_match_class_ids), pred_match_class_ids))

        # log.info("AP_per_image: {}".format(AP_per_image))
        # log.info("len(overlaps),overlaps: {},{}".format(len(overlaps), overlaps))

        pred_match_class_names = class_names[np.where(np.in1d(dataset.class_ids, pred_match_class_ids))[0]]

        detection_on_dataset_item['ap_per_image'].append(AP_per_image)
        detection_on_dataset_item['f1_per_image'].append(f1_per_image)
        detection_on_dataset_item['precisions'].append(precisions)
        detection_on_dataset_item['recalls'].append(list(recalls))
        detection_on_dataset_item['recall_bbox'].append(recall_bbox)
        detection_on_dataset_item['positive_ids_bbox'].append(list(positive_ids_bbox))
        detection_on_dataset_item['gt_match'].append(list(gt_match))
        detection_on_dataset_item['pred_match'].append(list(pred_match))
        detection_on_dataset_item['pred_match_scores'].append(list(pred_match_scores))
        detection_on_dataset_item['overlaps_mask_iou'].append(list(overlaps))
        detection_on_dataset_item['pred_match_class_ids'].append(list(pred_match_class_ids))
        detection_on_dataset_item['pred_match_class_names'].append(list(pred_match_class_names))
        detection_on_dataset_item['pred_match_total_annotation'].append(len(pred_match_class_ids))
        detection_on_dataset_item['iou_thresholds'].append(iou_threshold)

        if save_viz_and_json and iou_threshold == float(iou_threshold_input):
          fext = ".png"
          file_name = image_filename+fext
          log.info("@IoU, SAVED_FILE_NAME: {},{}".format(iou_threshold, file_name))
          jsonres = viz.get_display_instances(im, pred_boxes, pred_masks, pred_class_ids, class_names_model, pred_scores,
                                                 colors=cc, show_bbox=True, show_mask=True, get_mask=get_mask, filepath=filepath, filename=file_name, auto_show=auto_show)

          ## Convert Json response to VIA Json response
          ##---------------------------------------------
          # size_image = 0
          size_image = os.path.getsize(filepath_image_in)
          jsonres["filename"] = image_filename
          jsonres["size"] = size_image
          jsonres['file_attributes']['iou'] = iou_threshold

          ## TODO: if want to store in mongoDB, '.' (dot) should not be present in the key in the json data
          ## but, to visualize the results in VIA tool, this (dot) and size is expected
          # via_jsonres[image_filename.replace('.','-')+str(size_image)] = json.loads(common.numpy_to_json(jsonres))
          via_jsonres[image_filename+str(size_image)] = json.loads(common.numpy_to_json(jsonres))
          # log.debug("jsonres: {}".format(jsonres))
          # log.debug("via_jsonres[image_filename+str(size_image)]: {}".format(via_jsonres[image_filename+str(size_image)]))


      detection_on_dataset.append(detection_on_dataset_item)
      pred_match_total_annotation.append(__pred_match_total_annotation)

      mean_ap_of_per_image, mean_f1_of_per_image, mean_recall_bbox_of_per_image, total_pred_match_total_annotation_of_per_image = compute_ap_of_per_image_over_dataset(detection_on_dataset)

      ## TODO: use detection_on_dataset for evaluation over entire dataset and per class
      ## fix the TODO items within compute_ap_dataset
      # _mAPs, _precisions, _recalls = compute_ap_dataset(detection_on_dataset, iou_thresholds)

    log.info("---x-x---")
  except Exception as e:
    log.info("Exception: {}".format(e))
    log.error("Fatal error in main loop".format(e), exc_info=True)
    # log.error('Error occurred ' + str(e))
    raise
  finally:
    log.info("--------X--------X--------X--------")
    T1 = time.time()

    evaluate_run_summary['total_execution_time'] = T1 - T0
    
    evaluate_run_summary['mAP'] = _mAPs
    evaluate_run_summary['precision'] = _precisions
    evaluate_run_summary['recall'] = _recalls

    evaluate_run_summary['class_names_dataset'] = class_names
    evaluate_run_summary['class_ids_dataset'] = dataset.class_ids
    evaluate_run_summary['class_names_model'] = class_names_model
    evaluate_run_summary['class_ids_model'] = class_ids_model
    evaluate_run_summary['class_names_common'] = class_names_common

    evaluate_run_summary['mean_ap_of_per_image'] = mean_ap_of_per_image
    evaluate_run_summary['mean_f1_of_per_image'] = mean_f1_of_per_image
    evaluate_run_summary['mean_recall_bbox_of_per_image'] = mean_recall_bbox_of_per_image
    evaluate_run_summary['total_pred_match_total_annotation_of_per_image'] = total_pred_match_total_annotation_of_per_image

    evaluate_run_summary['pred_match_total_annotation'] = pred_match_total_annotation
    evaluate_run_summary['gt_total_annotation'] = gt_total_annotation
    evaluate_run_summary['pred_total_annotation'] = pred_total_annotation
    evaluate_run_summary['iou_thresholds'] = iou_thresholds
    evaluate_run_summary['execution_end_time'] = "{:%d%m%y_%H%M%S}".format(datetime.datetime.now())
    # evaluate_run_summary['detection_min_confidence'] = dnncfg.config['DETECTION_MIN_CONFIDENCE']
    evaluate_run_summary['remaining_num_images'] = remaining_num_images

    log.debug("evaluate_run_summary: {}".format(evaluate_run_summary))

    classification_reportfile_path = reportcfg['classification_reportfile']+'-per_dataset.json'
    with open(classification_reportfile_path,'w') as fw:
      fw.write(common.numpy_to_json(detection_on_dataset))

    evaluate_run_summary_reportfile_path = reportcfg['evaluate_run_summary_reportfile']+'.json'
    with open(evaluate_run_summary_reportfile_path,'w') as fw:
      fw.write(common.numpy_to_json(evaluate_run_summary))

    ## Save the image list for loading the response in VIA along with the images
    imagelist_filepath = os.path.join(filepath, 'annotations', "imagelist.csv")
    pd.DataFrame(imagelist).to_csv(imagelist_filepath)

    ## https://stackoverflow.com/questions/12309269/how-do-i-write-json-data-to-a-file
    via_jsonres_filepath = os.path.join(filepath, 'annotations', "annotations.json")
    if via_jsonres and len(via_jsonres) > 0:
      with open(via_jsonres_filepath, 'w') as fw:
        fw.write(json.dumps(via_jsonres))

    print("EVALUATE_REPORT:ANNOTATION:{}".format(via_jsonres_filepath))
    print("EVALUATE_REPORT:IMAGELIST:{}".format(imagelist_filepath))
    print("EVALUATE_REPORT:METRIC:{}".format(classification_reportfile_path))
    print("EVALUATE_REPORT:SUMMARY:{}".format(evaluate_run_summary_reportfile_path))

    log.info("--------")

    return evaluate_run_summary
