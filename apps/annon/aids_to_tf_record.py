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
import hashlib

from importlib import import_module

import yaml
from easydict import EasyDict as edict

import logging
import logging.config

import contextlib2
import tensorflow as tf

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


def int64_feature(value):
  return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))


def int64_list_feature(value):
  return tf.train.Feature(int64_list=tf.train.Int64List(value=value))


def bytes_feature(value):
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))


def bytes_list_feature(value):
  return tf.train.Feature(bytes_list=tf.train.BytesList(value=value))


def float_list_feature(value):
  return tf.train.Feature(float_list=tf.train.FloatList(value=value))


## Credits: /codehub/external/tensorflow/models/research/object_detection/dataset_tools/tf_record_creation_util.py
def open_sharded_output_tfrecords(exit_stack, base_path, num_shards):
  """Opens all TFRecord shards for writing and adds them to an exit stack.

  Args:
    exit_stack: A context2.ExitStack used to automatically closed the TFRecords
      opened in this function.
    base_path: The base path for all shards
    num_shards: The number of shards

  Returns:
    The list of opened TFRecords. Position k in the list corresponds to shard k.
  """
  tf_record_output_filenames = [
      '{}-{:05d}-of-{:05d}'.format(base_path, idx, num_shards)
      for idx in range(num_shards)
  ]

  # python_io = tf.python_io
  python_io = tf.compat.v1.python_io

  tfrecords = [
      exit_stack.enter_context(python_io.TFRecordWriter(file_name))
      for file_name in tf_record_output_filenames
  ]

  return tfrecords


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


def get_dataset_name(name, subset):
    return name + "_" + subset


def _create_tf_record_from_coco_annotations():
  return


def create_tf_example(image, annotations_list, image_dir, category_index, include_masks=False):
  """Converts image and annotations to a tf.Example proto.
  Args:
    image: dict with keys:
      [u'license', u'file_name', u'coco_url', u'height', u'width',
      u'date_captured', u'flickr_url', u'id']
    annotations_list:
      list of dicts with keys:
      [u'segmentation', u'area', u'iscrowd', u'img_id',
      u'bbox', u'category_id', u'id']
      Notice that bounding box coordinates in the official COCO dataset are
      given as [x, y, width, height] tuples using absolute coordinates where
      x, y represent the top-left (0-indexed) corner.  This function converts
      to the format expected by the Tensorflow Object Detection API (which is
      which is [ymin, xmin, ymax, xmax] with coordinates normalized relative
      to image size).
    image_dir: directory containing the image files.
    category_index: a dict containing COCO category information keyed
      by the 'id' field of each category.  See the
      label_map_util.create_category_index function.
    include_masks: Whether to include instance segmentations masks
      (PNG encoded) in the result. default: False.
  Returns:
    example: The converted tf.Example
    num_annotations_skipped: Number of (invalid) annotations that were ignored.

  Raises:
    ValueError: if the image pointed to by data['filename'] is not a valid JPEG
  """
  image_height = image['height']
  image_width = image['width']
  img_id = image['img_id']
  filename = image['filename']
  # filepath = os.path.join(image_dir, filename)
  filepath = image['filepath']

  # gfile = tf.gfile
  gfile = tf.compat.v1.gfile

  with gfile.GFile(filepath, 'rb') as fid:
    encoded_jpg = fid.read()
  # encoded_jpg_io = io.BytesIO(encoded_jpg)
  # image = PIL.Image.open(encoded_jpg_io)
  key = hashlib.sha256(encoded_jpg).hexdigest()

  xmin = []
  xmax = []
  ymin = []
  ymax = []
  is_crowd = []
  category_names = []
  category_ids = []
  area = []
  encoded_mask_png = []
  num_annotations_skipped = 0
  for object_annotations in annotations_list:
    bbox = object_annotations['bbox'] if type(object_annotations['bbox']) == list else object_annotations['_bbox']
    (x, y, width, height) = tuple(bbox)
    if width <= 0 or height <= 0:
      num_annotations_skipped += 1
      continue
    if x + width > image_width or y + height > image_height:
      num_annotations_skipped += 1
      continue
    xmin.append(float(x) / image_width)
    xmax.append(float(x + width) / image_width)
    ymin.append(float(y) / image_height)
    ymax.append(float(y + height) / image_height)

    iscrowd = object_annotations['iscrowd'] if 'iscrowd' in object_annotations else 0
    is_crowd.append(iscrowd)

    # category_id = int(object_annotations['category_id'])
    category_id = object_annotations['lbl_id'] if 'lbl_id' in object_annotations else int(object_annotations['category_id'])
    category_ids.append(category_id)

    # lbl_id = category_index[category_id]['name']
    lbl_id = category_index[category_id]['name'] if 'name' in category_index[category_id] else category_id
    category_names.append(lbl_id.encode('utf8'))

    bboxarea = object_annotations['bboxarea'] if 'bboxarea' in object_annotations else object_annotations['area']
    area.append(bboxarea)

    if include_masks:
      run_len_encoding = mask.frPyObjects(object_annotations['segmentation'],
                                          image_height, image_width)
      binary_mask = mask.decode(run_len_encoding)
      if not object_annotations['iscrowd']:
        binary_mask = np.amax(binary_mask, axis=2)
      pil_image = PIL.Image.fromarray(binary_mask)
      output_io = io.BytesIO()
      pil_image.save(output_io, format='PNG')
      encoded_mask_png.append(output_io.getvalue())

  feature_dict = {
      'image/height':
          int64_feature(image_height),
      'image/width':
          int64_feature(image_width),
      'image/filename':
          bytes_feature(filename.encode('utf8')),
      'image/source_id':
          bytes_feature(str(img_id).encode('utf8')),
      'image/key/sha256':
          bytes_feature(key.encode('utf8')),
      'image/encoded':
          bytes_feature(encoded_jpg),
      'image/format':
          bytes_feature('jpeg'.encode('utf8')),
      'image/object/bbox/xmin':
          float_list_feature(xmin),
      'image/object/bbox/xmax':
          float_list_feature(xmax),
      'image/object/bbox/ymin':
          float_list_feature(ymin),
      'image/object/bbox/ymax':
          float_list_feature(ymax),
      'image/object/class/text':
          bytes_list_feature(category_names),
      'image/object/is_crowd':
          int64_list_feature(is_crowd),
      'image/object/area':
          float_list_feature(area),
  }
  if include_masks:
    feature_dict['image/object/mask'] = (
        dataset_util.bytes_list_feature(encoded_mask_png))
  example = tf.train.Example(features=tf.train.Features(feature=feature_dict))
  return key, example, num_annotations_skipped


