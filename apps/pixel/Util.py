#!/usr/bin/env python

# --------------------------------------------------------
# Copyright (c) 2018 VidTeq
# Licensed under The MIT License [see LICENSE for details]
# Written by Mangal Bhaskar
# --------------------------------------------------------

import os
import os.path as osp
import time
import matplotlib.pyplot as plt

import datetime

import numpy as np
import json


class NumpyEncoder(json.JSONEncoder):
  """Special json encoder for numpy types
  Ref:
  https://stackoverflow.com/questions/26646362/numpy-array-is-not-json-serializable
  """
  def default(self, obj):
    if isinstance(obj, (np.int_, np.intc, np.intp, np.int8,
      np.int16, np.int32, np.int64, np.uint8,
      np.uint16, np.uint32, np.uint64)):
      return int(obj)
    elif isinstance(obj, (np.float_, np.float16, np.float32,  np.float64)):
      return float(obj)
    elif isinstance(obj,(np.ndarray,)):
      #### This is the fix
      return obj.tolist()
    return json.JSONEncoder.default(self, obj)


def numpy_to_json(json_input):
  json_str = json.dumps(json_input, cls=NumpyEncoder)
  return json_str


## file_name = "mask_{:%Y%m%dT%H%M%S}.png".format(datetime.datetime.now())

'''
`mkdir -p` linux command functionality

References:
* https://stackoverflow.com/questions/600268/mkdir-p-functionality-in-python
'''
def mkdir_p(path):
  try:
    os.makedirs(path)
  except OSError as exc:  # Python >2.5
    if exc.errno == errno.EEXIST and os.path.isdir(path):
      pass
    else:
      raise


def get(module, name):
  from importlib import import_module

  fn = None
  mod = import_module(module)
  if mod:
    fn = getattr(mod, name)
    if not fn:
      print("_get: function is not defined in the module!")
  
  return fn


def load_module(module):
  from importlib import import_module
  mod = import_module(module)
  return mod


def getDnnModule(args):
  # dnnModule = "pixel.mask_rcnn"
  # dnnModule = "pixel.faster_rcnn_end2end"
  dnnarch = args.DNNARCH
  dnnModule = "pixel."+dnnarch
  return dnnModule


## TBD: error handling
def yaml_load(fileName):
  import yaml
  from easydict import EasyDict as edict
  fc = None
  with open(fileName, 'r') as f:
    # fc = edict(yaml.load(f))
    fc = edict(yaml.safe_load(f))

  return fc


def getHeader(fileName, delimiter):
  with open(fileName,'r') as f:
    for line in f:
      return line.rstrip('\n').split(delimiter)


def readLine(fileName, delimiter, skipHeader):
  with open(fileName,'r') as f:
    gen = (i for i in f)
    
    if skipHeader:
      next(gen) # skip the header row
    
    for line in gen:
      yield line.rstrip('\n').split(delimiter)


## Usage: list( getOnlyFilesInDir(path) )
def getOnlyFilesInDir(path):
  for file in os.listdir(path):
    if osp.isfile(osp.join(path, file)):
      yield file


def createResponseForVisionAPI(im_name, FD, __appcfg, all_rows_for_all_classes, detections, baseUrl):
  # header = getOutFileHeader(FD).split(FD)
  # hFields = { header[i]:i for i in range(0,len(header), 1) }
  fname = osp.basename(im_name)
  ID = __appcfg.ID
  print("createResponseForVisionAPI::ID: {}".format(ID))

  apiDetectionsUrl = []
  # for url in detections:    
  #   apiUrl = baseUrl+"/detections/"+url
  #   print("apiUrl: {}".format(apiUrl))
  #   apiDetectionsUrl.append(apiUrl)

  res = {
    "name": fname
    ,"api": {
      "uploads":baseUrl+"/uploads/"+fname
      # ,"detections":apiDetectionsUrl
    }
    ,"type":ID
    # ,"bboxfields": hFields
    ,"result": all_rows_for_all_classes
  }

  return res

