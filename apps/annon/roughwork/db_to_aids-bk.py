__author__ = 'mangalbhaskar'
__version__ = '2.0'
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
import datetime
import json

import numpy as np
import glob

import pandas as pd
import skimage.io
import requests
import arrow

import pymongo
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

import datasplit
from dataset.Annon import ANNON


def create_db_data(images_splits, annon, splits, datacfg):
  """create aids - AI Datasets using image splits
  HINTS:
  - when iterating over images for type of split to create respective annotation, labels and classinfo
    it does not have the knowledge of filtered labels and hence it would take all the annotations and labels into consideration
  - Images does not have direct knowledge of labels, but only of the annotations
  - Ways to handle filtered labels here are:
    a) images data structure should already contains filtered annotations only
    b) filter criteria should be available
    - option a) seems better as its simple and no-brainer option b) becomes complex in testing
  """
  log.info("-----------------------------")
  
  ## Create AIDS - AI Datasets
  aids = {}
  total_images = 0
  total_annotations = 0
  total_labels = 0
  
  total_stats = {
    'total_images':0
    ,'total_annotations':0
    ,'total_labels':0
  }
  stats = {}

  ##TODO: mask area and bbox area stats
  ## keep bbox area attribute parallel to maskarea

  unique_labels = set()
  for i, fnn in enumerate(images_splits):
    log.info("\nTotal Images in: {},{},{}".format(splits[i], len(fnn), type(fnn)))
    total_images += len(fnn)

    if splits[i] not in aids:
      aids[splits[i]] = {
        'IMAGES':list(fnn)
        ,'ANNOTATIONS':{}
        # ,'LABELS':{}
        # ,'CLASSINFO':{}
        ,'CLASSINFO_SPLIT':{}
        ,'STATS':{}
      }
    
    if splits[i] not in datacfg:
      datacfg['files'][splits[i]] = {}

    if splits[i] not in stats:
      stats[splits[i]] = {
        'labels':''
        ,'total_annotations':0
        ,'classinfo':''
        ,"labels": []
        ,"annotation_per_img": []
        ,"label_per_img": []
        ,"total_unique_images": set()
        ,"total_images": 0
        ,"maskarea": []
        ,"bboxarea": []
        ,"colors": None
      }

    ## create ANNOTATIONS and LABELS
    annotations = {}
    labels = {}
    for av in fnn:
      ##
      total_annotations += len(av['annotations'])

      stats[splits[i]]['total_images'] += 1
      stats[splits[i]]['total_annotations'] += len(av['annotations'])
      stats[splits[i]]['annotation_per_img'].append(len(av['lbl_ids']))
      stats[splits[i]]['label_per_img'].append(len(set(av['lbl_ids'])))
      stats[splits[i]]['total_unique_images'].add(av['filename'])

      ## create unique LABELS
      for ant in av['annotations']:
        ant_id = ant.split(os.path.sep)[-1]
        annotations[ant_id] = annon[ant_id]

        ## TODO: error handling
        ## create LABELS
        if 'lbl_id' not in annon[ant_id]:
          log.info("annon: {}".format(annon))
        
        lbl_id = annon[ant_id]['lbl_id']
        # log.info("lbl_id: {}".format(lbl_id))
        if  lbl_id not in labels:
          labels[lbl_id] = {
            "lbl_id": lbl_id
            ,"image_per_label":set()
            ,"annotation_per_label":0
            ,"maskarea":[]
            ,"bboxarea":[]
          }

        unique_labels.add(lbl_id)
        labels[lbl_id]['annotation_per_label'] += 1
        labels[lbl_id]['image_per_label'].add(annon[ant_id]['image_name'])

        if 'maskarea' in annon[ant_id]:
          stats[splits[i]]['maskarea'].append(annon[ant_id]['maskarea'])
          labels[lbl_id]['maskarea'].append(annon[ant_id]['maskarea'])
        if 'bboxarea' in annon[ant_id]:
          stats[splits[i]]['bboxarea'].append(annon[ant_id]['bboxarea'])
          labels[lbl_id]['bboxarea'].append(annon[ant_id]['bboxarea'])

    for lbl_id in labels:
      labels[lbl_id]['image_per_label'] = len(labels[lbl_id]['image_per_label'])

    aids[splits[i]]['ANNOTATIONS'] = annotations
    # aids[splits[i]]['LABELS'] = labels
    colors = common.random_colors(len(labels))
    # classinfo = annonutils.get_class_info(labels, colors=colors, index=True)
    classinfo = annonutils.get_class_info(labels, colors=colors, index=False)
    aids[splits[i]]['CLASSINFO_SPLIT'] = classinfo

    stats[splits[i]]['total_labels'] = len(labels)
    stats[splits[i]]['labels'] = labels
    stats[splits[i]]['colors'] = colors
    stats[splits[i]]['classinfo'] = classinfo
    stats[splits[i]]['total_unique_images'] = len(stats[splits[i]]['total_unique_images'])


    aids[splits[i]]['STATS'] = [stats[splits[i]]]

    unique_labels_list = list(unique_labels)
    log.info("list(unique_labels_list): {}".format(unique_labels_list))
    unique_labels_list.sort()
    if unique_labels_list and len(unique_labels_list) > 0:
      datacfg['classes'] = unique_labels_list

      unique_classinfo_list = annonutils.get_class_info(unique_labels_list,
        colors=common.random_colors(len(unique_labels_list)), index=False)
      datacfg['classinfo'] = unique_classinfo_list

    total_labels = datacfg['num_classes'] = len(unique_labels_list)
    log.info("datacfg['classes'], datacfg['num_classes']: {}, {}".format(datacfg['classes'], datacfg['num_classes']))
    log.info("datacfg['classinfo'], len(datacfg['classinfo']): {}, {}".format(datacfg['classinfo'], len(datacfg['classinfo'])))

  total_stats['total_images'] = total_images
  total_stats['total_annotations'] = total_annotations
  total_stats['total_labels'] = total_labels
  # log.info("aids: {}".format(aids))
  # log.info("datacfg: {}".format(datacfg))

  datacfg['stats'] = stats
  datacfg['summary'] = total_stats


  return aids, datacfg


