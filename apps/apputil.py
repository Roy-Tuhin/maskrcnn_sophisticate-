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
from importlib import import_module
from easydict import EasyDict as edict
import yaml

import logging
log = logging.getLogger('__main__.'+__name__)


def yaml_load(filepath):
  """Safe load YAML file as easy dictionary object
  """
  fc = None
  with open(filepath, 'r') as f:
    # fc = edict(yaml.load(f))
    fc = edict(yaml.safe_load(f))

  return fc


def getOnlyFilesInDir(path):
  """Usage: list( getOnlyFilesInDir(path) )
  """
  for file in os.listdir(path):
    if os.path.isfile(os.path.join(path, file)):
      yield file


def get_num_classes(cfg):
  class_names = get_class_names(cfg)
  num_classes = len(class_names)
  log.debug("num_classes: {}".format(num_classes))

  return num_classes


def get_class_names(cfg):
  """
  get the classes/labels in a consistent way
  """
  import json

  cifilepath = cfg['classinfo'] if 'classinfo' in cfg else None
  if cifilepath is not None and os.path.exists(cifilepath):
    with open(cifilepath,'r') as fr:
      class_info = json.load(fr)
      log.debug("class_info: {}".format(class_info))
      class_names = [ i['name'] for i in class_info ]
  else:
    classes = cfg['classes']
    if 'BG' not in classes:
      class_names = ['BG']+classes
    else:
      class_names = classes

  log.info("class_names: {}".format(class_names))
  log.info("class_names[1:]: {}".format(class_names[1:]))

  return class_names


def get_path_dtls(args, appcfg):
  """
  TBD:
  1. path as URL (http, https)
  2. path with remote protocol access: ssh/sftp/ftp/smb path
  3. Read textfile with the complete path of image,
     instead of taking textfile path as the base path for the images
  """
  import numpy as np
  log.info("get_path_dtls:----------------------------->args:{} \n appcfg:{}".format(args, appcfg))
  
  cfg = appcfg['APP']
  ALLOWED_FILE_TYPE = cfg['ALLOWED_FILE_TYPE']
  ALLOWED_IMAGE_TYPE = cfg['ALLOWED_IMAGE_TYPE']
  ALLOWED_VIDEO_TYPE = cfg['ALLOWED_VIDEO_TYPE']

  path = args.path

  dtls = {
    "path":""
    ,"images":[]
    ,"videos":[]
  }

  if os.path.isdir(path):
    dtls["path"] = path
    # dtls["images"] = sorted(os.listdir(path)) ## this will contain the directories also
    dtls["images"] = list( getOnlyFilesInDir(path) )
  elif os.path.isfile(path):
    fn, ext = os.path.splitext(os.path.basename(path))
    log.info("fn, ext: {} {}".format(fn,ext))
    
    dtls["path"] = os.path.dirname(path)

    if ext.lower() in ALLOWED_FILE_TYPE:
      # FILE_DELIMITER = cfg['FILE_DELIMITER']
      FILE_DELIMITER = ','
      # it is a file containing image names
      with open(path,'r') as f:
        data = f.read()
        ## Ref: https://stackoverflow.com/questions/1140958/whats-a-quick-one-liner-to-remove-empty-lines-from-a-python-string
        gen = (i.split(FILE_DELIMITER)[0] for i in data.split('\n') if i.strip("\r\n") ) # this works even if i=['100818_144130_16718_zed_l_938.jpg']
        ## TBD: video; assuming the image list only in the file
        dtls["images"] = np.unique( list(gen) ).tolist()
    elif ext.lower() in ALLOWED_IMAGE_TYPE:
      # it is a single image file
      dtls["images"] = [ os.path.basename(path) ] ## convert to list
    elif ext.lower() in ALLOWED_VIDEO_TYPE:
      # it is a single image file
      dtls["videos"] = [ os.path.basename(path) ] ## convert to list

  return dtls;


def get_abs_path(appcfg, param, ptype=None):
  abs_path = None
  if ptype and ptype == 'AI_MODEL_CFG_PATH':
    abs_path = os.path.join(appcfg['PATHS'][ptype], param['model_info'])
  elif ptype and ptype == 'AI_LOGS':
    abs_path = os.path.join(appcfg['PATHS'][ptype], param['log_dir'])
  elif ptype and ptype == 'AI_WEIGHTS_PATH':
    abs_path = os.path.join(appcfg['PATHS'][ptype], param['weights_path'])
  elif ptype and ptype == 'AI_ANNON_DATA_HOME_LOCAL':
    abs_path = os.path.join(appcfg['PATHS'][ptype], param['dir']) if param['dir'] else appcfg['PATHS'][ptype]

  return abs_path


def get_modelinfo_filename(modelinfocfg):
  modelinfo_filename = modelinfocfg['org_name'] + '-' + modelinfocfg['name'] + '-'+ modelinfocfg['timestamp'] + '-' + modelinfocfg['dnnarch'] + '.yml'
  return modelinfo_filename


def get_datacfg(appcfg):
  datacfg = appcfg.DATASET[appcfg.ACTIVE.DATASET].cfg
  return datacfg


def get_dbcfg(appcfg):
  dbcfg = appcfg.DATASET[appcfg.ACTIVE.DATASET].dbcfg
  return dbcfg


def get_archcfg(appcfg):
  archcfg = appcfg.ARCH[appcfg.ACTIVE.ARCH].cfg
  return archcfg


def get_modelcfg(model_info_path):
  """
  TODO: filepath or the modelinfo object
  """
  modelcfg = yaml_load(model_info_path)
  return modelcfg


