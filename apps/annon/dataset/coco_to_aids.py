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

import logging

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

# if BASE_PATH_CFG not in sys.path:
#   sys.path.append(BASE_PATH_CFG)

# this = sys.modules[__name__]

from Annon import ANNON
import common

log = logging.getLogger('__main__.'+__name__)

# from pycocotools.coco import COCO
# from pycocotools import mask as maskUtils


def coco_to_annon(subset, metadata, dataset):
  """
  mutex to transform coco data to annon format
  """
  log.info("-----------------------------")
  image_dir = metadata['image_dir']
  annotation_file = metadata['annotation_file']

  ## CLASSINFO
  categories = { cat['name']: cat for cat in dataset['categories'] }
  catid_lblid_map = { str(cat['id']):cat['name'] for cat in dataset['categories'] }

  log.info("categories: {}".format(categories))
  cats = list(categories.keys())
  cats.sort()
  log.info("cats: {}".format(cats))

  for i, cat in enumerate(cats):
    category = categories[cat]
    category['coco_id'] = category['id']
    category['lbl_id'] = category['name']
    category['source'] = 'coco'

  metadata['catid_lblid_map'] = catid_lblid_map

  ## IMAGES
  ## instances, 2014 => ['license', 'file_name', 'coco_url', 'height', 'width', 'date_captured', 'flickr_url', 'id']
  images = dataset['images']
  for i, image in enumerate(images):
    if i==0:
      log.info("image.keys(): {}".format(image.keys()))

    uuid_img = common.createUUID('img')
    image['img_id'] = image['id']
    image['filename'] = image['file_name']
    image['subset'] = subset
    image['file_attributes'] = {
      'id': image['id']
      ,'uuid': uuid_img
    }
    image['size'] = 0
    image['modified_on'] = None
    image['base_dir'] = None
    image['dir'] = None
    image['file_id'] = None
    image['filepath'] = None
    image['rel_filename'] = None

  ## ANNOTATIONS
  ## instances, 2014 => ['segmentation', 'area', 'iscrowd', 'image_id', 'bbox', 'category_id', 'id']
  annotations = dataset['annotations']
  boxmode = 'XYWH_ABS'
  for i, annotation in enumerate(annotations):
    if i==0:
      log.info("annotation.keys(): {}".format(annotation.keys()))
      log.info("annotation.keys(): {}".format(annotation.keys()))

    uuid_ant = common.createUUID('ant')
    annotation['ant_id'] = annotation['id']
    annotation['img_id'] = annotation['image_id']
    annotation['lbl_id'] = annotation['category_id']
    ## crucial mapping
    annotation['lbl_id'] = catid_lblid_map[str(annotation['category_id'])]

    ## BoxMode.XYWH_ABS
    _bbox = {
      "ymin": annotation['bbox'][1],
      "xmin": annotation['bbox'][0],
      "ymax": None,
      "xmax": None,
      "width": annotation['bbox'][2],
      "height": annotation['bbox'][3]
    }
    annotation['annon_index'] = -1
    annotation['annotation_rel_date'] = None
    annotation['annotation_tool'] = 'coco'
    annotation['annotator_id'] = 'coco'
    # annotation['ant_type'] = 'bbox'
    # annotation['ant_type'] = 'polygon'
    annotation['filename'] = annotation['id']
    annotation['subset'] = subset
    annotation['modified_on'] = None
    annotation['maskarea'] = -1
    annotation['_bbox'] = _bbox
    annotation['boxmode'] = boxmode
    annotation['bboxarea'] = annotation['area']
    annotation['region_attributes'] = {
      'id': annotation['id']
      ,'uuid': uuid_ant
      ,'iscrowd': annotation['iscrowd']
    }
    annotation['dir'] = None
    annotation['file_id'] = annotation['image_id']
    annotation['filepath'] = None
    annotation['rel_filename'] = annotation_file
    annotation['image_name'] = None
    annotation['image_dir'] = image_dir
    annotation['file_attributes'] = {}


def get_metadata(from_path, task, subset, year):
  metadata = {
    "annotation_file": None
    ,"annotation_filepath": None
    ,"image_dir": None
    ,"task": None
    ,"year": None
    ,"base_from_path": None
  }
  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))


  ## TODO: fix the subset issue
  if task == "panoptic":
    annotation_file = "{}_{}{}.json".format(task+"_instances", subset, year)
    subset = task+"_"+subset
  else:
    annotation_file = "{}_{}{}.json".format(task, subset, year)

  log.info("annotation_file: {}".format(annotation_file))
  annotation_filepath = os.path.join(base_from_path, annotation_file)
  log.info("annotation_filepath: {}".format(annotation_filepath))
  if not os.path.exists(annotation_filepath):
    raise Exception("File: {} does not exists!".format(annotation_filepath))

  if subset == "minival" or subset == "valminusminival":
    subset = "val"

  image_dir = "{}/{}{}".format(base_from_path, subset, year)
  log.info("image_dir: {}".format(image_dir))

  metadata['task'] = task
  metadata['year'] = year
  metadata['base_from_path'] = base_from_path
  metadata['annotation_file'] = annotation_file
  metadata['annotation_filepath'] = annotation_filepath
  metadata['image_dir'] = image_dir

  return metadata


