# coding: utf-8

"""
References:
# /codehub/external/tensorflow/models/research/object_detection/dataset_tools/create_via_tf_record.py
# /codehub/external/lanenet-lane-detection/data_provider/lanenet_data_feed_pipline.py

# http://warmspringwinds.github.io/tensorflow/tf-slim/2016/12/21/tfrecords-guide/
# https://github.com/sulc/tfrecord-viewer
"""

import os
import sys
import time
import datetime
import json

from importlib import import_module

import yaml
from easydict import EasyDict as edict

import logging
import logging.config

import contextlib2


this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
ROOT_DIR = os.getenv('AI_HOME')
BASE_PATH_CFG = os.getenv('AI_CFG')
BASE_PATH_CONFIG = os.getenv('AI_CONFIG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

this = sys.modules[__name__]

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

import _cfg_
import common
import apputil


class TFRConfig:
  def __init__(self, args, appcfg, subset, timestamp=None):
    self.subset = subset

    ## TODO: labelmap_filename from the user input
    self.labelmap_filename = 'labelmap'
    self.ai_tf_od_api_path = args.ai_tf_od_api_path
    self.appcfg = appcfg
    self.name = args.did
    self.dbname = args.dataset
    self.num_shards = int(args.num_shards)
    self.output_basepath = args.output_basepath
    self.include_masks = args.include_masks

    self.output_dir = self.dbname
    if self.name:
      self.output_dir = self.name+"-"+self.dbname

    if timestamp:
      self.timestamp = timestamp

    self.output_basepath = os.path.join(self.output_basepath, self.output_dir, self.timestamp)
    self.output_path = os.path.join(self.output_basepath, self.subset)
    log.info("output_basepath: {}".format(self.output_basepath))
    log.info("output_path: {}".format(self.output_path))

    self.init()


  def init(self):
    common.mkdir_p(self.output_basepath)


  def get_image_path(self, img):
    image_path = apputil.get_abs_path(self.appcfg, img, 'AI_ANNON_DATA_HOME_LOCAL')
    log.debug("image_path: {}".format(image_path))
    return image_path

##-------

def get_dataset_name(name, subset):
    return name + "_" + subset


def get_appcfg(ai_annon_data_home_local=None, host=None, base_path_config=None, cmd=None, subset=None, dbname=None, exp_id=None):
  """
  load the appcfg and overrides default values to the custom inputs
  """
  if not base_path_config:
    base_path_config = BASE_PATH_CONFIG

  appcfg = _cfg_.load_appcfg(base_path_config)
  appcfg = edict(appcfg)
  if host:
    appcfg['APP']['DBCFG']['PXLCFG']['host'] = host

  if ai_annon_data_home_local:
    appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'] = ai_annon_data_home_local

  _cfg_.load_datacfg(cmd, appcfg, dbname, exp_id, subset)

  # log.info("datacfg: {}".format(datacfg))
  # log.info("dbcfg: {}".format(dbcfg))

  # _cfg_.load_archcfg(cmd, appcfg, dbname, exp_id, subset)

  # log.debug(appcfg)
  # log.info(appcfg['APP']['DBCFG']['PXLCFG'])
  log.info(appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'])

  return appcfg


def create_tfl(class_ids, tfrconfig):
  """
  create tfrecord label
  Ref: https://github.com/tensorflow/models/issues/1601#issuecomment-533659942

  If error: ModuleNotFoundError: No module named 'object_detection'

  Excecute on shell prompt:
  ```bash
  cd /codehub/external/tensorflow/models/research
  protoc object_detection/protos/*.proto --python_out=.
  ```

  NOTE:
  * tensorflow object_detection module should be in the PYTHONPATH
  """
  ai_tf_od_api_path = tfrconfig.ai_tf_od_api_path
  log.debug("ai_tf_od_api_path: {}".format(ai_tf_od_api_path))
  if ai_tf_od_api_path not in sys.path:
    sys.path.append(ai_tf_od_api_path)
  log.debug("sys.path: {}".format(sys.path))

  import tflabel

  ## labelmaps should be same irrespective of the subset
  labelmap_filepath = os.path.join(tfrconfig.output_basepath, tfrconfig.subset+'-'+tfrconfig.labelmap_filename)
  # labelmap_filepath = os.path.join(tfrconfig.output_basepath, tfrconfig.labelmap_filename)
  tflabel.main(class_ids, labelmap_filepath)


def create_tfr(args, appcfg, subset, timestamp=None):
  """
  create tf record data compatible with object detection API of tensorflow and for tensorflow training in general
  """
  import tfrecord

  dbname = args.dataset

  tfrconfig = TFRConfig(args, appcfg, subset, timestamp)
  class_ids = None

  # dataset_name = get_dataset_name(name, subset)
  class_ids, id_map, imgs, anns = apputil.get_data(appcfg, subset=subset, dbname=dbname)
  log.info("class_ids, id_map: {}, {}".format(class_ids, id_map))

  tfrecord.main(imgs, anns, id_map, tfrconfig)

  create_tfl(class_ids, tfrconfig)

  return class_ids, id_map, imgs, anns


def create_tfr_dataset(args, subset, ai_annon_data_home_local, timestamp=None):
  """
  create tensorflow record
  """
  exp_id = args.exp_id
  name = args.did
  dbname = args.dataset
  host = args.host

  appcfg = get_appcfg(ai_annon_data_home_local=ai_annon_data_home_local, host=host, cmd=None, subset=subset, dbname=dbname, exp_id=exp_id)
  # log.info(appcfg)
  create_tfr(args, appcfg, subset, timestamp)


def main(args):
  try:
    log.info("----------------------------->\nargs:{}".format(args))
    image_basepath = args.image_basepath
    out_path = args.out_path
    if not out_path:
      out_path = common.timestamp()
    log.info("out_path: {}".format(out_path))
    for i, subset in enumerate(args.subset):
      ai_annon_data_home_local = image_basepath[i]
      create_tfr_dataset(args, subset=subset, ai_annon_data_home_local=ai_annon_data_home_local, timestamp=out_path)
  except Exception as e:
    log.error("Exception occurred", exc_info=True)
  return


def get_ai_annon_data_home_local():
  ai_annon_data_home_local = os.getenv('AI_ANNON_DATA_HOME_LOCAL')
  ai_annon_data_home_local if ai_annon_data_home_local else '/aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns'
  return ai_annon_data_home_local


def parse_args():
  import argparse
  from argparse import RawTextHelpFormatter
  
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='AI Dataset to tensorflow TF Record converter.\n\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument('--dataset'
    ,dest='dataset'
    ,metavar="/path/to/<name>.yml or AIDS (AI Dataset) database name"
    ,help='Path to AIDS (AI Dataset) yml or AIDS ID/DatabaseName available in database'
    ,required=True)

  parser.add_argument('--host'
    ,dest='host'
    ,help='Database host'
    ,required=False
    ,default='localhost')

  parser.add_argument('--image_basepath'
    ,dest='image_basepath'
    ,help='image basepath and for multiple subset use paths with comma separated. \n Environment variable: AI_ANNON_DATA_HOME_LOCAL is used as default value.'
    ,required=False
    ,default=get_ai_annon_data_home_local())

  parser.add_argument('--subset'
    ,dest='subset'
    ,metavar="[train | val | test | 'train,val' | 'train,val,test']"
    ,help='name of the subset or multiple subset using comma separated values.'
    ,required=False
    ,default='train,val')

  parser.add_argument('--did'
    ,dest='did'
    ,help='public or private dataset id. Options: hmd, coco, mvd, bdd, idd, adek.\n Only hmd, coco is supported for now'
    ,required=False
    ,default='hmd')

  parser.add_argument('--exp'
    ,dest='exp_id'
    ,metavar="/path/to/<name>.yml or Experiment Id in AIDS for the TEPPr"
    ,help='Arch specific yml file or Experiment Id for the given AI Dataset for the TEPPr'
    ,required=False
    ,default=None)

  parser.add_argument('--shards'
    ,dest='num_shards'
    ,help='number of shards'
    ,required=False
    ,default=100)

  ## os.getenv('AI_TFR')
  parser.add_argument('--to'
    ,dest='output_basepath'
    ,help='output_basepath'
    ,required=False
    ,default='/aimldl-dat/tfrecords')

  parser.add_argument('--out'
    ,dest='out_path'
    ,help='to override the timestamp director and to reuse previous dir'
    ,required=False)

  parser.add_argument('--tfods'
    ,dest='ai_tf_od_api_path'
    ,help='tensorflow object detection api module base path'
    ,required=False
    ,default=os.getenv('AI_TF_OD_API_PATH'))

  parser.add_argument('--mask'
    ,dest='include_masks'
    ,help='include_masks'
    ,action='store_true')

  args = parser.parse_args()    

  args.subset = common.str2list(args.subset)
  args.image_basepath = common.str2list(args.image_basepath)

  if len(args.image_basepath) != len(args.subset):
    args.image_basepath = args.image_basepath*len(args.subset)

  assert len(args.image_basepath) == len(args.subset)

  return args


if __name__ == '__main__':
  """
  # host = '10.4.71.69'
  # image_basepath = '/aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns'

  Example:
  python aids_to_tf_record.py --dataset PXL-270220_175734 --image_basepath /aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns --shards 5 --subset 'train,val'
  python aids_to_tf_record.py --dataset PXL-270220_175734 --image_basepath /aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns --shards 5 --subset 'train,val,test'

  ## for annon coco dataset
  python aids_to_tf_record.py --dataset PXL-130220_034525 --image_basepath '/aimldl-dat/data-public/ms-coco-1/train2014,/aimldl-dat/data-public/ms-coco-1/val2014' --subset 'train,val'

  # name = "hmd"
  # subset = "train"

  # dbname = "PXL-291119_180404"
  # exp_id = "train-422d30b0-f518-4203-9c4d-b36bd8796c62"

  # dbname = "PXL-270220_175734"
  # exp_id = None

  ## Verify by visualizing tfrecords
  https://github.com/sulc/tfrecord-viewer.git
  python tfviewer.py /aimldl-dat/data-public/ms-coco-1/tfrecord/coco_train.record-00063-of-00100
  """
  args = parse_args()
  log.info("args: {}".format(args))
  main(args)

