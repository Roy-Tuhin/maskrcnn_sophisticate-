# --------------------------------------------------------
# Faster R-CNN
# Copyright (c) 2015 Microsoft
# Licensed under The MIT License [see LICENSE for details]
# Written by Ross Girshick
# Modified by Mangal Bhaskar
# --------------------------------------------------------

import os.path as osp
import cv2
from utils.timer import Timer
import numpy as np

import logging
log = logging.getLogger('__main__.'+__name__)


from fast_rcnn.test import im_detect
from fast_rcnn.nms_wrapper import nms
from fast_rcnn.config import cfg
import caffe

import pixel.Util as Util
## TBD:
## Throws:
##  1. WARNING: Logging before InitGoogleLogging() is written to STDERR
##  2. [libprotobuf WARNING google/protobuf/io/coded_stream.cc:604] Reading dangerously large protocol message.  If the message turns out to be larger than 2147483647 bytes, parsing will be halted for security reasons.  To increase the limit (or to disable these warnings), see CodedInputStream::SetTotalBytesLimit() in google/protobuf/io/coded_stream.h.
##      [libprotobuf WARNING google/protobuf/io/coded_stream.cc:81] The total number of bytes read was 546762597
## @API function
def loadModel(modelDtls, args):
    cfg.TEST.HAS_RPN = True  # Use RPN for proposals

    if args.MODE == 'cpu':
        caffe.set_mode_cpu()
    else:
        caffe.set_mode_gpu()
        caffe.set_device(args.GPU_ID)
        cfg.GPU_ID = args.GPU_ID

    ## when getting it through the web, it comes as unicode and hence str() funct is used to convert into normal string
    prototxt = str(modelDtls["prototxt_test"])
    weights = str(modelDtls["weights"])
    print("++++++++++++++++++++++++")
    print("loading Model Details:")
    print("prototxt:")
    print(prototxt)
    print(type(prototxt))
    print("weights:")
    print(weights)
    print("modelDtls:")
    print(modelDtls)
    print("++++++++++++++++++++++++")
    if not osp.isfile(weights):
        raise IOError(('{:s} not found.\nDid you run ./data/script/'
                       'fetch_faster_rcnn_models.sh?').format(weights))
    net = caffe.Net(prototxt, weights, caffe.TEST)

    print('\n\nLoaded network {:s}'.format(weights))
    return net


def warmup(net):
    # Warmup on a dummy image
    im = 128 * np.ones((300, 500, 3), dtype=np.uint8)
    for i in xrange(2):
        _, _= im_detect(net, im)


## TBD: put NMS_THRESH, CONF_THRESH and any other architecture specific
## parameters to the configuration optin
## Create the actual createResponseForVisionAPI
## @API function
def predict(modelDtls, net, im_name, path, out_file, __appcfg):
    print("Inside {}: predict()".format(__file__))
    # Load the image
    im_file = osp.join(path, im_name)

    print('im_name: '+im_name)
    print('im_file: '+im_file)
    im = cv2.imread(im_file)
    # Detect all object classes and regress object bounds
    timer = Timer()
    timer.tic()
    scores, boxes = im_detect(net, im)
    # print scores,boxes

    ## OpenCV read the images in BGR format R=0,G=1,B=2
    ## hence, when plotting with matplotlib specify the order
    im = im[:, :, (2, 1, 0)]

    modelCfg = modelDtls["config"]

    ## Ref: https://stackoverflow.com/questions/34768717/matplotlib-unable-to-save-image-in-same-resolution-as-original-image
    dim = im.shape[:2]
    height, width = dim[0], dim[1]
    FILE_DELIMITER = __appcfg.FILE_DELIMITER

    timer.toc()
    #print(np.amax(scores, axis=1))
    #print('Detection took {:.3f}s for {:d} object proposals').format(timer.total_time, boxes.shape[0])
  
    CONF_THRESH = modelCfg.CONF_THRESH
    NMS_THRESH = modelCfg.NMS_THRESH
    # Visualize detections for each class
    CLASSES = modelDtls["CLASSES"]
    
    # print("CLASSES, NMS_THRESH: "+CLASSES+","+NMS_THRESH)

    all_rows_for_all_classes = {}
    # all_labels = []
    labelNames = enumerate(CLASSES);
    # print("Label Names: {}").format(CLASSES)

    for cls_ind, cls in labelNames:
      cls_ind += 1 # because we skipped background
      cls_boxes = boxes[:, 4*cls_ind:4*(cls_ind + 1)]
      cls_scores = scores[:, cls_ind]
      dets = np.hstack((cls_boxes,
                        cls_scores[:, np.newaxis])).astype(np.float32)
      keep = nms(dets, NMS_THRESH)
      dets = dets[keep, :]
      all_rows = getDetections(width, height, cls, dets, im_name, out_file, CONF_THRESH, FILE_DELIMITER, __appcfg)

      # all_labels.append(cls)
      if all_rows and len(all_rows) > 0:
        if all_rows["bbox"] and len(all_rows["bbox"]) > 0:
          all_rows_for_all_classes[cls] = all_rows
        else:
          all_rows_for_all_classes[cls] = None

    detections = [ Util.getVizImageFileName(im_name, None, __appcfg ) ]
    # print("faster_rcnn_end2end::detections: {}".format(detections))
    res = Util.createResponseForVisionAPI(im_name, FILE_DELIMITER, __appcfg, all_rows_for_all_classes, detections, __appcfg.API_VISION_BASE_URL)
    return res