def get_dataset_dicts(cfg, class_ids, id_map, imgs, anns, bbox_mode):
    # print(anns)

    ## => quick hack for running detectron2 with gaze data
    ## TODO: Convert to COCO -> if done in pre-processing, this step not required here

    imgs_anns = list(zip(imgs, anns))
    dataset_dicts = []
    extra_annotation_keys=None

    ## TODO: iscrowd is available in attributes as something like group
    ann_keys = ["iscrowd", "bbox", "keypoints", "category_id", "lbl_id"] + (extra_annotation_keys or [])
    num_instances_without_valid_segmentation = 0

    # print("imgs_anns: {}".format(imgs_anns[:2]))

    for (img_dict, anno_dict_list) in imgs_anns:
        # print("img_dict: {}".format(img_dict))
        # print("anno_dict_list: {}".format(len(anno_dict_list)))

        filtered_anns = []
        for key in anno_dict_list:
            if key["ant_type"]=="polygon":
                filtered_anns.append(key)

        # print("img_dict: {}".format(img_dict))
        # print("anno_dict_list: {}".format(len(anno_dict_list)))
        # print("filtered_anns: {}".format(len(filtered_anns)))
        # print("filtered_anns: {}".format(filtered_anns))
        # print("anno_dict_list: {}".format(anno_dict_list))
        if len(filtered_anns)!=0:
            image_path = apputil.get_abs_path(cfg, img_dict, 'AI_ANNON_DATA_HOME_LOCAL') ##image_root
            filepath = os.path.join(image_path, img_dict['filename'])
            record = {}
            record["file_name"] = filepath
            record["height"] = img_dict["height"]
            record["width"] = img_dict["width"]
            image_id = record["image_id"] = img_dict["img_id"] ## coco: id

            objs = []
            # for anno in anno_dict_list:
            for anno in filtered_anns:
                if anno["ant_type"]=="polygon":
                    assert anno["img_id"] == image_id ## image_id
                    obj = {key: anno[key] for key in ann_keys if key in anno}
                    ##TODO: convert bbbox to coco format
                    _bbox = obj['bbox']

                    ##TODO: verify what is BoxMode.XYWH_ABS
                    coco_frmt_bbox = [_bbox['xmin'], _bbox['ymin'], _bbox['width'], _bbox['height'] ]
                    #print("coco_frmt_bbox: {}".format(coco_frmt_bbox))
                    obj['bbox'] = coco_frmt_bbox
                    ## TODO: get polygon from shape_attributes and convert to coco format
                    #segm = anno.get("segmentation", None)


                    # assert not anno["region_attributes"]
                    # segm=None

                    # if anno["ant_type"]=="polygon":
                    anno = anno["shape_attributes"]
                    # print("anno: {}".format(anno))
                    px = anno["all_points_x"]
                    py = anno["all_points_y"]
                    poly = [(x + 0.5, y + 0.5) for x, y in zip(px, py)]
                    poly = [p for x in poly for p in x]

                    segm = [poly]

                    if segm:  # either list[list[float]] or dict(RLE)
                        if not isinstance(segm, dict):
                            # filter out invalid polygons (< 3 points)
                            segm = [poly for poly in segm if len(poly) % 2 == 0 and len(poly) >= 6]
                            if len(segm) == 0:
                                num_instances_without_valid_segmentation += 1
                                continue  # ignore this instance
                            obj["segmentation"] = segm

                    obj["bbox_mode"] = bbox_mode
                    obj["category_id"] = id_map[obj["lbl_id"]] ## category_id
                    objs.append(obj)

            record["annotations"] = objs
            dataset_dicts.append(record)

    return dataset_dicts


