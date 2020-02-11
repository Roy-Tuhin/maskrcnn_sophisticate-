__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# Upload the MS COCO dataset to MongoDB in Annon DB specification
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

import json
import time
import datetime

import numpy as np

import zipfile
import urllib.request
import shutil

import pymongo
from pymongo import MongoClient

import logging

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

import annonutils
import common

log = logging.getLogger('__main__.'+__name__)

from pycocotools.coco import COCO
from pycocotools import mask as maskUtils


def get_data_coco(cfg, args, datacfg):
  """Loads the coco json annotation file
  Refer: pycocotools/coco.py

  Mandatory arguments:
  args.from_path => directory name where annotations directory contains all the annotation json files
  args.task => None, panoptic
  args.subset => test, train, val, minival, valminusminival
  args.year => year of publication
  """
  if not args.from_path:
    raise Exception("--{} not defined".format('from'))
  if not args.task:
    raise Exception("--{} not defined".format('task'))
  if not args.year:
    raise Exception("--{} not defined".format('year'))

  from_path = args.from_path
  if not os.path.exists(from_path) and os.path.isfile(from_path):
      raise Exception('--from needs to be directory path')

  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))
  cfg['TIMESTAMP'] = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  ## TODO: as user input
  splits = ['train','val','test']
  aids = {}
  stats = {}
  total_stats = {
    'total_images':0
    ,'total_annotations':0
    ,'total_labels':0
  }

  task = args.task
  year = args.year

  datacfg['id'] = 'coco'
  datacfg['name'] = 'coco'
  datacfg['problem_id'] = 'coco'
  datacfg['annon_type'] = 'coco'
  datacfg['splits'] = splits

  for i, subset in enumerate(splits):
    if subset not in aids:
      aids[subset] = {
        'IMAGES':None
        ,'ANNOTATIONS': None
        ,'CLASSINFO':None
        # ,'CLASSINFO_SPLIT':None
        ,'STATS':None
      }
    if subset not in stats:
      stats[subset] = {
        'labels':None
        ,"classinfo": None
        ,"total_labels": 0
        ,'total_annotations':0
        ,"total_images": 0
        # ,"total_unique_images": set()
        ,"total_unique_images": 0
        ,"labels": []
        ,"annotation_per_img": []
        ,"label_per_img": []
        ,"maskarea": []
        ,"bboxarea": []
        ,"colors": None
        ,"annotation_file": None
        ,"annotation_filepath": None
        ,"image_dir": None
      }

    ## TODO: fix the subset issue
    if task == "panoptic":
      annotation_file = 'annotations', "{}_{}{}.json".format(task+"_instances", subset, year)
      subset = task+"_"+subset
    else:
      annotation_file = 'annotations', "{}_{}{}.json".format(task, subset, year)

    annotation_filepath = os.path.join(base_from_path, annotation_file)
    log.info("annotation_filepath: {}".format(annotation_filepath))
    if not os.path.exists(annotation_filepath):
      raise Exception("File: {} does not exists!".format(annotation_filepath))


    if subset == "minival" or subset == "valminusminival":
      subset = "val"

    image_dir = "{}/{}{}".format(base_from_path, subset, year)
    log.info("image_dir: {}".format(image_dir))

    stats[subset]['task'] = task
    stats[subset]['year'] = year
    stats[subset]['base_from_path'] = base_from_path
    stats[subset]['annotation_file'] = annotation_file
    stats[subset]['annotation_filepath'] = annotation_filepath
    stats[subset]['image_dir'] = image_dir

    log.info('loading annotations into memory...')
    tic = time.time()
    with open(annotation_filepath, 'r') as fr:
      dataset = json.load(fr)
      assert type(dataset)==dict, 'annotation file format {} not supported'.format(type(dataset))
      log.info('Done (t={:0.2f}s)'.format(time.time()- tic))
      log.info("dataset.keys(): {}".format(dataset.keys()))

      aids[subset]['dataset'] = dataset
      coco_to_annon(subset, stats, dataset)

  datacfg['stats'] = stats
  datacfg['summary'] = total_stats
  datacfg['classinfo'] = None

  return aids, datacfg


