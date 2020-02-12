__author__ = 'mangalbhaskar'
__version__ = '3.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).
#
## References
* https://datascience.stackexchange.com/questions/60866/split-tuples-with-labeled-samples-in-training-validation-and-test-sets/60872
* https://cs230-stanford.github.io/train-dev-test-split.html
* https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html
#
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
## Example:
# --------------------------------------------------------

## TODO:
# --------------------------------------------------------

## Future wok:
# --------------------------------------------------------

"""

import os
import sys
import time

# import json

# import numpy as np
# import glob

# import pandas as pd
# import skimage.io
# import requests
# import arrow

# import pymongo
from pymongo import MongoClient

import logging
import logging.config

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

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

log.debug("APP_ROOT_DIR: {}\nROOT_DIR: {}\nBASE_PATH_CFG:{}".format(APP_ROOT_DIR, ROOT_DIR, BASE_PATH_CFG))

from _annoncfg_ import appcfg
from _aidbcfg_ import dbcfg

import common
import annonutils


def save_to_annon_db(cfg, aidsdata):
  """Save to Annotation DB
  """
  DBCFG = cfg['DBCFG']
  ANNONCFG = DBCFG['ANNONCFG']
  mclient = MongoClient('mongodb://'+ANNONCFG['host']+':'+str(ANNONCFG['port']))
  dbname = ANNONCFG['dbname']
  log.info("ANNONCFG['dbname']: {}".format(dbname))
  db = mclient[dbname]

  tblname = annonutils.get_tblname('AIDS')
  annonutils.create_unique_index(db, tblname, 'created_on')
  collection = db.get_collection(tblname)
  collection.update_one(
    {'created_on': aidsdata['created_on']}
    ,{'$setOnInsert': aidsdata}
    ,upsert=True
  )

  mclient.close()


def create_db(cfg, args, datacfg, aids):
  """release the AIDS database i.e. creates the PXL DB (AI Datasets)
  and create respective entries in AIDS table in annon database
  """
  log.info("-----------------------------")

  by = args.by

  splits = datacfg['splits']

  DBCFG = cfg['DBCFG']
  PXLCFG = DBCFG['PXLCFG']
  mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))
  dbname = 'PXL-'+cfg['TIMESTAMP']
  log.info("dbname: {}".format(dbname))
  db = mclient[dbname]

  uuid_aids = None
  if len(aids) > 0:
    uuid_aids = common.createUUID('aids')
    ## Save aids - AI Datasets
    for split in splits:
      for tbl in aids[split]:
        # log.info("aids[{}][{}]".format(split, tbl))
        log.info("split: {}".format(split))
        
        if aids[split][tbl] is not None:
          tblname = annonutils.get_tblname(tbl)
          log.info("tblname: {}".format(tblname))
          log.info("aids[split][tbl]: {}".format(type(aids[split][tbl])))
          if isinstance(aids[split][tbl], dict):
            log.info('dict')
            data = list(aids[split][tbl].values())
            # log.info(aids[split][tbl]['img-19a68326-3468-4b1e-9fc6-5a739523c6f6'])
          elif isinstance(aids[split][tbl], list):
            log.info('list')
            data = aids[split][tbl]


          log.info("tblname, type(data): {}, {}".format(tblname, type(data)))
          for doc in data:
            doc['dbid'] = uuid_aids
            doc['timestamp'] = cfg['TIMESTAMP']
            doc['subset'] = split

            if tblname == 'STATS':
              log.info('doc: {}'.format(doc))
            annonutils.write2db(db, tblname, doc)

    created_on = common.now()
    uuid_rel = common.createUUID('rel')

    datacfg['dbid'] = uuid_aids
    datacfg['dbname'] = dbname
    datacfg['created_on'] = created_on
    datacfg['modified_on'] = None
    datacfg['anndb_id'] = dbname
    datacfg['timestamp'] = cfg['TIMESTAMP']
    datacfg['anndb_rel_id'] = None
    datacfg['rel_id'] = uuid_rel
    datacfg['log_dir'] = dbname
    datacfg['rel_type'] = 'aids'
    datacfg['creator'] = by.upper()

    tblname = annonutils.get_tblname('AIDS')
    annonutils.create_unique_index(db, tblname, 'created_on')
    collection = db.get_collection(tblname)
    collection.update_one(
      {'created_on': datacfg['created_on']}
      ,{'$setOnInsert': datacfg}
      ,upsert=True
    )

    tblname = annonutils.get_tblname('CLASSINFO')
    collection = db.get_collection(tblname)
    annonutils.write2db(db, tblname, datacfg['classinfo'], idx_col='lbl_id')

    save_to_annon_db(cfg, aidsdata=datacfg)

    ## TODO:
    ## generate STATS, STATSLABEL and respective SUMMARY csv files for AIDS
 
  mclient.close()

  return dbname


def create_dataset_hmd(cfg, args, datacfg):
  """Release HD Map Dataset (AI Dataset).
  Execute all the steps from creation to saving AI Dataset from the Annotation Database.
  Every AI Datasets is creates as a new database AIDS_<ddmmyy_hhmmss> ready to be consumed for AI Training without dependency.
  This is further used in the TEPPr (Training, Evaluate, Prediction, Publish with reporting) workflow
  """
  log.info("-----------------------------")

  import dataset.hmd_to_aids as hmd2aids

  tic = time.time()
  cfg['TIMESTAMP'] = common.timestamp()

  # createdb = False
  # ## Check required args
  # if not args.from_path or not args.to_path:
  #   createdb = True
  # log.info("createdb: {}".format(createdb))

  aids, datacfg = hmd2aids.prepare_datasets(cfg, args, datacfg)
  res = create_db(cfg, args, datacfg, aids)
  
  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))

  return res


def create_dataset_coco(cfg, args, datacfg):
  """coco to AI Datasets (AIDS)

  args.from_path should be: "/aimldl-dat/data-public/ms-coco-1/annotations"

  /aimldl-dat/data-public/ms-coco-1/annotations
      ├── all-datasets
      │   ├── 2014
      │   └── 2017
      ├── annotations
      │   ├── captions_train2014.json
      │   ├── captions_train2017.json
      │   ├── captions_val2014.json
      │   ├── captions_val2017.json
      │   ├── coco_viz.py
      │   ├── image_info_test2014.json
      │   ├── instances_minival2014.json
      │   ├── instances_train2014.json
      │   ├── instances_train2017.json
      │   ├── instances_val2014.json
      │   ├── instances_val2017.json
      │   ├── instances_valminusminival2014.json
      │   ├── panoptic_instances_val2017.json
      │   ├── panoptic_train2017.json
      │   ├── panoptic_val2017.json
      │   ├── person_keypoints_train2014.json
      │   ├── person_keypoints_train2017.json
      │   ├── person_keypoints_val2014.json
      │   ├── person_keypoints_val2017.json
      │   ├── stuff_train2017.json
      │   └── stuff_val2017.json
      ├── cocostuff
      │   └── models
      │       └── deeplab
      │           ├── cocostuff
      │           │   ├── config
      │           │   │   ├── deeplabv2_resnet101
      │           │   │   └── deeplabv2_vgg16
      │           │   ├── data
      │           │   ├── features
      │           │   ├── list
      │           │   ├── log
      │           │   └── model
      │           │       └── deeplabv2_vgg16
      │           └── deeplab-v2
      ├── instances_valminusminival2014.json
      ├── panoptic_train2017
      ├── panoptic_val2017
      ├── stuffthingmaps_trainval2017
      │   ├── train2017
      │   └── val2017
      ├── test2014
      ├── tfrecord
      ├── train2014
      ├── train2017
      ├── val2014
      └── val2017
  """
  log.info("-----------------------------")

  import dataset.coco_to_aids as coco2aids

  tic = time.time()

  cfg['TIMESTAMP'] = common.timestamp()
  aids, datacfg = coco2aids.prepare_datasets(cfg, args, datacfg)

  res = create_db(cfg, args, datacfg, aids)
  
  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))

  return res


def tdd(cfg, args, datacfg):
  """test driven development
  * this provides the short-circuit approach to do the development
  * provides all the initial configuration and parameters as to any other function
  * delete the code in this function and write your own to test any function calls
  """
  from tqdm import tqdm
  # annon, images, annotations, classinfo, lbl_ids, img_lbl_arr = annondata.get_annon_data(cfg, datacfg)

  from dataset.Annon import ANNON

  ANNONCFG = cfg['DBCFG']['ANNONCFG']
  annon = ANNON(dbcfg=ANNONCFG, datacfg=datacfg)
  lbl_ids =  annon.getCatIds()
  log.info("-----------------lbl_ids, len(lbl_ids): {}, {}".format(lbl_ids, len(lbl_ids)))

  # images =  annon.getImgIds()
  # log.info("-----------------len(images): {}".format(len(images)))

  images_for_lbl_ids =  annon.getImgIds(catIds=lbl_ids)
  log.info("-----------------len(images_for_lbl_ids): {}".format(len(images_for_lbl_ids)))

  catToImgs = annon.catToImgs
  log.info("catToImgs: {}".format(len(catToImgs)))

  return annon


def verify_aids(cfg, args):
  """verify AI Datasets
  """
  tic = time.time()
  log.info("\nverify_aids:-----------------------------")
  
  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))

  return


def main(cfg, args, datacfg):

  ## override the default configuration with the user inputs
  log.debug("Before: cfg['AIDS_FILTER']['LABELS']: {}".format(cfg['AIDS_FILTER']['LABELS']))
  if args.include_labels and len(args.include_labels) > 0:
    cfg['AIDS_FILTER']['ENABLE'] = True
    cfg['AIDS_FILTER']['LABELS'] = args.include_labels

  log.debug("After: cfg['AIDS_FILTER']['LABELS']: {}".format(cfg['AIDS_FILTER']['LABELS']))

  if args.command == 'create':
    fn = None
    if args.did:
      fname = 'create_dataset_'+args.did
      fn = getattr(this, fname)
    if fn:
      log.info("-------")
      res = fn(cfg, args, datacfg)
      log.info("AIDS(AI Dataset): {}".format(res))
      log.info("-------")
    else:
      raise Exception("Invalid dataset id (--did)")
  elif args.command == 'tdd':
    tdd(cfg, args, datacfg)


def parse_args(commands):
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Annotation parser for VGG Via tool files'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--by'
    ,dest='by'
    ,help='AI Engineer ID'
    ,required=True)

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/annotation/<directory_OR_annotation_json_file> - deprecated'
    ,required=False)

  parser.add_argument('--to'
    ,dest='to_path'
    ,help='/path/to/anndb_root_OR_aids_root'
    ,required=False)

  parser.add_argument('--did'
    ,dest='did'
    ,help='public or private dataset id. Options: hmd, coco, mvd, bdd, idd, adek.\n Only hmd, coco is supprted for now'
    ,required=False)

  parser.add_argument('--labels'
    ,dest='include_labels'
    ,help='provide labels to be used for creating the ai dataset'
    ,required=False)

  parser.add_argument('--task'
    ,dest='task'
    ,help='task name'
    ,required=False)

  parser.add_argument('--subset'
    ,dest='subset'
    ,help='name of the subset. Options: train, val'
    ,required=False)

  parser.add_argument('--year'
    ,dest='year'
    ,help='year of publication of the dataset'
    ,required=False)

  args = parser.parse_args()
  
  # Validate arguments
  cmd = args.command

  cmd_supported = False
  for c in commands:
    if cmd == c:
      cmd_supported = True

  if not cmd_supported:
    log.info("'{}' is not recognized.\n"
          "Use any one: {}".format(cmd,', '.join(commands)))
    sys.exit(-1)


  if cmd == "create":
    assert args.did,\
           "Provide --did"

  if args.did == "coco":
    if not args.from_path:
      raise Exception("--{} not defined".format('from'))
    if not args.task:
      raise Exception("--{} not defined".format('task'))
    if not args.year:
      raise Exception("--{} not defined".format('year'))
    from_path = args.from_path
    if not os.path.exists(from_path) and os.path.isfile(from_path):
        raise Exception('--from needs to be directory path')

  if args.include_labels:
    ## https://www.tutorialspoint.com/How-to-remove-all-special-characters-punctuation-and-spaces-from-a-string-in-Python
    import re
    s = args.include_labels
    s = re.sub('[^A-Za-z0-9_,]+', '', s)
    if s:
      args.include_labels = s.split(',')
      log.info("len(args.include_labels), args.include_labels: {}, {}".format(len(args.include_labels), args.include_labels))
    else:
      log.info("Un-usual labels, hence skipping these labels!")


  return args


if __name__ == '__main__':
  """
  Usage Examples:

  python db_to_aids.py create --by AIE3 --did coco --from /aimldl-dat/data-public/ms-coco-1/annotations --task instances --year 2014
  """
  commands = ['create', 'verify', 'tdd']
  args = parse_args(commands)

  main(appcfg, args, dbcfg)