def get_api_model_key(modelcfg):
  api_model_key = modelcfg['org_name']+'-'+modelcfg['problem_id']+'-'+str(modelcfg['rel_num'])
  return api_model_key


def get_module(dnnarch):
  dnnmod = import_module("falcon.arch."+dnnarch)
  return dnnmod


def get_module_fn(module, name):
  fn = None
  if module:
    fn = getattr(module, name)
    if not fn:
      log.error("_get: function is not defined in the module:{}".format(name))
  else:
    log.error("module not defined: {}".format(module))

  return fn


def get_dataset_instance(appcfg, dbcfg, datacfg, subset):
  """
  Get Dataset Instance
  Load dataset and also provide stats:
  dataset, num_classes, num_images, class_names, total_stats, total_verify

  TODO
  - remove dynamic dataclass loading, instead dynamic loading if required should be within the dataset class
  """
  log.info("-------------------------------->")
  log.debug("datacfg: {}".format(datacfg))
  log.debug("dbcfg: {}".format(dbcfg))

  # datamod = import_module('utils.'+datacfg.dataclass)
  ## TODO: detecron2 specific change, to be tested, looks good but still to keep a watch on it
  datamod = import_module('falcon.utils.'+datacfg.dataclass)
  datamodcls = getattr(datamod, datacfg.dataclass)
  name = datacfg.name
  dataset = datamodcls(name)

  total_stats = {}
  TOTAL_IMG, TOTAL_ANNOTATION, TOTAL_CLASSES = 0,0,0

  total_img, total_annotation, total_classes, annon = dataset.load_data(appcfg, dbcfg, datacfg, subset)
  log.debug("total_img, total_annotation, total_classes: {}, {}, {}".format(total_img, total_annotation, total_classes))

  total_stats[name] = [total_img, total_annotation, total_classes]

  TOTAL_IMG = total_img
  TOTAL_ANNOTATION = total_annotation
  TOTAL_CLASSES = total_classes

  total_verify = [TOTAL_IMG, TOTAL_ANNOTATION, TOTAL_CLASSES]

  log.debug("total_stats, total_verify are in the following format: [Image, Annotation, Classes]")

  ## Must call before using the dataset
  ## TODO: fix it with the class_map of the loaded model's class_ids sequence for the evaluate command - critical BUG
  dataset.prepare()

  num_classes = len(dataset.classinfo)
  num_images = dataset.num_images
  class_names = [ i['name'] for i in dataset.classinfo]

  ## length of class_names should include only single count of 'BG'
  ## But, TOTAL_CLASSES gives count without 'BG' for individual dataset(s)
  log.debug("return...: dataset, num_classes, num_images, class_names, total_stats, total_verify\n")
  log.debug("num_classes: {}".format(num_classes))
  log.debug("num_images: {}".format(num_images))
  log.debug("class_names: {}".format(class_names))
  log.debug("total_stats: {}".format(total_stats))
  log.debug("total_verify: {}".format(total_verify))

  log.debug("\n------xx-------xxx-------xx----->\n\n")

  return dataset, num_classes, num_images, class_names, total_stats, total_verify


def get_data(appcfg, subset=None, dbname=None):
  from annon.dataset import Annon

  ## datacfg and dbcfg
  datacfg = get_datacfg(appcfg)
  dbcfg = get_dbcfg(appcfg)
  dataset, num_classes, num_images, class_names, total_stats, total_verify = get_dataset_instance(appcfg, dbcfg, datacfg, subset)

  log.info("class_names: {}".format(class_names))
  log.info("len(class_names): {}".format(len(class_names)))
  log.info("num_classes: {}".format(num_classes))
  log.info("num_images: {}".format(num_images))

  name = dataset.name
  datacfg.name = name
  datacfg.classes = class_names
  datacfg.num_classes = num_classes

  annon = Annon.ANNON(dbcfg, datacfg, subset=subset)

  class_ids = datacfg.class_ids if 'class_ids' in datacfg and datacfg['class_ids'] else []
  class_ids = annon.getCatIds(catIds=class_ids) ## cat_ids
  classinfo = annon.loadCats(class_ids) ## cats
  id_map = {v: i for i, v in enumerate(class_ids)}

  img_ids = sorted(list(annon.imgs.keys()))

  imgs = annon.loadImgs(img_ids)
  anns = [annon.imgToAnns[img_id] for img_id in img_ids]

  log.info("class_ids: {}".format(class_ids))
  log.info("id_map: {}".format(id_map))
  log.info("len(imgs): {}".format(len(imgs)))
  log.info("len(anns): {}".format(len(anns)))

  return class_ids, id_map, imgs, anns


def get_augmentation_imgaug(cmdcfg):
  """
  returns the instance of augmentation using imgaug based on input cmdcfg configuration

  For reference Only:
  
    augmentation_list_items = getattr(getattr(imgaug, 'augmenters'),'Fliplr')
    augmentation = imgaug.augmenters.Sometimes(0.5, [
      imgaug.augmenters.Fliplr(0.5),
      imgaug.augmenters.GaussianBlur(sigma=(0.0, 5.0))
    ])
  """
  augmentation = None
  if 'imgaug' in cmdcfg and cmdcfg['imgaug']:
    import imgaug
    aug_items = []
    for aug_type, aug_val in cmdcfg['imgaug']['augmenters'].items():
      aug_fn = getattr(imgaug.augmenters, aug_type)
      aug_item = aug_fn(aug_val)
      log.debug("aug_item {}".format(aug_item))
      aug_items.append(aug_item)

      ## TODO parameterize sometimes through config
      augmentation = imgaug.augmenters.Sometimes(1, aug_items)
  return augmentation
