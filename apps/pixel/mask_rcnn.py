#!/usr/bin/env python

# --------------------------------------------------------
# Copyright (c) 2018 VidTeq
# Licensed under The MIT License [see LICENSE for details]
# Written by Mangal Bhaskar
# --------------------------------------------------------

import os.path as osp


import mrcnn.model as modellib
# from mrcnn import visualize

import cv2
import numpy as np
import json

# import datetime
import time
import random
import skimage.io
import colorsys
from skimage.measure import find_contours
import matplotlib.pyplot as plt
from matplotlib import patches,  lines
from matplotlib.patches import Polygon
# from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
# from matplotlib.figure import Figure


from importlib import import_module

import pixel.Util as Util
from pixel.mask_rcnn_config import Mask_Rcnn_Config as InferenceConfig

## @API function
def loadModel(modelDtls, args):
  print('loadModel')
  print("modelDtls: {}".format(modelDtls))
  
  modelCfg = modelDtls["config"]
  print("modelCfg: {}".format(modelCfg))

  # config = InferenceConfig()

  ## this loads the configuration dyunamically and inherits properties from the base configuration
  config = InferenceConfig(modelCfg)
  # config["NAME"] = len(modelDtls["ID"])
  # config["NUM_CLASSES"] = len(modelDtls["CLASSES"])

  config.display()

  MODEL_DIR = osp.join(str(modelDtls["basepath"]), 'weights')
  model = modellib.MaskRCNN(mode="inference", model_dir=MODEL_DIR, config=config)


  weights = str(modelDtls["weights"])
  print("++++++++++++++++++++++++")
  print("loading Model Details:")
  print("weights:")
  print(weights)
  print("modelDtls:")
  print(modelDtls)
  print("++++++++++++++++++++++++")
  model.load_weights(weights, by_name=True)
  

  # ## name.lower() == "coco"
  # model.load_weights(weights_path, by_name=True, exclude=[
  #   "mrcnn_class_logits", "mrcnn_bbox_fc",
  #   "mrcnn_bbox", "mrcnn_mask"])

  return model


def get_res_polygon_from_detection(mask, label, score, color=None):
  # Mask Polygon
  # Pad to ensure proper polygons for masks that touch image edges.
  padded_mask = np.zeros((mask.shape[0] + 2, mask.shape[1] + 2), dtype=np.uint8)
  padded_mask[1:-1, 1:-1] = mask    
  contours = find_contours(padded_mask, 0.5)
  all_polys = []
  all_points_x = []
  all_points_y = []
  res_poly = None
  for verts in contours:
    # Subtract the padding and flip (y, x) to (x, y)
    verts = np.fliplr(verts) - 1
    # print("verts (x,y): {}".format(verts[::,0]))
    # print("type(verts[::,0]): {}".format(type(verts[::,0])))
    p = Polygon(verts, facecolor=color, edgecolor=color, alpha=0.5)
    # print("polygon: {}".format(p))
    all_polys.append(p)
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
  # print("res_bbox: {},{}".format(type(res_bbox),res_bbox))
  return res_bbox

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

  # max_area will save the largest object for all the detection results
  max_area = 0
  
  # n_instances saves the amount of all objects
  n_instances = boxes.shape[0]
  print("Total Detections - n_instances: {}".format(n_instances))

  if not n_instances:
      print('NO INSTANCES TO DISPLAY')
  else:
      assert boxes.shape[0] == masks.shape[-1] == class_ids.shape[0]

  ## Generate random colors or slice the colors based on number of instances detected
  ## colors should have length equal to the total number of classes
  # print("class_names: {}".format(class_names))
  # print("random_colors(n_instances): {}".format(random_colors(n_instances)))

  colors = colors or dict( zip(class_names,random_colors(n_instances)) )
  # print("colors: {}".format(colors))

  result = []
  for i in range(n_instances):
    class_id = class_ids[i]
    label = class_names[class_id]
    color = colors[label] if label in colors else None
    score = scores[i] if scores is not None else None
    ## Bounding box
    ## bbox = [1,2,3,4]
    bbox = boxes[i]
    # print("bbox: {},{}".format(type(bbox),bbox))
    ## Mask
    mask = masks[:, :, i]
    # print("mask: {},{}".format(type(mask),mask))

    if not np.any(bbox):
      # Skip this instance. Has no bbox. Likely lost in image cropping.
      continue

    if len(bbox) > 0:
      res_bbox = get_res_bbox_from_detection(bbox, label, score, color)      
      if res_bbox is not None:
        result.append(res_bbox)

    if get_mask and len(mask) > 0:
      # print("get_mask:{}".format(get_mask))
      res_poly = get_res_polygon_from_detection(mask, label, score, color)
      if res_poly is not None:
        result.append(res_poly)

  height, width, nbands = image.shape
  jsonres = {
    "filename":""
    ,"size":0
    ,"regions":[]
    ,"file_attributes":{
      "width": height
      ,"height": width
    }
  }
  if len(result) > 0:
    jsonres["regions"] = result
  # print("jsonres: {}".format(jsonres))

  return jsonres


