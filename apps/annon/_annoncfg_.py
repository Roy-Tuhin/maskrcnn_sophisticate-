"""appcfg - Annon configuration
This is mutable object.
"""
appcfg = {
  'BASEDIR_NAME':{
    'DB':'data'
    ,'LOG':'log'
    ,'ARCHIVE':'archive'
    ,'RELEASE':'release'
    ,'ANNON':'annon_data'
  }
  ## In AICATS: Last item must always be 'Unlabeled'
  ## 'Label' added for new job
  ,'AICATS':['Label', 'Human', 'Animal', 'Reptile', 'Rodent', 'Bird', 'Object', 'Structure', 'Place', 'Surface', 'Road', 'Road_Marking', 'Vehicle', 'Building', 'Contruction', 'Sky', 'Water', 'Earth', 'Fire', 'Terrain', 'Vegetation', 'Snow', 'Void', 'Loose_Material', 'Unlabeled']
  ,'BASE_PATH':{
    'DB_DIR':''
    ,'LOG_DIR':''
    ,'DB_DATA_DIR':''
    ,'RELEASE_DIR':''
  }
  ,'ERROR_TYPES': ['file_not_found','error_reading_file','unsupported_annotation_type','malformed_annotation','empty_annotation','unlabeled_annotation']
  ,'VALID_ANNON_TYPE':{
    'polygon':['all_points_x','all_points_y']
    ,'rect':['x','y','width','height']
    ,'circle':['cx','cy','r']
    ,'ellipse':['cx','cy','rx','ry']
    ,'polyline':['all_points_x','all_points_y']
    # ,'point':['cx','cy']
  }
  ,'FILES':{
    'IMAGES':'IMAGES.json'
    ,'ANNOTATIONS':'ANNOTATIONS.json'
    ,'LABELS':'LABELS.json'
    ,'ERRORS':'ERRORS.json'
    ,'CLASSINFO':'CLASSINFO.json'
    ,'STATS':'STATS.csv'
    ,'STATSLABEL':'STATSLABEL.csv'
    ,'IMAGELIST':'IMAGELIST.csv'
  }
  ,'TABLES':{
    'IMAGES':['annotations']
    ,'ANNOTATIONS':['img_id','lbl_id']
    ,'LABELS':[None]
    ,'ERRORS':[None]
    ,'STATS':[None]
    ,'STATSLABEL':[None]
    ,'IMAGELIST':[None]
  }
  ,'COLLECTIONS':['Images','Annotations']
  ,'GROUPBY':{
    'STATS':'annotator_id'
    ,'STATSLABEL':'label'
  }
  ,'SORT':{
    'STATS':'total_ant'
    ,'STATSLABEL':'annotation_per_label'
  }
  ,'SUMMARY':{
    'STATS':['annotator_id','total_ant','total_error_img_notfound','total_error_unlabeled_ant','total_error_img_reading','total_error_ant']
    ,'STATSLABEL':['label','annotation_per_label','image_per_label']
    ,'IMAGELIST':['filename','filepath','dir']
  }
  ,'RELEASE':{
    'FILE':'release.csv'
    ,'COLS':{
      'rel_id':None
      ,'timestamp':None
      ,'created_on':None
      ,'total_exec_time_in_sec':-1
      ,'total_annon_file_processed':-1
      ,'rel_type':'annon'
    }
  }
  ,'LOG':{
    'FILE':'log.csv'
    ,'COLS':{
      'rel_id':''
      ,'timestamp':''
      ,'created_on':None
      ,'total_exec_time':0
      ,'rel_filename':None
      ,'modified_on':None
    }
  }
  # ,'ANNON_DB_TABLE_PREFIX':'HMD'
  ,'ANNON_FILENAME_PREFIX':'images-p'
  ,'TIMESTAMP':''
  ## aids - AI Datasets
  ,'DB_PATH': ''
  ,'ANNDB_RELEASE_TIMESTAMP': ''
  ,'AIDS_SPLITS_CRITERIA': {
    'TNVLTT':[['train','val','test'],[0.75,0.2]]
    ,'TNVL':[['train','val'],[0.75]]
    ,'USE':'TNVLTT'
    # ,'USE':'TNVL'
  }
  ,'AIDS_FILTER':{
    # 'LABELS':[]
    'LABELS':['barricade', 'barrigade', 'billboard', 'booth', 'cctv_camera', 'crosswalk', 'flyover_pillar', 'footpath_polygon', 'garbage_can', 'garbage_trolley', 'loose_material', 'pole', 'pothole', 'reflector', 'road_asphalt', 'road_edge', 'road_polygon', 'roadside_junction_box', 'roadside_spot_light', 'signage', 'speed_breaker', 'street_light', 'traffic_light', 'traffic_sign', 'traffic_sign_frame', 'transformer', 'white_line']
    # 'LABELS':['flyover_pillar', 'pole', 'signage', 'street_light', 'traffic_sign', 'traffic_sign_frame']
    # 'LABELS':['traffic_sign', 'traffic_sign_frame', 'lane_marking']
    # 'LABELS':['traffic_sign_frame']
    # 'LABELS':['traffic_sign']
    ,'RATIO':0
    # ,'OPTIONS':['annotation_per_label','image_per_label']
    ,'BY':'LABELS'
    # ,'ON':'annotation_per_label'
    # ,'ENABLE':False
    ,'ENABLE':True
  }
  ,'AIDS_RANDOMIZER':{
    'ENABLE':True
    ,'USE_SEED':True
  }
  ,"INFO_DATA": {
    "AIDS": {
      "FILE": "aids_info.json"
      ,"DATA": None
    }
    ,"PATHS": {
      "FILE": "paths_info.yml"
      ,"DATA": None
    }
  }
  ,'SAVE_TO_FILE':True
  ,'IMAGE_API': {
    'URL': 'http://10.4.71.121/stage/maze/vs/trackSticker.php'
    ,'ENABLE':True
    ,'TYPE':'get'
    ## params keys should be in same case as provided by the URL specification
    ,'PARAMS':{
      'action':'getImage'
      ,'image':''
    }
    ,'SAVE_LOCAL_COPY':True
    ,'DEBUG':True
    ,'IMAGE_HEIGHT':1080
    ,'IMAGE_WIDTH':1920
    ,'STATIC_IMAGE_DIMENSION':False
    ,'IMG_CHECK':True
  }
  ,'ALLOWED_IMAGE_TYPE':['.png', '.jpg', '.jpeg', '.gif']
  ,'TEPPR_ITEMS':['train', 'evaluate', 'predict', 'publish','report']
}

