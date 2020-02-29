__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Description:
# --------------------------------------------------------
# Creates the TEPPr pipeline from the tepprcfg

# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
## Example:
# --------------------------------------------------------

## TODO:
# --------------------------------------------------------

## References:
# --------------------------------------------------------
https://studio3t.com/whats-new/mongodb-acid-properties/

https://stackoverflow.com/questions/46123418/catching-classes-that-do-not-inherit-from-baseexception-is-not-allowed
https://stackoverflow.com/questions/44838280/how-to-ignore-duplicate-key-errors-safely-using-insert-many
https://api.mongodb.com/python/current/api/pymongo/errors.html#pymongo.errors.PyMongoError

https://www.mongodb.com/blog/post/multi-document-transactions-in-mongodb
https://www.mongodb.com/blog/post/introduction-to-mongodb-transactions-in-python
https://docs.mongodb.com/master/core/transactions/#transactions-and-replica-sets
https://stackoverflow.com/questions/51238986/pymongo-transaction-errortransaction-numbers-are-only-allowed-on-a-replica-set

pip install mtools psutil
"""

import os
import sys
import time

import pymongo
from pymongo import MongoClient
# from easydict import EasyDict as edict

import logging
import logging.config

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

# APP_ROOT_DIR = os.path.join(this_dir,'..')
# ROOT_DIR = os.path.join(APP_ROOT_DIR,'..')
# BASE_PATH_CFG = os.path.join(ROOT_DIR,'cfg')

APP_ROOT_DIR = os.getenv('AI_APP')
ROOT_DIR = os.getenv('AI_HOME')
BASE_PATH_CFG = os.getenv('AI_CFG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

import annonutils
from _annoncfg_ import appcfg
from _tepprcfg_ import tepprcfg
import common

this = sys.modules[__name__]

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)


def get_info(args, cfg):
  return


def check_args(args_type, args, cfg):
  if args_type == 'experiment':
    if not args.from_path:
      raise Exception('--from not defined')
    if not args.to:
      raise Exception('--to not defined')
    if not args.exp:
      raise Exception('--exp not defined')

    from_path = args.from_path
    if not os.path.exists(from_path) or not os.path.isfile(from_path):
      raise Exception('File does not exists: {}'.format(from_path))
  elif args_type == 'modelinfo':
    if not args.from_path:
      raise Exception('from_path not defined')

    from_path = args.from_path
    if not os.path.exists(from_path) or not os.path.isfile(from_path):
      raise Exception('File does not exists: {}'.format(from_path))

  return


def _create_modelinfo(from_path, dbname, db):
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
  data['filename'] = from_path.split(os.path.sep)[-1]
  data['filepath'] = from_path
  data['dbname'] = dbname

  data['rel_num'] = str(data['rel_num'])

  try:
    tblname = annonutils.get_tblname('MODELINFO')
    # annonutils.create_unique_index(db, tblname, 'created_on')
    annonutils.create_unique_index(db, tblname, 'weights_path')
    collection = db.get_collection(tblname)
    collection.update_one(
      {'created_on': data['created_on']}
      ,{'$setOnInsert': data}
      ,upsert=True
    )
  except pymongo.errors.PyMongoError as e:
    print(e.details)

  return uuid


def create_modelinfo(args, cfg):
  log.info("----------------------------->")
  from_path = args.from_path
  if not from_path:
    raise Exception('from_path not defined')
  if not os.path.exists(from_path) or not os.path.isfile(from_path):
    raise Exception('File does not exists: {}'.format(from_path))

  DBCFG = cfg['DBCFG']
  OASISCFG = DBCFG['OASISCFG']
  mclient = MongoClient('mongodb://'+OASISCFG['host']+':'+str(OASISCFG['port']))
  dbname = OASISCFG['dbname']
  db = mclient[dbname]

  uuid = _create_modelinfo(from_path, dbname, db)

  return uuid


def create_experiment(args, cfg):
  log.info("----------------------------->")

  from_path = args.from_path
  dbname = args.to
  exp_type = args.exp

  DBCFG = cfg['DBCFG']
  PXLCFG = DBCFG['PXLCFG']
  mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))

  check_args('experiment', args, cfg)
  expdata = common.loadcfg(from_path)
  if expdata and len(expdata) > 0:
    expdata = {k.lower():v for k,v in expdata.items()} 

  creator = 'AIE3'
  if 'creator' in expdata:
    creator = expdata['creator']

  if exp_type in expdata:
    expdata = expdata[exp_type]

  if expdata and len(expdata) > 0:
    expdata = {k.lower():v for k,v in expdata.items()} 

  modelinfo_abspath = os.path.join(os.getenv('AI_CFG'), 'model')
  modelinfo_filepath = os.path.join(modelinfo_abspath, expdata['model_info'])

  args.from_path = modelinfo_filepath
  check_args('modelinfo', args, cfg)

  created_on = common.now()
  timestamp = common.timestamp_from_datestring(created_on)
  uuid = common.createUUID(exp_type)
  expdata['uuid'] = uuid
  expdata['created_on'] = created_on
  expdata['timestamp'] = timestamp
  expdata['creator'] = creator
  expdata['filename'] = from_path.split(os.path.sep)[-1]
  expdata['filepath'] = from_path
  expdata['dbname'] = dbname

  log_dir = os.path.join(expdata['dnnarch'], timestamp)
  expdata['log_dir'] = log_dir

  modelinfo = common.loadcfg(modelinfo_filepath)
  if modelinfo and len(modelinfo) > 0:
    modelinfo = {k.lower():v for k,v in modelinfo.items()}

  modelinfo['uuid'] = uuid
  modelinfo['created_on'] = created_on
  modelinfo['timestamp'] = timestamp
  modelinfo['filename'] = expdata['model_info']
  modelinfo['filepath'] = modelinfo_filepath

  expdata['modelinfo'] = modelinfo

  log.info("expdata:{}".format(expdata))

  db = mclient[dbname]

  tblname = annonutils.get_tblname(exp_type.upper())
  collection = db.get_collection(tblname)
  collection.update_one(
    {'created_on': expdata['created_on']}
    ,{'$setOnInsert': expdata}
    ,upsert=True
  )

  aidsdata = {}
  aidsdata[exp_type] = uuid

  tblname = annonutils.get_tblname('AIDS')
  collection = db.get_collection(tblname)
  collection.update_one(
    {'dbname': dbname}
    ,{'$push': aidsdata}
  )

  mclient.close()

  return uuid


def check_options(argsval, opts):
  opt_supported = False
  # log.info("{}, {}".format(argsval, opts))
  for c in opts:
    if argsval == c:
      opt_supported = True

  if not opt_supported:
    log.info("'{}' is not recognized.\n"
          "Use any one: {}".format(argsval,', '.join(opts)))
    sys.exit(-1)


def main(args, cfg):
  fname = args.command+'_'+args.type
  fn = getattr(this, fname)

  res = None
  if fn:
    ## TODO: exception handling in try except and finally block
    res = fn(args, cfg)
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
    description='Uses `_tepprcfg_.py` configuration file as template to create AI Experiments and upload to database'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="Options: {}".format(', '.join(commands)))

  cmd_type = ['modelinfo', 'experiment', 'info']
  parser.add_argument('--type'
    ,dest='type'
    ,help="Options: {}".format(', '.join(cmd_type))
    ,required=True)

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/<directory_OR_yml_file>'
    ,required=True)
  
  parser.add_argument('--to'
    ,dest='to'
    ,help='AI Dataset (AIDS) DB Name'
    ,required=True)
  
  exp_type = ['train', 'evaluate', 'predict']
  parser.add_argument('--exp'
    ,dest='exp'
    ,help="Options: {}".format(', '.join(exp_type))
    ,required=False)

  args = parser.parse_args()


  ## Validate arguments
  cmd = args.command
  opt_type = args.type
  
  check_options(cmd, commands)
  check_options(opt_type, cmd_type)

  if opt_type == "experiment":
    assert args.exp,\
           "Provide --exp"
    check_options(args.exp, exp_type)

  return args


if __name__ == '__main__':
  commands = ['create', 'get', 'update', 'delete']
  args = parse_args(commands)

  ## --from PXL-260619_221820_270619_143723
  main(args, appcfg)
