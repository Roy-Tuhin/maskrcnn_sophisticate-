__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).

# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
## Example:
# --------------------------------------------------------

## TODO:
# --------------------------------------------------------

## Future wok:
# --------------------------------------------------------

"""

import os
import sys
import glob
import time
import datetime
import json
import logging

# Root directory of the project
ROOT_DIR = os.path.abspath(".")
sys.path.append(ROOT_DIR)  # To find local version of the library


from _annoncfg_ import appcfg
import common

log = logging.getLogger('__main__.'+__name__)


## TODO: *.yml file name should be the timestamp of AIDS createion date (used as AIDS_ID)
def get_dbcfg_template():
  """DBCfg - Template to generate the yml file
  """
  dbcfg = {
    "DESCRIPTION": "HD Map Dataset"
    ,"AIDS_INFO": ""
    ,"PATHS_INFO": ""
    ,"UUID":""
    ,"AIDS_ID":""
    ,"ANNDB_ID":""
    ,"ID": "hmd"
    ,"NAME": "hmd"
    ,"PROBLEM_ID": "hmd"
    ,"NUM_CLASSES": None
    ,"ANNON_TYPE": "hmd"
    ,"DB_DIR": None
    ,"TIMESTAMP": ""
    ,"ANNOTATIONS": {
        "TRAIN": "" 
        ,"VAL": ""
        ,"TEST": ""
    }
    ,"IMAGES": {
        "TRAIN": ""
        ,"VAL": ""
        ,"TEST": ""
    }
    ,"LABELS":{   
        "TRAIN": ""
        ,"VAL": ""
        ,"TEST": ""
    }
    ,"CLASSES": ""
    ,"CLASSINFO": {
        "TRAIN": "" 
        ,"VAL": ""
        ,"TEST": ""
    }
    ,"CLASS_IDS": None
    ,"CLASS_MAP": None
    ,"RETURN_ANNDB": None
    ,"RETURN_HMD": None
    ,"SPLITS": ""
    ,"DATACLASS": "HmdDataset"
    # set to negative value to load all data, '0' loads no data at all
    ,"DATA_READ_THRESHOLD": -1
  }

  return dbcfg


def create_dbcfg(cfg, base_path):
  AIDS_SPLITS_CRITERIA = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]
  splits = AIDS_SPLITS_CRITERIA[0]
  dbcfg = get_dbcfg_template()
  dbcfg['SPLITS'] = splits

  for split in splits:
    files = glob.glob(os.path.join(base_path,'*'+split+'.json'))
    log.info("split:{},{}".format(split, files))
    for f in files:
      item_filename = f.split(os.path.sep)[-1]
      item = item_filename.split('.')[0].split('_')
      log.info("item: {}".format(item))
      dbcfg[ item[0].upper() ][ item[1].upper() ] = os.path.sep.join(f.split(os.path.sep)[-2:])

  aids_info_filepath = os.path.join(base_path, cfg['INFO_DATA']['AIDS']['FILE'])
  log.info("aids_info_filepath: {}".format(aids_info_filepath))
  with open(aids_info_filepath,'r') as fr:
    aids_info = json.load(fr)

  dbcfg['UUID'] = aids_info['uuid']
  dbcfg['AIDS_ID'] = aids_info['aids_id']
  dbcfg['ANNDB_ID'] = aids_info['anndb_id']

  dbcfg['AIDS_INFO'] =  os.path.join(aids_info['aids_id'], cfg['INFO_DATA']['AIDS']['FILE'])
  dbcfg['PATHS_INFO'] = os.path.join(aids_info['aids_id'], cfg['INFO_DATA']['PATHS']['FILE'])

  log.info(dbcfg)
  return dbcfg


def save_dbcfg(base_path, dbcfg):
  fileName = dbcfg['AIDS_ID']+'.yml'
  filepath = os.path.join(base_path, fileName)
  common.yaml_safe_dump(filepath, dbcfg)

  return filepath


def release_dbcfg(cfg, from_path, to_path):
  tic = time.time()
  log.info("\nrelease_dbcfg:-----------------------------")
  timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))
  
  base_to_path = common.getBasePath(to_path)
  log.info("base_to_path: {}".format(base_to_path))

  dbcfg = create_dbcfg(cfg, base_from_path)
  dbcfg['TIMESTAMP'] = timestamp

  filepath = save_dbcfg(base_to_path, dbcfg)
  log.info('\nDone (t={:0.2f}s)\n'.format(time.time()- tic))
  
  return filepath


def main(cfg, args):
  from_path = args.from_path
  to_path = args.to_path

  filepath = release_dbcfg(cfg, base_from_path, base_to_path)
  log.info("-------")
  log.info("dbcfg filepath: {}".format(filepath))
  log.info("-------")


def parse_args():
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Annotation parser for VGG Via tool files'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/aids (AI Dataset)'
    ,required=True)

  parser.add_argument('--to'
    ,dest='to_path'
    ,help='/path/to/cfg/dataset'
    ,required=True)
  
  args = parser.parse_args()
  
  from_path, to_path = args.from_path, args.to_path
  for d in [from_path, to_path]:
    if not os.path.exists(d):
      raise NotADirectoryError("{}".format(d))
  
  return args


if __name__ == '__main__':
  args = parse_args()
  
  main(appcfg, args)