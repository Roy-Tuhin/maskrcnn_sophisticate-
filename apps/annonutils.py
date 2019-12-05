__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
## Description:
# --------------------------------------------------------
# Annon workflow specific utility functions.
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
import requests

import numpy as np
import skimage.io
import skimage.draw
import logging
from PIL import Image
from io import BytesIO

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

import common

log = logging.getLogger('__main__.'+__name__)


def get_tblname(tblname, tblprefix=""):
  # db_tblname = tblname
  db_tblname = tblname.strip().upper()
  if tblprefix and tblprefix.strip():
    db_tblname = tblprefix+'_'+tblname
  
  return db_tblname


def create_unique_index(db, tblname, idx_col):
  collection = db.get_collection(tblname)

  if idx_col:
    index_name = 'index-'+idx_col
    log.info("index_name: {}".format(index_name))

    if index_name not in collection.index_information():
      # collection.create_index([(idx_col, pymongo.DESCENDING )], name=index_name, unique=True, background=True)
      collection.create_index(idx_col, name=index_name, unique=True, background=True)


def write2db(db, tblname, tbldata, idx_col=None):
  """write the data to the mongodb, create index, which implicitly creates collection if does not exists
  """
  # log.info("\nwrite2db:-----------------------------")
  # log.info("tblname, idx_col: {}, {}".format(tblname, idx_col))

  # log.info("tbldata: {}".format(tbldata))
  collection = db.get_collection(tblname)
  if idx_col:
    
    create_unique_index(db, tblname, idx_col)
    for doc in tbldata:
      # log.info("idx_col: {}, doc: {}".format(idx_col, doc))
      # log.info("doc[idx_col]: {}".format(doc[idx_col]))
      qfilter = {}
      qfilter[idx_col] = doc[idx_col]
      res = collection.update_one(
        qfilter
        ,{ '$setOnInsert': doc}
        ,upsert=True
      )
  else:
    res = collection.insert_one(tbldata)

  # collection.update_many(tbl_data, 'update', upsert=True)
  # log.info("--x--x--x--")


def parse_annon_filename(name):
  """Annotation file names are semantically named such that it empowers for different
  types of annotations in computer vision tasks to be carried out without duplicating
  the images on the filesystem. And, different annotators can annotate same image for
  different type of annotation tasks like for detection, classification, scene type, keypoint annoations etc.
  This also empower for generating different statistics for tracking and management.

  Semantics of annotation file name is illustrated below:
  # --------------------------------------------------------

  * example: Annotation file is saved with the name: `images-p1-230119_AT1_via205_010219.json`
  
  Level-1: After removing the file extension, split with '_' (underscore)
    * returns 4 groups (or Level 2) indexed
    * ex: [0,1,2,3] => ['images-p1-230119', 'AT1', 'via205', '010219'], where:
          'images-p1-230119' => Reference to `image folder` used for the annotations present in this file
          'AT1' => Annotator ID
          'via205' => Annotation tool with version; here VIA annotation tool and version 2.05
          '010219' => Release date on which the annotation file was provided by the annotator
    * additionally, joining [0,1] back with '_' (underscore) provides the reference for directory under which images are present
          ex: [0,1] => ['images-p1-230119', 'AT1'] joining it back with '_' (underscore) gives: 'images-p1-230119_AT1'
  
  Level-2: For each Level 1 items can be split with '-' (minus) wherever possible (absence of this will not result in error during split)
    * ex: 'images-p1-230119' => ['images','p1','230191'], where:
      'images' => directory name under which images would be allocated.
      'p1' => part ID of the images
      '230191' => date on which the images cut was taken and assigned to the annotators
  """
  ref = os.path.splitext(name)[0].split('_')
  ref_img = ref[0].split('-')
  name_ids = {
    "image_rel_date": str(ref_img[2])
    ,"image_part": "-".join(ref_img[:2])
    ,"annotator_id": ref[1]
    ,"annotation_rel_date": str(ref[3])
    ,"annotation_tool": ref[2]
    ,"image_dir": '_'.join(ref[:2])
  }

  log.info("name_ids: {}".format(name_ids))

  return name_ids


def getImgPath(base_from_path, image_dir):
  """provide the base directory path (absolute path) where images are stored 
  """
  # log.info(" base_from_path:{} \n image_dir:{}".format(base_from_path, image_dir))
  
  base_from_path_job = os.path.sep.join(base_from_path.split(os.path.sep)[:-1])
  imgpath = os.path.join('images',image_dir)
  base_path_img = os.path.join(base_from_path_job, imgpath)

  # log.info("base_path_img: {}".format(base_path_img))

  return imgpath, base_path_img


def get_image_from_url(image_api, image_name, base_path_img='', save_local_copy=True, debug=False, resize_image=False):
  """Get the image from HTTP/HTTPS URL
  REF:
  http://docs.python-requests.org/en/master/user/quickstart/
  https://realpython.com/python-requests/
  https://stackoverflow.com/questions/13137817/how-to-download-image-using-requests

  TODO:
    error handling in fetching image file
  """
  # log.info("\nget_image_from_url:-----------------------------")
  filepath_img = os.path.join(base_path_img, image_name)
  success = False

  if os.path.exists(filepath_img):
    # log.info("Image already exists: filepath_img: {}".format(filepath_img))
    success = True
  else:
    base_url = image_api['URL']
    params = image_api['PARAMS']
    params['image'] = image_name

    res = requests.get(base_url, params=params, stream=True)

    if debug:
      # log.info("Request url,status_code,content-type" )
      # log.info("res:{}".format(res))
      log.info("{}\n,{},{}".format(res.url, res.status_code, res.headers['content-type']))

    if res.status_code == 200:
      if save_local_copy:
        ## Create the base_path_img if not exists and is not empty
        if base_path_img and not os.path.exists(base_path_img):
          common.mkdir_p(base_path_img)

        if resize_image:
          image = Image.open(BytesIO(res.content))
          image = image.resize((1280,720), Image.ANTIALIAS)
          image.save(filepath_img)
          success = True
        else:
          with open(filepath_img, 'wb') as of:
            res.raw.decode_content = True
            # shutil.copyfileobj(res.raw, of)
            of.write(res.content)
            success = True
            log.info("Image saved at filepath_img: {}".format(filepath_img))

    del res
  
  return success


