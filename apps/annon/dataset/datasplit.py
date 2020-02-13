__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Data split alogrithm
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
from collections import OrderedDict

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

import annonutils
import common

log = logging.getLogger('__main__.'+__name__)


def create_data_split(img_lbl_arr, labels, splited_indices_per_label, already_processed_indices, prcntg):
  """Creates the Data split by splitting images on per label basis
  * all labels should be present in all splits
  * images must be mutually exclusive across the splits
  * all labels must split proportionally in the given criteria
  """
  log.info("--------------------------------------->")
  log.debug("img_lbl_arr.shape: {}\nlabels to be processed: {}\nalready_processed_indices: {}\nprcntg: {}".format(img_lbl_arr.shape, labels, already_processed_indices, prcntg))

  dd = np.array(img_lbl_arr != 0, dtype=int)
  total_images_per_label, total_label_per_image = np.sum(dd, axis=0), np.sum(dd, axis=1)
  total_duplications_in_image = np.sum(np.sum(dd, axis=1)) - len(np.sum(dd, axis=1))
  total_labels, total_annotations_per_label = len(np.sum(img_lbl_arr, axis=0)), np.sum(img_lbl_arr, axis=0)
  total_annotations = np.sum(np.sum(img_lbl_arr, axis=0))
  total_images, total_annotations_per_image = len(np.sum(img_lbl_arr, axis=1)), np.sum(img_lbl_arr, axis=1)

  log.debug("Total Images per Label: {}\nTotal Label per Image: {}".format(total_images_per_label, total_label_per_image))
  log.debug("Total Duplication in Images: {}".format(total_duplications_in_image))
  log.debug("Total Labels: {}\nTotal Annotations per Label: {}".format(total_labels, total_annotations_per_label))
  log.debug("Total Annotations: {}".format(total_annotations))
  log.debug("Total Images: {}\nTotal Annotations per Image: {}".format(total_images, total_annotations_per_image))
  
  if total_images > 0 and len(labels) > 0:
    log.debug("total_images_per_label: {}".format(total_images_per_label))
    total_images_per_label_sorted_index = np.argsort(total_images_per_label)
    log.debug("total_images_per_label_sorted_index: {}".format(total_images_per_label_sorted_index))

    ## index_of_min_total_images_per_label
    index = total_images_per_label_sorted_index[0]
    log.debug("total_images_per_label[index]: {}".format(total_images_per_label[index]))

    ## column values for the given index_of_min_total_images_per_label
    index_col_vals = img_lbl_arr[:,index]
    log.debug("index_col_vals: {}".format(index_col_vals))

    label = labels[index]
    log.debug("label: {}".format(label))

    ## for the given index_col_vals get only the non-zero indices in an array i.e. only the rows (i.e. images) which has the labels
    K = np.where(index_col_vals != 0)[0]
    log.debug("len(K): {}, K: {}".format(len(K), K))

    ## calculate the total_images_per_label for the selected column i.e. label
    T = np.sum(index_col_vals != 0)
    log.debug("total_images_per_label_col(T): {}".format(T))

    ## must verfiy the total length calculate in different ways must match
    assert T == len(K)

    ## Check and filter rows(images) which are already processed
    log.debug("len(already_processed_indices), already_processed_indices: {}".format(len(already_processed_indices), already_processed_indices))
    
    ## TODO: this does not all labels in all splits, but somehow comes in final split when all labels are combined
    if len(already_processed_indices) > 0:
      K = K[np.where(np.in1d(K,already_processed_indices) < 1 )[0]]
      log.debug("K: {}".format(K))
      T = len(K)
    
    if len(K) > 0:
      ## Get the split distribution based on the 'T'
      ptn, pvl = prcntg[0],prcntg[1]
      tn,vl = int(T*ptn), int(T*pvl)
      tt = T - tn - vl
      log.debug("train, val, test splits: {},{},{}".format(tn, vl, tt))

      assert T == tn+vl+tt
      log.debug("tn, tn+vl, tt: {},{},{}".format(tn, tn+vl, tt))

      ## get the indices per dataset splits
      split_pts = [[0,tn-1], [tn,tn+vl-1], [tn+vl,T-1]]
      log.debug("split_pts: {}".format(split_pts))

      log.debug("K[0:tn], K[tn:tn+vl], K[tn+vl:T]: {},{},{}".format(K[0:tn], K[tn:tn+vl], K[tn+vl:T]))
      
      if label not in splited_indices_per_label:
        splited_indices_per_label[label] = {}
      else:
        log.debug("label already exists!!! raise Error")

      # splited_indices_per_label[label]["splits"] = np.array([K[0:tn], K[tn:tn+vl], K[tn+vl:T]])
      splits = [ list(K[0:tn]), list(K[tn:tn+vl]), list(K[tn+vl:T]) ]
      splited_indices_per_label[label]["splits"] = splits
      splited_indices_per_label[label]["total_images_per_label"] = total_images_per_label[index]
      splited_indices_per_label[label]["label"] = label
      splited_indices_per_label[label]["total_images_per_split"] = [ len(x) for x in splits ]
      
      ## split the indices for the rows i.e. the images which has the labels in the given split percentage
      already_processed_indices = np.concatenate((already_processed_indices, K), axis=0)
      log.debug("len(already_processed_indices), already_processed_indices: {}".format(len(already_processed_indices), already_processed_indices))
      
      log.debug("splited_indices_per_label: {}".format(splited_indices_per_label))
      if len(labels) > 0:
        log.debug("index: {}, labels: {}".format(index, labels))
        labels.pop(index)
        log.debug("labels: {}".format(labels))
        ## rows for a particular column which has value, make them as zero for all the rows i.e. for the images
        img_lbl_arr[:,index][K[0:tn]] = np.zeros(len(img_lbl_arr[:,index][K[0:tn]]), dtype=int)
        img_lbl_arr[:,index][K[tn:tn+vl]] = np.zeros(len(img_lbl_arr[:,index][K[tn:tn+vl]]), dtype=int)
        img_lbl_arr[:,index][K[tn+vl:T]] = np.zeros(len(img_lbl_arr[:,index][K[tn+vl:T]]), dtype=int)

        ## CAUTIOUS: recurssion!!!
        img_lbl_arr = img_lbl_arr[:,total_images_per_label_sorted_index[1:]]
        create_data_split(img_lbl_arr, labels, splited_indices_per_label, already_processed_indices, prcntg)