def prepare_aids(cfg, images, annon, lbl_ids, datacfg):
  """Create AI Datasets and returns the actual data to be further processed and to persists on file-system or DB
  """
  aids_splits_criteria = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]

  images_splits, splited_indices, splited_indices_per_label = datasplit.do_data_split(images, lbl_ids, cfg)

  log.info("len(images_splits): {}".format(len(images_splits)))
  for split in images_splits:
    log.info("len(split): {}".format(len(split)))

  ## Create AIDS - AI Datasets
  splits = aids_splits_criteria[0] ## directory names

  aids, datacfg = create_db_data(images_splits, annon, splits, datacfg)
  log.info("aids: {}".format(len(aids)))
  datacfg['splits'] = splits

  return aids, datacfg


def aids_filter(cfg, images, filter_by):
  """filter images based on the specific filter_by

  TODO:
  * annotation filtering based on stats on total images, total annotations, area (mask, bbox)
  """
  log.info("\naids_filter:-----------------------------")
  log.info("len(list(images.keys())): {}".format(len(images)))

  total_ant = 0
  total_ant_before_filter = 0
  total_ant_filtered = 0

  if filter_by and len(filter_by)>0:
    filter_by = np.array(filter_by)
    for i, v in enumerate(images):
      total_ant_before_filter += len(v['annotations'])
      annotations = np.array(v['annotations'])
      lbl_ids = np.array(v['lbl_ids'])
      v['lbl_ids'] = list(lbl_ids[np.where(np.in1d(lbl_ids,filter_by))])
      v['annotations'] = list(annotations[np.where(np.in1d(lbl_ids,filter_by))])
      total_ant += len(annotations)

  total_ant_filtered = total_ant_before_filter - total_ant
  log.info('--------------------------------------')
  log.info("total_ant, total_ant_filtered: {}, {}".format(total_ant, total_ant_filtered))
  
  return images


