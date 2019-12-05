__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).

# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""

import os
import sys
import json

import skimage.io
import numpy as np

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


def parse_annon_file(cfg, annon_filepath, base_from_path):
  """Entry point for parsing single annotation file 
  It's a wrapper around actual parser.
  """
  log.info("\nparse_annon_file:-----------------------------")
  annondata = None
  with open(annon_filepath,'r') as frw:
    dataset = json.load(frw)
    ## dataset = list(dataset.values())  # don't need the dict keys
    dataset = {k:v for k,v in dataset.items() if dataset[k]['regions']}
    ## log.info(json.dumps(dataset))
    annondata = get_annon(cfg, dataset, annon_filepath, base_from_path)
  
  return annondata


def get_annon(cfg, annotations, annon_filepath, base_from_path):
  """Main function that parse annotations and create the required data structure.

  It also implements. DRC - Design Rule Check and filter the errors to create the clean data structure like:
  ## Error
    - file_not_found: mainly image files not found issues
    - error_reading_file: image file truncated error
    - unsupported_annotation_type: configured from cfg
    - unlabelled_annotation

  TODO:
  - Allow unlabelled annotations for a dataset containing only single label, but label text is not provided in annoation
  """
  log.info("\nget_annon:-----------------------------")
  log.info("annon_filepath:{}".format(annon_filepath))
  labels = {}

  total_img = 0
  total_ant = 0
  total_ant_type = {}
  total_lbl = 0
  total_error_img_notfound = 0
  total_error_unlabeled_ant = 0
  total_error_img_reading = 0
  total_error_ant = 0
  total_error_empty_ant = 0

  Image = {}
  Label = {}
  Annotation_Info = {}
  Annotation_Data = {}
  Error = {}

  annon_filename = os.path.basename(annon_filepath)
  log.info("annon_filename: {}".format(annon_filename))
  ref = annonutils.parse_annon_filename(annon_filename)

  total_stats = {
    "image_rel_date":ref['image_rel_date']
    ,"image_part":ref['image_part']
    ,"annotator_id":ref['annotator_id'] 
    ,"annotation_rel_date":ref['annotation_rel_date']
    ,"annotation_tool":ref['annotation_tool']
  }

  IMAGE_API = cfg['IMAGE_API']
  USE_IMAGE_API = IMAGE_API['ENABLE']
  SAVE_LOCAL_COPY = IMAGE_API['SAVE_LOCAL_COPY']
  STATIC_IMAGE_DIMENSION = IMAGE_API['STATIC_IMAGE_DIMENSION']
  IMG_CHECK = IMAGE_API['IMG_CHECK']

  AICATS = cfg['AICATS']
  VALID_ANNON_TYPE = cfg['VALID_ANNON_TYPE']
  ERROR_TYPES = cfg['ERROR_TYPES']

  ## Error Table Structure for different error type
  if annon_filename not in Error:
    Error[annon_filename] = {
      'rel_filename': annon_filename
      ,"created_on": common.now()
      ,"has_error": False
      ,"modified_on": None
    }

    for error_type in ERROR_TYPES:
      Error[annon_filename][error_type] = []

  for ak,av in annotations.items():
    # log.info("ak: {}".format(ak))
    imgpath, base_path_img = annonutils.getImgPath(base_from_path, ref['image_dir'])
    filepath_img = os.path.join(base_path_img, av['filename'])

    if USE_IMAGE_API:
      get_img_from_url_success = annonutils.get_image_from_url(IMAGE_API, av['filename'], base_path_img, save_local_copy=SAVE_LOCAL_COPY, debug=IMAGE_API['DEBUG'])
    
    im_height, im_width = 0, 0
    
    if STATIC_IMAGE_DIMENSION or not IMG_CHECK:
      # log.info("STATIC_IMAGE_DIMENSION, IMG_CHECK: {}, {}".format(STATIC_IMAGE_DIMENSION, IMG_CHECK))
      im_height = IMAGE_API['IMAGE_HEIGHT']
      im_width = IMAGE_API['IMAGE_WIDTH']

    if IMG_CHECK:
      try:
        if os.path.exists(filepath_img):
          # log.info("IMG_CHECK: {}".format(IMG_CHECK))
          im = skimage.io.imread(filepath_img)
          im_height, im_width = im.shape[:2]
        else:
          ## Error
          Error[annon_filename]['file_not_found'].append({
            'dir': imgpath
            ,'filename':av['filename']
            ,'filepath': filepath_img
            ,'base_dir':ref['image_dir']
          })
          Error[annon_filename]['has_error'] = True
          total_error_img_notfound += 1
          # log.info("total_error_file: {}".format(total_error_img_notfound))
          continue
      except:
          log.info("Skipped as Error reading file: {}".format(filepath_img))
          ## Error
          Error[annon_filename]['error_reading_file'].append({
            'dir': imgpath
            ,'filename':av['filename']
            ,'filepath': filepath_img
            ,'base_dir':ref['image_dir']
          })
          Error[annon_filename]['has_error'] = True
          total_error_img_reading += 1
          # log.info("Reading: total_error_file: {}".format(total_error_img_reading))
          continue

    ## Get the x, y coordinates of points of the polygons that make up
    ## the outline of each object instance. These are stores in the
    ## shape_attributes (see json format above)
    ## The if condition is needed to support VIA versions 1.x and 2.x.
    if isinstance(av['regions'], dict):
      shape_attributes = [r['shape_attributes'] for r in av['regions'].values()]
      region_attributes = [r['region_attributes'] for r in av['regions'].values()]
    elif isinstance(av['regions'], list):
      shape_attributes = [r['shape_attributes'] for r in av['regions']]
      region_attributes = [r['region_attributes'] for r in av['regions']]
    else:
      shape_attributes = []
      region_attributes = []

    total_img += 1
    total_ant += len(av['regions'])

    uuid_img = common.createUUID('img')
    image_info = {
      'img_id': uuid_img
      ,'file_id': ak
      ,'size': av['size']
      ,'dir': imgpath
      ,'filename': av['filename']
      ,'filepath': filepath_img
      ,'base_dir': ref['image_dir']
      ,'file_attributes': av['file_attributes']
      ,'annon_dir': None
      ,'width': im_width
      ,'height': im_height
      ,'rel_filename': annon_filename
      ,"created_on": common.now()
      ,"modified_on": None
    }

    image_list = {
      'annotations':[]
      ,'lbl_ids':[]
    }

    ## - extract bbox, calculate area of extracted bbox for every polygon
    ## - calculate area of polygon
    maskstats = annonutils.complute_bbox_maskstats_from_via_annotations(shape_attributes, im_height, im_width)
    # log.info("maskstats: {}".format(maskstats))

    for i in range(0,len(shape_attributes)):
      ant_type = shape_attributes[i]['name']
      
      ## Check for unsupported_annotation_type
      if ant_type not in list(VALID_ANNON_TYPE.keys()):
        Error[annon_filename]['unsupported_annotation_type'].append({
          'file_id': ak
          ,'ant_type': ant_type
          ,"image_rel_date":ref['image_rel_date']
          ,"image_part":ref['image_part']
          ,'image_filepath': imgpath
          ,"annotator_id":ref['annotator_id']
          ,"annotation_rel_date":ref['annotation_rel_date']
          ,"annotation_tool":ref['annotation_tool']
          # ,'shape_attributes': shape_attributes[i]
          # ,'region_attributes': region_attributes[i]
          ,'annon_filename':annon_filename
          ,'annon_index':i
        })
        Error[annon_filename]['has_error'] = True
        total_error_ant += 1
        continue

      ## This is expensive check, but 'rect' type has missing attributes forced me to put this check
      ## better take more time in data creation, rather than getting errors while training DNN
      ## Check for malformed_annotation
      if ant_type in list(VALID_ANNON_TYPE.keys()):
        ant_missing_attr = False
        for attr in VALID_ANNON_TYPE[ant_type]:
          if attr not in shape_attributes[i]:
            Error[annon_filename]['malformed_annotation'].append({
              'file_id': ak
              ,'ant_type': ant_type
              ,"image_rel_date":ref['image_rel_date']
              ,"image_part":ref['image_part']
              ,'image_filepath': imgpath
              ,"annotator_id":ref['annotator_id']
              ,"annotation_rel_date":ref['annotation_rel_date']
              ,"annotation_tool":ref['annotation_tool']
              # ,'shape_attributes': shape_attributes[i]
              # ,'region_attributes': region_attributes[i]
              ,'annon_filename':annon_filename
              ,'annon_index':i
            })
            Error[annon_filename]['has_error'] = True
            ant_missing_attr = True
            break
        if ant_missing_attr:
          total_error_ant += 1
          continue

      if 'ant_id' in region_attributes[i]:
        uuid_ant = region_attributes[i]['ant_id']
      else:
        uuid_ant = common.createUUID('ant')
        shape_attributes[i]['ant_id'] = uuid_ant
        if region_attributes[i]:
          region_attributes[i]['ant_id'] = uuid_ant

      ## relative path
      annon_dir = os.path.join(cfg['TIMESTAMP'], cfg["BASEDIR_NAME"]["ANNON"])
      filepath_ant = os.path.join(annon_dir, uuid_ant)

      bbox, bboxarea, maskarea = annonutils.get_from_maskstats(maskstats[i])

      ## TODO:
      ## 1. change file_id to image_file_id
      annotation_info = {
        'ant_id': uuid_ant
        ,'img_id': uuid_img
        ,'image_name': av['filename']
        ,'file_id': ak
        ,'ant_type': ant_type
        ,'lbl_id': None
        ,"image_rel_date": ref['image_rel_date']
        ,"image_part": ref['image_part']
        ,'image_dir': imgpath
        ,'image_filepath': image_info['filepath']
        ,"annotator_id": ref['annotator_id']
        ,"annotation_rel_date": ref['annotation_rel_date']
        ,"annotation_tool": ref['annotation_tool']
        ,'rel_filename': annon_filename
        ,'dir': annon_dir
        ,'annon_index': i
        ,'filepath': filepath_ant
        ,'filename': uuid_ant
        ,"anndb_id": cfg['TIMESTAMP']
        ,'shape_attributes': shape_attributes[i]
        ,'region_attributes': region_attributes[i]
        ,"bbox": bbox
        ,"bboxarea": bboxarea
        ,"maskarea": maskarea
        ,"created_on": common.now()
        ,"modified_on": None
      }


      ## TODO: normalize to common format and optimize for high throughput I/O storage for the shape and region attribute
      annotation_data = {
        'ant_id': uuid_ant
        ,'img_id': uuid_img
        ,'file_id': ak
        ,'rel_filename': annon_filename
        ,'ant_type': ant_type
        ,'lbl_id': None
        ,'shape_attributes': shape_attributes[i]
        ,'region_attributes': region_attributes[i]
        ,"bbox": bbox
        ,"maskarea": maskarea
        ,"anndb_id": cfg['TIMESTAMP']
      }

      if ant_type not in total_ant_type:
        total_ant_type[ant_type] = 0

      total_ant_type[ant_type] += 1

      ## Unlabeled logic to be introduce
      ## case-1 when region_attributes[i] is empty
      ## case-2 when region_attributes[i] is non-empty but AICATS have not been assigned value

      ## magic happens in  this function call - this is tricky
      v = create_label(region_attributes[i], AICATS, labels)

      for j in v:
        if annotation_info['lbl_id'] == None:
          annotation_info['lbl_id'] = j

        if annotation_data['lbl_id'] == None:
          annotation_data['lbl_id'] = j

        if j not in Label:
          Label[j] = j

        if len(labels[j]) == 0:
          total_lbl += 1
        # log.info("labels: {}".format(labels))
        # log.info("j: {}".format(j))
        # log.info("labels[j]: {}".format(labels[j]))
        g = av['filename']+str(av['size'])

        if g not in labels[j]:
          labels[j][g] = {
            'filename': av['filename']
            ,'size': av['size']
            ,'regions': []
            ,'file_attributes': av['file_attributes']
          }

        if labels[j][g]["filename"] == av['filename']:
          labels[j][g]["regions"].append({
            'shape_attributes': shape_attributes[i]
            ,'region_attributes': region_attributes[i]
          })

        if j not in labels[j][g]['file_attributes']:
          labels[j][g]['file_attributes'][j] = j
     

      ## null check implemented
      ## TODO - store null checks separately
      lbl_id = annotation_info['lbl_id']
      if lbl_id:
        image_list['annotations'].append(uuid_ant)
        image_list['lbl_ids'].append(lbl_id)
        ## Annotation_Info
        if uuid_ant not in Annotation_Info:
          Annotation_Info[uuid_ant] = annotation_info
      
        ## Annotation_Data
        if uuid_ant not in Annotation_Data:
          Annotation_Data[uuid_ant] = annotation_data
      else:
        # log.info("lbl_id: {}".format(lbl_id))
        if 'unlabeled_annotation' not in Error[annon_filename]:
          Error[annon_filename]['unlabeled_annotation'] = []

        wanted_keys = ['ant_id','img_id','image_name','file_id','ant_type','lbl_id',"image_rel_date","image_part",'image_dir','image_filepath',"annotator_id","annotation_rel_date","annotation_tool",'rel_filename','annon_index','filepath','filename',"anndb_id","created_on","modified_on"]
        unlabeled_annotation = {k: annotation_info[k] for k in set(wanted_keys) & set(annotation_info.keys())}
        Error[annon_filename]['unlabeled_annotation'].append(unlabeled_annotation)
        Error[annon_filename]['has_error'] = True
        total_error_unlabeled_ant += 1

    ## Image
    if len(image_list['annotations']) > 0 and len(image_list['lbl_ids']) > 0:
      if uuid_img not in Image:
        Image[uuid_img] = image_info
    else:
      log.info("Empty Label or Annotation: {}".format(filepath_img))
      ## Error
      Error[annon_filename]['empty_annotation'].append(image_info)
      Error[annon_filename]['has_error'] = True
      total_error_empty_ant += 1

  total_stats['total_img'] = total_img
  total_stats['total_ant'] = total_ant
  total_stats['total_lbl'] = total_lbl
  total_stats['total_ant_type'] = [total_ant_type]
  ## Error Stats
  total_stats['total_error_img_notfound'] = Error[annon_filename]['total_error_img_notfound'] = total_error_img_notfound
  total_stats['total_error_unlabeled_ant'] = Error[annon_filename]['total_error_unlabeled_ant'] = total_error_unlabeled_ant
  total_stats['total_error_img_reading'] = Error[annon_filename]['total_error_img_reading'] = total_error_img_reading
  total_stats['total_error_ant'] = Error[annon_filename]['total_error_ant'] = total_error_ant
  total_stats['total_error_empty_ant'] = Error[annon_filename]['total_error_empty_ant'] = total_error_empty_ant

  log.info("Total Annotated File (Images): {}".format(total_img))
  log.info("Total Annotation: {}".format(total_ant))
  log.info("Total Label: {}".format(total_lbl))
  log.info("Total Annotation Type: {}".format(total_ant_type))
  log.info("Total Error: File: Not Found: {}".format(total_error_img_notfound))
  log.info("Total Error: Annotation: Unlabeled: {}".format(total_error_unlabeled_ant))
  log.info("Total Error: File: Reading: {}".format(total_error_img_reading))
  log.info("Total Error: Annotation: {}".format(total_error_ant))
  log.info("Total Error: Empty Annotation: {}".format(total_error_empty_ant))

  log.info("Total Stats: {}".format(total_stats))

  Stats = generate_stats_from_labels(labels, annon_filename)

  annondata = {
    'Dataset':annotations
    ,'Labels':labels
    ,'Total_Stats':total_stats
    ,'Image':Image
    ,'Label':Label
    ,'Annotation_Info':Annotation_Info
    ,'Annotation_Data':Annotation_Data
    ,'Error':Error
    ,'Stats':Stats
  }

  log.debug("Labels: {}".format(labels))
  return annondata