def coco_to_annon(subset, stats, dataset):
  stats = stats[subset]
  image_dir = stats['image_dir']
  annotation_file = stats['annotation_file']

  images = dataset['images']
  for i, image in enumerate(images):
    uuid_img = common.createUUID('img')
    image['dbid'] = uuid_aids
    image['img_id'] = image['id']
    image['created_on'] = created_on
    image['filename'] = image['file_name']
    image['subset'] = subset
    image['file_attributes'] = {
      'id': image['id']
      ,'uuid': uuid_img
    }
    image['timestamp'] = timestamp
    image['size'] = 0
    image['modified_on'] = None
    image['base_dir'] = None
    image['dir'] = None
    image['file_id'] = None
    image['filepath'] = None
    image['rel_filename'] = None

  annotations = dataset['annotations']

  boxmode = 'XYWH_ABS'
  for i, annotation in enumerate(annotations):
    uuid_ant = common.createUUID('ant')
    ##TODO: verify what is BoxMode.XYWH_ABS
    coco_frmt_bbox = [_bbox['xmin'], _bbox['ymin'], _bbox['width'], _bbox['height'] ]
    _bbox = {
      "ymin": annotation['bbox'][1],
      "xmin": annotation['bbox'][0],
      "ymax": None,
      "xmax": None,
      "width": annotation['bbox'][2],
      "height": annotation['bbox'][3]
    }
    annotation['dbid'] = uuid_aids
    annotation['ant_id'] = annotation['id']
    annotation['annon_index'] = -1
    annotation['annotation_rel_date'] = None
    annotation['annotation_tool'] = 'coco'
    annotation['annotator_id'] = 'coco'
    annotation['ant_type'] = 'bbox'
    # annotation['ant_type'] = 'polygon'
    annotation['created_on'] = created_on
    annotation['timestamp'] = timestamp
    annotation['filename'] = annotation['id']
    annotation['subset'] = subset
    annotation['modified_on'] = None
    annotation['lbl_id'] = annotation['category_id']
    annotation['maskarea'] = 0
    annotation['_bbox'] = _bbox
    annotation['boxmode'] = boxmode
    annotation['bboxarea'] = annotation['area']
    annotation['region_attributes'] = {
      'area': annotation['area']
      ,'iscrowd': annotation['iscrowd']
    }
    annotation['img_id'] = annotation['image_id']
    annotation['dir'] = None
    annotation['file_id'] = annotation['image_id']
    annotation['filepath'] = None
    annotation['rel_filename'] = annotation_file
    annotation['image_name'] = None
    annotation['image_dir'] = image_dir
    annotation['file_attributes'] = {
      'id': annotation['id']
      ,'img_id': annotation['image_id']
      ,'uuid': uuid_ant
    }

  categories = { cat['name']: cat for cat in dataset['categories'] }
  log.info("categories: {}".format(categories))
  cats = list(categories.keys())
  cats.sort()
  log.info("cats: {}".format(cats))

  class_info = []
  # colors = common.random_colors(len(categories))

  for i, cat in enumerate(cats):
    classid = i + 1
    category = categories[cat]
    category['coco_id'] = category['id']
    category['lbl_id'] = category['name']
    category['source'] = 'coco'
    category['dbid'] = uuid_aids
    category['timestamp'] = timestamp
    category['subset'] = subset
    category['id'] = classid

    class_info.append(category)


def create_db(cfg, args, datacfg):
  aids, datacfg = get_data_coco(cfg, args, datacfg)

  timestamp = created_on = common.now()
  uuid_aids = common.createUUID('aids')

  _dataset['timestamp'] = timestamp
  _dataset['uuid_aids'] = uuid_aids


  DBCFG = cfg['DBCFG']
  PXLCFG = DBCFG['PXLCFG']
  mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))
  DBNAME = 'PXL-'+cfg['TIMESTAMP']
  log.info("DBNAME: {}".format(DBNAME))
  db = mclient[DBNAME]

  ## IMAGES
  tblname = annonutils.get_tblname('IMAGES')
  collection = db.get_collection(tblname)
  annonutils.write2db(db, tblname, dataset['images'], idx_col='img_id')

  ## ANNOTATIONS
  tblname = annonutils.get_tblname('ANNOTATIONS')
  collection = db.get_collection(tblname)
  annonutils.write2db(db, tblname, dataset['annotations'], idx_col='ant_id')

  ## CLASSINFO
  tblname = annonutils.get_tblname('CLASSINFO')
  collection = db.get_collection(tblname)
  annonutils.write2db(db, tblname, dataset['categories'], idx_col='lbl_id')



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

  mclient.close()

  return _dataset
