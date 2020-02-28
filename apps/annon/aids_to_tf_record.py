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

import tfrecord


class TFRConfig:
  def __init__(self, args, appcfg):
    self.appcfg = appcfg
    self.name = args.did
    self.subset = args.subset
    self.dbname = args.dataset
    self.num_shards = int(args.num_shards)
    self.output_basepath = args.output_basepath
    self.include_masks = args.include_masks

    self.output_dir = self.dbname
    if self.name:
      self.output_dir = self.name+"-"+self.dbname

    self.timestamp = common.timestamp()

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


def create_tfr(args, appcfg):
  """
  create tf record data compatible with object detection API of tensorflow and for tensorflow training in general
  """
  subset = args.subset
  dbname = args.dataset

  tfrconfig = TFRConfig(args, appcfg)

  # dataset_name = get_dataset_name(name, subset)
  class_ids, id_map, imgs, anns = apputil.get_data(appcfg, subset=subset, dbname=dbname)
  log.info("class_ids, id_map: {}, {}".format(class_ids, id_map))

  tfrecord.main(imgs, anns, id_map, tfrconfig)

  return class_ids, id_map, imgs, anns


def main(args):
  """TODO: JSON RESPONSE
  All errors and json response needs to be JSON compliant and with proper HTTP Response code
  A common function should take responsibility to convert into API response
  """
  try:
    log.info("----------------------------->\nargs:{}".format(args))

    exp_id = args.exp_id
    name = args.did
    subset = args.subset
    dbname = args.dataset
    host = args.host
    ai_annon_data_home_local = args.ai_annon_data_home_local

    appcfg = get_appcfg(ai_annon_data_home_local=ai_annon_data_home_local, host=host, cmd=None, subset=subset, dbname=dbname, exp_id=exp_id)

    cmd = 'create'+'_'+'tfr'

    fn = getattr(this, cmd)

    log.debug("fn: {}".format(fn))
    log.debug("cmd: {}".format(cmd))
    log.debug("---x---x---x---")
    if fn:
      fn(args, appcfg)
    else:
      log.error("Unknown fn:{}".format(cmd))
  except Exception as e:
    log.error("Exception occurred", exc_info=True)

  return


def parse_args():
  import argparse
  from argparse import RawTextHelpFormatter
  
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='Annon data loader\n * and converter.\n\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument('--dataset'
    ,dest='dataset'
    ,metavar="/path/to/<name>.yml or AIDS (AI Dataset) database name"
    ,required=True
    ,help='Path to AIDS (AI Dataset) yml or AIDS ID/DatabaseName available in database`')

  parser.add_argument('--host'
    ,dest='host'
    ,required=False
    ,default='localhost'
    ,help='Database host')

  parser.add_argument('--ai_annon_data_home_local'
    ,dest='ai_annon_data_home_local'
    ,required=False
    ,default='/aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns'
    ,help='overrides AI_ANNON_DATA_HOME_LOCAL')

  parser.add_argument('--subset'
    ,dest='subset'
    ,metavar="[train | val | test]"
    ,help='name of the subset. Options: train, val'
    ,default='train'
    ,required=False)

  parser.add_argument('--did'
    ,dest='did'
    ,help='public or private dataset id. Options: hmd, coco, mvd, bdd, idd, adek.\n Only hmd, coco is supprted for now'
    ,default='hmd'
    ,required=False)

  parser.add_argument('--exp'
    ,dest='exp_id'
    ,metavar="/path/to/<name>.yml or Experiment Id in AIDS for the TEPPr"
    ,required=False
    ,default=None
    ,help='Arch specific yml file or Experiment Id for the given AI Dataset for the TEPPr')

  parser.add_argument('--shards'
    ,dest='num_shards'
    ,help='number of shards'
    ,default=100
    ,required=False)

  parser.add_argument('--to'
    ,dest='output_basepath'
    ,help='output_basepath'
    ,default='/aimldl-dat/tfrecords'
    ,required=False)

  parser.add_argument('--mask'
    ,dest='include_masks'
    ,help='include_masks'
    ,action='store_true')

  args = parser.parse_args()    

  return args


if __name__ == '__main__':
  """
  # host = '10.4.71.69'
  # ai_annon_data_home_local = '/aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns'

  Example:
  python aids_to_tf_record.py --dataset PXL-270220_175734
  python aids_to_tf_record.py --dataset PXL-130220_034525 --ai_annon_data_home_local /aimldl-dat/data-public/ms-coco-1/train2014
  python aids_to_tf_record.py --dataset PXL-130220_151926 --ai_annon_data_home_local /aimldl-dat/data-public/ms-coco-1/train2014
  python aids_to_tf_record.py --dataset PXL-130220_034525
  python aids_to_tf_record.py --dataset PXL-270220_175734 --ai_annon_data_home_local /aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns

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
  log.debug("args: {}".format(args))
  main(args)

