"""
Pixel DNN Framework
Base Configurations class.

Copyright (c) 2020 mangalbhaskar
Licensed under [see LICENSE for details]
Written by mangalbhaskar
"""
import os

class Traincfg(object):
  ## ---------------------------------------------
  ## DNN Arch and run time configurations
  ## ---------------------------------------------
  DNNARCH = "mask_rcnn"
  FRAMEWORK_TYPE = "keras"
  CONFIG = {
    "GPU_COUNT":1
    ,"NAME":"coco" ## Give the configuration a recognizable name
    ,"IMAGES_PER_GPU":1 ## GPU with 12GB memory, which can fit two images.
    ,"DETECTION_MIN_CONFIDENCE":0.9 ## Skip detections with < 90% confidence
    ,"IMAGE_MIN_DIM":1080
    ,"IMAGE_MAX_DIM":1920
    # Number of classes (including background)
    ,"NUM_CLASSES":1 + 80 ## Background + things # Number of classes (including background)
    ## COCO has 91 `stuff` classes + 1 unlabelled, numbered from 92 onwards i.e. afterwards the index of things `category`, calsses
    # ,"NUM_CLASSES":1 + 183  ## During data inspection
    # ,"NUM_CLASSES":1 + 92  ## During Training on coco-stuff
  }
  WEIGHTS = ['data','matterport','object_detection_segmentation','1','mask_rcnn','weights','mask_rcnn_coco.h5']
  ## "train", evaluate"
  COMMAND = "train"

  MODE = "training"
  LOAD_WEIGHTS = {
    "by_name":True
    ,"exclude":["mrcnn_class_logits", "mrcnn_bbox_fc", "mrcnn_mask"]
  }

  ## ---------------------------------------------
  ## Dataset specific configurations
  ## ---------------------------------------------
  ## @name maps to folder
  ## @dataclass maps to python file inside the @name folder

  AI_DATA = os.getenv('AI_DATA')

  LEARNING_RATE = 0.001

  COCO = {
    "name":"coco"
    ,"category": [ { "supercategory": "person", "id": 1, "name": "person" }, { "supercategory": "vehicle", "id": 2, "name": "bicycle" }, { "supercategory": "vehicle", "id": 3, "name": "car" }, { "supercategory": "vehicle", "id": 4, "name": "motorcycle" }, { "supercategory": "vehicle", "id": 5, "name": "airplane" }, { "supercategory": "vehicle", "id": 6, "name": "bus" }, { "supercategory": "vehicle", "id": 7, "name": "train" }, { "supercategory": "vehicle", "id": 8, "name": "truck" }, { "supercategory": "vehicle", "id": 9, "name": "boat" }, { "supercategory": "outdoor", "id": 10, "name": "traffic light" }, { "supercategory": "outdoor", "id": 11, "name": "fire hydrant" }, { "supercategory": "outdoor", "id": 13, "name": "stop sign" }, { "supercategory": "outdoor", "id": 14, "name": "parking meter" }, { "supercategory": "outdoor", "id": 15, "name": "bench" }, { "supercategory": "animal", "id": 16, "name": "bird" }, { "supercategory": "animal", "id": 17, "name": "cat" }, { "supercategory": "animal", "id": 18, "name": "dog" }, { "supercategory": "animal", "id": 19, "name": "horse" }, { "supercategory": "animal", "id": 20, "name": "sheep" }, { "supercategory": "animal", "id": 21, "name": "cow" }, { "supercategory": "animal", "id": 22, "name": "elephant" }, { "supercategory": "animal", "id": 23, "name": "bear" }, { "supercategory": "animal", "id": 24, "name": "zebra" }, { "supercategory": "animal", "id": 25, "name": "giraffe" }, { "supercategory": "accessory", "id": 27, "name": "backpack" }, { "supercategory": "accessory", "id": 28, "name": "umbrella" }, { "supercategory": "accessory", "id": 31, "name": "handbag" }, { "supercategory": "accessory", "id": 32, "name": "tie" }, { "supercategory": "accessory", "id": 33, "name": "suitcase" }, { "supercategory": "sports", "id": 34, "name": "frisbee" }, { "supercategory": "sports", "id": 35, "name": "skis" }, { "supercategory": "sports", "id": 36, "name": "snowboard" }, { "supercategory": "sports", "id": 37, "name": "sports ball" }, { "supercategory": "sports", "id": 38, "name": "kite" }, { "supercategory": "sports", "id": 39, "name": "baseball bat" }, { "supercategory": "sports", "id": 40, "name": "baseball glove" }, { "supercategory": "sports", "id": 41, "name": "skateboard" }, { "supercategory": "sports", "id": 42, "name": "surfboard" }, { "supercategory": "sports", "id": 43, "name": "tennis racket" }, { "supercategory": "kitchen", "id": 44, "name": "bottle" }, { "supercategory": "kitchen", "id": 46, "name": "wine glass" }, { "supercategory": "kitchen", "id": 47, "name": "cup" }, { "supercategory": "kitchen", "id": 48, "name": "fork" }, { "supercategory": "kitchen", "id": 49, "name": "knife" }, { "supercategory": "kitchen", "id": 50, "name": "spoon" }, { "supercategory": "kitchen", "id": 51, "name": "bowl" }, { "supercategory": "food", "id": 52, "name": "banana" }, { "supercategory": "food", "id": 53, "name": "apple" }, { "supercategory": "food", "id": 54, "name": "sandwich" }, { "supercategory": "food", "id": 55, "name": "orange" }, { "supercategory": "food", "id": 56, "name": "broccoli" }, { "supercategory": "food", "id": 57, "name": "carrot" }, { "supercategory": "food", "id": 58, "name": "hot dog" }, { "supercategory": "food", "id": 59, "name": "pizza" }, { "supercategory": "food", "id": 60, "name": "donut" }, { "supercategory": "food", "id": 61, "name": "cake" }, { "supercategory": "furniture", "id": 62, "name": "chair" }, { "supercategory": "furniture", "id": 63, "name": "couch" }, { "supercategory": "furniture", "id": 64, "name": "potted plant" }, { "supercategory": "furniture", "id": 65, "name": "bed" }, { "supercategory": "furniture", "id": 67, "name": "dining table" }, { "supercategory": "furniture", "id": 70, "name": "toilet" }, { "supercategory": "electronic", "id": 72, "name": "tv" }, { "supercategory": "electronic", "id": 73, "name": "laptop" }, { "supercategory": "electronic", "id": 74, "name": "mouse" }, { "supercategory": "electronic", "id": 75, "name": "remote" }, { "supercategory": "electronic", "id": 76, "name": "keyboard" }, { "supercategory": "electronic", "id": 77, "name": "cell phone" }, { "supercategory": "appliance", "id": 78, "name": "microwave" }, { "supercategory": "appliance", "id": 79, "name": "oven" }, { "supercategory": "appliance", "id": 80, "name": "toaster" }, { "supercategory": "appliance", "id": 81, "name": "sink" }, { "supercategory": "appliance", "id": 82, "name": "refrigerator" }, { "supercategory": "indoor", "id": 84, "name": "book" }, { "supercategory": "indoor", "id": 85, "name": "clock" }, { "supercategory": "indoor", "id": 86, "name": "vase" }, { "supercategory": "indoor", "id": 87, "name": "scissors" }, { "supercategory": "indoor", "id": 88, "name": "teddy bear" }, { "supercategory": "indoor", "id": 89, "name": "hair drier" }, { "supercategory": "indoor", "id": 90, "name": "toothbrush" } ]
    ,"dataclass": "CocoDataset"
    ,"task": "instances" ## "instances", "panoptic", "stuff"
    ,"basepath":""
    ## LEARNING_RATE, epochs, layers, augmentation
    ,"stages":[
      {
        'epochs':40
        ,'layers':'head'
        ,'learning_rate':LEARNING_RATE
        # ,'augmentation':True
      }
      ,{
        'epochs':120
        ,'layers':'4+'
        ,'learning_rate':LEARNING_RATE
        # ,'augmentation':True
      }
      ,{
        'epochs':160
        ,'layers':'all'
        ,'learning_rate':LEARNING_RATE / 10
        # ,'augmentation':True
      }
    ]
  }

  VIA = {
    "name":"via"
    ,"category":[{}]
    ,"dataclass":"VIADataset"
    ,"basepath":""
    # ,"task": "instances"
  }

  DATASET = []

  def display(self):
    """Display Configuration values."""
    print("\nPixel Training Configurations:")
    for a in dir(self):
      if not a.startswith("__") and not callable(getattr(self,a)):
        print("{:30} {}".format(a, getattr(self, a)))
    print("\n")