__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation workflow.
# Create the TFRecord format from in a coco format for object detection and segmentation
#
# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
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
import logging
import hashlib
import contextlib2

import tensorflow as tf

log = logging.getLogger('__main__.'+__name__)

## Ref: https://www.geeksforgeeks.org/class-method-vs-static-method-python/
class TFProtobuf():
  def __init__(self):
    return

  @staticmethod
  def int64_feature(value):
    return tf.train.Feature(int64_list=tf.train.Int64List(value=[value]))

  @staticmethod
  def int64_list_feature(value):
    return tf.train.Feature(int64_list=tf.train.Int64List(value=value))

  @staticmethod
  def bytes_feature(value):
    return tf.train.Feature(bytes_list=tf.train.BytesList(value=[value]))

  @staticmethod
  def bytes_list_feature(value):
    return tf.train.Feature(bytes_list=tf.train.BytesList(value=value))

  @staticmethod
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


def create_tf_example_annon(image, annotations_list, image_dir, category_index, include_masks=False):
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

    log.debug("category_index:{}".format(category_index))
    log.debug("category_id:{}".format(category_id))
    # lbl_id = category_index[category_id]['name']
    lbl_id = category_index[category_id]['name'] if type(category_index[category_id]) is dict and 'name' in category_index[category_id] else category_id
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

    feature_dict_schema = [
      ['image/height',['int64','image_height']]
      ,['image/width',['int64','image_width']]
      ,['image/filename',['bytes','filename','utf8']]
      ,['image/source_id',['bytes','img_id','utf8']]
      ,['image/key/sha256',['bytes','key','utf8']]
      ,['image/encoded',['bytes','encoded_jpg']]
      ,['image/format',['bytes','jpeg','utf8']]
      ,['image/object/bbox/xmin',['float_list','xmin']]
      ,['image/object/bbox/xmax',['float_list','xmax']]
      ,['image/object/bbox/ymin',['float_list','ymin']]
      ,['image/object/bbox/ymax',['float_list','ymax']]
      ,['image/object/class/text',['bytes_list','category_names']]
      ,['image/object/is_crowd',['int64_list','is_crowd']]
      ,['image/object/area',['float_list','area']]
      ,['image/object/mask',['bytes_list','encoded_mask_png']]
    ]

    ## TODO: make TFViewer compatible to non-coco data format
    ## * https://github.com/sulc/tfrecord-viewer.git
    ## https://stackoverflow.com/questions/18425225/getting-the-name-of-a-variable-as-a-string
    _fd = {}
    localitems = locals().items()
    log.debug("localitems.keys: {}".format(dict(localitems).keys()))
    for item in feature_dict_schema:
      fn = getattr(TFProtobuf, item[1][0]+'_feature')
      # log.info("item[1][1]: {}".format(item[1][1]))
      _val = None
      _key = None
      for k,v in localitems:
        if k == item[1][1]:
          _val = v
          _key = k
          break
      if len(item[1]) == 3:
        _val = str(_val).encode(item[1][2])

      if _val:
        _fd[item[0]] = fn(_val)
      else:
        log.debug("_key, _val: {}, {}".format(_key, _val))


    feature_dict = _fd

  # feature_dict = {
  #     'image/height': TFProtobuf.int64_feature(image_height),
  #     'image/width': TFProtobuf.int64_feature(image_width),
  #     'image/filename': TFProtobuf.bytes_feature(filename.encode('utf8')),
  #     'image/source_id': TFProtobuf.bytes_feature(str(img_id).encode('utf8')),
  #     'image/key/sha256': TFProtobuf.bytes_feature(key.encode('utf8')),
  #     'image/encoded': TFProtobuf.bytes_feature(encoded_jpg),
  #     'image/format': TFProtobuf.bytes_feature('jpeg'.encode('utf8')),
  #     'image/object/bbox/xmin': TFProtobuf.float_list_feature(xmin),
  #     'image/object/bbox/xmax': TFProtobuf.float_list_feature(xmax),
  #     'image/object/bbox/ymin': TFProtobuf.float_list_feature(ymin),
  #     'image/object/bbox/ymax': TFProtobuf.float_list_feature(ymax),
  #     'image/object/class/text': TFProtobuf.bytes_list_feature(category_names),
  #     'image/object/is_crowd': TFProtobuf.int64_list_feature(is_crowd),
  #     'image/object/area': TFProtobuf.float_list_feature(area),
  # }
  # if include_masks:
  #   feature_dict['image/object/mask'] = (TFProtobuf.bytes_list_feature(encoded_mask_png))

  example = tf.train.Example(features=tf.train.Features(feature=feature_dict))

  return key, example, num_annotations_skipped


def main(imgs, anns, category_index, tfrconfig):
  total_num_annotations_skipped = 0
  output_path = tfrconfig.output_path
  num_shards = tfrconfig.num_shards
  include_masks = tfrconfig.include_masks

  log.info("output_path: {}".format(output_path))
  log.info("num_shards: {}".format(num_shards))
  log.info("include_masks: {}".format(include_masks))

  with contextlib2.ExitStack() as tf_record_close_stack:
    output_tfrecords = open_sharded_output_tfrecords(tf_record_close_stack, output_path, num_shards)

    for idx, img in enumerate(imgs):
      if idx % num_shards == 0:
        log.info('On img %d of %d', idx, len(imgs))
      
      image_path = tfrconfig.get_image_path(img)
      log.debug("image_path: {}".format(image_path))

      if not img['filepath']:
        filepath = os.path.join(image_path, img['filename'])
        img['filepath'] = filepath

      log.debug("img['filepath']: {}".format(img['filepath']))
      image_dir = os.path.dirname(image_path)
      anns_items = anns[idx]
      _, tf_example, num_annotations_skipped = create_tf_example_annon(
        img
        ,anns_items
        ,image_dir
        ,category_index
        ,include_masks
      )

      total_num_annotations_skipped += num_annotations_skipped
      shard_idx = idx % num_shards
      output_tfrecords[shard_idx].write(tf_example.SerializeToString())

    log.info('Finished writing, skipped %d annotations.', total_num_annotations_skipped)