def create_tfr(args, appcfg):
  """
  create tf record data compatible with object detection API of tensorflow and for tensorflow training in general
  """
  name = args.did
  subset = args.subset
  dbname = args.dataset
  num_shards = args.num_shards
  output_basepath = args.output_basepath

  output_dir = dbname
  if name:
    output_dir = name+"-"+dbname

  ## TODO: create a standard path in aimldl workflow
  output_basepath = os.path.join(output_basepath, output_dir)
  log.info("output_path: {}".format(output_basepath))
  common.mkdir_p(output_basepath)
  # output_path = os.path.join(output_basepath, output_dir)
  output_path = output_basepath
  log.info("output_path: {}".format(output_path))

  # dataset_name = get_dataset_name(name, subset)
  class_ids, id_map, imgs, anns = apputil.get_data(appcfg, subset=subset, dbname=dbname)
  log.info("class_ids, id_map: {}, {}".format(class_ids, id_map))

  category_index = id_map

  include_masks = False
  total_num_annotations_skipped = 0
  with contextlib2.ExitStack() as tf_record_close_stack:
    output_tfrecords = open_sharded_output_tfrecords(tf_record_close_stack, output_path, num_shards)

    for idx, image in enumerate(imgs):
      if idx % num_shards == 0:
        logging.info('On image %d of %d', idx, len(imgs))
      
      image_dir = os.path.dirname(image['filepath'])
      anns_items = anns[idx]
      _, tf_example, num_annotations_skipped = create_tf_example(
        image
        ,anns_items
        ,image_dir
        ,category_index
        ,include_masks
      )

      total_num_annotations_skipped += num_annotations_skipped
      shard_idx = idx % num_shards
      output_tfrecords[shard_idx].write(tf_example.SerializeToString())

    logging.info('Finished writing, skipped %d annotations.', total_num_annotations_skipped)

   # _create_tf_record_from_coco_annotations(
   #    FLAGS.train_annotations_file,
   #    FLAGS.train_image_dir,
   #    train_output_path,
   #    FLAGS.include_masks,
   #    num_shards=100)

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
      ## Within the specific command, route to python module for specific architecture
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

  # host = '10.4.71.69'
  # ai_annon_data_home_local = '/aimldl-dat/data-gaze/AIML_Annotation/ods_job_trafficsigns'

  parser.add_argument('--dataset'
    ,dest='dataset'
    ,metavar="/path/to/<name>.yml or AIDS (AI Dataset) database name"
    ,required=True
    # ,default='PXL-270220_175734'
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
    ,default='100'
    ,required=False)

  parser.add_argument('--to'
    ,dest='output_basepath'
    ,help='output_basepath'
    ,default='/aimldl-dat/tfrecords'
    ,required=False)

  args = parser.parse_args()    

  return args


if __name__ == '__main__':
  """
  Example:
  python aids_to_tf_record.py --dataset PXL-270220_175734
  python aids_to_tf_record.py --dataset PXL-130220_034525 --ai_annon_data_home_local /aimldl-dat/data-public/ms-coco-1/val2014
  python aids_to_tf_record.py --dataset PXL-130220_034525

  # name = "hmd"
  # subset = "train"

  # dbname = "PXL-291119_180404"
  # exp_id = "train-422d30b0-f518-4203-9c4d-b36bd8796c62"

  # dbname = "PXL-270220_175734"
  # exp_id = None
  """
  args = parse_args()
  log.debug("args: {}".format(args))
  main(args)

