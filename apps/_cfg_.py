__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Main configuration file, like a bootstrap file.
## NOTE: It should not have too much dependencies on 3rd party libs

# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys
import yaml
import logging
from pymongo import MongoClient

log = logging.getLogger('__main__.'+__name__)


def dict_keys_to_lowercase(d):
  """
  recursive function
  """
  d_mod = { k.lower():d[k] if not isinstance(d[k],dict) else dict_keys_to_lowercase(d[k]) for k in d.keys() }
  return d_mod


def add_path(path):
  if path not in sys.path:
    sys.path.insert(0, path)


def load_yaml(filepath):
  """Sale load YAML file (does not provide edit object)
  """
  fc = None
  with open(filepath, 'r') as f:
    # fc = edict(yaml.load(f))
    # fc = edict(yaml.safe_load(f))
    fc = yaml.safe_load(f)

  return fc


def _set_item_in_appcfg(appcfg, item_name, item_cfg, item, dbcfg=None):
  """
  item is'ARCH' or 'DATASET'
  """
  if item_name not in appcfg[item]:
    appcfg[item][item_name] = {}

  appcfg[item][item_name]['cfg'] = item_cfg
  appcfg[item][item_name]['cfg_file'] = item_name
  appcfg[item][item_name]['cfg_loaded'] = True
  
  if dbcfg:
    appcfg[item][item_name]['dbcfg'] = dbcfg

  appcfg['ACTIVE'][item] = item_name


def load_datacfg(cmd, appcfg, dbname, exp_id=None, eval_on=None):
  log.debug("----------------------------->")
  log.debug("cmd, appcfg, dbname, exp_id, eval_on:  {}, {}, {}, {}, {}".format(cmd, appcfg, dbname, exp_id, eval_on))
  DBCFG = appcfg['APP']['DBCFG']
  datacfg = None
  _dbcfg = None

  log.debug("DBCFG, dbname: {}, {}".format(DBCFG, dbname))

  ## visualize allowed on annon and AIDS, but inspect_annon is allowed only on AIDS as it needs model to be loaded
  ## AI experiment should exists
  if os.path.exists(dbname) and os.path.isfile(dbname):
    item_name = dbname.split(os.path.sep)[-1].split('.')[0]
    datacfg = load_yaml(dbname)
    _dbcfg = datacfg.copy()
  elif DBCFG['ANNONCFG']['dbname'] in dbname:
    ## TODO: what if the dbname has timestamped variation
    DBCFG['ANNONCFG']['dbname'] = dbname
    # datacfg = dict_keys_to_lowercase(DBCFG['ANNONCFG'].copy())
    datacfg = DBCFG['ANNONCFG'].copy()
    _dbcfg = DBCFG['ANNONCFG'].copy()
  elif DBCFG['PXLCFG']['dbname'] in dbname:
    DBCFG['PXLCFG']['dbname'] = dbname
    _dbcfg = DBCFG['PXLCFG'].copy()

    if cmd not in appcfg['APP']['CMD'] and eval_on:
      datacfg = DBCFG['PXLCFG'].copy()
    else:
      PXLCFG = DBCFG['PXLCFG']
      AI_DATASET_TBLNAME = 'AIDS'
      query = {}

      if cmd in appcfg['APP']['CMD'] and eval_on:
        AI_DATASET_TBLNAME = cmd.upper()
        query = {'uuid': exp_id}
      elif cmd in appcfg['APP']['CMD'] and not eval_on:
        AI_DATASET_TBLNAME = cmd.upper()
      elif cmd not in appcfg['APP']['CMD'] and not eval_on:
        raise Exception('--on to be defined if using AI Dataset')

      log.debug("AI_DATASET_TBLNAME, query: {}, {}".format(AI_DATASET_TBLNAME, query))
      mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))
      db = mclient[dbname]
      collection = db.get_collection(AI_DATASET_TBLNAME)
      datacfg = collection.find_one(query, {'_id':0})
      mclient.close()

  log.debug("datacfg: {}".format(datacfg))
  if datacfg:
    _set_item_in_appcfg(appcfg, dbcfg=_dbcfg, item_name=dbname, item_cfg=datacfg, item='DATASET')

  return datacfg