## Ref::
## https://stackoverflow.com/questions/17153978/flask-error-handling-response-object-is-not-iterable
## not used now as using from flask import jsonify
# def getResponse(data, res_code, mimetype):
#   # print("getResponse:")
#   # print(data)
#   from flask import Response
#   res = Response(response=data, status=res_code, mimetype=mimetype)
#   # print("data, res_code, mimetype: {} {} {}".format(data, res_code, mimetype))

#   if mimetype=="application/xml":
#     res.headers["Content-Type"] = "text/xml; charset=utf-8"
  
#   if mimetype=="application/json":
#     res.headers["Content-Type"] = "text/json; charset=utf-8"
  
#   # print("res.headers: {}".format(res.headers))
#   # print("--------------")

#   return res



def getOutFileRow(bbox, label, score, width, height, FD):
  print("getOutFileRow::bbox: {}".format(bbox))

  # mask_rcnn: getOutFileRow: bbox:: image coordinates => following this convention now!
  # [ 306 23 1080 1920] => [y1,x1,y2,x2] => [top, left, bottom, right] mapping in Util.getOutFileRow

  # faster_rcnn_end2end: getOutFileRow::bbox: => this was original output now transformed to mask_rcnn convention
  # [643.95715  105.885155 717.3395   177.24414 ] => [left, top, right, bottom] => [x1,y1,x2,y2]

  if len(bbox) > 0:
    # left = bbox[0]
    # top = bbox[1]
    # right = bbox[2]
    # bottom = bbox[3]

    left = bbox[1]
    top = bbox[0]
    right = bbox[3]
    bottom = bbox[2]
    row = str(label)+FD+str(score)+FD+str(width)+FD+str(height)+FD+str(left)+FD+str(top)+FD+str(right - left)+FD+str(bottom - top)
  else:
    row = str(label)+FD+"null"+FD+str(width)+FD+str(height)+FD+"null"+FD+"null"+FD+"null"+FD+"null"

  return row


def getOutFileHeader(FD):
    header = 'label'+FD+'score'+FD+'image_width'+FD+'image_height'+FD+'left_x'+FD+'top_y'+FD+'width_w'+FD+'height_h'
    return header


## TBD: some issue, review the logic again for the standalone app execution
def getOutFileName(path, im_name, ext, __appcfg):
  fpath = path
  fname = osp.basename(im_name)
  # print("getOutFileName:fpath, im_name, fname: {}, {}, {}".format(fpath, im_name, fname))
  if osp.isdir(path):
    fpath = path
  else:
    fpath = osp.dirname(path)

  if ext==".csv":
    fname = __appcfg.ID + "-" + __appcfg.REL_NUM + "-" + fname

  # fname = fname+"-{:%Y%m%dT%H%M%S}".format(datetime.datetime.now())
  fileName = osp.join(fpath, fname + ext)
  print("getOutFileName:fpath, fname, fileName: {}, {}, {}".format(fpath, fname, fileName))
  return fileName


def getVizImageFileName(im_name, vizType, __appcfg ):
  ext = ".png"
  ## vizType = viz, splash, mask, None
  fname = osp.basename(im_name)

  if vizType is None:
    vizImageFileName = fname
  else:
    vizImageFileName = fname+"-"+__appcfg.ID+"-"+__appcfg.REL_NUM+"-"+vizType+ext
  
  # fpath = osp.dirname(osp.abspath(im_name))
  # return osp.join(fpath, vizImageFileName)
  return vizImageFileName