def create_label(ra, AICATS, labels, filter_by=None):
  # log.info("create_label: {}".format(ra.items()))
  if ra:
    for k,v in ra.items():
      if k in AICATS:
        if filter_by is not None:
          if v in filter_by and v not in labels:
            # labels[v] = []
            labels[v] = {}
            # log.info("k,v:{} {}".format(k,v))
        else:
          if v not in labels:
            # labels[v] = []
            labels[v] = {}
            # log.info("k,v:{} {}".format(k,v))
        yield v


def generate_stats_from_labels(labels, annon_filename):
  """Creates Label-wise information and save them into `label-<labelName>.json` and `image-<labelName>.txt` files.

  TODO:
  - type of annotation, and total of each
  - area of enclosed types
  - max, min, mean and avg annotations per label w.r.t total images found for that label
  - % of total coverage w.r.t image
  """
  total = 0
  total_str = ''
  ref = annonutils.parse_annon_filename(annon_filename)
  stats = {
    "rel_filename": annon_filename
    ,"image_rel_date": str(ref['image_rel_date'])
    ,"image_part": ref['image_part']
    ,"annotator_id": ref['annotator_id'] 
    ,"annotation_rel_date": str(ref['annotation_rel_date'])
    ,"annotation_tool": ref['annotation_tool']
    ,"label": []
    ,"image_per_label": []
    ,"annotation_per_label": []
    ,"max_label_per_img": []
    ,"mean_label_per_img": []
    ,"label_per_img": []
    ,"image_name": []
    ,"created_on": common.now()
    ,"modified_on": None
  }

  log.info("\ngenerate_stats_from_labels:-----------------------------")
  for i,gid in enumerate(labels):
    log.info("Image per label: => {}:{}".format(gid,len(labels[gid])))
    stats["label"].append(gid)

    stats["image_per_label"].append(len(labels[gid]))
    image_name = []
    lcount = 0
    label_per_img = []
    for j,g in enumerate(labels[gid].values()):
      image_name.append(g["filename"])

      r = g["regions"]
      total += len(r)
      lcount += len(r)

      label_per_img.append(len(r))

      if j == 0:
        total_str += '('
      
      if j < len(labels[gid].values()) - 1:
        total_str += str(len(r)) +'+'
      else:
        total_str += str(len(r))+')'

    # log.info("labels[gid].keys(): {}".format(labels[gid].keys()))
    stats["annotation_per_label"].append(lcount)

    # log.info("label_per_img: {}".format(label_per_img))
    stats["label_per_img"].append(label_per_img)
    stats["image_name"].append(image_name)
    stats["max_label_per_img"].append(np.max(label_per_img))
    stats["mean_label_per_img"].append(np.mean(label_per_img))

  return stats
