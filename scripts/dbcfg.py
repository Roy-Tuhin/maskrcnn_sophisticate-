__author__ = 'mangalbhaskar'
__version__ = '1.0'
'''
# Database configurations
## NOTE: This file 'SHOULD NOT' be customized, instead use `appcfg.py`
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
'''

DBCFG = {}

## Redis server configuration
DBCFG['REDISCFG'] = {
  'host': 'localhost'
  ,'port': 6379
  ,'db': 0
  ,'image_queue': 'image_queue'
  ,'batch_size': 1
  ,'server_sleep': 0.25
  ,'client_sleep': 0.25
  ,'image_dtype': 'float32'
  ,'client_max_tries': 100
}

## CBIR - Content Based Image Retrival Database configuration
DBCFG['CBIRCFG'] = {
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
  ,'dbname': 'annon_v2'
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