def load_archcfg(cmd, appcfg, dbname, exp_id, eval_on=None):
  log.debug("----------------------------->")

  archcfg = None
  if not exp_id:
    log.info("No epxeriment config has been dentified.")
    return archcfg

  if os.path.exists(exp_id) and os.path.isfile(exp_id):
      archcfg = load_yaml(exp_id)
      log.debug("loaded: archcfg.keys(): {}".format(archcfg.keys()))
      log.debug("archcfg: {}".format(archcfg))
      log.debug("archcfg['{}'']: {}".format(cmd, archcfg[cmd]))


      item_name = exp_id.split(os.path.sep)[-1].split('.')[0]
      log.info("item_name: {}".format(item_name))
      _set_item_in_appcfg(appcfg, item_name=item_name, item_cfg=archcfg[cmd], item='ARCH')
      # _set_item(item_name, archcfg)
      appcfg['ACTIVE']['ARCH'] = item_name
  else:
    AI_DATASET_TBLNAME = 'AIDS'
    query = {}
    if cmd in appcfg['APP']['CMD']:
      AI_DATASET_TBLNAME = cmd.upper()
      query = {'uuid': exp_id}
    elif cmd not in appcfg['APP']['CMD'] and eval_on:
      AI_DATASET_TBLNAME = 'TRAIN'
    #   # AI_DATASET_TBLNAME = eval_on.upper()
    # elif cmd in appcfg['APP']['CMD'] and eval_on:
    #   AI_DATASET_TBLNAME = eval_on.upper()

    DBCFG = appcfg['APP']['DBCFG']
    PXLCFG = DBCFG['PXLCFG']

    log.debug("DBCFG: {}".format(DBCFG))
    log.debug("PXLCFG['dbname'], dbname: {}, {}".format(PXLCFG['dbname'], dbname))
    log.debug("AI_DATASET_TBLNAME, query: {}, {}".format(AI_DATASET_TBLNAME, query))

    mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))
    db = mclient[dbname]
    collection = db.get_collection(AI_DATASET_TBLNAME)
    
    archcfg = collection.find_one(query, {'_id':0})
    # assert exp_id == archcfg['uuid']
    mclient.close()

    if archcfg:
      _set_item_in_appcfg(appcfg, item_name=exp_id, item_cfg=archcfg, item='ARCH')

  log.debug("archcfg: {}".format(archcfg))
  return archcfg


def load_appcfg(base_path_cfg):
  appcfg = {}
  
  for t in ['paths','app']:
    filepath = os.path.join(base_path_cfg, t+'.yml')
    cfg = None
    if os.path.exists(filepath) and os.path.isfile(filepath):
      cfg = load_yaml(filepath)

    appcfg[t.upper()] = cfg
  
  for u in ['arch','dataset']:
    appcfg[u.upper()] = {}

  appcfg['ACTIVE'] = {
    'ARCH':''
    ,'DATASET':''
  }

  log.debug("appcfg: {}".format(appcfg))

  ## Add proper PYTHONPATH for the application
  pythonpath = appcfg['PATHS']['PYTHONPATH']
  log.info("pythonpath:{}".format(pythonpath))
  for k in pythonpath.keys():
    log.debug("pythonpath[{}]: {}".format(k, pythonpath[k]))
    add_path(pythonpath[k])

  log.debug("loaded: appcfg.keys(): {}".format(appcfg.keys()))
  log.debug("-------")

  return appcfg


def loadcfg(cmd, dbname, exp_id=None, eval_on=None):
  """
  dbname can be:
    * it can be a file (<dnnarch>-<dataset-cfg-file-name>.yml) or AIDS (AI Dataset) database name
  exp_id can be:
    * none when inspecting the data alone without loading the model
    * it can be a file (<dnnarch>-<dataset-cfg-file-name>.yml) or experiment ID string from the DB
  """
  log.debug("----------------------------->")
  from easydict import EasyDict as edict

  this_dir = os.path.dirname(__file__)
  APP_ROOT_DIR = this_dir

  # ROOT_DIR = os.path.join(APP_ROOT_DIR,'..')
  # BASE_PATH_CFG = os.path.join(ROOT_DIR,'cfg')
  ROOT_DIR = os.getenv('AI_HOME')
  BASE_PATH_CFG = os.getenv('AI_CONFIG')
  log.debug("ROOT_DIR: {}\nBASE_PATH_CFG:{}".format(ROOT_DIR, BASE_PATH_CFG))

  add_path(APP_ROOT_DIR)
  add_path(BASE_PATH_CFG)

  log.debug("dbname, exp_id:{},{}".format(dbname, exp_id))

  appcfg = load_appcfg(BASE_PATH_CFG)
  appcfg = edict(appcfg)

  ## TODO: might be breaking changes; quick hack for expo for video predictions
  if os.path.exists(exp_id) and os.path.isfile(exp_id):
    print("exp_id is a file; skipping datacfg load from db")
  else:
    datacfg = load_datacfg(cmd, appcfg, dbname, exp_id, eval_on)
    if not datacfg:
      raise Exception('datacfg is corrupted: {}'.format(datacfg))

  load_archcfg(cmd, appcfg, dbname, exp_id, eval_on)

  log.debug("appcfg::--------\n\n{}".format(appcfg))
  return appcfg