def getDetections(width, height, class_name, dets, im_name, out_file, CONF_THRESH, FILE_DELIMITER, __appcfg):
    print("getDetections")
    row = None;

    all_bbox = []

    inds = np.where(dets[:, -1] >= CONF_THRESH)[0]
    print(len(inds))

    fileName = Util.getOutFileName(out_file, im_name, ".csv", __appcfg)

    with open(fileName,'a') as f:
      if len(inds) == 0:
        if __appcfg.SAVE_NULL_RESULTS:
          row = Util.getOutFileRow([], class_name, "null", width, height, FILE_DELIMITER)
          f.write(row+'\n')        
      else:
        for i in inds:
          bbox = dets[i, :4]
          score = dets[i, -1]
          
          # mask_rcnn: getOutFileRow: bbox:: image coordinates
          # [ 306 23 1080 1920] => [y1,x1,y2,x2] => [top, left, bottom, right] mapping in Util.getOutFileRow

          # faster_rcnn_end2end: getOutFileRow::bbox:
          # [643.95715  105.885155 717.3395   177.24414 ] => [left, top, right, bottom] => [x1,y1,x2,y2]

          # row = Util.getOutFileRow(bbox, class_name, score, width, height, FILE_DELIMITER)
          row = Util.getOutFileRow([bbox[1],bbox[0],bbox[3],bbox[2]], class_name, score, width, height, FILE_DELIMITER)
          print("row:")
          print(row)
          ## TBD: type conversion mapping
          all_bbox.append(row.split(FILE_DELIMITER))
          print("Detection Row:"+row)
          f.write(row+'\n')

    all_rows = {
      "bbox":all_bbox
    }
    return all_rows