def get_class_info(Label, colors=None, source='hmd', index=False):
  """Get the CLASSINFO in the consistent way based on the labels 
  """
  class_info = []
  lbl_ids = []
  index_offset = 1
  for i, gid in enumerate(Label):
    class_name = gid
    lbl_ids.append(class_name)

  lbl_ids.sort()
  log.info("lbl_ids: {}".format(lbl_ids))

  for i, class_name in enumerate(lbl_ids):
    class_info.append({
      "source": source
      ,"name": class_name
      ,"lbl_id": class_name
    })

    if index:
      class_id = i+index_offset
      class_info[class_id]['id'] = class_id

  return class_info


def polyline2coords(points):
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


def ann_to_geometry_via(ann):
  """Load Different Geometry types specific to VGG via tool
  Ref:
  - http://scikit-image.org/docs/0.8.0/api/skimage.draw.html
  - http://scikit-image.org/docs/0.14.x/api/skimage.draw.html#skimage.draw.line
  """
  # log.info("ann_to_geometry_via")
  rr = np.zeros([0, 0, len(ann)], dtype=np.uint8)
  cc = np.zeros([0, 0, len(ann)], dtype=np.uint8)
  
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
    rr,cc = polyline2coords(points)
  else:
    ## TODO: raise error
    log.info("Annotation Geometry Not Yet Supported")
    log.info("ann_to_mask_via: ann['name']: {}".format(ann['name']))

  # log.info("rr.shape, min(rr),max(rr): {}, {},{}".format(rr.shape, np.min(rr),np.max(rr)))
  # log.info("cc.shape, min(cc),max(cc): {}, {},{}".format(cc.shape, np.min(cc),np.max(cc)))

  return rr,cc


def extract_bboxes_and_maskarea(mask):
    """Compute bounding boxes from masks.
    mask: [height, width, num_instances]. Mask pixels are either 1 or 0.
    Returns: maskstats array [num_instances, (y1, x1, y2, x2, width, height, area, maskarea)]
    Credit: Adapted form matterport Mask_RCNN, https://github.com/mangalbhaskar/Mask_RCNN/blob/master/mrcnn/utils.py
    Ref:
    - https://math.stackexchange.com/questions/180804/how-to-get-the-aspect-ratio-of-an-image
    """
    maskstats = np.zeros([mask.shape[-1], 8], dtype=np.int32)
    # log.info("mask.shape: {}".format(mask.shape))
    for i in range(mask.shape[-1]):
      m = mask[:, :, i]
      # log.info("m.shape: {}".format(m.shape))
      maskarea = compute_mask_area(m)
      # Bounding box.
      horizontal_indicies = np.where(np.any(m, axis=0))[0]
      vertical_indicies = np.where(np.any(m, axis=1))[0]
      if horizontal_indicies.shape[0]:
          x1, x2 = horizontal_indicies[[0, -1]]
          y1, y2 = vertical_indicies[[0, -1]]
          # x2 and y2 should not be part of the box. Increment by 1.
          x2 += 1
          y2 += 1
      else:
          # No mask for this instance. Might happen due to
          # resizing or cropping. Set bbox to zeros
          x1, x2, y1, y2 = 0, 0, 0, 0
      # maskstats = np.array([y1, x1, y2, x2])
      # maskstats = np.array([x1, y1, x2 - x1, y2 - y1])
      width, height = x2 - x1, y2 - y1
      area = width*height
      maskstats[i] = np.array([y1, x1, y2, x2, width, height, area, maskarea])

    return maskstats.astype(np.int32)


def complute_bbox_maskstats_from_via_annotations(annotations, height, width):
  """return the custom maskstats object
  annotation (shape_attributes) in VGG via format
  """
  mask = np.zeros([height, width, len(annotations)], dtype=np.uint8)
  for i, ann in enumerate(annotations):
    rr,cc = ann_to_geometry_via(ann)
    rr[rr > mask.shape[0]-1] = mask.shape[0]-1
    cc[cc > mask.shape[1]-1] = mask.shape[1]-1
    mask[rr, cc, i] = 1
  
  bmask = mask.astype(np.bool)
  maskstats = extract_bboxes_and_maskarea(bmask)
  return maskstats


def compute_mask_area(mask):
  """ Computes the area of the mask
  Credit: Adapted form matterport Mask_RCNN, https://github.com/mangalbhaskar/Mask_RCNN/blob/master/mrcnn/utils.py
  Ref:
  - https://github.com/mangalbhaskar/Mask_RCNN/blob/master/mrcnn/utils.py
  """
  # flatten masks and compute their areas
  mask = np.reshape(mask > .5, (-1, 1)).astype(np.float32)
  area = np.sum(mask, axis=0)
  # log.info("mask area: {}".format(area))
  return area


def get_from_maskstats(mstats):
  bbox = {
    'ymin':mstats[0]
    ,'xmin': mstats[1]
    ,'ymax': mstats[2]
    ,'xmax': mstats[3]
    ,'width': mstats[4]
    ,'height': mstats[5]
  }
  bboxarea = mstats[6]
  maskarea = mstats[7]

  return bbox, bboxarea, maskarea
  