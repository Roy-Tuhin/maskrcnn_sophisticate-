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

import logging
log = logging.getLogger('__main__.'+__name__)


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
    abs_path = os.path.join(appcfg['PATHS'][ptype], param['dir'])

  return abs_path


def get_modelinfo_filename(modelinfocfg):
  modelinfo_filename = modelinfocfg['org_name'] + '-' + modelinfocfg['name'] + '-'+ modelinfocfg['timestamp'] + '-' + modelinfocfg['dnnarch'] + '.yml'
  return modelinfo_filename