def vis_detections_from_csvfile(im_name, delimiter, path, out_file, __appcfg):
  t3 = time.time()  
  print("vis_detections_from_csvfile")
  
  fileName = getOutFileName(out_file, im_name, ".csv", __appcfg)

  print("fileName:")
  print(fileName)
  print("path:")
  print(path)
  print("im_name:")
  print(im_name)
  
  # print("__appcfg: {}".format(__appcfg))

  detections = False

  if os.path.exists(fileName):
      header = getHeader(fileName, delimiter)
      hFields = { header[i]:i for i in range(0,len(header), 1) }
      
      imgFileName = osp.join(path, im_name)
      print(imgFileName)
      
      ## read image
      im = plt.imread(imgFileName)
      # print(im)
      dim = im.shape[:2]
      # print(dim)
      H, W = dim[0], dim[1]
      dpi = 80
      figsize = W/float(dpi), H/float(dpi)
      # print(figsize)
      fig, ax = plt.subplots(figsize=figsize)

      fig = plt.figure(figsize=figsize)      
      ax = fig.add_axes([0.,0,1,1])

      ax.axis('off')
      # ax.imshow(im, aspect='equal')
      # ax.imshow(im.astype(np.uint8))
      ax.imshow(im)

      ## read and create annotatation
      
      for row in readLine(fileName, delimiter, True):
          print("row:")
          print(row)
          
          if len(row) < 1:
            continue
          
          if row[ hFields["score"] ] == 'null':
            continue

          detections = True
          print("hFields:")
          print(hFields)
          image_width = float(row[ hFields["image_width"] ])
          image_height = float(row[ hFields["image_height"] ])
          left = float(row[ hFields["left_x"] ])
          top = float(row[ hFields["top_y"] ])
          width = float(row[ hFields["width_w"] ])
          height = float(row[ hFields["height_h"] ])
          label = row[ hFields["label"] ]
          score = row[ hFields["score"] ]
          # print(image_width)
          # print(image_height)
          # print(left)
          # print(top)
          # print(width)
          # print(height)
          # print(label)
          # print(score)
          
          txtLabel = label +':\n'+score
          ## add bbox
          ax.add_patch(plt.Rectangle((left,top), width, height, fill=False, edgecolor="red", linewidth=1.5))
          ## label
          # ax.text(left, top, txtLabel, bbox=dict(facecolor='blue', alpha=0.5), fontsize=14, color='white')
          
          ## label with fancy arrow
          ax.annotate(txtLabel, xy=(left, top), xytext=(left - 50, top - 50),
            color='white', size=16, ha='right', bbox=dict(facecolor='blue', alpha=0.5),
            arrowprops=dict(arrowstyle='fancy', fc='cyan', ec='none'))

      try:
        if detections or __appcfg.SAVE_NULL_RESULTS:
          ## Save Annotated Image
          # ax.set(xlim=[0,W], ylim=[H,0], aspect=1)
          # pltname = osp.basename(fileName)
          pltname = im_name
          pltfilename = getOutFileName(out_file, pltname, "", "")

          # plt.axis('off')
          plt.draw()
          plt.savefig(pltfilename, dpi=dpi, transparent=False, bbox_inches='tight')
          print("File saved: "+pltfilename)

        ## TBD: in case of no detections, put all the images and csv files in a separate directory for easy access
        # if not detections and not __appcfg.SAVE_NULL_RESULTS:
        #   print("no detection: hence will be deleted!")
        #   print(fileName)
        #   os.path.exists(fileName) and os.remove(fileName)
      except Exception as e:
        print("Error: ")
        print(e)
      finally:
        plt.close()

  t4 = time.time()
  print("====>: Time taken for vis_detections_from_csvfile: ")
  print(t4 - t3)

  return detections


def vis_annotations(out_file, fileName, left, top, width, height, label):
      # read image
    im = plt.imread(fileName)
    # print(im)

    dim = im.shape[:2]
    # print(dim)
    H, W = dim[0], dim[1]
    dpi = 80
    figsize = W/float(dpi), H/float(dpi)
    # print(figsize)

    fig, ax = plt.subplots(figsize=figsize)
    ax.imshow(im, aspect='equal')

    ## add annotations
    
    plt.axis('off')
    plt.draw()
    # ax.set(xlim=[0,W], ylim=[H,0], aspect=1)
    pltname = osp.basename(fileName)
    pltfilename = getOutFileName(out_file, pltname, "", "")
    try:
      plt.savefig(pltfilename, dpi=dpi, transparent=False, bbox_inches='tight')
    except Exception as e:
      print("Error: ")
      print(e)
    finally:
      plt.close()
      print("File saved: "+pltfilename)