def get_annon_data(cfg):
    datacfg = cfg['DBCFG']

    hmd = ANNON(cfg, datacfg)


def get_annon_data_bk(cfg):
  """
  return actual data hash of all images, all allotations (annon), release info and classinfo (categories/labels)
  """
  query_images = {}
  query_annotations = {}
  query_classinfo = {}

  filter_enable = cfg['AIDS_FILTER']['ENABLE']
  if filter_enable:
    # filter_by = cfg['AIDS_FILTER']['LABELS']
    filter_by = cfg['AIDS_FILTER'][ cfg['AIDS_FILTER']['BY'] ]

  DBCFG = cfg['DBCFG']
  mclient = MongoClient('mongodb://'+DBCFG['HOST']+':'+str(DBCFG['PORT']))
  db = mclient[DBCFG['DBNAME']]

  ## get IMAGES data
  tblname = annonutils.get_tblname('IMAGES')
  collection = db.get_collection(tblname)
  images = np.array(list(collection.find(query_images, {'_id':False})))
  log.info("len(images): {}".format(len(images)))
  # images = {item['img_id']:item for item in images}

  ## get ANNOTATIONS data
  tblname = annonutils.get_tblname('ANNOTATIONS')
  collection = db.get_collection(tblname)
  annotations = list(collection.find(query_annotations, {'_id':False}))
  log.info("len(annotations): {}".format(len(annotations)))
  annon = {item['ant_id']:item for item in annotations}

  ## get RELEASE data
  tblname = annonutils.get_tblname('RELEASE')
  collection = db.get_collection(tblname)
  release = list(collection.find({'rel_type':'annon'}, {'_id':False}))
  log.info("len(release): {}".format(len(release)))
  ## 'YYYY-MM-DD HH:mm:ss ZZ'
  release.sort(key = lambda x: arrow.get(x['created_on'], common._date_format_).date(), reverse=True)
  latest_release_info = release[0]
  # wanted_keys = ['rel_id','timestamp','created_on']
  # release_info = {k: latest_release_info[k] for k in set(wanted_keys) & set(latest_release_info.keys())}

  ## get CLASSINFO (labels) data
  tblname = annonutils.get_tblname('CLASSINFO')
  collection = db.get_collection(tblname)
  classinfo = list(collection.find(query_classinfo, {'_id':False}))
  lbl_ids = []
  for item in classinfo:
    lbl_ids.append(item['lbl_id'])

  log.info('lbl_ids: {}'.format(lbl_ids))

  lbl_ids.sort()

  log.info('len(lbl_ids): {}'.format(len(lbl_ids)))
  log.info('lbl_ids: {}'.format(lbl_ids))

  mclient.close()

  if filter_enable and filter_by and len(filter_by)>0:
    images = aids_filter(cfg, images, filter_by)

  return images, annon, latest_release_info, lbl_ids


