"""modelinfo_cfg - TEPPr configuration
This is mutable object.

* one teppr cfg points to only one dataset
* one teppr cfg can have many trainings and respective evaluations, reportings
and tracks which of the training is published
* The sequence of trainings can be parallel schedule or sequence schedule.
* In case it is sequence schedule, the linkage between the sequence provides the insight on hyper tunning
* Two differnt teppr cfg can be inter-related from the perspective of transfer learning i.e. base model that
that is being used as the starting point.

teppr workflow steps

# step-1
a) point to a AI Dataset
b) create training experiment
* a) and b) can be done to create the batch workfload
c) run training
* training can run for all the workfload
# step-2
a) create evaluation strategy
b) run the evaluation
#step-3
a) generate training and evaluation reports
b) publish the model to AI port
"""

## deprecated, and only for reference

# teppr cfg
tepprcfg = {
  "created_on": None
  ,"modified_on": None
  ,"aids_dbname": None
  ,"aids_id": None
  ,"timestamp": None
  ,"log_dir": "logs/<dbname>"
  # ,"dnnarch": None
  # ,"framework_type": None
  ,"train_mode": "training"
  ,"test_mode": "inference"
  ,"allowed_file_type":['.txt','.csv','.yml','.json']
  ,"allowed_image_type":['.pdf','.png','.jpg','.jpeg','.gif']
  ,"allowed_video_type":['.mp4']
  ,"data": None
  ,"stats": None
  ,"summary": None
  ,"train":[]
  ,"evaluate": []
  ,"predict": []
  ,"publish": []
  ,"report": []
}

## ARCH CFG
traincfg = {
  "MODE": "training"
  ,"DEVICE": "/gpu:0" ## /cpu:0 or /gpu:0
  ,"WEIGHTS": None
  ,"MODEL_INFO": "mask_rcnn-matterport-coco-1.yml"
  ,"LOAD_WEIGHTS":{
    "BY_NAME": True
    ,"EXCLUDE": ['mrcnn_class_logits', 'mrcnn_bbox_fc', 'mrcnn_bbox', 'mrcnn_mask']
  }
  ,"SCHEDULES":[
    {
      "EPOCHS": 40
      ,"LAYERS": "heads"
      ,"LEARNING_RATE": 0.001
    }
    ,{
      "EPOCHS": 120
      ,"LAYERS": "4+"
      ,"LEARNING_RATE": 0.001
    }
    ,{
      "EPOCHS": 160
      ,"LAYERS": "all"
      ,"LEARNING_RATE": 0.0001
    }
  ]
  ,"CONFIG":{}
}

evaluatecfg = {
  "SAVE_VIZ_AND_JSON": True
  ,"MODE": "inference"
  ,"DEVICE": "/gpu:0" ## /cpu:0 or /gpu:0
  ,"WEIGHTS": None
  ,"MODEL_INFO": "mask_rcnn-vidteq-tsdr-1.yml"
  ,"LOAD_WEIGHTS":{
    "BY_NAME": True
    ,"EXCLUDE": ['mrcnn_class_logits', 'mrcnn_bbox_fc', 'mrcnn_bbox', 'mrcnn_mask']
  }
  ,"CONFIG":{
    "DETECTION_MIN_CONFIDENCE": 0.9
    ,"GPU_COUNT": 1
    ,"IMAGES_PER_GPU": 1
    ,"IMAGE_MIN_DIM": 720
    ,"IMAGE_MAX_DIM": 1280
  }
}

predictcfg = {
  "SAVE_VIZ_AND_JSON": True
  ,"MODE": "inference"
  ,"DEVICE": "/gpu:0" ## /cpu:0 or /gpu:0
  ,"WEIGHTS": None
  ,"MODEL_INFO": "mask_rcnn-vidteq-tsdr-1.yml"
  ,"LOAD_WEIGHTS":{
    "BY_NAME": True
    ,"EXCLUDE": ['mrcnn_class_logits', 'mrcnn_bbox_fc', 'mrcnn_bbox', 'mrcnn_mask']
  }
  ,"CONFIG":{
    "DETECTION_MIN_CONFIDENCE": 0.9
    ,"GPU_COUNT": 1
    ,"IMAGES_PER_GPU": 1
    ,"IMAGE_MIN_DIM": 720
    ,"IMAGE_MAX_DIM": 1280
  }
}

## publish_cfg is model info, whiv is linked to at least one item or more then one in the teppr cfg
publishcfg = {
  "DNNARCH": None
  ,"FRAMEWORK_TYPE": None
  ,"ID": "tsdr"
  ,"PROBLEM_ID": "tsdr_segmentation"
  ,"ORG_NAME": "vidteq"
  ,"REL_NUM": None
  ,"CONFIG": {}
  ,"NAME": "tsdr"
  ,"DATASET": None
  ,"WEIGHTS_PATH": None
  ,"WEIGHTS": "ORG_NAME/ID/REL_NUM/DNNARCH"
  ,"PROTOTXT": None
  ,"NUM_CLASSES": None
  ,"CLASSINFO": []
  ,"CLASSES": []
  ,"DESCRIPTION": None
  ,"TIMESTAMP": None
}