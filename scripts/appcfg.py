__author__ = 'mangalbhaskar'
__version__ = '1.0'
'''
# Custom configuration to override default configuration
# NOTE: This should either override all keys of dictionary objects  or do not override dictionary object!
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
'''

API_DEFAULT_MODEL_KEY = 'vidteq-hmd-1'
# API_DEFAULT_MODEL_KEY = 'vidteq-ods-171019_190549'
API_DEFAULT_MODEL_KEY = 'maybeshewill-rld-1'
API_DEFAULT_MODEL_KEY = 'vidteq-rld-1'

MODE = 'gpu' #['gpu','cpu']
GPU_ID = 0
DEVICE ='/gpu:0'

DEBUG = False

DBCFG = {}

## Redis server configuration
DBCFG['REDISCFG'] = {
  'host': 'localhost'
  # 'host': '10.4.71.69'
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
  # 'host': '10.4.71.69'
  ,'port': 27017
  ,'username': ''
  ,'password': ''
  ,'dbname': 'eka'
}

## Annotation Database configuration
DBCFG['ANNONCFG'] = {
  'host': 'localhost'
  # 'host': '10.4.71.69'
  ,'port': 27017
  ,'username': ''
  ,'password': ''
  # ,'dbname': 'annon'
  # ,'dbname': 'annon_v5'
  # ,'dbname': 'annon_v5'
  ,'dbname': 'annon_v5'
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
  # 'host': '10.4.71.69'
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