def create_db(cfg, args, datacfg):
  """release the AIDS database i.e. creates the PXL DB (AI Datasets)
  and create respective entries in AIDS table in annon database
  """
  log.info("-----------------------------")

  by = args.by
  db_images, db_annon, latest_release_info, lbl_ids = get_annon_data(cfg)
  aids, datacfg = prepare_aids(cfg, db_images, db_annon, lbl_ids, datacfg)

  DBCFG = cfg['DBCFG']
  mclient = MongoClient('mongodb://'+DBCFG['HOST']+':'+str(DBCFG['PORT']))
  rel_timestamp = latest_release_info['timestamp']
  DBNAME = 'PXL-'+rel_timestamp+'_'+cfg['TIMESTAMP']
  log.info("DBNAME: {}".format(DBNAME))
  db = mclient[DBNAME]

  uuid_aids = None
  if len(aids) > 0:
    uuid_aids = common.createUUID('aids')

    AIDS_SPLITS_CRITERIA = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]
    splits = AIDS_SPLITS_CRITERIA[0] ## directory names

    ## Save aids - AI Datasets
    for split in splits:
      for tbl in aids[split]:
        log.info("aids[{}][{}]".format(split, tbl))
        
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
          # if tblname == 'STATS':
          #   log.info(doc)

          doc['dbid'] = uuid_aids
          doc['timestamp'] = cfg['TIMESTAMP']
          doc['subset'] = split
          annonutils.write2db(db, tblname, doc)

    created_on = common.now()
    uuid_rel = common.createUUID('rel')

    datacfg['dbid'] = uuid_aids
    datacfg['dbname'] = DBNAME
    datacfg['created_on'] = created_on
    datacfg['modified_on'] = None
    datacfg['anndb_id'] = rel_timestamp
    datacfg['timestamp'] = cfg['TIMESTAMP']
    datacfg['anndb_rel_id'] = latest_release_info['rel_id']
    datacfg['rel_id'] = uuid_rel
    datacfg['log_dir'] = DBNAME
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

  return uuid_aids


def save_to_annon_db(cfg, aidsdata):
  """Save to Annotation DB
  """
  DBCFG = cfg['DBCFG']
  mclient = MongoClient('mongodb://'+DBCFG['HOST']+':'+str(DBCFG['PORT']))
  db = mclient[DBCFG['DBNAME']]

  tblname = annonutils.get_tblname('AIDS')
  annonutils.create_unique_index(db, tblname, 'created_on')
  collection = db.get_collection(tblname)
  collection.update_one(
    {'created_on': aidsdata['created_on']}
    ,{'$setOnInsert': aidsdata}
    ,upsert=True
  )

  mclient.close()


def create_dataset_hmd(cfg, args, datacfg):
  """Release HD Map Dataset (AI Dataset).
  Execute all the steps from creation to saving AI Dataset from the Annotation Database.
  Every AI Datasets is creates as a new database AIDS_<ddmmyy_hhmmss> ready to be consumed for AI Training without dependency.
  This is further used in the TEPPr (Training, Evaluate, Prediction, Publish with reporting) workflow
  """
  tic = time.time()
  log.info("\ncreate_dataset_hmd:-----------------------------")
  cfg['TIMESTAMP'] = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  createdb = False
  ## Check required args
  if not args.from_path or not args.to_path:
    createdb = True
  
  log.info("createdb: {}".format(createdb))
  res = create_db(cfg, args, datacfg)
  
  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))

  return res


def create_dataset_coco(cfg, args, datacfg):
  """coco to database
  """
  import coco_to_db as c2db
  dataset = c2db.create_db(cfg, args, datacfg)

  return dataset


def tdd(cfg, args, datacfg):
  """test driven development
  * this provides the short-circuit approach to do the development
  * provides all the initial configuration and parameters as to any other function
  * delete the code in this function and write your own to test any function calls
  """
  from tqdm import tqdm
  log.info("datacfg:{}".format(datacfg))
  hmd = ANNON(cfg, datacfg)

  return


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
  if args.command == 'create':
    fn = None
    if args.did:
      fname = 'create_dataset_'+args.did
      fn = getattr(this, fname)
    if fn:
      log.info("-------")
      dataset = fn(cfg, args, datacfg)
      log.info("AIDS(AI Dataset) len(dataset): {}".format(len(dataset)))
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
    ,help='year of publiccatin of the dataset'
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

  return args


if __name__ == '__main__':
  commands = ['create', 'verify', 'tdd']
  args = parse_args(commands)

  main(appcfg, args, dbcfg)
