__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
Generic Annotation Dataset Parser

------------------------------------------------------------
Copyright (c) 2020 mangalbhaskar
Licensed under [see LICENSE for details]
Written by mangalbhaskar
------------------------------------------------------------
"""
import os

import numpy as np

import skimage.io
import skimage.draw
import json

import sys
import logging

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

## custom imports
import common
import apputil

from Base import Dataset
from annon.dataset.Annon import ANNON

log = logging.getLogger('__main__.'+__name__)


class AnnonDataset(Dataset):
  name = ""
  # num_classes = 0
  annon_type = ""
  pyclassid = None
  annon = None

  def __init__(self, name=None):
    self.pyclassid = self.__class__

    super(self.__class__, self).__init__()
    self.name = name


  def add_class(self, source, idx, class_name, lbl_id=None, color=None):
    super(self.__class__, self).add_class(source, idx, class_name, lbl_id, color)
    return


  def add_image(self, source, image_id, path, **kwargs):
    super(self.__class__, self).add_image(source, image_id, path, **kwargs)
    return


  def get_classid_from_source_class_name(self, source_class_name):
    class_id = self.classname_from_sourcename_map[source_class_name]
    if not class_id:
      class_id = super(self.__class__, self).get_classid_from_source_class_name(source_class_name)
    return class_id


  def get_classid_from_source_class_id(self, source_class_id):
    log.info("source_class_id: {}".format(source_class_id))
    class_id = self.class_from_source_map[source_class_id]
    if not class_id:
      class_id = super(self.__class__, self).get_classid_from_source_class_id(source_class_id)
    return class_id


  def get_classname_from_source_class_id(self, source_class_id):
    class_name = self.classname_from_source_map[source_class_id]
    if not class_name:
      class_name = super(self.__class__, self).get_classname_from_source_class_id(source_class_id)
    return class_name


  def load_data(self, appcfg, dbcfg, datacfg, subset):
    """
    load the data based on the annotation type
    """
    log.info("--------------------------------> {}".format(subset))

    # if subset:
    #   splits = datacfg.splits
    #   # Train or validation or testing dataset?
    #   assert subset in splits

    log.info("load_data:-----> {}".format(datacfg.name))
    
    annon_type = datacfg.annon_type

    fname = 'load'+'_'+annon_type
    log.info("load_data::fname: {}".format(fname))

    fn = getattr(self, fname)

    ## TBD: raise unknown error
    if fn:
      return fn(appcfg=appcfg, dbcfg=dbcfg, datacfg=datacfg, subset=subset)
    else:
      log.info("Unknown fn: {}".format(fname))
      return


  def load_labelImg(self, appcfg, dbcfg, datacfg, subset):
    """
    labelImg specific CSV header:
    ,Image Server Path,Dest Path,Top,Left,Width,Height,Label
    log.info("Top,Left,Width,Height,Label")

    - assume data in csv file format
    TODO:
    - json file data loading
    """

    log.info("AnnonDataset::load_labelImg::-------------------------------->")

    annotation_filename = datacfg['annotations']
    images_dir = datacfg['images']
    log.info("annotation_filename: {}".format(annotation_filename))
    log.info("images_dir: {}".format(images_dir))

    annon_type = datacfg.annon_type
    name = datacfg.name
    fixed_lbl_id = datacfg.single_class if 'single_class' in datacfg else None
    # class_ids = []

    total_annotation = 0
    total_img = 0
    images = set()
    class_labels = set()
    data_read_threshold = datacfg.data_read_threshold if 'data_read_threshold' in datacfg else 0
    log.info("data_read_threshold: {}".format(data_read_threshold))

    ## Add images
    for line in common.read_csv_line(annotation_filename):
      if data_read_threshold == total_img:
        log.info("Threshold reached: total_img: {}".format(total_img))
        break

      image_name = line[1].split("\\")[-1]
      # image_path = os.path.join(images_dir, image_name)
      filepath = os.path.join(images_dir, image_name)

      # image_path = apputil.get_abs_path(appcfg, img, 'AI_ANNON_DATA_HOME_LOCAL')
      # filepath = os.path.join(image_path, filename)
      # log.debug("filepath: {}".format(filepath))

      if os.path.exists(filepath):
          images.add(filepath)

          lbl_id = line[-1]
          lbl_id = fixed_lbl_id if fixed_lbl_id else lbl_id.lower().replace(' ','_')

          attributes = {}
          class_labels.add(lbl_id)
          # log.info("lbl_id: {}".format(lbl_id))
          if 'height' not in img or 'width' not in img:
            im = skimage.io.imread(filepath)
            height, width = im.shape[:2]
          else:
            height, width = img['height'], img['width']
          # log.info("height, width: {} {}".format(height, width))
          # log.info("{}, {}, {},{},{},{},{}".format(image_name, line[-6], line[-5], line[-4], line[-3], line[-2], line[-1]))
          # count += 1
          ## top(y), left(x), height, width
          annotations = [int(line[-5]), int(line[-4]), int(line[-2]), int(line[-3])]
          # log.info("bbox: {}".format(annotations))
          total_annotation += 1
          
          attributes['lbl_id'] = lbl_id

          self.add_image(
            name,
            image_id=name+'-'+image_name,  # use file name as a unique image id
            path=filepath,
            width=width,
            height=height,
            annon_type=annon_type,
            annotations=annotations,
            attributes=attributes)

    total_img = len(images)
    total_classes = len(class_labels)

    # for index, class_name in enumerate(class_ids):
    for index, class_name in enumerate(list(class_labels)):
      class_id = index+1
      log.info("name, class_id ,class_name: {},{},{}".format(name, class_id, class_name))
      ## "source_name", "id", "name"
      self.add_class(name, class_id, class_name)

    log.info("Total Images: {}".format(total_img))
    log.info("Total Annotations: {}".format(total_annotation))
    log.info("Total Classes: {}".format(total_classes))
    log.info("Class Labels, Total class_labels: {}".format(class_labels, len(class_labels)))
    log.info("-------")

    return total_img, total_annotation, total_classes


  def load_via(self, appcfg, dbcfg, datacfg, subset):
    """
    Load dataset
    VGG Image Annotator (up to version 1.6) saves each image in the form:
    { 'filename': '28503151_5b5b7ec140_b.jpg',
      'regions': {
          '0': {
              'region_attributes': {},
              'shape_attributes': {
                  'all_points_x': [...],
                  'all_points_y': [...],
                  'name': 'polygon'}},
          ... more regions ...
      },
      'size': 100202
    }
    We mostly care about the x and y coordinates of each region
    Note: In VIA 2.0, regions was changed from a dict to a list.

    - assume default file extension is json
    TODO:
    - csv file loading
    """

    log.info("AnnonDataset::load_json_via::-------------------------------->")

    annotation_filename = datacfg['ANNOTATIONS']
    images_dir = datacfg['IMAGES']
    log.info("annotation_filename: {}".format(annotation_filename))
    log.info("images_dir: {}".format(images_dir))

    annon_type = datacfg.annon_type
    name = datacfg.name
    fixed_lbl_id = datacfg.single_class if 'SINGLE_CLASS' in datacfg else None
    # class_ids = []

    with open(annotation_filename,'r') as fr:
      dataset = json.load(fr)
      dataset = list(dataset.values())  # don't need the dict keys
      # log.info("dataset: {}".format(dataset))
      # The VIA tool saves images in the JSON even if they don't have any
      # dataset. Skip unannotated images.
      dataset = [a for a in dataset if a['regions']]

    total_annotation = 0
    total_img = 0
    class_labels = set()
    data_read_threshold = datacfg.data_read_threshold if 'data_read_threshold' in datacfg else 0
    log.info("data_read_threshold: {}".format(data_read_threshold))

    ## Add images
    for i, a in enumerate(dataset):
      if data_read_threshold == i:
        log.info("Threshold reached: i: {}".format(i))
        break

      # Get the x, y coordinaets of points of the polygons that make up
      # the outline of each object instance. These are stores in the
      # shape_attributes (see json format above)
      # The if condition is needed to support VIA versions 1.x and 2.x.
      if type(a['regions']) is dict:
        annotations = [r['shape_attributes'] for r in a['regions'].values()]
        attributes = [r['region_attributes'] for r in a['regions'].values()]
      else:
        annotations = [r['shape_attributes'] for r in a['regions']]
        attributes = [r['region_attributes'] for r in a['regions']]

      # log.info("attributes: {}".format(attributes))
      # log.info("annotations, len(annotations): {},{}".format(annotations, len(annotations)))
      # load_mask() needs the image size to convert polygons to masks.
      # Unfortunately, VIA doesn't include it in JSON, so we must read
      # the image. This is only managable since the dataset is tiny.
      image_name = a['filename']
      # image_path = os.path.join(images_dir, a['filename'])
      filepath = os.path.join(images_dir, a['filename'])

      # image_path = apputil.get_abs_path(datacfg, img, 'AI_ANNON_DATA_HOME_LOCAL')
      # filepath = os.path.join(image_path, filename)
      # log.debug("filepath: {}".format(filepath))

      total_annotation_per_img = len(annotations)
      # log.info("{}: {}".format(image_name, total_annotation_per_img))
      for j in range(0, len(annotations)):
        if attributes[j] == {}:
          attributes[j]['lbl_id'] = fixed_lbl_id
          class_labels.add(fixed_lbl_id)
        elif 'lbl_id' in attributes[j]:
          class_labels.add(attributes[j]['lbl_id'])

      total_annotation += total_annotation_per_img
      ## TBD: width and height from a['file_attributes']['width'], a['file_attributes']['height']

      if os.path.exists(filepath):

        if 'height' not in img or 'width' not in img:
          im = skimage.io.imread(filepath)
          height, width = im.shape[:2]
        else:
          height, width = img['height'], img['width']

        self.add_image(
          name,
          image_id=name+'-'+image_name,  # use file name as a unique image id
          path=filepath,
          width=width,
          height=height,
          annon_type=annon_type,
          annotations=annotations,
          attributes=attributes)


    total_img = len(dataset)
    total_classes = len(class_labels)

    for index, class_name in enumerate(class_labels):
      class_id = index+1
      log.info("name, index, class_name: {}, {}, {}".format(name, class_id, class_name))
      ## "source_name", "id", "name"
      self.add_class(name, class_id, class_name)
      # self.add_class(name, class_name, class_name)

    log.info("Total Images: {}".format(total_img))
    log.info("Total Annotations: {}".format(total_annotation))
    log.info("Total Classes: {}".format(total_classes))
    log.info("Class Labels, Total class_labels: {}".format(class_labels, len(class_labels)))
    log.info("-------")

    return total_img, total_annotation, total_classes


  def load_hmd(self, appcfg, dbcfg, datacfg, subset):
    """
    - assume default file extension is json
    TODO:
    - csv file loading
    """
    log.info("-------------------------------->")
    log.debug("datacfg: {}".format(datacfg))

    class_ids = datacfg.class_ids if 'class_ids' in datacfg and datacfg['class_ids'] else []
    annon_type = datacfg.annon_type
    name = datacfg.name

    # class_map = datacfg.class_map if datacfg.class_map else None


    annon = self.annon = ANNON(dbcfg, datacfg, subset=subset)

    class_ids = annon.getCatIds(catIds=class_ids)
    image_ids = annon.getImgIds(catIds=class_ids)

    # log.debug("subset, image_ids: {}, {}".format(subset, image_ids))
    log.debug("subset, class_ids: {}, {}".format(subset, class_ids))

    ## Add images
    total_annotation = 0
    total_maskarea = 0
    total_bboxarea = 0
    data_read_threshold = datacfg.data_read_threshold if 'data_read_threshold' in datacfg else -1
    log.debug("data_read_threshold: {}".format(data_read_threshold))

    images = annon.loadImgs(ids=image_ids)
    for i, img in enumerate(images):
      if data_read_threshold == i:
        log.info("Threshold reached: i: {}".format(i))
        break

      # log.debug("img: {}".format(img))
      image_path = apputil.get_abs_path(appcfg, img, 'AI_ANNON_DATA_HOME_LOCAL')
      filepath = os.path.join(image_path, img['filename'])
      # log.debug("filepath: {}".format(filepath))
      ## TBD: width and height from a['file_attributes']['width'], a['file_attributes']['height']
      if os.path.exists(filepath):
        try:
          ##log.info("Image file: {}".format(filepath))
          if 'height' not in img or 'width' not in img:
            im = skimage.io.imread(filepath)
            height, width = im.shape[:2]
          else:
            height, width = img['height'], img['width']
          # width = annon.imgs[i]["width"]
          # height = annon.imgs[i]["height"]
          img_id = img['img_id']

          annotations = annon.loadAnns(annon.getAnnIds(imgIds=[img_id], catIds=class_ids))
          total_annotation += len(annotations)

          self.add_image(
            name,
            image_id=name+'-'+str(img_id),
            path=filepath,
            width=width,
            height=height,
            annon_type=annon_type,
            annotations=annotations)
        except:
          log.info("Error Reading file or adding annotation: {}".format(filepath))
          log.error("Exception occurred", exc_info=True)
      else:
        log.info("file does not exists: {}".format(filepath))


    total_img = len(image_ids)
    total_classes = len(class_ids)

    classinfo = annon.loadCats(ids=class_ids)

    for index, ci in enumerate(classinfo):
      class_idx = index+1
      class_source, class_lbl_id, class_name = ci['source'], ci['lbl_id'], ci['name']
      log.info("Adding: class_source, class_lbl_id, class_name, class_dx: {}, {}, {}".format(class_source, class_lbl_id, class_name, class_idx))
      self.add_class(source=class_source, idx=class_idx, class_name=class_name, lbl_id=class_lbl_id, color=None)

    log.info("Total Images: {}".format(total_img))
    log.info("Total Annotations: {}".format(total_annotation))
    log.info("Total Classes without BG: {}".format(total_classes))
    log.info("Total Classes including BG: {}".format(len(self.classinfo)))
    log.info("Classinfo: {}".format(self.classinfo))
    log.info("-------")

    return total_img, total_annotation, total_classes, annon


  def load_json_coco(self, appcfg, dbcfg, datacfg, subset):
    log.info("AnnonDataset::load_json_coco::-------------------------------->")
    # log.info("AnnonDataset::datacfg: {}".format(datacfg))

    import CocoDataset
    dataclass = self

    cocodataset = CocoDataset.CocoDataset("coco", dataclass)

    self.cocodataset = cocodataset
    total_img, total_annotation, total_classes = cocodataset.load_data(datacfg['SUBSET'], datacfg, datacfg['CLASS_IDS'], datacfg['CLASS_MAP'])

    # log.info("Total Images: {}".format(total_img))
    # log.info("Total Annotations: {}".format(total_annotation))
    # log.info("Total Classes: {}".format(total_classes))
    # log.info("-------")

    return total_img, total_annotation, total_classes


  def load_mask(self, image_id, datacfg=None, config=None):
    """Load instance masks for the given image.

    Different datasets use different ways to store masks. This
    function converts the different mask format to one format
    in the form of a bitmap [height, width, instances].

    Returns:
    masks: A bool array of shape [height, width, instance count] with
        one mask per instance.
    class_ids: a 1D array of class IDs of the instance masks.
    """

    # log.debug("---------------------------->")
    # log.debug("datacfg:{}".format(datacfg))

    info = self.image_info[image_id]
    # log.info("Info: {}".format(info))

    name = datacfg.name if datacfg and datacfg.name else None
    # log.debug("info: {}".format(info))

    ## route to proper load_mask_<annon_type>
    ##------------------------------------------
    annon_type = ''
    if "annon_type" in info:
      annon_type = info["annon_type"]
    elif "source" in info:
      ## coco has source key used to route to proper load_mask function
      annon_type = info["source"]

    fname = 'load_mask_'+annon_type
    ds_source = info["source"]

    # log.info("load_mask::fname: {}".format(fname))

    ## Testing for proper routing, uncomment print statement to debug unknown source and image mapping
    # log.info("-------")
    # log.info("load_mask::name, annon_type, fname, ds_source: {}, {}, {}, {}".format(name, annon_type, fname, ds_source))

    # If not a self.name image, delegate to parent class.
    ##---------------------------------------------------

    # log.debug("ds_source != name, ds_source, name: {}, {}, {}".format(ds_source != name, ds_source, name))

    if ds_source != name:
        return super(self.__class__, self).load_mask(image_id)

    # if datacfg and 'NAME' in datacfg:
    #   if ds_source != datacfg.name:
    #     return super(self.__class__, self).load_mask(image_id)
    # else:
    #   if ds_source != name:
    #     return super(self.__class__, self).load_mask(image_id)

    fn = getattr(self, fname)

    ## TBD: raise unknown error
    if fn:
      return fn(image_id, info, datacfg, config)
    else:
      log.info("Unknown fn: {}".format(fname))
      return


  def load_mask_coco(self, image_id, info, datacfg=None, config=None):
    # log.info("AnnonDataset::load_mask_coco")

    cocodataset = self.cocodataset

    return cocodataset.load_mask(image_id, datacfg)


  def load_mask_via(self, image_id, info, datacfg=None, config=None):
    # log.info("AnnonDataset::load_mask_via")

    annotations = info["annotations"]
    attributes = info["attributes"]

    name = datacfg.name
    # log.info("name: {}".format(name))

    instance_masks = []
    class_ids = []
    class_labels = []


    # class_ids = datacfg.classes
    # log.info("debug------------------------")
    # log.info("len(annotations): {}".format(len(annotations)))
    # log.info("len(attributes): {}".format(len(attributes)))
    # log.info("annotations: {}".format(annotations))
    # log.info("attributes: {}".format(attributes))

    # log.info("datacfg.classes: {}".format(datacfg.classes))


    # log.info("self:...{},{},{}".format(self.class_ids, self.class_names, self.num_classes))
    # log.info("classinfo:...{}".format(self.classinfo))
    # log.info("classname_from_source_map:...{}".format(self.classname_from_source_map))
    # log.info("classname_from_sourcename_map:...{}".format(self.classname_from_sourcename_map))

    mask = np.zeros([info["height"], info["width"], len(annotations)], dtype=np.uint8)
    # mask = np.zeros([info["height"], info["width"]], dtype=np.uint8)

    for i, ann in enumerate(annotations):
      # Get indexes of pixels inside the polygon and set them to 1
      # rr, cc = skimage.draw.polygon(ann['all_points_y'], ann['all_points_x'])

      lbl_id = attributes[i]['lbl_id']
      # log.info("lbl_id: {}".format(lbl_id))

      ct_class_id = self.get_classid_from_source_class_name( name+".{}".format(lbl_id) )
      # log.info("ct_class_id: {}".format(ct_class_id))

      class_id = self.classinfo[ct_class_id]['id']
      # log.info("class_id: {}".format(class_id))
      class_label = self.get_classname_from_source_class_id( name+".{}".format(class_id) )
      # log.info("class_label: {}".format(class_label))
      # log.info("lbl_id, lbl_name: {}, {}".format(class_id, class_label))

      assert lbl_id == class_label

      if class_id:
        class_ids.append(ct_class_id)

      if class_label:
        class_labels.append(class_label)

      rr, cc = self.ann_to_geometry_via(ann)


      # log.info("mask.shape, min(mask),max(mask): {}, {},{}".format(mask.shape, np.min(mask),np.max(mask)))
      # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
      # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

      ## Note that this modifies the existing array arr, instead of creating a result array
      ## Ref: https://stackoverflow.com/questions/19666626/replace-all-elements-of-python-numpy-array-that-are-greater-than-some-value
      rr[rr > mask.shape[0]-1] = mask.shape[0]-1
      cc[cc > mask.shape[1]-1] = mask.shape[1]-1

      # log.info("After fixing the dirt mask, new values:")        
      # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
      # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))
      mask[rr, cc, i] = 1

    keys = ['image_name', 'image_id', 'image_source', 'class_ids', 'class_labels']
    values = [self.image_info[image_id]['id'], image_id, self.image_info[image_id]['source'], class_ids, class_labels]

    if class_ids:
      # mask = np.stack(instance_masks, axis=2).astype(np.bool)
      class_ids = np.array(class_ids, dtype=np.int32)

    # Return mask, and array of class IDs of each instance. Since we have
    # one class ID only, we return an array of 1s
    # return mask.astype(np.bool), np.ones([mask.shape[-1]], dtype=np.int32), keys, values
    return mask.astype(np.bool), class_ids, keys, values


  def load_mask_labelImg(self, image_id, info, datacfg=None, config=None):
    # log.info("AnnonDataset::load_mask_labelImg")
    name = datacfg.name
    annotations = info["annotations"]
    attributes = info["attributes"]

    class_ids = []
    class_labels = []

    # log.info("debug------------------------")
    # log.info("len(annotations): {}".format(len(annotations)))
    # log.info("len(attributes): {}".format(len(attributes)))
    # log.info("annotations: {}".format(annotations))
    # log.info("attributes: {}".format(attributes))


    # log.info("-------------")
    # log.info("source_class_ids: {}".format(self.source_class_ids))
    # log.info("-------------")
    # log.info("class_ids, class_names, num_classes: {},{},{}".format(self.class_ids, self.class_names, self.num_classes))
    # log.info("-------------")
    # log.info("classinfo: {}".format(self.classinfo))
    # log.info("-------------")
    # log.info("classname_from_source_map: {}".format(self.classname_from_source_map))
    # log.info("-------------")
    # log.info("classname_from_sourcename_map: {}".format(self.classname_from_sourcename_map))
    # log.info("-------------")

    # all_class_ids = self.source_class_ids[name]
    # log.info("all_class_ids: {}".format(all_class_ids))

    # mask = np.zeros([info["height"]+1, info["width"]+1, len(annotations)], dtype=np.uint8)
    # Build mask of shape [height, width, len(annotations)] and list
    # of class IDs that correspond to each channel of the mask.

    mask = np.zeros([info["height"], info["width"], 1], dtype=np.uint8)

    lbl_id = attributes['lbl_id']
    # log.info("lbl_id: {}".format(lbl_id))

    ct_class_id = self.get_classid_from_source_class_name("{}.{}".format(name, lbl_id) )
    # log.info("ct_class_id: {}".format(ct_class_id))

    class_id = self.classinfo[ct_class_id]['id']
    # log.info("class_id: {}".format(class_id))
    class_label = self.get_classname_from_source_class_id("{}.{}".format(name, class_id) )
    # log.info("class_label: {}".format(class_label))
    # log.info("lbl_id, lbl_name: {}, {}".format(class_id, class_label))

    assert lbl_id == class_label

    if class_label:
      class_labels.append(class_label)

    if class_id:
      class_ids.append(ct_class_id)

    # log.info("mask.shape, min(mask),max(mask): {}, {},{}".format(mask.shape, np.min(mask),np.max(mask)))

    # Get indexes of pixels inside the bbox and set them to 1
    rr, cc = self.ann_to_geometry_labelImg(annotations)

    ## Note that this modifies the existing array arr, instead of creating a result array
    ## Ref: https://stackoverflow.com/questions/19666626/replace-all-elements-of-python-numpy-array-that-are-greater-than-some-value
    rr[rr > mask.shape[0]-1] = mask.shape[0]-1
    cc[cc > mask.shape[1]-1] = mask.shape[1]-1

    # log.info("After fixing the dirt mask, new values:")
    # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
    # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

    mask[rr, cc, 0] = 1

    keys = ['image_name', 'image_id', 'image_source', 'class_ids', 'class_labels']
    values = [self.image_info[image_id]['id'], image_id, self.image_info[image_id]['source'], class_ids, class_labels]

    if class_ids:
      # mask = np.stack(instance_masks, axis=2).astype(np.bool)
      class_ids = np.array(class_ids, dtype=np.int32)

    # Return mask, and array of class IDs of each instance. Since we have
    # one class ID only, we return an array of 1s
    # return mask.astype(np.bool), np.ones([mask.shape[-1]], dtype=np.int32), keys, values

    ## Return mask, and array of class IDs of each instance
    # return mask.astype(np.bool), np.ones([mask.shape[-1]], dtype=np.int32), keys, values
    return mask.astype(np.bool), class_ids, keys, values


  def load_mask_hmd(self, image_id, info, datacfg=None, config=None):
    # log.info("AnnonDataset::load_mask_hmd")

    annotations = info["annotations"]

    name = datacfg.name

    instance_masks = []
    class_ids = []
    class_labels = []
    # Build mask of shape [height, width, len(info["annotations"])] and list
    # of class IDs that correspond to each channel of the mask.
    for annotation in annotations:
      lbl_id = annotation['lbl_id']
      # log.debug("lbl_id: {}".format(lbl_id))

      ct_class_id = self.get_classid_from_source_class_name( "{}.{}".format(name, lbl_id) )
      # log.info("ct_class_id: {}".format(ct_class_id))

      class_id = self.classinfo[ct_class_id]['id']
      # log.info("class_id: {}".format(class_id))
      class_label = self.get_classname_from_source_class_id( "{}.{}".format(name, class_id) )
      # log.info("class_label: {}".format(class_label))
      # log.info("lbl_id, lbl_name: {}, {}".format(class_id, class_label))

      assert lbl_id == class_label

      if class_label:
        class_labels.append(class_label)

      if class_id:
        m = self.ann_to_mask_via(annotation["shape_attributes"], info["height"], info["width"])
        # Some objects are so small that they're less than 1 pixel area
        # and end up rounded out. Skip those objects.
        if m is not None and m.max() < 1:
            continue
        # # Is it a crowd? If so, use a negative class ID.
        # if annotation['iscrowd']:
        #     # Use negative class ID for crowds
        #     class_id *= -1
        #     # For crowd masks, ann_to_mask_via() sometimes returns a mask
        #     # smaller than the given dimensions. If so, resize it.
        #     if m.shape[0] != info["height"] or m.shape[1] != info["width"]:
        #         m = np.ones([info["height"], info["width"]], dtype=bool)
        instance_masks.append(m)
        class_ids.append(ct_class_id)

    # Pack instance masks into an array
    if class_ids:
      mask = np.stack(instance_masks, axis=2).astype(np.bool)
      keys = ['image_name', 'image_id', 'image_source', 'class_ids', 'class_labels']
      values = [self.image_info[image_id]['id'], image_id, self.image_info[image_id]['source'], class_ids, class_labels]

      class_ids = np.array(class_ids, dtype=np.int32)
      return mask, class_ids, keys, values
    else:
      # Call super class to return an empty mask
      return super(self.__class__, self).load_mask(image_id)


  def ann_to_geometry_labelImg(self, ann):
    """
    Load Different Geometry types specific to labelImg tool
    Ref: http://scikit-image.org/docs/0.8.0/api/skimage.draw.html
    """

    # log.info("AnnonDataset::ann_to_geometry_labelImg")

    start = (ann[0], ann[1])
    extent = (ann[2], ann[3])
    # log.info("start, extent: {} {}".format(start, extent))
    rr, cc = skimage.draw.rectangle(start, extent=extent)
    # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
    # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

    return rr, cc


  def polyline2coords(self, points):
      """
      ## Ref:
      https://www.programcreek.com/python/example/94226/skimage.draw.line

      Return row and column coordinates for a polyline.

      >>> rr, cc = polyline2coords([(0, 0), (2, 2), (2, 4)])
      >>> list(rr)
      [0, 1, 2, 2, 3, 4]
      >>> list(cc)
      [0, 1, 2, 2, 2, 2]

      :param list of tuple points: Polyline in format [(x1,y1), (x2,y2), ...] 
      :return: tuple with row and column coordinates in numpy arrays
      :rtype: tuple of numpy array
      """
      coords = []
      for i in range(len(points) - 1):
          xy = list(map(int, points[i] + points[i + 1]))
          coords.append(skimage.draw.line(xy[1], xy[0], xy[3], xy[2]))
      return [np.hstack(c) for c in zip(*coords)]


  def ann_to_geometry_via(self, ann):
    """
    Load Different Geometry types specific to via tool
    Ref: http://scikit-image.org/docs/0.8.0/api/skimage.draw.html
    Ref: http://scikit-image.org/docs/0.14.x/api/skimage.draw.html#skimage.draw.line
    """

    # log.info("AnnonDataset::ann_to_geometry_via")

    ## rr, cc = 0, 0
    rr = np.zeros([0, 0, len(ann)],dtype=np.uint8)
    cc = np.zeros([0, 0, len(ann)],dtype=np.uint8)
    
    if ann['name'] == 'polygon':
      rr, cc = skimage.draw.polygon(ann['all_points_y'], ann['all_points_x'])
    elif ann['name'] == 'rect':
      ## x, y, width, height
      ## quck patch for old data having KeyError: missing 'y' or 'x'
      ## TODO: Error logging
      for attr in ['x','y','width','height']:
        if attr not in ann:
          return rr,cc
      
      # start = (ann['x'], ann['y'])
      # extent = (ann['width'], ann['height'])

      start = (ann['y'], ann['x'])
      extent = (ann['height'], ann['width'])
      # log.info("start, extent: {} {}".format(start, extent))
      rr, cc = skimage.draw.rectangle(start, extent=extent)
    elif ann['name'] == 'circle':
      rr, cc = skimage.draw.circle(ann['cy'], ann['cx'],ann['r'])
    elif ann['name'] == 'ellipse':
      rr, cc = skimage.draw.ellipse(ann['cy'], ann['cx'],ann['ry'],ann['rx'])
    elif ann['name'] == 'polyline':
      points = list(zip(ann['all_points_x'],ann['all_points_y']))
      rr,cc = self.polyline2coords(points)
    else:
      ## TBD: raise error
      log.info("Annotation Geometry Not Yet Supported")
      log.info("ann_to_mask_via: ann['name']: {}".format(ann['name']))

    # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
    # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

    return rr,cc


  def ann_to_mask_via(self, ann, height, width):
    """
    Convert geometries specific to via tool to mask
    :return: binary mask (numpy 2D array)
    """

    # log.info("AnnonDataset::ann_to_mask_via")

    # mask = np.zeros([height, width, len(ann)],dtype=np.uint8)
    mask = np.zeros([height, width],dtype=np.uint8)

    rr, cc = self.ann_to_geometry_via(ann)

    if rr is not None and cc is not None:
      # log.info("mask.shape, min(mask),max(mask): {}, {},{}".format(mask.shape, np.min(mask),np.max(mask)))
      # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
      # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

      ## Note that this modifies the existing array arr, instead of creating a result array
      ## Ref: https://stackoverflow.com/questions/19666626/replace-all-elements-of-python-numpy-array-that-are-greater-than-some-value
      rr[rr > mask.shape[0]-1] = mask.shape[0]-1
      cc[cc > mask.shape[1]-1] = mask.shape[1]-1

      # log.info("After fixing the dirt mask, new values:")
      # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
      # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

      mask[rr, cc] = 1
    
    # Return mask
    return mask.astype(np.bool)


  def image_reference(self, image_id, info=None, datacfg=None):
    # log.info("AnnonDataset::image_reference")

    """Return the path of the image."""
    info = info if info  else self.image_info[image_id]
    name = datacfg.name if datacfg and datacfg.name else self.name

    if info["source"] == name:
        return info["path"]
    else:
        super(self.__class__, self).image_reference(image_id)