def delete_no_detection_csvfile(im_name, delimiter, path, out_file, __appcfg):
    print("delete_no_detection_csvfile")

    fileName = getOutFileName(out_file, im_name, ".csv", __appcfg)

    detections = False
    for row in readLine(fileName, delimiter, True):
      print("Found detections:")
      detections = True
      break;

    if not detections:
      try:
        ## TBD: in case of no detections, put all the images and csv files in a separate directory for easy access
        if not __appcfg.SAVE_NULL_RESULTS:
          print("no detection: hence will be deleted!")
          print(fileName)
          osp.exists(fileName) and os.remove(fileName)
      except Exception as e:
        print("Error: ")
        print(e)

    return detections


## TBD:
## 1. path as URL (http, https)
## 2. path with remote protocol access: ssh/sftp/ftp/smb path
## 3. Read textfile with the complete path of image,
##    instead of taking textfile path as the base path for the images
def getImageAndPathDtls(args):
  import numpy as np
  dtls = {
      "path":""
      ,"images":[]
  }
  path = args.PATH

  if osp.isdir(path):
      dtls["path"] = path
      # dtls["images"] = sorted(os.listdir(path)) ## this will contain the directories also
      dtls["images"] = list( getOnlyFilesInDir(path) )
  else:
      if osp.isfile(path):
          fn, ext = osp.splitext(osp.basename(path))
          print("fn, ext: {} {}".format(fn,ext))
          
          dtls["path"] = osp.dirname(path)

          if ext.lower() in args['ALLOWED_FILE_TYPE']:
              # it is a file containing image names
              with open(path,'r') as f:
                  data = f.read()
                  ## Ref: https://stackoverflow.com/questions/1140958/whats-a-quick-one-liner-to-remove-empty-lines-from-a-python-string
                  gen = (i.split(args['FILE_DELIMITER'])[0] for i in data.split('\n') if i.strip("\r\n") ) # this works even if i=['100818_144130_16718_zed_l_938.jpg']
                  dtls["images"] = np.unique( list(gen) ).tolist()
          elif ext.lower() in args['ALLOWED_IMAGE_TYPE']:
              # it is a single image file
              dtls["images"] = [ osp.basename(path) ] ## convert to list
  
  return dtls;



## Ref:
## https://stackoverflow.com/questions/3853722/python-argparse-how-to-insert-newline-in-the-help-text
def parse_args_for_predict(cfg, msg=''):
  import argparse
  from argparse import RawTextHelpFormatter

  """Parse input arguments."""
  parser = argparse.ArgumentParser(
    description='DNN Application Framework - Prediction.\n * Refer: `dnncfg.yml` for model configuration details.\n * Refer: `paths.yml` environment and paths configurations.\n\n' + msg
    ,formatter_class=RawTextHelpFormatter)
    
  parser.add_argument('--gpu'
    ,dest='gpu_id'
    ,metavar="<gpu id>"
    ,help='Single GPU device id to use [0]'
    ,default=0
    ,type=int)
  
  parser.add_argument('--cpu'
    ,dest='cpu_mode'
    ,help='Use CPU mode (overrides --gpu)'
    ,action='store_true')
  
  parser.add_argument('--net'
    ,dest='org_name'
    # ,metavar="<organisation Name>"
    ,help='Network to use ['+cfg.ORG_NAME+']'
    ,default=cfg.ORG_NAME
    ,required=True
    ,choices=cfg.NETS.keys())
  
  parser.add_argument('--id'
    ,dest='id'
    # ,metavar="<dnn id>"
    ,help='DNN problem identification acronym ['+cfg.ID+']'
    ,default=cfg.ID
    ,required=True
    ,choices=cfg.APIS.vision.ids.keys())

  parser.add_argument('--rel'
    ,dest='rel_num'
    ,metavar="<release number>"
    ,help='Release number / ID for the DNN ['+cfg.REL_NUM+']'
    ,default=cfg.REL_NUM
    ,required=True)

  parser.add_argument('--dnn'
    ,dest='dnnarch'
    # ,metavar="<dnn architecture name>"
    ,help='DNN Architecture ['+cfg.DNNARCH+']'
    ,default=cfg.DNNARCH
    ,required=True
    ,choices=cfg.DNNARCH_AVAILABLE)


  parser.add_argument('--path'
    ,dest='path'
    ,metavar="/path/to/images"
    ,help='Input: Path of images folder or image file or text file containing image names. Allowed Image Types: '+str(cfg.ALLOWED_IMAGE_TYPE)
    ,default=''
    ,required=True)
  
  parser.add_argument('--out'
    ,dest='out'
    ,metavar="/path/to/output/directory"
    ,help='Output directory')

  ## TBD: out_file would be used for reporting inseated of output of the detections
  ## and it would be the  default path under reports/summary-<ID>-<dd-mmm-yyyy>.csv

  # parser.add_argument('--file',dest='test_file',help='Path the test images txt file')
  # parser.add_argument('--image_file',dest='image_file',help='Image file with complete path')    
  #parser.add_argument('--folder_index',dest='folder_index',help='Folder Number')
  #parser.add_argument('--lat',dest='lat',help='Latitude')
  #parser.add_argument('--lon',dest='lon',help='Longitude')

  args = parser.parse_args()
  print(args)

  return args


