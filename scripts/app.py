__author__ = 'mangalbhaskar'
__version__ = '2.0'
'''
# Generate Application Configurations and settings.
# NOTE: This should not generate any absolute paths in the configuration!
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
'''

import yaml
import os
import os.path as osp

BASEPATH = osp.dirname(osp.abspath(__file__))

## TODO: separate app.yml for production and development

from api_doc import API_DOC
from dbcfg import DBCFG

cfg = {
  'SAVE_NULL_RESULTS':False
  ,'SAVE_NULL_RESULTS': False
  ,'VIS_DETECTIONS': False
  ,'API_VISION_BASE_URL': '/api/vision'
  ,'API_VISION_URL': None
  ,'API_VERSION': 'v2'
  # ,'API_DEFAULT_MODEL_KEY': 'matterport-coco_things-1'
  ,'API_DEFAULT_MODEL_KEY': 'vidteq-hmd-1'
  ,'API_MODELINFO_TABEL': 'MODELINFO'
  ,'LOG_TIMESTAMP': False
  ,'HOST': ['10.4.71.69:4040']
  ,'DOCS': ''
  ,'MODE':'gpu' #['gpu','cpu']
  ,'GPU_ID':0
  ,'DEVICE': '/gpu:0'
  ## IDS:{'id':'problem_id'}
  ,'IDS': {
    'bsg': 'ballon_segmentation'
    ,'cocot': 'coco_things'
    ,'cocos': 'coco_stuff'
    ,'cocop': 'coco_panoptic'
    ,'hmd': 'hd_map_dataset'
    ,'od': 'object_detection'
    ,'ods': 'object_detection_segmentation'
    ,'pd': 'people_detection'
    ,'road': 'road_segmentation'
    ,'tsd': 'traffic_sign_detection'
    ,'tsr': 'traffic_sign_recognition'
    ,'spd': 'sign_post_detection'
    ,'spr': 'sign_post_recognition'
    ,'rld': 'road_lane_detection'
    ,'rbd': 'road_boundary_detection'
    ,'rlbd': 'road_lane_boundary_detection'
    ,'tlr': 'traffic_light_recognition'
  }
  ## TODO: use the ROUTER instead of APP_NAME
  ,'APP_NAME': 'falcon'
  ,'ROUTER': 'falcon'
  ,'DEBUG': False
  ,'WARMUP': False
  ,'TRAIN_MODE': 'training'
  ,'TEST_MODE': 'inference'
  ,'ALLOWED_FILE_TYPE':['.txt','.csv','.yml','.json']
  ,'ALLOWED_IMAGE_TYPE':['.pdf','.png','.jpg','.jpeg','.tiff','.gif']
  ,'ALLOWED_VIDEO_TYPE':['.mp4']
  ,'FILE_DELIMITER':';'
  ,'ARCH': 'arch'
  ,'DATASET': 'dataset'
  ,'CMD': ['train', 'predict', 'evaluate']
  ,'ARCHS':[
    'mask_rcnn'
    ,'lanenet'
  ]
  ,'ORGNAME':[
    'matterport'
    ,'vidteq'
    ,'mmi'
  ]
}

cfg['TABLES'] = {
  'AIDS':[None]
  ,'MODELINFO':[None]
  ,'RELEASE ':[None]
}

API_DOC['API_VISION_BASE_URL'] = cfg['API_VISION_BASE_URL']
API_DOC['API_VERSION'] = cfg['API_VERSION']
API_DOC['IDS'] = cfg['IDS']
API_DOC['ARCHS'] = cfg['ARCHS']
API_DOC['ORGNAME'] = cfg['ORGNAME']

cfg['API_VISION_URL'] = os.path.join(cfg['API_VISION_BASE_URL'], cfg['API_VERSION'])
cfg['API_DOC'] = API_DOC

cfg['DBCFG'] = DBCFG


def override_cfg():
  """override default configuration based on appcfg.
  all keys of dictionary objects should be overriden.
  
  Ref: https://stackoverflow.com/questions/21885814/how-to-iterate-through-a-modules-functions
  """
  import appcfg

  # customcfg = [name for name, val in appcfg.__dict__.iteritems()]
  customcfg = [name for name, val in appcfg.__dict__.items()]
  # print("customcfg: {}".format(customcfg))
  for cfg_item in customcfg:
    if cfg_item in cfg:
      val = getattr(appcfg, cfg_item)
      # print("cfg_item:val: {} = {}".format(cfg_item, val))
      cfg[cfg_item] = val


def yaml_safe_dump(filepath, o):
  """Create yaml file from python dictionary object
  """
  with open(filepath,'w') as f:
    yaml.safe_dump(o, f, default_flow_style=False)


def load_yaml(filepath):
  """Sale load YAML file (does not provide edit object)
  """
  fc = None
  with open(filepath, 'r') as f:
    # fc = edict(yaml.load(f))
    # fc = edict(yaml.safe_load(f))
    fc = yaml.safe_load(f)

  return fc


if __name__ == '__main__':
  paths_file = 'app.yml'

  override_cfg()

  yaml_safe_dump(osp.join(osp.dirname(__file__),'config',paths_file+'.example'), cfg)
  yaml_safe_dump(osp.join(osp.dirname(__file__),'..','config',paths_file), cfg)
