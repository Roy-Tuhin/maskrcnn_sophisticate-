__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# Utility functions
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys
import glob
import re
import time
import datetime
from collections import defaultdict

from importlib import import_module
import logging

# custom imports
import common
import apputil
import viz

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
ROOT_DIR = os.getenv('AI_HOME')
BASE_PATH_CFG = os.getenv('AI_CFG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

this = sys.modules[__name__]
log = logging.getLogger('__main__.'+__name__)

import motor.motor_asyncio
import asyncio
import json
import aiofiles


def visualize(args, mode, appcfg):
  """Load and display given image_ids
  """
  log.debug("-------------------------------->")
  log.debug("visualizing annotations...")

  from falcon.utils import compute
  from falcon.utils import visualize as _visualize

  subset = args.eval_on
  log.debug("subset: {}".format(subset))

  datacfg = apputil.get_datacfg(appcfg)
  dbcfg = apputil.get_dbcfg(appcfg)

  dataset, num_classes, num_images, class_names, total_stats, total_verify = apputil.get_dataset_instance(appcfg, dbcfg, datacfg, subset)
  colors = viz.random_colors(len(class_names))

  log.debug("class_names: {}".format(class_names))
  log.debug("len(class_names): {}".format(len(class_names)))
  log.debug("len(colors), colors: {},{}".format(len(colors), colors))
  log.debug("num_classes: {}".format(num_classes))
  log.debug("num_images: {}".format(num_images))

  name = dataset.name
  datacfg.name = name
  datacfg.classes = class_names
  datacfg.num_classes = num_classes
  image_ids = dataset.image_ids
  # log.debug("dataset: {}".format(vars(dataset)))
  # log.debug("len(dataset.image_info): {}".format(len(dataset.image_info)))
  class_names = dataset.class_names
  log.debug("dataset: len(image_ids): {}\nimage_ids: {}".format(len(image_ids), image_ids))
  log.debug("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

  for image_id in image_ids:
    image = dataset.load_image(image_id, datacfg)
    if image is not None:
      mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg)

      log.debug("keys: {}".format(keys))
      log.debug("values: {}".format(values))
      log.debug("class_ids: {}".format(class_ids))

      ## Display image and instances
      # _visualize.display_top_masks(image, mask, class_ids, class_names)
      ## Compute Bounding box
      
      bbox = compute.extract_bboxes(mask)
      log.debug("bbox: {}".format(bbox))
      # _visualize.display_instances(image, bbox, mask, class_ids, class_names, show_bbox=False)
      _visualize.display_instances(image, bbox, mask, class_ids, class_names)
      # return image, bbox, mask, class_ids, class_names
    else:
      log.error("error reading image with image_id: {}".format(image_id))


def inspect_annon(args, mode, appcfg):
  """inspection of data from command line for quick verification of data sanity
  """
  log.debug("---------------------------->")
  log.debug("Inspecting annotations...")

  subset = args.eval_on
  log.debug("subset: {}".format(subset))
  
  datacfg = apputil.get_datacfg(appcfg)
  dbcfg = apputil.get_dbcfg(appcfg)

  dataset, num_classes, num_images, class_names, total_stats, total_verify = apputil.get_dataset_instance(appcfg, dbcfg, datacfg, subset)
  colors = viz.random_colors(len(class_names))

  log.debug("class_names: {}".format(class_names))
  log.debug("len(class_names): {}".format(len(class_names)))
  log.debug("len(colors), colors: {},{}".format(len(colors), colors))
  log.debug("num_classes: {}".format(num_classes))
  log.debug("num_images: {}".format(num_images))

  name = dataset.name
  datacfg.name = name
  datacfg.classes = class_names
  datacfg.num_classes = num_classes

  # log.debug("dataset: {}".format(vars(dataset)))
  log.debug("len(dataset.image_info): {}".format(len(dataset.image_info)))
  log.debug("len(dataset.image_ids): {}".format(len(dataset.image_ids)))

  mod = apputil.get_module('inspect_annon')

  archcfg = apputil.get_archcfg(appcfg)
  log.debug("archcfg: {}".format(archcfg))
  cmdcfg = archcfg

  cmdcfg.name = name
  cmdcfg.config.NAME = name
  cmdcfg.config.NUM_CLASSES = num_classes

  dnnmod = apputil.get_module(cmdcfg.dnnarch)

  get_dnncfg = apputil.get_module_fn(dnnmod, "get_dnncfg")
  dnncfg = get_dnncfg(cmdcfg.config)
  log.debug("config.MINI_MASK_SHAPE: {}".format(dnncfg.MINI_MASK_SHAPE))
  log.debug("type(dnncfg.MINI_MASK_SHAPE): {}".format(type(dnncfg.MINI_MASK_SHAPE)))
  mod.all_steps(dataset, datacfg, dnncfg)

  return


def train(args, mode, appcfg):
  log.debug("train---------------------------->")

  datacfg = apputil.get_datacfg(appcfg)

  ## Training dataset.
  subset = "train"
  log.info("subset: {}".format(subset))
  dbcfg = apputil.get_dbcfg(appcfg)

  dataset_train, num_classes_train, num_images_train, class_names_train, total_stats_train, total_verify_train = apputil.get_dataset_instance(appcfg, dbcfg, datacfg, subset)
  colors = viz.random_colors(len(class_names_train))
  
  log.info("-------")
  log.info("len(colors), colors: {},{}".format(len(colors), colors))

  log.info("subset, class_names_train: {}, {}".format(subset, class_names_train))
  log.info("subset, len(class_names_train): {}, {}".format(subset, len(class_names_train)))
  log.info("subset, num_classes_train: {}, {}".format(subset, num_classes_train))
  log.info("subset, num_images_train: {}, {}".format(subset, num_images_train))

  log.info("subset, len(dataset_train.image_info): {}, {}".format(subset, len(dataset_train.image_info)))
  log.info("subset, len(dataset_train.image_ids): {}, {}".format(subset, len(dataset_train.image_ids)))

  ## Validation dataset
  subset = "val"
  log.info("subset: {}".format(subset))
  dataset_val, num_classes_val, num_images_val, class_names_val, total_stats_val, total_verify_val = apputil.get_dataset_instance(appcfg, dbcfg, datacfg, subset)
  
  log.info("-------")
  log.info("subset, class_names_val: {}, {}".format(subset, class_names_val))
  log.info("subset, len(class_names_val): {}, {}".format(subset, len(class_names_val)))
  log.info("subset, num_classes_val: {}, {}".format(subset, num_classes_val))
  log.info("subset, num_images_val: {}, {}".format(subset, num_images_val))
  
  log.info("subset, len(dataset_val.image_info): {}, {}".format(subset, len(dataset_val.image_info)))
  log.info("subset, len(dataset_val.image_ids): {}, {}".format(subset, len(dataset_val.image_ids)))

  log.info("-------")

  ## Ensure label sequence and class_names of train and val dataset are excatly same, if not abort training
  assert class_names_train == class_names_val

  archcfg = apputil.get_archcfg(appcfg)
  log.debug("archcfg: {}".format(archcfg))
  cmdcfg = archcfg

  name = dataset_train.name

  ## generate the modelinfo template to be used for evaluate and prediction
  modelinfocfg = {
    'classes': class_names_train.copy()
    ,'classinfo': None
    ,'config': cmdcfg.config.copy()
    ,'dataset': cmdcfg.dbname
    ,'dbname': cmdcfg.dbname
    ,'dnnarch': cmdcfg.dnnarch
    ,'framework_type': cmdcfg.framework_type
    ,'id': None
    ,'load_weights': cmdcfg.load_weights.copy()
    ,'name': name
    ,'num_classes': num_classes_train
    ,'problem_id': None
    ,'rel_num': None
    ,'weights': None
    ,'weights_path': None
    ,'log_dir': None
    ,'checkpoint_path': None
    ,'model_info': None
    ,'timestamp': None
    ,'creator': None
  }

  datacfg.name = name
  datacfg.classes = class_names_train
  datacfg.num_classes = num_classes_train

  cmdcfg.name = name
  cmdcfg.config.NAME = name
  cmdcfg.config.NUM_CLASSES = num_classes_train

  modelcfg_path = os.path.join(appcfg.PATHS.AI_MODEL_CFG_PATH, cmdcfg.model_info)
  log.info("modelcfg_path: {}".format(modelcfg_path))
  modelcfg = apputil.get_modelcfg(modelcfg_path)

  weights_path = apputil.get_abs_path(appcfg, modelcfg, 'AI_WEIGHTS_PATH')
  cmdcfg['weights_path'] = weights_path

  dnnmod = apputil.get_module(cmdcfg.dnnarch)
  load_model_and_weights = apputil.get_module_fn(dnnmod, "load_model_and_weights")
  model = load_model_and_weights(mode, cmdcfg, appcfg)  
  
  modelinfocfg['log_dir'] = model.log_dir
  modelinfocfg['checkpoint_path'] = model.checkpoint_path

  if 'creator' in cmdcfg:
    modelinfocfg['creator'] = cmdcfg['creator']

  log.info("modelinfocfg: {}".format(modelinfocfg))

  fn_create_modelinfo = apputil.get_module_fn(dnnmod, "create_modelinfo")
  modelinfo = fn_create_modelinfo(modelinfocfg)
  
  create_modelinfo = args.create_modelinfo
  try:
    if not create_modelinfo:
      log.info("Training...")
      fn_train = apputil.get_module_fn(dnnmod, "train")
      fn_train(model, dataset_train, dataset_val, cmdcfg)
      log.info("Training Completed!!!")
  finally:
    ## save modelinfo
    ## popolate the relative weights_path of the last model from the training if any model is generated otherwise None

    logs_path = appcfg['PATHS']['AI_LOGS']
    dnn = cmdcfg.dnnarch
  
    ##TODO

    list_of_files = glob.glob(os.path.join(model.log_dir,dnn+'*')) # * means all if need specific format then *.h5
    latest_file = max(list_of_files, key=os.path.getctime)
    new_weights_path = re.sub('\{}'.format(logs_path+'/'), '', latest_file)

    modelinfo['weights_path'] = new_weights_path

    modelinfo_filepath = apputil.get_abs_path(appcfg, modelinfo, 'AI_MODEL_CFG_PATH')
    common.yaml_safe_dump(modelinfo_filepath, modelinfo)
    log.info("TRAIN:MODELINFO_FILEPATH: {}".format(modelinfo_filepath))
    log.info("---x--x--x---")

  return modelinfo_filepath


def predict(args, mode, appcfg):
  """Executes the prediction and stores the generated results
  TODO:
  1. create the prediction configuration 
  2. PDB specification
  """

  log.debug("predict---------------------------->")

  archcfg = apputil.get_archcfg(appcfg)
  log.debug("archcfg: {}".format(archcfg))
  cmdcfg = archcfg

  if 'save_viz_and_json' not in cmdcfg:
    cmdcfg.save_viz_and_json = False
  
  save_viz = args.save_viz
  log.debug("save_viz: {}".format(save_viz))
  cmdcfg.save_viz_and_json = save_viz

  modelcfg_path = os.path.join(appcfg.PATHS.AI_MODEL_CFG_PATH, cmdcfg.model_info)
  log.info("modelcfg_path: {}".format(modelcfg_path))
  modelcfg = apputil.get_modelcfg(modelcfg_path)

  log.debug("modelcfg: {}".format(modelcfg))
  api_model_key = apputil.get_api_model_key(modelcfg)
  log.debug("api_model_key: {}".format(api_model_key))
  ## for prediction, get the label information from the model information
  class_names = apputil.get_class_names(modelcfg)
  log.debug("class_names: {}".format(class_names))

  num_classes = len(class_names)
  name = modelcfg.name

  cmdcfg.name = name
  cmdcfg.config.NAME = name
  cmdcfg.config.NUM_CLASSES = num_classes

  dnnmod = apputil.get_module(cmdcfg.dnnarch)

  weights_path = apputil.get_abs_path(appcfg, modelcfg, 'AI_WEIGHTS_PATH')
  cmdcfg['weights_path'] = weights_path

  load_model_and_weights = apputil.get_module_fn(dnnmod, "load_model_and_weights")
  model = load_model_and_weights(mode, cmdcfg, appcfg)


  path_dtls = apputil.get_path_dtls(args, appcfg)
  log.debug("path_dtls: {}".format(path_dtls))
  for t in ["images", "videos"]:
    if path_dtls[t] and len(path_dtls[t]) > 0:
      fname = "detect_from_"+t
      fn = getattr(this, fname)
      if fn:
        file_names, res = fn(appcfg, dnnmod, path_dtls[t], path_dtls['path'], model, class_names, cmdcfg, api_model_key)
        # log.debug("len(file_names), file_names: {}, {}".format(len(file_names), file_names))
      else:
        log.error("Unkown fn: {}".format(fname))
  
  # return file_names, res
  return


def evaluate(args, mode, appcfg):
  """prepare the report configuration like paths, report names etc. and calls the report generation function
  """
  log.debug("evaluate---------------------------->")

  subset = args.eval_on
  iou_threshold = args.iou
  log.debug("subset: {}".format(subset))
  log.debug("iou_threshold: {}".format(iou_threshold))
  get_mask = True
  auto_show = False

  datacfg = apputil.get_datacfg(appcfg)
  dbcfg = apputil.get_dbcfg(appcfg)

  log.debug("appcfg: {}".format(appcfg))
  log.debug("datacfg: {}".format(datacfg))
  
  dataset, num_classes, num_images, class_names, total_stats, total_verify = apputil.get_dataset_instance(appcfg, dbcfg, datacfg, subset)
  colors = viz.random_colors(len(class_names))

  log.debug("-------")
  log.debug("len(colors), colors: {},{}".format(len(colors), colors))

  log.debug("class_names: {}".format(class_names))
  log.debug("len(class_names): {}".format(len(class_names)))
  log.debug("num_classes: {}".format(num_classes))
  log.debug("num_images: {}".format(num_images))

  log.debug("len(dataset.image_info): {}".format(len(dataset.image_info)))
  log.debug("len(dataset.image_ids): {}".format(len(dataset.image_ids)))
  # log.debug("dataset: {}".format(vars(dataset)))

  log.debug("-------")
  
  # log.debug("TODO: color: cc")
  # cc = dict(zip(class_names,colors))

  name = dataset.name
  datacfg.name = name
  datacfg.classes = class_names
  datacfg.num_classes = num_classes
  
  archcfg = apputil.get_archcfg(appcfg)
  log.debug("archcfg: {}".format(archcfg))
  cmdcfg = archcfg

  if 'save_viz_and_json' not in cmdcfg:
    cmdcfg.save_viz_and_json = False
  
  save_viz = args.save_viz
  log.debug("save_viz: {}".format(save_viz))
  cmdcfg.save_viz_and_json = save_viz

  modelcfg_path = os.path.join(appcfg.PATHS.AI_MODEL_CFG_PATH, cmdcfg.model_info)
  log.info("modelcfg_path: {}".format(modelcfg_path))
  modelcfg = apputil.get_modelcfg(modelcfg_path)

  ## for prediction, get the label information from the model information
  class_names_model = apputil.get_class_names(modelcfg)
  log.debug("class_names_model: {}".format(class_names_model))

  cmdcfg.name = name
  cmdcfg.config.NAME = modelcfg.name
  cmdcfg.config.NUM_CLASSES = len(class_names_model)

  # class_names = apputil.get_class_names(datacfg)
  # log.debug("class_names: {}".format(class_names))
  weights_path = apputil.get_abs_path(appcfg, modelcfg, 'AI_WEIGHTS_PATH')
  cmdcfg['weights_path'] = weights_path

  ## Prepare directory structure and filenames for reporting the evluation results
  now = datetime.datetime.now()
  ## create log directory based on timestamp for evaluation reporting
  timestamp = "{:%d%m%y_%H%M%S}".format(now)
  datacfg_ts = datacfg.timestamp if 'TIMESTAMP' in datacfg else timestamp

  save_viz_and_json = cmdcfg.save_viz_and_json
  # iou_threshold = cmdcfg.iou_threshold
  if 'evaluate_no_of_result' not in cmdcfg:
    evaluate_no_of_result = -1
  else:
    evaluate_no_of_result = cmdcfg.evaluate_no_of_result


  def clean_iou(iou):
    return str("{:f}".format(iou)).replace('.','')[:3]

  path = appcfg['PATHS']['AI_LOGS']
  # evaluate_dir = datacfg_ts+"-evaluate_"+clean_iou(iou_threshold)+"-"+name+"-"+subset+"-"+timestamp
  evaluate_dir = "evaluate_"+clean_iou(iou_threshold)+"-"+name+"-"+subset+"-"+timestamp
  filepath = os.path.join(path, cmdcfg.dnnarch, evaluate_dir)
  log.debug("filepath: {}".format(filepath))

  common.mkdir_p(filepath)
  for d in ['splash', 'mask', 'annotations', 'viz']:
    common.mkdir_p(os.path.join(filepath,d))

  ## gt - ground truth
  ## pr/pred - prediction

  def get_cfgfilename(cfg_filepath):
    return cfg_filepath.split(os.path.sep)[-1]

  ## generate the summary on the evaluation run
  evaluate_run_summary = defaultdict(list)
  evaluate_run_summary['name'] =name
  evaluate_run_summary['execution_start_time'] = timestamp
  evaluate_run_summary['subset'] = subset
  evaluate_run_summary['total_labels'] = num_classes
  evaluate_run_summary['total_images'] = num_images
  evaluate_run_summary['evaluate_no_of_result'] = evaluate_no_of_result
  evaluate_run_summary['evaluate_dir'] = evaluate_dir
  evaluate_run_summary['dataset'] = get_cfgfilename(appcfg.DATASET[appcfg.ACTIVE.DATASET].cfg_file)
  evaluate_run_summary['arch'] = get_cfgfilename(appcfg.ARCH[appcfg.ACTIVE.ARCH].cfg_file)
  evaluate_run_summary['model'] = cmdcfg['model_info']

  ## classification report and confusion matrix - json and csv
  ## generate the filenames for what reports to be generated
  reportcfg = {
    'filepath':filepath
    ,'evaluate_run_summary_reportfile':os.path.join(filepath, "evaluate_run_summary_rpt-"+subset)
    ,'classification_reportfile':os.path.join(filepath, "classification_rpt-"+subset)
    ,'confusionmatrix_reportfile':os.path.join(filepath, "confusionmatrix_rpt-"+subset)
    ,'iou_threshold':iou_threshold
    ,'evaluate_run_summary':evaluate_run_summary
    ,'save_viz_and_json':save_viz_and_json
    ,'evaluate_no_of_result':evaluate_no_of_result
  }

  log.debug("reportcfg: {}".format(reportcfg))

  dnnmod = apputil.get_module(cmdcfg.dnnarch)

  fn_evaluate = apputil.get_module_fn(dnnmod, "evaluate")

  evaluate_run_summary = fn_evaluate(mode, cmdcfg, appcfg, modelcfg, dataset, datacfg, class_names, reportcfg, get_mask)

  return evaluate_run_summary


def tdd(args, mode, appcfg):
  log.info("---------------------------->")

  from falcon import test

  status = test.main(args, mode, appcfg)

  return status


async def do_insert(c, doc):
  result = await c.insert_one(doc)
  print('result %s' % repr(result.inserted_id))

async def do_insert_many(c, docs):
  result = await c.insert_many(docs)
  print('inserted %d docs' % (len(result.inserted_ids),))

# import numpy as np
async def do_save_to_file(filepath, data, feature_vector=None):
  ## Save the VIA Json response asynchronously
  ##---------------------------------------------
  # np.save('%s.npy' % filepath, feature_vector)
  async with aiofiles.open(filepath,'w') as afw:
    await afw.write(json.dumps(data))


async def _create_res(detect, filepath, images, path, model, class_names, cmdcfg, api_model_key):
  save_viz_and_json = cmdcfg.save_viz_and_json if 'save_viz_and_json' in cmdcfg else False
  ## TODO: move to cmdcfg configuration
  get_mask = True

  file_names = []
  res = []

  colors = viz.random_colors(len(class_names))
  log.debug("class_names: {}".format(class_names))
  log.debug("len(class_names), class_names: {},{}".format(len(class_names), class_names))
  log.debug("len(colors), colors: {},{}".format(len(colors), colors))

  cc = dict(zip(class_names, colors))

  ## TODO: highly ineffecient and should be switched to batch processing mode

  # im_arr = [ viz.imread(os.path.join(path, image_filename)) for image_filename in images ]
  for image_filename in images:
    # Run model detection and save the outputs
    log.debug("-------")
    log.debug("Running on {}".format(image_filename))

    # Read image
    ##------------------------------
    ## TODO: file or filepath or url
    filepath_image_in = os.path.join(path, image_filename)
    
    t0 = time.time()
    ## TODO: 3. to verify
    # im = skimage.io.imread(filepath_image_in)
    im = viz.imread(filepath_image_in)
    # im_arr.append[im]

    t1 = time.time()
    time_taken_imread = (t1 - t0)
    log.debug('Total time taken in time_taken_imread: %f seconds' %(time_taken_imread))

    # Detect objects
    ##---------------------------------------------
    t2 = time.time()

    r = detect(model, im=im, verbose=1)[0]
    pred_boxes = r['rois']
    pred_masks =  r['masks']
    pred_class_ids = r['class_ids']
    pred_scores = r['scores']

    log.debug("Prediction on Groud Truth-------->")
    log.debug('len(r): {}'.format(len(r)))
    log.debug("len(pred_class_ids), pred_class_ids: {},{}".format(len(pred_class_ids), pred_class_ids))
    log.debug("len(pred_boxes), pred_boxes.shape, type(pred_boxes): {},{},{}".format(len(pred_boxes), pred_boxes.shape, type(pred_boxes)))
    log.debug("len(pred_masks), pred_masks.shape, type(pred_masks): {},{},{}".format(len(pred_masks), pred_masks.shape, type(pred_masks)))
    log.debug("--------")

    t3 = time.time()
    time_taken_in_detect = (t3 - t2)
    log.debug('Total time taken in detect: %f seconds' %(time_taken_in_detect))

    t4 = time.time()
    ## TODO: batchify
    if save_viz_and_json:
      imgviz, jsonres = viz.get_display_instances(im, pred_boxes, pred_masks, pred_class_ids, class_names, pred_scores,
                                                     colors=cc, show_bbox=False, get_mask=get_mask)
    else:
      jsonres = viz.get_detections(im, pred_boxes, pred_masks, pred_class_ids, class_names, pred_scores,
                                     colors=cc, get_mask=get_mask)

    log.debug("jsonres: {}".format(jsonres))

    ## Convert Json response to VIA Json response
    ##---------------------------------------------
    ## https://stackoverflow.com/questions/11904083/how-to-get-image-size-bytes-using-pil
    # size_image = 0
    size_image = os.path.getsize(filepath_image_in)
    jsonres["filename"] = image_filename
    jsonres["size"] = size_image
    via_jsonres = {}

    ## TODO: if want to store in mongoDB, '.' (dot) should not be present in the key in the json data
    ## but, to visualize the results in VIA tool, this (dot) and size is expected
    via_jsonres[image_filename.replace('.','-')+str(size_image)] = jsonres
    # via_jsonres[image_filename+str(size_image)] = jsonres
    json_str = common.numpy_to_json(via_jsonres)
    # log.debug("json_str:\n{}".format(json_str))
    file_name = image_filename
    # file_names.append(file_name)

    t5 = time.time()
    time_taken_res_preparation = (t5 - t4)
    log.debug('Total time taken in time_taken_res_preparation: %f seconds' %(time_taken_res_preparation))

    ## Create Visualisations & Save output
    ## TODO: resize the annotation and match with the original image size and not the min or max image dimenion form cfg
    ##---------------------------------------------
    time_taken_save_viz_and_json = -1
    if save_viz_and_json:
      t6 = time.time()
      
      fext = ".png"
      file_name = image_filename+fext

      ## Color Splash Effect & Save image
      ##---------------------------------------------
      viz.imsave(os.path.join(filepath, 'splash', file_name), viz.color_splash(im, pred_masks))

      ## Color Mask Effect & Save image
      ##---------------------------------------------
      viz.imsave(os.path.join(filepath, 'mask', file_name), viz.color_mask(im, pred_masks))

      ## Annotation Visualisation & Save image
      ##---------------------------------------------
      viz.imsave(os.path.join(filepath, 'viz', file_name), imgviz)

      t7 = time.time()
      time_taken_save_viz_and_json = (t6 - t7)
      log.debug('Total time taken in save_viz_and_json: %f seconds' %(time_taken_save_viz_and_json))

    t8 = time.time()
    tt_turnaround = (t8 - t0)
    log.debug('Total time taken in tt_turnaround: %f seconds' %(tt_turnaround))

    res_code = 200
    dnnarch = cmdcfg.dnnarch
    modelkeys = api_model_key.split('-')
    # feature_vector = json.loads(common.numpy_to_json(r))
    feature_vector = r

    apires = {
      "api": None
      ,"type": api_model_key
      ,"dnnarch": dnnarch
      ,"org_name": modelkeys[0]
      ,"problem_id": modelkeys[1]
      ,"rel_num": modelkeys[2]
      ,"image_name": image_filename
      ,"result": json.loads(json_str)
      ,'status_code': res_code
      ,'timings': {
        'image_read': time_taken_imread
        ,'detect': time_taken_in_detect
        ,'res_preparation': time_taken_res_preparation
        ,'time_taken_save_viz_and_json': time_taken_save_viz_and_json
        ,'tt_turnaround': tt_turnaround
      }
    }


    filepath_jsonres = os.path.join(filepath, 'annotations', image_filename+".json")
    log.debug("filepath_jsonres: {}".format(filepath_jsonres))

    ## Always Save the VIA Json response
    await asyncio.gather(
      do_save_to_file(filepath_jsonres, apires, feature_vector)
    )

    # res.append(apires)

  log.debug("-------")


def detect_from_images(appcfg, dnnmod, images, path, model, class_names, cmdcfg, api_model_key):
  """detections from the images
  Convention:
    image - image filename
    filepath - the absolute path of the image input file location
    im - binary data after reading the image file
  TODO:
    1. Prediction details log:
      - model details (path), copy of configuration, arch used, all class_names used in predictions, execution time etc.
    2. Verify that masks are properly scaled to the original image dimensions
    3. Impact on prediction of replacing skimage.io.imread with imread wrapper
    4. call response providing the pointer to the saved files
    5. viz from jsonres
    6. memory leak in reading image as read time increases
    7. async file and DB operation. MongoDB limit of 16 MB datasize
  """

  
  ## always create abs filepaths and respective directories
  timestamp = "{:%d%m%y_%H%M%S}".format(datetime.datetime.now())
  filepath = os.path.join(path, "predict-"+timestamp)
  common.mkdir_p(filepath)
  for d in ['splash', 'mask', 'annotations', 'viz']:
    common.mkdir_p(os.path.join(filepath,d))

  detect = apputil.get_module_fn(dnnmod, "detect")

  DBCFG = appcfg['APP']['DBCFG']
  CBIRCFG = DBCFG['CBIRCFG']

  mclient = motor.motor_asyncio.AsyncIOMotorClient('mongodb://'+CBIRCFG['host']+':'+str(CBIRCFG['port']))
  dbname = CBIRCFG['dbname']
  db = mclient[dbname]
  collection = db['IMAGES']

  loop = asyncio.new_event_loop()
  asyncio.set_event_loop(loop)

  try:
    loop.run_until_complete(_create_res(detect, filepath, images, path, model, class_names, cmdcfg, api_model_key))
  finally:
    # shutting down and closing fil descriptors after interupt
    loop.run_until_complete(loop.shutdown_asyncgens())
    loop.close()

  file_names = []
  res = []
  return file_names,res


def detect_from_videos(appcfg, dnnmod, videos, path, model, class_names, cmdcfg, api_model_key):
  """detect_from_videos
  Code adopted from:
  
  Copyright (c) 2018 Matterport, Inc.
  Licensed under the MIT License (see LICENSE for details)
  Originally, Written by Waleed Abdulla
  ---
  
  Key contribution:
  * saving the annotated results directly
  * saving the annotated mask only
  * annotation results as json response for consumption in API, VGG VIA compatible results

  Copyright (c) 2019 Vidteq India Pvt. Ltd.
  Licensed under [see LICENSE for details]
  Written by mangalbhaskar
  ---

  Conventions:
    video - video filename
    filepath - the absolute path of the video input file location
    vid - binary data after reading the video file
  """
  import cv2
  
  save_viz_and_json = cmdcfg.save_viz_and_json if 'save_viz_and_json' in cmdcfg else False
  if save_viz_and_json:
    timestamp = "{:%d%m%y_%H%M%S}".format(datetime.datetime.now())
    filepath = os.path.join(path,"predict-"+timestamp)
    log.debug("filepath: {}".format(filepath))
    common.mkdir_p(filepath)

  file_names = []
  res = []
  detect = apputil.get_module_fn(dnnmod, "detect")
  colors = viz.random_colors(len(class_names))
  log.debug("class_names: {}".format(class_names))
  log.debug("len(class_names), class_names: {},{}".format(len(class_names), class_names))
  log.debug("len(colors), colors: {},{}".format(len(colors), colors))

  cc = dict(zip(class_names,colors))

  for video in videos:
    ## Run model detection and save the outputs
    log.debug("Running on {}".format(video))

    ## Read Video
    ##---------------------------------------------
    filepath_video = os.path.join(path, video)
    log.debug("Processing video with filepath_video: {}".format(filepath_video))
    vid = cv2.VideoCapture(filepath_video)
    width = int(vid.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(vid.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fps = vid.get(cv2.CAP_PROP_FPS)

    vname, vext = os.path.splitext(video)
    file_name = video

    if save_viz_and_json:
      ## oframe - original image frame from the video
      ## pframe - annotations visualization frame from the video
      ## annotations - annotations json per frame
      path_oframe = os.path.join(filepath,vname,"oframe")
      path_pframe = os.path.join(filepath,vname,"pframe")
      path_sframe = os.path.join(filepath,vname,"splash")
      path_mframe = os.path.join(filepath,vname,"mask")
      path_viz = os.path.join(filepath,vname,"viz")
      path_annotations = os.path.join(filepath,vname,"annotations")
      for d in [path_oframe, path_pframe, path_annotations, path_sframe, path_mframe]:
        log.debug("videos dirs: {}".format(d))
        common.mkdir_p(d)

      ## Define codec and create video writer
      ##---------------------------------------------
      # file_name = "{:%d%m%y_%H%M%S}.avi".format(datetime.datetime.now())
      fext = ".avi"
      file_name = vname+fext

      filepath_pvideo = os.path.join(filepath, vname, file_name)
      log.debug("filepath_pvideo: {}".format(filepath_pvideo))

    count = 0
    success = True
    frame_cutoff = 0
    from_frame = 0
    while success:
      log.debug("-------")
      log.debug("frame: ", count)

      if frame_cutoff and count >= frame_cutoff:
        break

      ## start predictions specific 'from the specific frame number'
      if from_frame and count < from_frame:
        count += 1
        continue

      ## Read next image
      success, oframe_im = vid.read()
      if success:
        oframe_name = str(count)+"_"+video+".png"

        ## OpenCV returns images as BGR, convert to RGB
        oframe_im_rgb = oframe_im[..., ::-1]
        
        ## Detect objects
        t1 = time.time()
        
        # r = detect(model, im=oframe_im_rgb, verbose=0)
        r = detect(model, im=oframe_im_rgb, verbose=1)[0]

        t2 = time.time()
        time_taken = (t2 - t1)
        log.debug('Total time taken in detect: %f seconds' %(time_taken))

        ## Convert Json response to VIA Json response
        ##---------------------------------------------
        t1 = time.time()

        if save_viz_and_json:
          pframe_im, jsonres = viz.get_display_instances(oframe_im_rgb, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'], colors=cc, show_bbox=False)
        else:
          jsonres = viz.get_detections(oframe_im_rgb, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'], colors=cc)

        t2 = time.time()
        time_taken = (t2 - t1)
        log.debug('Total time taken in detections: %f seconds' %(time_taken))
        
        ## Convert Json response to VIA Json response
        ##---------------------------------------------
        t1 = time.time()
        size_oframe = 0
        jsonres["filename"] = oframe_name
        jsonres["size"] = size_oframe
        via_jsonres = {}
        via_jsonres[oframe_name+str(size_oframe)] = jsonres
        json_str = common.numpy_to_json(via_jsonres)
        # log.debug("json_str:\n{}".format(json_str))

        t2 = time.time()
        time_taken = (t2 - t1)
        log.debug('Total time taken in json_str: %f seconds' %(time_taken))
        
        ## Create Visualisations & Save output
        ##---------------------------------------------
        if save_viz_and_json:
          t1 = time.time()

          ## Color Splash Effect
          ## Save vframe and video buffer
          ##---------------------------------------------
          # splash = viz.color_splash(oframe_im_rgb, r['masks'])
          # # RGB -> BGR to save image to video
          # splash = splash[..., ::-1]
          # # Add image to video writer
          # vwriter_splash.write(splash)

          ## Color Mask Effect
          ## Save vframe and video buffer
          ##---------------------------------------------
          mframe_im = viz.color_mask(oframe_im_rgb, r['masks'])
          ## RGB -> BGR to save image to video
          ## mframe_im = mframe_im[..., ::-1]
          filepath_mframe = os.path.join(path_mframe, oframe_name)
          viz.imsave(filepath_mframe, mframe_im)

          ## Annotation Visualisation
          ## Save vframe and video buffer
          ##---------------------------------------------

          filepath_pframe = os.path.join(path_pframe, oframe_name)
          viz.imsave(filepath_pframe, pframe_im)

          filepath_oframe = os.path.join(path_oframe, oframe_name)
          viz.imsave(filepath_oframe, oframe_im_rgb)
          # size_oframe = os.path.getsize(filepath_oframe)

          filepath_jsonres = os.path.join(path_annotations, oframe_name+".json")
          log.debug("filepath_jsonres: {}".format(filepath_jsonres))
          with open(filepath_jsonres,'w') as fw:
            fw.write(json_str)

          ## TODO: using the opencv itself created visualisation video from individual frames
          # pframe_im_bgr = pframe_im[..., ::-1]
          # height, width = pframe_im_bgr.shape[:2]
          # ## int(vid.get(cv2.CAP_PROP_FRAME_WIDTH))
          # ## height = int(vid.get(cv2.CAP_PROP_FRAME_HEIGHT))
          # ## vwriter_splash = cv2.VideoWriter(os.path.join(filepath, 'splash_'+file_name), cv2.VideoWriter_fourcc(*'MJPG'), fps, (width, height))
          # vwriter_viz = cv2.VideoWriter(filepath_pvideo, cv2.VideoWriter_fourcc(*'MJPG'), fps, (width, height))
          # vwriter_viz.write(pframe_im_bgr)

          # ## Add image to video writer
          # ## vwriter_mask.write(mframe_im)
        
        res.append(json_str)

        count += 1

    # if save_viz_and_json:    
    #   ## vwriter_splash.release()
    #   vwriter_viz.release()

    file_names.append(file_name)

    ## https://stackoverflow.com/questions/36643139/python-and-opencv-cannot-write-readable-avi-video-files
    ## ffmpeg -framerate 29 -i MAH04240.mp4-%d.png -c:v libx264 -r 30 MAH04240-maskrcnn-viz.mp4
    ## ffmpeg -framerate 29 -i %d_MAH04240.mp4.png -c:v libx264 -r 30 MAH04240-maskrcnn-viz.mp4
  return file_names,res


def detect_from_webcam(appcfg, dnnmod, videos, path, model, class_names, cmdcfg, api_model_key):
  """TODO: stub for detect_from_webcam

  Ref:
  * https://github.com/SrikanthVelpuri/Mask_RCNN/blob/master/webcam.py
  """
  file_names = []
  res = []
  return file_names,res