def do_data_split(cfg, images, labels, img_lbl_arr):
  """mutates input data
  """
  log.info("-----------------------------")
  aids_splits_criteria = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]

  ## keep the master list of row indices (image) which has been processed
  already_processed_indices = np.array([], dtype='int32')
  splited_indices_per_label = {}
  splits, prcntg = aids_splits_criteria[0], aids_splits_criteria[1]

  create_data_split(img_lbl_arr, labels.copy(), splited_indices_per_label, already_processed_indices, prcntg)

  log.debug("splited_indices_per_label-----------------------------: {}".format(splited_indices_per_label))

  splited_indices_per_label_list = np.array([ v['splits'] for v in splited_indices_per_label.values() ])
  splited_indices_with_duplication = np.sum(splited_indices_per_label_list, axis=0)
  log.debug("splited_indices_with_duplication: {}".format(splited_indices_with_duplication))
  splited_indices = [list(set(x)) for x in splited_indices_with_duplication]
  splited_indices_len = [len(set(x)) for x in splited_indices_with_duplication]
  log.debug("splited_indices: {}\n\nsplited_indices_len: {}\n".format(splited_indices, splited_indices_len))
  log.debug("----------x---X-------------\n")

  for split in splited_indices:
    log.debug("split: {}".format(split))

  log.debug("images: {}".format(images))
  imagesnp = np.array(images.copy())
  images_splits = [imagesnp[split] for split in splited_indices]

  return images_splits, splited_indices, splited_indices_per_label