def load_coco_data(from_path, task, subset, year):
  metadata = get_metadata(from_path, task, subset, year)
  annotation_filepath = metadata['annotation_filepath']

  log.info('loading annotations into memory...')
  tic = time.time()
  with open(annotation_filepath, 'r') as fr:
    dataset = json.load(fr)
    assert type(dataset)==dict, 'annotation file format {} not supported'.format(type(dataset))
    log.info('Done (t={:0.2f}s)'.format(time.time()- tic))
    log.info("dataset.keys(): {}".format(dataset.keys()))

  return dataset, metadata


def prepare_datasets(cfg, args, datacfg):
  """Loads the coco json annotation file
  Refer: pycocotools/coco.py

  Mandatory arguments:
  args.from_path => directory name where annotations directory contains all the annotation json files
  args.task => None, panoptic
  args.subset => test, train, val, minival, valminusminival
  args.year => year of publication

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

  if not args.from_path:
    raise Exception("--{} not defined".format('from'))
  if not args.task:
    raise Exception("--{} not defined".format('task'))
  if not args.year:
    raise Exception("--{} not defined".format('year'))
  from_path = args.from_path
  if not os.path.exists(from_path) and os.path.isfile(from_path):
      raise Exception('--from needs to be directory path')

  task = args.task
  year = args.year

  ## TODO: as user input
  splits = ['train','val']
  # splits = ['train']
  aids = {}
  stats = {}
  total_stats = {
    'total_images':0
    ,'total_annotations':0
    ,'total_labels':0
  }

  datacfg['id'] = 'coco'
  datacfg['name'] = 'coco'
  datacfg['problem_id'] = 'coco'
  datacfg['annon_type'] = 'coco'
  datacfg['splits'] = splits
  datacfg['classinfo'] = []

  for i, subset in enumerate(splits):
    log.info("subset: {}".format(subset))
    total_images = 0
    total_annotations = 0
    total_labels = 0

    if subset not in aids:
      aids[subset] = {
        'IMAGES':None
        ,'ANNOTATIONS': None
        ,'STATS':None
      }

    if subset not in stats:
      stats[subset] = None

    dataset, metadata = load_coco_data(from_path, task, subset, year)
    coco_to_annon(subset, metadata, dataset)
    annon = ANNON(datacfg=datacfg, subset=subset, images_data=dataset['images'], annotations_data=dataset['annotations'], classinfo=dataset['categories'])

    annon_stats = annon.getStats()
    annon_stats['metadata'] = metadata
    annon_stats['colors'] = None

    # ,"maskarea": []
    # ,"bboxarea": []
    # # ,"total_labels": 0
    # # ,'total_annotations':0
    # # ,"total_images": 0
    # # ,"total_unique_images": set()
    # # ,"total_unique_images": 0
    # # ,"annotation_per_img": []
    # # ,"label_per_img": []


    lbl_ids = annon.getCatIds()
    catIds = annon.getCatIds(catIds=lbl_ids)
    imgIds = annon.getImgIds(catIds=lbl_ids)
    annIds = annon.getAnnIds(imgIds=imgIds, catIds=lbl_ids)
    classinfo_split = annon.loadCats(ids=lbl_ids)

    # log.info("lbl_ids: {}".format(lbl_ids))
    # log.info("catIds: {}".format(catIds))
    # log.info("imgIds: {}".format(imgIds))
    # log.info("annIds: {}".format(annIds))
    # log.info("classinfo_split: {}".format(classinfo_split))

    aids[subset]['IMAGES'] = annon.loadImgs(ids=imgIds)
    aids[subset]['ANNOTATIONS'] = annon.loadAnns(ids=annIds)
    aids[subset]['STATS'] = [stats[subset]]

    ## classinfo / categories should be unique names for all the splits taken together
    ## and should not to be differentiated splitwise - the differences should be captured in the per split stats
    classinfo = list({v['lbl_id']:v for v in classinfo_split}.values())
    datacfg['classinfo'] += classinfo

    ## Calculation for total_labels is incorrect because it does not take care of common labels amoung subsets
    total_labels += len(classinfo)
    total_annotations += len(annIds)
    total_images += len(imgIds)

    ## update total stats object
    total_stats['total_labels'] += total_labels
    total_stats['total_annotations'] += total_annotations
    total_stats['total_images'] += total_images

    ## update stats object
    annon_stats['labels'] = catIds.copy()
    annon_stats['classinfo'] = classinfo.copy()

    stats[subset] = annon_stats

    # log.info("stats: {}".format(stats))
    # log.info("aids: {}".format(aids))

  datacfg['stats'] = stats
  datacfg['summary'] = total_stats

  return aids, datacfg


def tdd():
  from_path = '/aimldl-dat/data-public/ms-coco-1/annotations'
  task = 'instances'
  subset = 'train'
  year = 2014
  datacfg = None

  dataset, mdata = load_coco_data(from_path, task, subset, year)
  coco_to_annon(subset, mdata, dataset)
  annon = ANNON(datacfg=datacfg, subset=subset, images_data=dataset['images'], annotations_data=dataset['annotations'], classinfo=dataset['categories'])

  return dataset, mdata, annon

