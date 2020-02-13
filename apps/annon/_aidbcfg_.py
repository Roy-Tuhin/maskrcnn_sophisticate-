"""dbcfg - Annon configuration
This is mutable object.
"""
dbcfg = {
  "created_on": None
  ,"modified_on": None
  ,"timestamp": None
  ,"anndb_id": None
  ,"rel_id": None
  ,"dbname": None
  ,"dbid": None
  ,"allowed_file_type":['.txt','.csv','.yml','.json']
  ,"allowed_image_type":['.pdf','.png','.jpg','.jpeg','.gif']
  ,"allowed_video_type":['.mp4']
  ,"dataset": {}
  ,"load_data_from_file": False 
  ,"train":[]
  ,"evaluate": []
  ,"predict": []
  ,"publish": []
  ,"report": []
  ,"description": "AI Dataset"
  ,"files": {}
  ,"id": "hmd"
  ,"name": "hmd"
  ,"problem_id": "hmd"
  ,"annon_type": "hmd"
  ,"dataclass": "AnnonDataset"
  ,"classes": ""
  ,"classinfo": None
  ,"class_ids": None
  ,"class_map": None
  ,"num_classes": None
  ,"splits": None
  ,"stats": {}
  ,"summary": {}
  ,"metadata": {}
  # set to negative value to load all data, '0' loads no data at all
  ,"data_read_threshold": -1
  ,"db_dir": None
  ,"return_hmd": None
  ,"train_mode": "training"
  ,"test_mode": "inference"
  # ,"dnnarch": None
  # ,"log_dir": "logs/<dnnarch>"
  # ,"framework_type": None
  # ,"annotations": {
  #     "train": "" 
  #     ,"val": ""
  #     ,"test": ""
  # }
  # ,"images": {
  #     "train": ""
  #     ,"val": ""
  #     ,"test": ""
  # }
  # ,"labels":{   `
  #     "train": ""
  #     ,"val": ""
  #     ,"test": ""
  # }
  # ,"classinfo": {
  #     "train": "" 
  #     ,"val": ""
  #     ,"test": ""
  # }
}