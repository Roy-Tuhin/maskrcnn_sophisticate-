__author__ = 'mangalbhaskar'
__version__ = '1.0'
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

import logging

import numpy as np

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
ROOT_DIR = os.getenv('AI_HOME')
BASE_PATH_CFG = os.getenv('AI_CFG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

# if BASE_PATH_CFG not in sys.path:
#   sys.path.append(BASE_PATH_CFG)

# this = sys.modules[__name__]

from Annon import ANNON
import datasplit

log = logging.getLogger('__main__.'+__name__)


def get_annon_data(cfg, args, datacfg):
  """filter images based on the specific filter_by

  TODO:
  * annotation filtering based on stats on total images, total annotations, area (mask, bbox)
  """
  log.info("-----------------------------")

  ANNONCFG = cfg['DBCFG']['ANNONCFG']
  annon = ANNON(dbcfg=ANNONCFG, datacfg=datacfg)
  releaseinfo = annon.getReleaseId()

  filter_by = []
  filter_enable = cfg['AIDS_FILTER']['ENABLE']
  if filter_enable:
    filter_by = cfg['AIDS_FILTER'][ cfg['AIDS_FILTER']['BY'] ]
    # filter_by = np.array(cfg['AIDS_FILTER'][ cfg['AIDS_FILTER']['BY'] ])
    lbl_ids =  annon.getCatIds(catIds=filter_by)
    # lbl_ids = list(lbl_ids[np.where(np.in1d(lbl_ids, filter_by))])
    log.info("lbl_ids after filter: {}".format(lbl_ids))
  else:
    lbl_ids =  annon.getCatIds()

  log.info("lbl_ids: {}".format(lbl_ids))

  images_imgIds = annon.getImgIds(catIds=lbl_ids)
  # annotations = annon.getAnnIds(imgIds=images_imgIds, catIds=lbl_ids, areaRng=[])
  annotations = annon.getAnnIds(imgIds=images_imgIds, catIds=lbl_ids)
  classinfo = annon.loadCats(ids=lbl_ids)

  ## make sure that the K have a fixed order before shuffling
  ## https://cs230-stanford.github.io/train-dev-test-split.html
  T = len(images_imgIds)
  log.info("images_imgIds Size: => {}".format(T))

  cfg_aids_randomizer = cfg['AIDS_RANDOMIZER']
  if cfg_aids_randomizer['ENABLE']:
    if cfg_aids_randomizer['USE_SEED']:
      np.random.seed(T) ## provides consistent shuffle given that 'T' is same between two different execution of the script
    ## Shuffle K
    np.random.shuffle(images_imgIds)

  img_lbl_arr = np.zeros([len(images_imgIds), len(lbl_ids)], int)
  for j, lbl_id in enumerate(lbl_ids):
    img_col = img_lbl_arr[:,j]
    img_ids = annon.getImgIds(catIds=lbl_id)
    log.info("lbl_id, len(img_ids): {}, {}".format(lbl_id, len(img_ids)))
    if img_ids and len(img_ids) > 0:
      img_col[np.where(np.in1d(images_imgIds, img_ids))] += 1

  return annon, images_imgIds, annotations, classinfo, lbl_ids, img_lbl_arr


def prepare_datasets(cfg, args, datacfg):
  """Create AI Datasets and returns the actual data to be further processed and to persists on file-system or DB

  TODO:
  other stats like area, per label stats
  """
  log.info("-----------------------------")
  annon, images_imgIds, annotations, classinfo, lbl_ids, img_lbl_arr = get_annon_data(cfg, args, datacfg)
  log.info("-----------------lbl_ids: {}".format(lbl_ids))

  ## split the images_imgIds using splitting algorithm
  images_splits, splited_indices, splited_indices_per_label = datasplit.do_data_split(cfg, images_imgIds, lbl_ids, img_lbl_arr)
  log.info("len(images_splits): {}".format(len(images_splits)))
  for split in images_splits:
    log.info("images_splits: len(split): {}".format(len(split)))

  ## Create AIDS - AI Datasets data strcutre
  aids_splits_criteria = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]
  # splits, prcntg = aids_splits_criteria[0], aids_splits_criteria[1]
  splits = aids_splits_criteria[0] ## directory names

  aids = {}
  stats = {}
  total_stats = {
    'total_images':0
    ,'total_annotations':0
    ,'total_labels':0
  }

  for i, fnn in enumerate(images_splits):
    total_images = 0
    total_annotations = 0
    total_labels = 0
    subset = splits[i]

    log.info("\nTotal Images in: {}, {}, {}".format(subset, len(fnn), type(fnn)))
    imgIds = list(fnn)
    annIds = annon.getAnnIds(imgIds=imgIds, catIds=lbl_ids)
    catIds = annon.getCatIds(catIds=lbl_ids)
    classinfo_split = annon.loadCats(ids=catIds)

    log.info("catIds: {}".format(catIds))
    log.info("classinfo_split: {}".format(classinfo_split))

    if subset not in aids:
      aids[subset] = {
        'IMAGES':None
        ,'ANNOTATIONS': None
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
      }

    total_labels += len(classinfo_split)
    total_annotations += len(annIds)
    total_images += len(imgIds)

    ## update total stats object
    total_stats['total_labels'] += total_labels
    total_stats['total_annotations'] += total_annotations
    total_stats['total_images'] += total_images

    ## update stats object
    stats[subset]['labels'] = catIds.copy()
    stats[subset]['classinfo'] = classinfo_split.copy()
    stats[subset]['total_labels'] += total_labels
    stats[subset]['total_annotations'] += total_annotations
    stats[subset]['total_images'] += total_images

    ## create ai dataset data
    aids[subset]['IMAGES'] = annon.loadImgs(ids=imgIds)
    aids[subset]['ANNOTATIONS'] = annon.loadAnns(ids=annIds)
    # aids[subset]['CLASSINFO_SPLIT'] = classinfo_split
    aids[subset]['STATS'] = [stats[subset]]

    # log.debug("stats: {}".format(stats))
    # log.debug("aids: {}".format(aids))

  datacfg['stats'] = stats
  datacfg['summary'] = total_stats
  datacfg['classinfo'] = classinfo
  datacfg['splits'] = splits

  return aids, datacfg
