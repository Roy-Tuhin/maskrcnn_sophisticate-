#!/usr/bin/env python

# #--------------------------------------------------------
# # Written by Mangal
# #--------------------------------------------------------

"""Custom Application config system.

This file specifies default config options.
"""

import os.path as osp
import sys
# `pip install easydict` if you don't have it
from easydict import EasyDict as edict

import pixel._load_cfg_ as _load_cfg_

__C = edict()
# # Consumers can get config by:
# # from _init_ import appcfg
appcfg = __C

__C.CFG = edict(_load_cfg_.cfg)
__C.DNNCFG = edict(_load_cfg_.dnncfg)

# #---------------------------------
# # DNN Specific configuration
# #---------------------------------

__C.APP_NAME = __C.DNNCFG.DEFAULTS.APP_NAME
__C.ORG_NAME = __C.DNNCFG.DEFAULTS.ORG_NAME
__C.ID = __C.DNNCFG.DEFAULTS.ID
__C.REL_NUM = __C.DNNCFG.DEFAULTS.REL_NUM
__C.MODE = __C.DNNCFG.DEFAULTS.MODE
__C.GPU_ID = __C.DNNCFG.DEFAULTS.GPU_ID
__C.DNNARCH = __C.DNNCFG.DEFAULTS.DNNARCH
__C.FRAMEWORK_TYPE = __C.DNNCFG.DEFAULTS.FRAMEWORK_TYPE
__C.WARMUP = __C.DNNCFG.DEFAULTS.WARMUP
__C.ALLOWED_IMAGE_TYPE = set(__C.DNNCFG.DEFAULTS.ALLOWED_IMAGE_TYPE)
__C.ALLOWED_FILE_TYPE = set(__C.DNNCFG.DEFAULTS.ALLOWED_FILE_TYPE)
__C.DNNARCH_AVAILABLE = set(__C.DNNCFG.DEFAULTS.DNNARCH_AVAILABLE)
# __C.CONF_THRESH = __C.DNNCFG.DEFAULTS.CONF_THRESH
# __C.NMS_THRESH = __C.DNNCFG.DEFAULTS.NMS_THRESH
__C.FILE_DELIMITER = __C.DNNCFG.DEFAULTS.FILE_DELIMITER
__C.SAVE_NULL_RESULTS = __C.DNNCFG.DEFAULTS.SAVE_NULL_RESULTS
__C.VIS_DETECTIONS = __C.DNNCFG.DEFAULTS.VIS_DETECTIONS
__C.API_VISION_BASE_URL = __C.DNNCFG.DEFAULTS.API_VISION_BASE_URL

__C.LOG_TIMESTAMP = __C.DNNCFG.DEFAULTS.LOG_TIMESTAMP
__C.HOST = __C.DNNCFG.DEFAULTS.HOST
__C.DEBUG = __C.DNNCFG.DEFAULTS.DEBUG

__C.APIS = __C.DNNCFG.APIS

__C.ARCHS = __C.DNNCFG.ARCHS
__C.NETS = __C.DNNCFG.NETS
__C.REPORTS = __C.DNNCFG.REPORTS


# #---------------------------------
# # Path Specific Configurations
# #---------------------------------

__C.APP_PATHS = __C.CFG['APP_PATHS']
__C.AI_HOME = __C.APP_PATHS['AI_HOME']
__C.AI_SCRIPTS = __C.APP_PATHS['AI_SCRIPTS']
__C.AI_REPORTS = __C.APP_PATHS['AI_REPORTS']

__C.AI_WEB_APP = __C.APP_PATHS['AI_WEB_APP']
__C.DNN_MODEL_PATH = __C.APP_PATHS['DNN_MODEL_PATH']

## deprecated
# __C.MMI_MODEL_PATH = __C.APP_PATHS['MMI_MODEL_PATH']
# __C.MMI_MODEL_DEF_PATH = __C.APP_PATHS['MMI_MODEL_DEF_PATH']

__C.FRCN_ROOT = __C.APP_PATHS['FRCN_ROOT']
__C.CAFFE_ROOT = __C.APP_PATHS['CAFFE_ROOT']
__C.MRCNN_ROOT = __C.APP_PATHS['MRCNN_ROOT']

__C.MMI_IMG_PATH = __C.APP_PATHS['MMI_IMG_PATH']
__C.GAZE_IMG_PATH = __C.APP_PATHS['GAZE_IMG_PATH']

__C.AI_WEB_APP_LOGS = __C.APP_PATHS['AI_WEB_APP_LOGS']
__C.AI_WEB_APP_UPLOADS = __C.APP_PATHS['AI_WEB_APP_UPLOADS']

__C.LOG_FOLDER = osp.join(__C.AI_WEB_APP_LOGS, __C.APP_NAME)
__C.UPLOAD_FOLDER = osp.join(__C.AI_WEB_APP_UPLOADS, __C.APP_NAME)

__C.PATH = ''
__C.OUT = ''
__C.OUT_FILE = ''

__C.CMD = ''

def add_path(path):
  if path not in sys.path:
    sys.path.insert(0, path)

# # Add caffe to PYTHONPATH
caffe_path = osp.join(__C.CAFFE_ROOT, 'python')
add_path(caffe_path)

# # Add lib to PYTHONPATH
lib_path = osp.join(__C.FRCN_ROOT, 'lib')
add_path(lib_path)

# # Add to PYTHONPATH
lib_path = __C.MRCNN_ROOT
add_path(lib_path)
