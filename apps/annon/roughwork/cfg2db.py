__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).

# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
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
import time

from pymongo import MongoClient

import logging
import logging.config

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

from _annoncfg_ import appcfg
import annonutils
import common

this = sys.modules[__name__]

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)


def get_info(args, cfg, db):
  log.info("----------------------------->")

  aids_data = None
  tblname = annonutils.get_tblname('AIDS')
  collection = db.get_collection(tblname)
  if collection:
    aids_data = list(collection.find({},{'_id':False,'aids_dbname':True
      ,'aids_id':True, 'annon_type':True, 'classes':True}))
    aids_data = list(collection.find({},{'_id':False}))

  return aids_data


def create_modelinfo(args, cfg, db):
  log.info("----------------------------->")
  from_path = args.from_path
  if not from_path:
    raise Exception('from_path not defined')
  if not os.path.exists(from_path) or not os.path.isfile(from_path):
    raise Exception('File does not exists: {}'.format(from_path))
  
  ##TODO: for the entire directory
  data = common.loadcfg(from_path)

  if data and len(data) > 0:
    data = {k.lower():v for k,v in data.items()} 

  ## TODO: empty data and other sanity checks
  created_on = common.now()
  timestamp = common.timestamp_from_datestring(created_on)
  uuid = common.createUUID('uuid')
  data['uuid'] = uuid
  data['created_on'] = created_on
  data['timestamp'] = timestamp

  tblname = annonutils.get_tblname('MODELINFO')
  # annonutils.create_unique_index(db, tblname, 'created_on')
  annonutils.create_unique_index(db, tblname, 'weights_path')
  collection = db.get_collection(tblname)
  collection.update_one(
    {'created_on': data['created_on']}
    ,{'$setOnInsert': data}
    ,upsert=True
  )


def create_experiment(args, cfg, db):
  log.info("----------------------------->")
  from_path = args.from_path
  if not from_path:
    raise Exception('--from not defined')
  dbid = args.to
  if not dbid:
    raise Exception('--to not defined')
  exp_type = args.exp
  if not exp_type:
    raise Exception('--exp not defined')

  if not os.path.exists(from_path) or not os.path.isfile(from_path):
    raise Exception('File does not exists: {}'.format(from_path))
  
  ##TODO: for the entire directory
  data = common.loadcfg(from_path)

  if data and len(data) > 0:
    data = {k.lower():v for k,v in data.items()} 

 # teppr_items = cfg['TEPPR_ITEMS']
 #  for item in teppr_items:
 #    data[item]
  ## TODO: empty data and other sanity checks

  if exp_type in data:
    data = data[exp_type]

  if data and len(data) > 0:
    data = {k.lower():v for k,v in data.items()} 

  ## TODO: empty data and other sanity checks
  created_on = common.now()
  timestamp = common.timestamp_from_datestring(created_on)
  uuid = common.createUUID('uuid')
  data['uuid'] = uuid
  data['created_on'] = created_on
  data['timestamp'] = timestamp
  log_dir = os.path.join(data['dnnarch'], timestamp)
  data['log_dir'] = log_dir
  

  tblname = annonutils.get_tblname('AIDS')
  collection = db.get_collection(tblname)
  # aids_data = list(collection.find({'aids_id':from_path},{'_id':False}))

  expdata = {}
  expdata[exp_type] = data
  ## {'train':data}

  log.info("data:{}".format(expdata))
  
  ## TODO if collection does not exist raise error
  # if collection:
  collection.update_one(
    {'dbid': dbid}
    ,{'$push': expdata}
  )

  res = {
    'dbid': dbid
    ,'exp_id': uuid
  }

  return res


def main(args, cfg):
  fname = args.command+'_'+args.type
  fn = getattr(this, fname)

  res = None
  if fn:
    DBCFG = cfg['DBCFG']
    mclient = MongoClient('mongodb://'+DBCFG['HOST']+':'+str(DBCFG['PORT']))
    db = mclient[DBCFG['DBNAME']]

    res = fn(args, cfg, db)

    mclient.close()
  else:
    log.error("fname does not exists: {}".format(fname))

  log.info("-------")
  log.info("CFG(Annotation Database) res: {}".format(res))
  log.info("-------")


def parse_args(commands):
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Parser for cfg to upload to database'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--type'
    ,dest='type'
    ,help='CRUD for which type: [modelinfo | experiment | info]'
    ,required=True)

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/annotation/<directory_OR_annotation_yaml_file>'
    ,required=False)
  
  parser.add_argument('--to'
    ,dest='to'
    ,help='AI Dataset ID'
    ,required=False)
  
  parser.add_argument('--exp'
    ,dest='exp'
    ,help='Experiment Type: [train | evaluate | predict]'
    ,required=False)

  args = parser.parse_args()
  
  ## Validate arguments
  cmd = args.command

  cmd_supported = False

  for c in commands:
    if cmd == c:
      cmd_supported = True

  if not cmd_supported:
    log.info("'{}' is not recognized.\n"
          "Use any one: {}".format(cmd,', '.join(commands)))
    sys.exit(-1)
  
  return args


if __name__ == '__main__':
  commands = ['create', 'get', 'update', 'delete']
  args = parse_args(commands)

  ## --from PXL-260619_221820_270619_143723
  main(args, appcfg)