## @API function
def predict(modelDtls, model, im_name, path, out_file, __appcfg):
  print("Inside {}: predict()".format(__file__))
  # Load the image
  im_name = im_name.split(osp.sep)[-1]
  im_file = osp.join(path, im_name)
  size_image = osp.getsize(im_file)

  print('predict: path, im_name, im_file: {} {}'.format(path, im_name, im_file))
  # im = skimage.io.imread(im_file)
  im = cv2.imread(im_file)
  # print("predict: {}".format(im))

  # Run detection
  t1 = time.time()

  results = model.detect([im], verbose=1)
  CLASSES = modelDtls["CLASSES"]
  r = results[0]
  t2 = time.time()
  time_taken = (t2 - t1)  
  print ('Total time taken in get_detections: %f seconds' %(time_taken))

  
  ## OpenCV read the images in BGR format R=0,G=1,B=2
  ## hence, when plotting with matplotlib specify the order
  im = im[:, :, (2, 1, 0)]
  dim = im.shape[:2]
  height, width = dim[0], dim[1]
  FILE_DELIMITER = __appcfg.FILE_DELIMITER

  boxes, masks, ids, scores = r['rois'], r['masks'], r['class_ids'], r['scores']
  
  t1 = time.time()
  class_names = CLASSES
  jsonres = get_detections(im, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'])
  
  t2 = time.time()
  time_taken = (t2 - t1)
  print ('Total time taken in get_detections: %f seconds' %(time_taken))

  jsonres["filename"] = im_name
  jsonres["size"] = size_image
  via_jsonres = {}
  via_jsonres[im_name+str(size_image)] = jsonres
  detections = []
  res = Util.createResponseForVisionAPI(im_name, FILE_DELIMITER, __appcfg, via_jsonres, detections, __appcfg.API_VISION_BASE_URL)
  return res


def getColorSplash(image, mask):
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


def getSegmentMask(image, mask):
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
        splash = np.where(mask, image, mask).astype(np.uint8) ## cutout effect get only segmented objects as actual RGB
    else:
        splash = gray.astype(np.uint8)
    return splash


# This function is used to change the colorful background information to grayscale.
# image[:,:,0] is the Blue channel,image[:,:,1] is the Green channel, image[:,:,2] is the Red channel
# mask == 0 means that this pixel is not belong to the object.
# np.where function means that if the pixel belong to background, change it to gray_image.
# Since the gray_image is 2D, for each pixel in background, we should set 3 channels to the same value to keep the grayscale.

def apply_mask_shiny(image, mask):
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # OpenCV returns images as BGR, convert to RGB
    # gray_image = gray_1[..., ::-1]
    image[:, :, 0] = np.where(
        mask == 0,
        gray_image[:, :],
        image[:, :, 0]
    )
    image[:, :, 1] = np.where(
        mask == 0,
        gray_image[:, :],
        image[:, :, 1]
    )
    image[:, :, 2] = np.where(
        mask == 0,
        gray_image[:, :],
        image[:, :, 2]
    )
    return image


def apply_mask(image, mask, color, alpha=0.5):
    """Apply the given mask to the image.
    """
    for c in range(3):
        image[:, :, c] = np.where(mask == 1,
                                  image[:, :, c] *
                                  (1 - alpha) + alpha * color[c] * 255,
                                  image[:, :, c])
    return image


def random_colors(N, bright=True):
    """
    Generate random colors.
    To get visually distinct colors, generate them in HSV space then
    convert to RGB.
    """
    brightness = 1.0 if bright else 0.7
    hsv = [(i / N, 1, brightness) for i in range(N)]
    colors = list(map(lambda c: colorsys.hsv_to_rgb(*c), hsv))
    random.shuffle(colors)
    return colors


# This function is used to show the object detection result in original image.
def display_instances(fileName, image, boxes, masks, class_ids, class_names, scores,
                      title="",
                      figsize=(16, 16), ax=None,
                      show_mask=True, show_bbox=True,
                      colors=None, captions=None):
  """
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

  # max_area will save the largest object for all the detection results
  max_area = 0
  
  # n_instances saves the amount of all objects
  n_instances = boxes.shape[0]
  height, width, nbands = image.shape
  dpi = 80
  # dpi = 300
  # What size does the figure need to be in inches to fit the image?
  figsize = width/float(dpi), height/float(dpi)

  if not n_instances:
      print('NO INSTANCES TO DISPLAY')
  else:
      assert boxes.shape[0] == masks.shape[-1] == class_ids.shape[0]

  # If no axis is passed, create one and automatically call show()
  auto_show = False
  fig, ax = plt.subplots(1, figsize=figsize)

  fig = plt.figure(figsize=figsize)
  ax = fig.add_axes([0.,0,1,1])

  # Generate random colors
  colors = colors or random_colors(n_instances)
  masked_image = image.astype(np.uint32).copy()
  
  ax.axis('off')
  # ax.imshow(masked_image.astype(np.uint8))
  ax.imshow(masked_image)

  # ax = TBD(masked_image, boxes, masks, class_ids, class_names, scores, ax, show_mask, show_bbox, colors, captions)
  jsonres = TBD(fileName, masked_image, boxes, masks, class_ids, class_names, scores, ax, show_mask, show_bbox, colors, captions)
  # print("jsonres: {}".format(jsonres))

  
  masked_image_from_canvas = fig2rgb_array(fig)
  # print("masked_image_from_canvas: {}".format(masked_image_from_canvas))
  # ax.imshow(masked_image_from_canvas)
  # plt.show()
  plt.close()
  return masked_image_from_canvas.astype(np.uint8)
  # return jsonres


def TBD(fileName, masked_image, boxes, masks, class_ids, class_names, scores, ax, show_mask, show_bbox, colors, captions):
  n_instances = boxes.shape[0]
  ## TBD: group them for json response

  jsonres = []

  for i in range(n_instances):
    res = {}


    # Bounding box
    if not np.any(boxes[i]):
      # Skip this instance. Has no bbox. Likely lost in image cropping.
      continue

    color = colors[i]
    class_id = class_ids[i]
    label = class_names[class_id]        
    score = scores[i] if scores is not None else None

    res['color'] = color
    res['bbox'] = boxes[i]
    res['label'] = label
    res['score'] = score

    # compute the square of each object
    y1, x1, y2, x2 = boxes[i]
    # square = (y2 - y1) * (x2 - x1)
    if show_bbox:
      p = patches.Rectangle((x1, y1), x2 - x1, y2 - y1, linewidth=2,
                            alpha=0.7, linestyle="dashed",
                            edgecolor=color, facecolor='none')
      ax.add_patch(p)

    # Label
    if not captions:
      x = random.randint(x1, (x1 + x2) // 2)
      caption = "{} {:.3f}".format(label, score) if score else label
    else:
      caption = captions[i]
    

    ##Ref: https://matplotlib.org/api/text_api.html#matplotlib.text.Text
    ax.text(x1, y1 + 8, caption,
          color='w', size=11, backgroundcolor='none', fontweight='bold')

    # Mask
    mask = masks[:, :, i]

    if show_mask:
        masked_image = apply_mask(masked_image, mask, color)

    
    # Mask Polygon
    # Pad to ensure proper polygons for masks that touch image edges.
    padded_mask = np.zeros((mask.shape[0] + 2, mask.shape[1] + 2), dtype=np.uint8)
    padded_mask[1:-1, 1:-1] = mask
    
    # skimage.io.imsave(fileName+"mask.png", masked_image[..., ::-1])

    contours = find_contours(padded_mask, 0.5)

    # polys = []
    for verts in contours:
      # Subtract the padding and flip (y, x) to (x, y)
      verts = np.fliplr(verts) - 1
      # print("verts (x,y): {}".format(verts))
      p = Polygon(verts, facecolor=color, edgecolor=color, alpha=0.5)
      # print("polygon: {}".format(p))
      ax.add_patch(p)
      # polys.append("{}".format(p))
      # polys.append(verts)

    # res['polygon'] = polys

  jsonres.append(res)

  return jsonres


## https://stackoverflow.com/questions/21939658/matplotlib-render-into-buffer-access-pixel-data
## https://gist.github.com/joferkington/9138655
## https://stackoverflow.com/questions/35355930/matplotlib-figure-to-image-as-a-numpy-array
def fig2rgb_array(fig):
    fig.canvas.draw()
    buf = fig.canvas.tostring_rgb()
    ncols, nrows = fig.canvas.get_width_height()
    return np.fromstring(buf, dtype=np.uint8).reshape(nrows, ncols, 3)


# def vis_detections(im, class_name, dets, im_name, out_file, __appcfg):
## @API function
def vis_detections(__appcfg, imgFileName, im, class_names, results):
  print("vis_detections")
  r = results[0]
  # file_name = "viz_{:%Y%m%dT%H%M%S}.png".format(datetime.datetime.now())

  # visualize.display_instances(im[..., ::-1], r['rois'], r['masks'], r['class_ids'], class_names, r['scores'])

  # file_name = imgFileName+"-viz_{:%Y%m%dT%H%M%S}.png".format(datetime.datetime.now())
  # file_name = imgFileName+"-"+__appcfg.ID+"-"+"-viz.png"
  fpath = osp.dirname(osp.abspath(imgFileName))

  file_name = osp.join(fpath, Util.getVizImageFileName(imgFileName, 'viz', __appcfg ))
  print("viz_detections: file_name:viz: {}".format(file_name))
  # file_name = osp.join(imgFileName,file_name)
  viz = display_instances(file_name, im, r['rois'], r['masks'], r['class_ids'], class_names, r['scores'] )
 
  cv2.imwrite(file_name, viz)
  ## Color splash
  # file_name = imgFileName+"-splash_{:%Y%m%dT%H%M%S}.png".format(datetime.datetime.now())
  # file_name = imgFileName+"-"+__appcfg.ID+"-"+"-splash.png"
  file_name = osp.join(fpath, Util.getVizImageFileName(imgFileName, 'splash', __appcfg ))
  # file_name = osp.join(imgFileName,file_name)

  splash = getColorSplash(im, r['masks'])
  # skimage.io.imshow(splash)
  # skimage.io.show()
  cv2.imwrite(file_name, splash)

  ## get mask
  # file_name = imgFileName+"-mask_{:%Y%m%dT%H%M%S}.png".format(datetime.datetime.now())
  # file_name = imgFileName+"-"+__appcfg.ID+"-"+"-mask.png"
  file_name = osp.join(fpath, Util.getVizImageFileName(imgFileName, 'mask', __appcfg ))
  # file_name = osp.join(imgFileName,file_name)

  cutmask = getSegmentMask(im[..., ::-1], r['masks'])
  ## Save output
  # skimage.io.imshow(cutmask)
  # skimage.io.show()
  skimage.io.imsave(file_name, cutmask)

  # splash2 = display_instances(
  #   image, r['rois'], r['masks'], r['class_ids'], class_names, r['scores']
  # )
  # print("splash2: {}".format(splash2))
  # file_name = "splash2_{:%Y%m%dT%H%M%S}.png".format(datetime.datetime.now())
  # splash2 = splash2[..., ::-1]
  # cv2.imwrite(file_name, splash2)


def get_dataset_module_class(traincfg, did, dataset):
  dset = dataset.DSETS[did]
  dataclass = dset.DATACLASS
  ## TBD: other parameter valuss to be passed, example for coco
  mod = import_module(traincfg.DATACLASS[dataclass])  
  modcls = getattr(mod, dataclass)
  return modcls


def get_dataset_instance(modcls, did, dataset, subset, config):
  dset = dataset.DSETS[did]
  dataset_instance = modcls()
  dataset_instance.load_data(subset, datacfg=dset, dnncfg=config)
  # Must call before using the dataset
  dataset_instance.prepare()
  return dataset_instance


def get_datasets(traincfg, dataset, config):
  ## TBD: pass as parameter
  did = '0'
  modcls = get_dataset_module_class(traincfg, did, dataset)

  # dataset_train = modcls()
  # dataset_train.load_data("train", datacfg=dset, dnncfg=config)
  # # Must call before using the dataset
  # dataset_train.prepare()

  subset = "train"
  dataset_train = get_dataset_instance(modcls, did, dataset, subset, config)
  # inspect_data(dataset_train, config=config)

  ### validation dataset
  # dataset_val = modcls()
  # dataset_val.load_data("val", datacfg=dset, dnncfg=config)
  # # Must call before using the dataset
  # dataset_val.prepare()

  subset = "val"
  dataset_val = get_dataset_instance(modcls, did, dataset, subset, config)
  # inspect_data(dataset_val, config=config)
  return dataset_train, dataset_val


def get_training_schedule(traincfg, dataset, config):
  ## TBD: pass as parameter  
  sid = 'mask_rcnn-0'
  schedule = traincfg.SCHEDULES[sid]
  schedule = traincfg.SCHEDULES[sid] 

  dataset_train, dataset_val = get_datasets(traincfg, dataset, config)

  # ### Image Augmentation
  # ## Right/Left flip 50% of the time
  # augmentation = imgaug.augmenters.Fliplr(0.5)


  ### 2. Create Training Schedules
  ## * should be flexible to get different training schedules

  for stage in schedule:
    print("training_schedule:stage:{}".format(stage))
    yield {
            "dataset_train": dataset_train
            ,"dataset_val": dataset_val
            ,"learning_rate":stage.LEARNING_RATE
            ,"epochs":stage.EPOCHS
            ,"layers":stage.LAYERS
          }


def display_config(cfg):
  attrs = cfg.getdict()
  # print("attrs:{}".format(attrs))
  for k,v in attrs.items():
    print("{} = {}".format(k,v))


def inspect_dataset(traincfg):
  from pixel.inspect_data import inspect_data
  print("Inside {}: inspect_dataset()".format(__file__))
  ### 0. Load Pre-trained model
    ## If required, exclude the last layers because they require a matching number of classes

  dataset = traincfg[traincfg.DATASET]
  dnncfg = dataset.CONFIG

  config = InferenceConfig(dnncfg)
  config.display()
  # display_config(config)
  # config["NAME"] = len(modelDtls["ID"])
  # config["NUM_CLASSES"] = len(modelDtls["CLASSES"])
  dataset_train, dataset_val = get_datasets(traincfg, dataset, config)  
  inspect_data(dataset_train, config=config)
  inspect_data(dataset_val, config=config)
  return


## TBD: training mode
## @API function
def train(traincfg):
  print("Inside {}: train()".format(__file__))
  ### 0. Load Pre-trained model
    ## If required, exclude the last layers because they require a matching number of classes

  dataset = traincfg[traincfg.DATASET]
  dnncfg = dataset.CONFIG

  config = InferenceConfig(dnncfg)
  config.display()
  # display_config(config)
  # config["NAME"] = len(modelDtls["ID"])
  # config["NUM_CLASSES"] = len(modelDtls["CLASSES"])

  weights = traincfg.WEIGHTS
  command = traincfg.COMMAND
  MODEL_DIR = osp.dirname(weights)

  # model = modellib.MaskRCNN(mode="training", model_dir=MODEL_DIR, config=config)
  model = modellib.MaskRCNN(traincfg.MODE, config=config, model_dir=traincfg.LOG_DIR)

  print('loadModel')

  # # Load weights trained on MS COCO, but skip layers that
  # # are different due to the different number of classes
  # # See README for instructions to download the COCO weights
  # # model.load_weights(model_path, by_name=True, exclude=["mrcnn_class_logits", "mrcnn_bbox_fc",  "mrcnn_bbox", "mrcnn_mask"])
  # model.load_weights(
  #   osp.join(MODEL_DIR, weights)
  #   ,by_name=True
  #   ,exclude=["mrcnn_class_logits", "mrcnn_bbox_fc", "mrcnn_mask"]
  # )

  weights_path = osp.join(MODEL_DIR, weights)
  print("weights_path: {}".format(weights_path))

  model.load_weights(
    weights_path
    ,by_name=traincfg.LOAD_WEIGHTS.BY_NAME
    ,exclude=traincfg.LOAD_WEIGHTS.EXCLUDE
  )
  

  # import imgaug  # https://github.com/aleju/imgaug (pip3 install imgaug)

  # ### TBD: more robust augmenter strategy and experiements
  # ### Image Augmentation
  # ## Right/Left flip 50% of the time
  # # augmentation = imgaug.augmenters.Fliplr(0.5)
  # augmentation = None

  dataset_train, dataset_val = get_datasets(traincfg, dataset, config)

  training_schedule = get_training_schedule(traincfg, dataset, config=config)
  print("training_schedule: {}".format(training_schedule))
  for ts in training_schedule:
    print("ts: {}".format(ts['layers']))
    model.train(ts['dataset_train'], ts['dataset_val']
      ,learning_rate=ts['learning_rate']
      ,epochs=ts['epochs']
      ,layers=ts['layers'])

  return



## @API function
def predict_depricated(modelDtls, model, im_name, path, out_file, __appcfg):
  print("Inside {}: predict()".format(__file__))
  # Load the image
  im_file = osp.join(path, im_name)

  print('predict: im_name, im_file: {} {}'.format(im_name, im_file))
  # im = skimage.io.imread(im_file)
  im = cv2.imread(im_file)
  print("predict: {}".format(im))
  # Run detection
  
  results = model.detect([im], verbose=1)
  CLASSES = modelDtls["CLASSES"]
  r = results[0]

  imgFileName = Util.getOutFileName(out_file, im_name, "", __appcfg)
  ## Visualize results
  vis_detections(__appcfg, imgFileName, im, CLASSES, results)

  # jsonres = display_instances(
  #     fileName, im, r['rois'], r['masks'], r['class_ids'], CLASSES, r['scores']
  # )
  # # file_name = im_name+"_{:%Y%m%dT%H%M%S}.csv".format(datetime.datetime.now())

  # print("fileName: {}".format(fileName))

  # with open(fileName,'a') as f:
  #   for item in jsonres:
  #     row = ', '.join([str(i) for i in item.values()])
  #     print("row: {}".format(row))
  #     f.write(row+"\n")

  
  ## OpenCV read the images in BGR format R=0,G=1,B=2
  ## hence, when plotting with matplotlib specify the order
  im = im[:, :, (2, 1, 0)]
  dim = im.shape[:2]
  height, width = dim[0], dim[1]
  FILE_DELIMITER = __appcfg.FILE_DELIMITER

  all_rows_for_all_classes = {}
  boxes, masks, ids, scores = r['rois'], r['masks'], r['class_ids'], r['scores']
  
  # max_area will save the largest object for all the detection results
  max_area = 0
  # n_instances saves the amount of all objects
  n_instances = boxes.shape[0]
  if not n_instances:
    print('NO INSTANCES TO DISPLAY')
  else:
    assert boxes.shape[0] == masks.shape[-1] == ids.shape[0]

  for i in range(n_instances):
    if not np.any(boxes[i]):
      continue

    # compute the square of each object
    # y1, x1, y2, x2 = boxes[i]
    # bbox = boxes[i]
    score = scores[i]

    y1, x1, y2, x2 = boxes[i]
    square = (y2 - y1) * (x2 - x1)
    # use label to select person object from all the classes
    cls = CLASSES[ids[i]]
    max_area = square
    mask = masks[:, :, i]
    bbox = boxes[i]
  
    # apply mask for the image
    # all_rows = getDetections(width, height, cls, bbox, score, im_name, out_file, FILE_DELIMITER, __appcfg)
  
    print("getDetections")
    row = None;

    all_bbox = []
    fileName = Util.getOutFileName(out_file, im_name, ".csv", __appcfg)

    with open(fileName,'a') as f:
      # row = Util.getOutFileRow([bbox[1],bbox[0],bbox[3],bbox[2]], cls, score, width, height, FILE_DELIMITER)
      row = Util.getOutFileRow(bbox, cls, score, width, height, FILE_DELIMITER)      
      print("row:")
      print(row)
      ## TBD: type conversion mapping
      all_bbox.append(row.split(FILE_DELIMITER))
      print("Detection Row:"+row)
      f.write(row+'\n')

    all_rows = {
      "bbox":all_bbox
    }

    if all_bbox and len(all_bbox) > 0:
      all_rows_for_all_classes[cls] = all_rows
    else:
      all_rows_for_all_classes[cls] = None
  
  
  detections = [
    Util.getVizImageFileName(im_name, None, __appcfg )
    ,Util.getVizImageFileName(im_name, 'viz', __appcfg )
    ,Util.getVizImageFileName(im_name, 'splash', __appcfg )
    ,Util.getVizImageFileName(im_name, 'mask', __appcfg )
  ]
  # print("mask_rcnn::detections: {}".format(detections))
  res = Util.createResponseForVisionAPI(im_name, FILE_DELIMITER, __appcfg, all_rows_for_all_classes, detections, __appcfg.API_VISION_BASE_URL)
  return res
  # return jsonres