DBCFG = {}

## Redis server configuration
DBCFG['REDIS'] = {
  'host': 'localhost'
  ,'port': 6379
  ,'db': 0
  ,'image_queue': 'image_queue'
  ,'batch_size': 32
  ,'server_sleep': 0.25
  ,'client_sleep': 0.25
}

## CBIR - Content Based Image Retrival Database configuration
DBCFG['CBIRDB'] = {
  'host': 'localhost'
  ,'port': 27017
  ,'username': ''
  ,'password': ''
  ,'dbname': 'eka'
}

## Annotation Database configuration
DBCFG['ANNONCFG'] = {
  'host': 'localhost'
  ,'port': 27017
  ,'username': ''
  ,'password': ''
  # ,'dbname': 'annon'
  # ,'dbname': 'annon_v9'
  # ,'dbname': 'annon_v9'
  # ,'dbname': 'annon_v9'
  # ,'dbname': 'annon_v9'
  # ,'dbname': 'annon_v9'
  # ,'dbname': 'annon_v9'
  ,'dbname': 'annon_v10'
  ,'dataclass': 'AnnonDataset'
  ,'name': 'hmd'
  ,'annon_type': 'hmd'
  ,'class_ids': None
  ,'return_hmd': None
  ,'data_read_threshold': -1
}

## AI Datasets (AIDS) Database configuration
DBCFG['PXLCFG'] = {
  'host': 'localhost'
  ,'port': 27017
  ,'username': ''
  ,'password': ''
  ,'dbname': 'PXL'
  ,'dataclass': 'AnnonDataset'
  ,'name': 'hmd'
  ,'annon_type': 'hmd'
  ,'class_ids': None
  ,'return_hmd': None
  ,'data_read_threshold': -1
}

## Release Model Database configuration
DBCFG['OASISCFG'] = {
  'host': 'localhost'
  ,'port': 27017
  ,'username': ''
  ,'password': ''
  ,'dbname': 'oasis'
  ,'dataclass': 'AnnonDataset'
  ,'name': 'hmd'
  ,'annon_type': 'hmd'
  ,'class_ids': None
  ,'return_hmd': None
  ,'data_read_threshold': -1
}

appcfg['DBCFG'] = DBCFG
