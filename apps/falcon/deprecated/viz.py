__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
Credits:

Code adopted from:
* mrcnn/visualize.py
* color_splash from the blog post:
  * https://engineering.matterport.com/splash-of-color-instance-segmentation-with-mask-r-cnn-and-tensorflow-7c761e238b46
---

Mask R-CNN
Display and Visualization Functions.

Copyright (c) 2017 Matterport, Inc.
Licensed under the MIT License (see LICENSE for details)
Written by Waleed Abdulla
---

Key contribution:
* saving the annotated results directly
* saving the annotated mask only
* annotation results as json response for consumption in API, VGG VIA compatible results

Copyright (c) 2019 Vidteq India Pvt. Ltd.
Licensed under [see LICENSE for details]
Written by mangalbhaskar
------------------------------------------------------------
"""
import random
import colorsys

import numpy as np

import skimage.io
from skimage.measure import find_contours

import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib import patches

import logging
log = logging.getLogger('__main__.'+__name__)


def random_colors(N, bright=True):
  """Generate random colors.
  To get visually distinct colors, generate them in HSV space then
  convert to RGB.
  """
  brightness = 1.0 if bright else 0.7
  hsv = [(i / N, 1, brightness) for i in range(N)]
  colors = list(map(lambda c: colorsys.hsv_to_rgb(*c), hsv))
  random.shuffle(colors)
  return colors


def imread(image_path):
  """Load the specified image and return a [H,W,3] Numpy array.
  """
  # Load image
  image = skimage.io.imread(image_path)
  # log.debug("load_image::image_path, image.ndim: {},{}".format(image_path, image.ndim))
  # If grayscale. Convert to RGB for consistency.
  if image.ndim != 3:
      image = skimage.color.gray2rgb(image)
  # If has an alpha channel, remove it for consistency
  if image.shape[-1] == 4:
      image = image[..., :3]
  return image


def imsave(filename, im):
  skimage.io.imsave(filename, im)
  return


def color_splash(image, mask):
  """Apply color splash effect.
  image: RGB image [height, width, 3]
  mask: instance segmentation mask [height, width, instance count]

  Returns result image.
  """
  # Make a grayscale copy of the image. The grayscale copy still
  # has 3 RGB channels, though.
  gray = skimage.color.gray2rgb(skimage.color.rgb2gray(image)) * 255
  # Copy color pixels from the original color image where mask is set
  if mask.shape[-1] > 0:
      # We're treating all instances as one, so collapse the mask into one layer
      mask = (np.sum(mask, -1, keepdims=True) >= 1)
      splash = np.where(mask, image, gray).astype(np.uint8)
  else:
      splash = gray.astype(np.uint8)

  return splash


def color_mask(image, mask):
  """Apply color splash effect.
  image: RGB image [height, width, 3]
  mask: instance segmentation mask [height, width, instance count]

  Returns result image.
  """
  # Make a grayscale copy of the image. The grayscale copy still
  # has 3 RGB channels, though.
  gray = skimage.color.gray2rgb(skimage.color.rgb2gray(image)) * 255
  # Copy color pixels from the original color image where mask is set
  if mask.shape[-1] > 0:
      # We're treating all instances as one, so collapse the mask into one layer
      mask = (np.sum(mask, -1, keepdims=True) >= 1)
      # splash = np.where(mask, image, gray).astype(np.uint8)
      splash = np.where(mask, image, mask).astype(np.uint8) ## cutout effect get only segmented objects as actual RGB
  else:
      splash = gray.astype(np.uint8)
  return splash


def get_display_instances(image, boxes, masks, class_ids, class_names, scores,
                      title="",
                      figsize=(16, 16), ax=None,
                      show_mask=True, show_bbox=True,
                      colors=None, captions=None, get_mask=True):
  """returns the annotated image from the detections, so that it can be saved on filesystem
  
  boxes: [num_instance, (y1, x1, y2, x2, class_id)] in image coordinates.
    * example: bbox:: [ 306 23 1080 1920] => [y1,x1,y2,x2] => [top, left, bottom, right] mapping in Util.getOutFileRow
  masks: [height, width, num_instances]
  class_ids: [num_instances]
  class_names: list of class names of the dataset
  scores: (optional) confidence scores for each box
  title: (optional) Figure title
  show_mask, show_bbox: To show masks and bounding boxes or not
  figsize: (optional) the size of the image
  colors: (optional) An array or colors to use with each object
  captions: (optional) A list of strings to use as captions for each object
  """
  
  ## TODO: max_area will save the largest object for all the detection results
  max_area = 0
  
  ## n_instances saves the amount of all objects
  n_instances = boxes.shape[0]
  log.debug("Total Detections - n_instances: {}".format(n_instances))

  if not n_instances:
      log.debug('NO INSTANCES TO DISPLAY')
  else:
      log.debug(" boxes.shape[0] == masks.shape[-1] == class_ids.shape[0]: {}".format( boxes.shape[0] == masks.shape[-1] == class_ids.shape[0]))
      assert boxes.shape[0] == masks.shape[-1] == class_ids.shape[0]
  
  dpi = 80
  ## dpi = 300
  height, width, nbands = image.shape
  ## What size does the figure need to be in inches to fit the image?
  figsize = width/float(dpi), height/float(dpi)
  ## If no axis is passed, create one and automatically call show()
  auto_show = False
  fig, ax = plt.subplots(1, figsize=figsize)
  fig = plt.figure(figsize=figsize)
  ax = fig.add_axes([0.,0,1,1])
  masked_image = image.astype(np.uint32).copy()
  ax.axis('off')
  # ax.imshow(masked_image.astype(np.uint8))
  ax.imshow(masked_image)
  
  ## Generate random colors or slice the colors based on number of instances detected
  ## colors should have length equal to the total number of classes
  # colors = colors or random_colors(n_instances)
  colors = colors or dict( zip(class_names,random_colors(n_instances)) )
  result = []
  for i in range(n_instances):
    class_id = class_ids[i]
    label = class_names[class_id]
    color = colors[label]
    score = scores[i] if scores is not None else None
    ## Bounding box
    ## bbox = [1,2,3,4]
    bbox = boxes[i]
    # log.debug("bbox: {},{}".format(type(bbox),bbox))
    ## Mask
    mask = masks[:, :, i]
    # log.debug("mask: {},{}".format(type(mask),mask))

    ## Bounding box
    if not np.any(bbox):
      ## Skip this instance. Has no bbox. Likely lost in image cropping.
      continue

    if len(bbox) > 0:
      # compute the area_bbox of each object
      y1, x1, y2, x2 = bbox
      area_bbox = (y2 - y1) * (x2 - x1)
      ## json response
      res_bbox = get_res_bbox_from_detection(bbox, label, score, color)
      if res_bbox is not None:
        result.append(res_bbox)
      
      if show_bbox:
        p = patches.Rectangle((x1, y1), x2 - x1, y2 - y1, linewidth=2,
                              alpha=0.7, linestyle="dashed",
                              edgecolor=color, facecolor='none')
        ax.add_patch(p)
      
      ## Label
      ## TODO: put area_bbox in the Label text
      if not captions:
        x = random.randint(x1, (x1 + x2) // 2)
        caption = "{} {:.3f}".format(label, score) if score else label
      else:
        caption = captions[i]
    
      ## Ref: https://matplotlib.org/api/text_api.html#matplotlib.text.Text
      ax.text(x1, y1 + 8, caption,
            color='w', size=11, backgroundcolor='none', fontweight='bold')

    if show_mask and len(mask) > 0:
      ## json response
      res_poly = get_res_polygon_from_detection(mask, label, score, color)
      if get_mask and res_poly is not None:
        result.append(res_poly)
      
      masked_image = apply_mask(masked_image, mask, color)
      ## Mask Polygon
      ## Pad to ensure proper polygons for masks that touch image edges.
      padded_mask = np.zeros((mask.shape[0] + 2, mask.shape[1] + 2), dtype=np.uint8)
      padded_mask[1:-1, 1:-1] = mask
      
      contours = find_contours(padded_mask, 0.5)
      for verts in contours:
        ## Subtract the padding and flip (y, x) to (x, y)
        verts = np.fliplr(verts) - 1
        # log.debug("verts (x,y): {}".format(verts[::,0]))
        # log.debug("type(verts[::,0]): {}".format(type(verts[::,0])))
        p = Polygon(verts, facecolor=color, edgecolor=color, alpha=0.5)
        # log.debug("polygon: {}".format(p))
        ax.add_patch(p)
      
  masked_image_from_canvas = fig2rgb_array(fig)
  ## log.debug("masked_image_from_canvas: {}".format(masked_image_from_canvas))
  ## ax.imshow(masked_image_from_canvas)
  ## plt.show()
  plt.close()

  ## json response
  jsonres = {
    "filename":""
    ,"size":0
    ,"regions":[]
    ,"file_attributes":{
      "width": width
      ,"height": height
    }
  }
  if len(result) > 0:
    jsonres["regions"] = result
  
  return masked_image_from_canvas.astype(np.uint8), jsonres


def get_via_json_regions(label, score, caption, sa):
  regions = {
    "region_attributes":{
      "label": label
      ,"score": score
      ,"caption": caption
    }
    ,"shape_attributes": sa
  }

  return regions


def fig2rgb_array(fig):
  """fig2rgb_array
  Ref:
  * https://stackoverflow.com/questions/21939658/matplotlib-render-into-buffer-access-pixel-data
  * https://gist.github.com/joferkington/9138655
  * https://stackoverflow.com/questions/35355930/matplotlib-figure-to-image-as-a-numpy-array
  """
  fig.canvas.draw()
  buf = fig.canvas.tostring_rgb()
  ncols, nrows = fig.canvas.get_width_height()

  return np.fromstring(buf, dtype=np.uint8).reshape(nrows, ncols, 3)


def apply_mask(image, mask, color, alpha=0.5):
    """Apply the given mask to the image.
    """
    for c in range(3):
        image[:, :, c] = np.where(mask == 1,
                                  image[:, :, c] *
                                  (1 - alpha) + alpha * color[c] * 255,
                                  image[:, :, c])
    return image


def get_detections(image, boxes, masks, class_ids, class_names,
                  scores,
                  colors=None,
                  get_mask=False):
  """
  boxes: [num_instance, (y1, x1, y2, x2, class_id)] in image coordinates.
    * example: bbox:: [ 306 23 1080 1920] => [y1,x1,y2,x2] => [top, left, bottom, right] mapping in Util.getOutFileRow
  masks: [height, width, num_instances]
  class_ids: [num_instances]
  class_names: list of class names of the dataset
  scores: (optional) confidence scores for each box
  colors: (optional) An array or colors to use with each object

  Ref:
  * https://stackoverflow.com/questions/32468278/list-as-an-entry-in-a-dict-not-json-serializable
  * https://stackoverflow.com/questions/26646362/numpy-array-is-not-json-serializable
  """

  ## TODO: max_area will save the largest object for all the detection results
  max_area = 0
  
  ## n_instances saves the amount of all objects
  n_instances = boxes.shape[0]
  log.debug("Total Detections - n_instances: {}".format(n_instances))

  if not n_instances:
      log.debug('NO INSTANCES TO DISPLAY')
  else:
      assert boxes.shape[0] == masks.shape[-1] == class_ids.shape[0]

  ## Generate random colors or slice the colors based on number of instances detected
  ## colors should have length equal to the total number of classes
  # colors = colors or random_colors(n_instances)
  colors = colors or dict( zip(class_names,random_colors(n_instances)) )
  result = []
  for i in range(n_instances):
    class_id = class_ids[i]
    label = class_names[class_id]
    color = colors[label] if label in colors else None
    score = scores[i] if scores is not None else None
    ## Bounding box
    ## bbox = [1,2,3,4]
    bbox = boxes[i]
    # log.debug("bbox: {},{}".format(type(bbox),bbox))
    ## Mask
    mask = masks[:, :, i]
    # log.debug("mask: {},{}".format(type(mask),mask))

    if not np.any(bbox):
      ## Skip this instance. Has no bbox. Likely lost in image cropping.
      continue

    if len(bbox) > 0:
      y1, x1, y2, x2 = bbox
      area_bbox = (y2 - y1) * (x2 - x1)
      
      res_bbox = get_res_bbox_from_detection(bbox, label, score, color)
      if res_bbox is not None:
        result.append(res_bbox)

    if get_mask and len(mask) > 0:
      # log.debug("get_mask:{}".format(get_mask))
      res_poly = get_res_polygon_from_detection(mask, label, score, color)
      if res_poly is not None:
        result.append(res_poly)

  height, width, nbands = image.shape
  jsonres = {
    "filename":""
    ,"size":0
    ,"regions":[]
    ,"file_attributes":{
      "width": width
      ,"height": height
    }
  }
  if len(result) > 0:
    jsonres["regions"] = result
  # log.debug("jsonres: {}".format(jsonres))

  return jsonres


def get_res_polygon_from_detection(mask, label, score, color=None):
  """VGG VIA specific polygon detection format
  """
  ## Mask Polygon
  ## Pad to ensure proper polygons for masks that touch image edges.
  padded_mask = np.zeros((mask.shape[0] + 2, mask.shape[1] + 2), dtype=np.uint8)
  padded_mask[1:-1, 1:-1] = mask    
  contours = find_contours(padded_mask, 0.5)
  all_polys = []
  all_points_x = []
  all_points_y = []
  res_poly = None
  for verts in contours:
    ## Subtract the padding and flip (y, x) to (x, y)
    verts = np.fliplr(verts) - 1
    # log.debug("verts (x,y): {}".format(verts[::,0]))
    # log.debug("type(verts[::,0]): {}".format(type(verts[::,0])))

    ## TODO: check if poly can be used, because masks with many vertices needs to be simplyfied may be using rdp algo
    # p = Polygon(verts, facecolor=color, edgecolor=color, alpha=0.5)
    # log.debug("polygon: {}".format(p))
    # all_polys.append(p)
    
    all_points_y += list(verts[::,1])
    all_points_x += list(verts[::,0])

  if all_points_x and len(all_points_x) > 0:
    ## shape_attributes
    sa_poly = {
      "name":"polygon"
      ,"all_points_x":all_points_x
      ,"all_points_y":all_points_y
    }
    res_poly = {
      "region_attributes":{
        "label": label
        ,"score": score
        ,"color": color
      }
      ,"shape_attributes": sa_poly
    }
  
  return res_poly


def get_res_bbox_from_detection(bbox, label, score, color=None):
  """VGG VIA specific bbox detection format
  """
  sa_bbox = {
    "name":"rect"
    ,"y":bbox[0]
    ,"x":bbox[1]
    ,"height":bbox[2]-bbox[0]
    ,"width":bbox[3]-bbox[1]
  }
  res_bbox = {
    "region_attributes":{
      "label": label
      ,"score": score
      ,"color": color
    }
    ,"shape_attributes": sa_bbox
  }
  # log.debug("res_bbox: {},{}".format(type(res_bbox),res_bbox))
  return res_bbox


def getOutFileRow(bbox, label, score, color, width, height, FD):
  log.debug("getOutFileRow::bbox: {}".format(bbox))

  ## mask_rcnn: getOutFileRow: bbox:: image coordinates => following this convention now!
  ## [ 306 23 1080 1920] => [y1,x1,y2,x2] => [top, left, bottom, right] mapping in Util.getOutFileRow

  ## faster_rcnn_end2end: getOutFileRow::bbox: => this was original output now transformed to mask_rcnn convention
  ## [643.95715  105.885155 717.3395   177.24414 ] => [left, top, right, bottom] => [x1,y1,x2,y2]

  if len(bbox) > 0:
    # left = bbox[0]
    # top = bbox[1]
    # right = bbox[2]
    # bottom = bbox[3]

    left = bbox[1]
    top = bbox[0]
    right = bbox[3]
    bottom = bbox[2]
    row = str(label)+FD+str(score)+FD+str(color)+FD+str(width)+FD+str(height)+FD+str(left)+FD+str(top)+FD+str(right - left)+FD+str(bottom - top)
  else:
    row = str(label)+FD+"null"+FD+"null"+FD+str(width)+FD+str(height)+FD+"null"+FD+"null"+FD+"null"+FD+"null"

  return row
