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
  """
  if not args.from_path:
    raise Exception("--{} not defined".format('from'))
  if not args.task:
    raise Exception("--{} not defined".format('task'))
  if not args.subset:
    raise Exception("--{} not defined".format('subset'))
  if not args.year:
    raise Exception("--{} not defined".format('year'))

  dataset = None
  from_path = args.from_path
  if not os.path.exists(from_path) and os.path.isfile(from_path):
      raise Exception('--from needs to be directory path')

  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))
  cfg['TIMESTAMP'] = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())


  task = args.task
  subset = args.subset
  year = args.year
  if task == "panoptic":
    annotation_file = os.path.join(base_from_path, 'annotations', "{}_{}{}.json".format(task+"_instances", subset, year))
    subset = task+"_"+subset
  else:
    annotation_file = os.path.join(base_from_path, 'annotations', "{}_{}{}.json".format(task, subset, year))

  log.info("annotation_file: {}".format(annotation_file))
  
  if subset == "minival" or subset == "valminusminival":
    subset = "val"
  
  image_dir = "{}/{}{}".format(base_from_path, subset, year)
  log.info("image_dir: {}".format(image_dir))

  log.info('loading annotations into memory...')
  tic = time.time()
  dataset = json.load(open(annotation_file, 'r'))
  assert type(dataset)==dict, 'annotation file format {} not supported'.format(type(dataset))
  log.info('Done (t={:0.2f}s)'.format(time.time()- tic))
  log.info("dataset.keys(): {}".format(dataset.keys()))

  return dataset


def coco_to_annon(cfg, args, datacfg, dataset):
  timestamp = created_on = common.now()
  uuid_aids = common.createUUID('aids')
  subset = args.subset

  images = dataset['images']
  for i, image in enumerate(images):
    uuid_img = common.createUUID('img')
    image['dbid'] = uuid_aids
    image['img_id'] = uuid_img
    image['created_on'] = created_on
    image['filename'] = image['file_name']
    image['subset'] = subset
    image['file_attributes'] = {
      'img_id': image['id']
      ,'uuid': uuid_img
    }
    image['timestamp'] = timestamp
    image['size'] = 0
    image['modified_on'] = None
    image['annotations'] = []
    image['lbl_ids'] = []
    image['base_dir'] = None
    image['dir'] = None
    image['file_id'] = None
    image['filepath'] = None
    image['rel_filename'] = None

  annotations = dataset['annotations']
  for i, annotation in enumerate(annotations):
    uuid_ant = common.createUUID('ant')
    
    annotation['dbid'] = uuid_aids
    annotation['ant_id'] = uuid_ant
    annotation['annon_index'] = -1
    annotation['annotation_rel_date'] = None
    annotation['annotation_tool'] = 'coco'
    annotation['annotator_id'] = 'coco'
    annotation['ant_type'] = 'bbox'
    # annotation['ant_type'] = 'polygon'
    annotation['created_on'] = created_on
    annotation['timestamp'] = timestamp
    annotation['filename'] = uuid_ant
    annotation['subset'] = subset
    annotation['modified_on'] = None
    annotation['lbl_id'] = annotation['category_id']
    annotation['maskarea'] = 0
    annotation['bboxarea'] = annotation['area']
    annotation['region_attributes'] = annotation['area']
    annotation['img_id'] = annotation['image_id']
    annotation['dir'] = None
    annotation['file_id'] = annotation['image_id']
    annotation['filepath'] = None
    annotation['image_name'] = None
    annotation['file_attributes'] = {
      'img_id': annotation['image_id']
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


def release_coco(cfg, args, datacfg):

  dataset = get_data_coco(cfg, args, datacfg)

  coco_to_annon(cfg, args, datacfg, dataset)

  DBCFG = cfg['DBCFG']
  mclient = MongoClient('mongodb://'+DBCFG['host']+':'+str(DBCFG['port']))
  rel_timestamp = cfg['TIMESTAMP']
  DBNAME = 'PXL-'+rel_timestamp+'_'+cfg['TIMESTAMP']
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

  mclient.close()
  return


def create_db(cfg, args, datacfg):

  dataset = get_data_coco(cfg, args, datacfg)
  coco_to_annon(cfg, args, datacfg, dataset)

  DBCFG = cfg['DBCFG']
  mclient = MongoClient('mongodb://'+DBCFG['host']+':'+str(DBCFG['port']))
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

  mclient.close()

  return dataset