## Training is GPU bound process
def parse_args_for_train(cfg, msg=''):
  import argparse
  from argparse import RawTextHelpFormatter

  """Parse input arguments."""
  parser = argparse.ArgumentParser(
    description='DNN Application Framework - Training.\n * Refer: `paths.yml` environment and paths configurations.\n\n' + msg
    ,formatter_class=RawTextHelpFormatter)
  
  parser.add_argument('command'
    ,metavar="<command>"
    ,default="inspect"
    ,help='inspect or train')
  
  parser.add_argument('--cfg'
    ,metavar="/path/to/traincfg-<dnnArch>.yml"
    # ,default="traincfg-mask_rcnn.yml"
    ,required=True
    ,help='Configuration file (yml) for specifiying DNN training parameters, ex: `traincfg-mask_rcnn.yml`')

  parser.add_argument('--dataset'
    ,metavar="dataset_name"
    ,required=True
    ,help='Dataset name')

  args = parser.parse_args()
  print(args)

  return args


'''
## parse_args
'''
def parse_args():
  import argparse
  from argparse import RawTextHelpFormatter

  commands = ['train', 'predict', 'inspect_data', 'evaluate', 'tdd']
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='Pixel - DNN Application Framework.\n * Refer: `paths.yml` environment and paths configurations.\n\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--cfg'
    ,metavar="/path/to/<name>-cfg.yml"
    ,required=True
    ,help='Configuration file (yml) for specifiying DNN training parameters, ex: `balloon-cfg.yml`')

  parser.add_argument('--path'
    ,dest='path'
    ,metavar="/path/to/image(s)_or_video(s)"
    ,help='Input: Path of images/videos folder or image/video file or text file containing image names. Allowed Image Types')

  parser.add_argument('--on'
    ,dest='eval_on'
    ,metavar="[train | val | test]"
    ,help='provide the dataset type "on" against which prediction results would be compared with.')

  args = parser.parse_args()    

  # Validate arguments
  cmd = args.command

  cmd_supported = False

  for c in commands:
    if cmd == c:
      cmd_supported = True

  if not cmd_supported:
    print("'{}' is not recognized.\n"
          "Use any one: {}".format(cmd,', '.join(commands)))
    sys.exit(-1)

  if cmd == "evaluate":
    assert args.eval_on,\
           "Provide --on"

  if cmd == "predict":
    assert args.path,\
           "Provide --path"

  if cmd == "train":
    mode = "training"
  else:
    mode = "inference"

  args.mode = mode

  return args