## TBD: not sure if it's deprecated and is it retained here for legacy reasons
## and if it's used in the pixel app workflow
## @API function
def vis_detections(im, class_name, dets, im_name, out_file, CONF_THRESH, __appcfg):
  ## Deprecated (Original function)
  ## Does too many things: aggregating detections, writing it to a file, visualizing detections on image (annotate image)
  print("vis_detections")
  row = None
  all_rows = []

  # CONF_THRESH = __appcfg.CONF_THRESH
  FILE_DELIMITER = __appcfg.FILE_DELIMITER

  ## OpenCV read the images in BGR format R=0,G=1,B=2
  ## hence, when plotting with matplotlib specify the order
  im = im[:, :, (2, 1, 0)]

  ## Ref: https://stackoverflow.com/questions/34768717/matplotlib-unable-to-save-image-in-same-resolution-as-original-image
  dim = im.shape[:2]
  height, width = dim[0], dim[1]
  dpi = 80
  figsize = width/float(dpi), height/float(dpi)
  print("figsize: ")
  print(figsize)

  """Draw detected bounding boxes."""
  inds = np.where(dets[:, -1] >= CONF_THRESH)[0]
  print(len(inds))

  if len(inds) == 0:
    if __appcfg.SAVE_NULL_RESULTS:
      row = [str(im_name)+FILE_DELIMITER+str(width)+FILE_DELIMITER+str(height)+FILE_DELIMITER+"null"+FILE_DELIMITER+"null"+FILE_DELIMITER+"null"+FILE_DELIMITER+"null"+FILE_DELIMITER+str(class_name)+FILE_DELIMITER+"null"]

      fig, ax = plt.subplots(figsize=figsize)
      ax.imshow(im, aspect='equal')
      plt.axis('off')
      plt.tight_layout()
      plt.draw()
      pltname = im_name
      print('pltname: '+pltname)

      fileName = os.path.join(os.path.dirname( out_file ),'../logs-nodetections', pltname)
      print('fileName to be saved: '+fileName)
      ax.set(xlim=[0, width], ylim=[height, 0], aspect=1)

      try:
        plt.savefig(fileName, dpi=dpi, transparent=True)
      except Exception as e:
        print("Error: ")
        print(e)
      finally:
        plt.close()
        print("NULL Results Saved")
        
        return row
    return row
 
  # ax = plt.subplots(figsize=(12, 12))
  fig, ax = plt.subplots(figsize=figsize)
  ax.imshow(im, aspect='equal')
  
  for i in inds:
      bbox = dets[i, :4]
      score = dets[i, -1]

      left = bbox[0]
      top = bbox[1]
      right = bbox[2]
      bottom = bbox[3]

      # ax.add_patch(plt.Rectangle((bbox[0], bbox[1]),bbox[2] - bbox[0],bbox[3] - bbox[1], fill=False, edgecolor='red', linewidth=1.5))
      ax.add_patch(plt.Rectangle((left, top), (right - left), (bottom - top), fill=False, edgecolor='red', linewidth=1.5))
      # ax.text(left, top - 3,' {:.3f}'.format(score),bbox=dict(facecolor='blue', alpha=0.5),fontsize=14, color='white')
      # ax.text(bbox[0], bbox[1] - 2,'{:s} {:.3f}'.format(class_name),bbox=dict(facecolor='blue', alpha=0.5),fontsize=14, color='white')
  
      ax.annotate(class_name+":\n"+str(score), xy=(left, top), xytext=(left - 50, top - 50),
            color='white', size=16, ha='right', bbox=dict(facecolor='blue', alpha=0.5),
            arrowprops=dict(arrowstyle='fancy', fc='cyan', ec='none'))

      # row = str(im_name)+';'+str(bbox[0])+';'+str(bbox[1])+';'+str(bbox[2] - bbox[0])+';'+str(bbox[3] - bbox[1])+';'+str(class_name)+';'+str(score)
      # f.write()
      row = str(im_name)+FILE_DELIMITER+str(width)+FILE_DELIMITER+str(height)+FILE_DELIMITER+str(left)+FILE_DELIMITER+str(top)+FILE_DELIMITER+str(right - left)+FILE_DELIMITER+str(bottom - top)+FILE_DELIMITER+str(class_name)+FILE_DELIMITER+str(score)
      # f.write()
      all_rows.append(row)
      # print("Detection Row: ")
      # print(row)
  
  # ax.set_title(('{} detections with ''p({} | box) >= {:.1f}').format(class_name, class_name, CONF_THRESH), fontsize=14)
  plt.axis('off')
  plt.tight_layout()
  plt.draw()
  
  # name = os.path.basename(im_name)[:-4]
  # pltname = name+"_"+class_name+".jpg"
  pltname = im_name
  print('pltname:'+pltname)

  fileName = os.path.join(os.path.dirname( out_file ), pltname)
  print('fileName to be saved: '+fileName)
  ax.set(xlim=[0, width], ylim=[height, 0], aspect=1)

  try:
    # plt.savefig(fileName)
    plt.savefig(fileName, dpi=dpi, transparent=True)
  except Exception as e:
    print("Error:")
    print(e)
  finally:
    plt.close()
    print("DONE - Image Saved")
    
    return all_rows


## TBD: training mode
## comments mentioned as per mask_rcnn and hence to be updated
## @API function
def train(model, Dataset):
  print("Inside {}: train()".format(__file__))
  ### 0. Load Pre-trained model
    ## If required, exclude the last layers because they require a matching number of classes

  ### 1. Initialize & Prepare Dataset

  ## Training set
  
  ## Validation set
  
  ## Testing set

  ## Image Augmentation

  ### 2. Create Training Schedules

  ## *** This training schedule is an example. Update to your needs ***
  
  ## Training - Stage 1
  print("Training network heads")
  
  ## Training - Stage 2
  ## Finetune layers from backbone network (ResNet) stage 4 and up
  print("Fine tune Resnet stage 4 and up")

  ## Training - Stage 3
  ## Fine tune all layers
  print("Fine tune all layers")

  return
