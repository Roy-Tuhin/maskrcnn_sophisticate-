"""TEPPr configuration
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
tepprcfg = {}
## training configuration
tepprcfg['train'] = {
  'allowed_file_type':['.txt','.csv','.yml','.json']
  ,'allowed_image_type':['.pdf','.png','.jpg','.jpeg','.gif']
  ,'allowed_video_type':['.mp4']
  ,'train_mode': 'training'
  ,'test_mode': 'inference'
  ,'dbname': None
  ,'splits': None
  ,'annon_type': 'hmd'
  ,'dataclass': 'AnnonDataset'
  ,'name': 'hmd'
  ,'framework_type': None
  ,"mode": "training"
  ,"device": "/gpu:0" ## /cpu:0 or /gpu:0
  ,"weights": None
  ,"model_info": None
  ,'dnnarch':None
  ,"config":{}
  ,"load_weights":None
  ,"schedules":[]
}

## evaluation configuration
tepprcfg['evaluate'] = {
  'allowed_file_type':['.txt','.csv','.yml','.json']
  ,'allowed_image_type':['.pdf','.png','.jpg','.jpeg','.gif']
  ,'allowed_video_type':['.mp4']
  ,'train_mode': 'training'
  ,'test_mode': 'inference'
  ,'dbname': None
  ,'splits': None
  ,'annon_type': 'hmd'
  ,'dataclass': 'AnnonDataset'
  ,'name': 'hmd'
  ,'framework_type': None
  ,"mode": "inference"
  ,"device": "/gpu:0" ## /cpu:0 or /gpu:0
  ,"weights": None
  ,"model_info": None
  ,'dnnarch':None
  ,"config": {}
  ,"load_weights": {}
  ,"save_viz_and_json": True
  ,'evaluate_no_of_result': -1
  ,'iou_threshold': 0.5
}

## prediction configuration
tepprcfg['predict'] = {
  'allowed_file_type':['.txt','.csv','.yml','.json']
  ,'allowed_image_type':['.pdf','.png','.jpg','.jpeg','.gif']
  ,'allowed_video_type':['.mp4']
  ,'train_mode': 'training'
  ,'test_mode': 'inference'
  ,'dbname': None
  ,'framework_type': None
  ,"mode": "inference"
  ,"device": "/gpu:0" ## /cpu:0 or /gpu:0
  ,"weights": None
  ,"model_info": None
  ,'dnnarch':None
  ,"config":{}
  ,"load_weights":{}
  ,"save_viz_and_json": True
  ,'iou_threshold': 0.5
}

## publish_cfg is model info, whiv is linked to at least one item or more then one in the teppr cfg
modelinfo_cfg = {
  'dataset': None
  ,'dnnarch':None
  ,'framework_type': None
  ,'train_mode': 'training'
  ,'test_mode': 'inference'
  ,'mode':'inference'
  ,"classes": []
  ,"classinfo": []
  ,"config": {}
  ,"id": None
  ,"name": 'hmd'
  ,"org_name": "vidteq"
  ,"problem_id": None
  ,"rel_num": None
  ,"weights": "ORG_NAME/ID/REL_NUM/DNNARCH"
  ,"weights_path": None
  ,"prototxt": None
  ,"num_classes": 0
  ,"description": None
  ,"created_on": None
  ,"modified_on": None
  ,"timestamp": None
}