__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Description:
# --------------------------------------------------------
# Verify and create summary report from the Database
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
import json
import datetime

import logging
import logging.config

from pymongo import MongoClient

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

from _annoncfg_ import appcfg
import annonutils
import common

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

this = sys.modules[__name__]

from bson import ObjectId
from bson import json_util

# class JSONEncoder(json.JSONEncoder):
#   """
#   Ref: https://stackoverflow.com/questions/16586180/typeerror-objectid-is-not-json-serializable
#   """
#   def default(self, o):
#     if isinstance(o, ObjectId):
#       return str(o)
#     return json.JSONEncoder.default(self, o)

# class JsonEncoder():
#   def encode(self, o):
#     if '_id' in o:
#       o['_id'] = str(o['_id'])
#     return o

# define a custom encoder point to the json_util provided by pymongo (or its dependency bson)
class JsonEncoder(json.JSONEncoder):
    def default(self, obj): return json_util.default(obj)

def tbl_classinfo(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('CLASSINFO')

  classinfo = db.get_collection(tblname)
  cur = classinfo.find()

  rpt = {
    'total_items': 0
    ,'unique_lbl_ids': set()
    ,'lbl_ids': []
    ,'total_unique_lbl_ids': 0
    ,'total_lbl_ids': 0
  }

  lbl_ids = []
  for item in cur:
    rpt['unique_lbl_ids'].add(item['lbl_id'])
    rpt['lbl_ids'].append(item['lbl_id'])
    rpt['total_items'] += 1

  rpt['total_unique_lbl_ids'] = len(rpt['unique_lbl_ids'])
  rpt['total_lbl_ids'] = len(rpt['lbl_ids'])

  log.debug("=> len(unique_lbl_ids): {}".format(len(rpt['unique_lbl_ids'])))
  log.debug("=> total_unique_lbl_ids: {}".format(rpt['total_unique_lbl_ids']))
  log.debug("total_lbl_ids: {}".format(rpt['total_lbl_ids']))
  log.debug("total_items: {}".format(rpt['total_items']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_errors(db):
  log.debug("\nErrors::")
  log.debug("--------")
  tblname = annonutils.get_tblname('ERRORS')

  stats = db.get_collection(tblname)
  cur = stats.find({'has_error':True})

  rpt = {
    'total_items': 0
    ,'total_error_ant': 0
    ,'total_error_empty_ant': 0
    ,'total_error_img_notfound': 0
    ,'total_error_img_reading': 0
    ,'total_error_unlabeled_ant': 0
    ,'total_error_in_rel_filename': 0
    ,'errors_for_reporting': None
    ,'unique_rel_filenames': set()
    ,'all_rel_filenames': []
    ,'total_unique_rel_filenames': 0
    ,'total_rel_filenames': 0
  }

  errors_for_reporting = {}

  for item in cur:
    rpt['unique_rel_filenames'].add(item['rel_filename'])
    rpt['all_rel_filenames'].append(item['rel_filename'])
    rpt['total_error_ant'] += item['total_error_ant']
    rpt['total_error_empty_ant'] += item['total_error_empty_ant']
    rpt['total_error_img_notfound'] += item['total_error_img_notfound']
    rpt['total_error_img_reading'] += item['total_error_img_reading']
    rpt['total_error_unlabeled_ant'] += item['total_error_unlabeled_ant']
    rpt['total_error_in_rel_filename'] += 1
    rpt['total_items'] += 1

    if item['has_error']:
      error_types = appcfg['ERROR_TYPES']
      rel_filename = os.path.splitext(item['rel_filename'])[0]
      if rel_filename not in errors_for_reporting:
        errors_for_reporting[rel_filename] = {}

      errors_for_reporting[rel_filename]['rel_filename'] = item['rel_filename']
      for et in error_types:
        if et in item and len(item[et]) > 0:
          errors_for_reporting[rel_filename][et] = item[et]



  rpt['errors_for_reporting'] = errors_for_reporting

  rpt['total_unique_rel_filenames'] = len(rpt['unique_rel_filenames'])
  rpt['total_rel_filenames'] = len(rpt['all_rel_filenames'])

  log.debug("=> len(unique_rel_filenames): {}".format(len(rpt['unique_rel_filenames'])))
  log.debug("=> total_unique_rel_filenames: {}".format(rpt['total_unique_rel_filenames']))
  log.debug("total_rel_filenames: {}".format(rpt['total_rel_filenames']))
  log.debug('total_error_ant: {}'.format(rpt['total_error_ant']))
  log.debug('total_error_empty_ant: {}'.format(rpt['total_error_empty_ant']))
  log.debug('total_error_img_notfound: {}'.format(rpt['total_error_img_notfound']))
  log.debug('total_error_img_reading: {}'.format(rpt['total_error_img_reading']))
  log.debug('total_error_unlabeled_ant: {}'.format(rpt['total_error_unlabeled_ant']))
  log.debug('total_error_in_rel_filename: {}'.format(rpt['total_error_in_rel_filename']))
  log.debug("---x---x---x---\n")

  return rpt

def tbl_log(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('LOG')
  logs = db.get_collection(tblname)
  cur = logs.find({})

  rpt = {
    'total_items': 0
    ,'unique_rel_filenames': set()
    ,'all_rel_filenames': []
    ,'total_unique_rel_filenames': 0
    ,'total_rel_filenames': 0
  }

  for item in cur:
    rpt['unique_rel_filenames'].add(item['rel_filename'])
    rpt['all_rel_filenames'].append(item['rel_filename'])
    rpt['total_items'] += 1

  rpt['total_unique_rel_filenames'] = len(rpt['unique_rel_filenames'])
  rpt['total_rel_filenames'] = len(rpt['all_rel_filenames'])

  log.debug("=> len(unique_rel_filenames): {}".format(len(rpt['unique_rel_filenames'])))
  log.debug("=> total_unique_rel_filenames: {}".format(rpt['total_unique_rel_filenames']))
  log.debug("total_rel_filenames: {}".format(rpt['total_rel_filenames']))
  log.debug("total_items: {}".format(rpt['total_items']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_stats(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('STATS')

  stats = db.get_collection(tblname)
  cur = stats.find({})

  rpt = {
    'total_items': 0
    ,'total_ant': 0
    ,'total_error_ant': 0
    ,'total_error_img_notfound': 0
    ,'total_error_img_reading': 0
    ,'total_error_unlabeled_ant': 0
    ,'total_img': 0
    ,'total_lbl': 0
    ,'unique_rel_filenames': set()
    ,'all_rel_filenames': []
    ,'total_unique_rel_filenames': 0
    ,'total_rel_filenames': 0
    ,'error_rel_filenames': set()
  }

  for item in cur:
    rpt['unique_rel_filenames'].add(item['rel_filename'])
    rpt['all_rel_filenames'].append(item['rel_filename'])
    rpt['total_error_ant'] += item['total_error_ant']
    rpt['total_error_img_notfound'] += item['total_error_img_notfound']
    rpt['total_error_img_reading'] += item['total_error_img_reading']
    rpt['total_error_unlabeled_ant'] += item['total_error_unlabeled_ant']
    rpt['total_img'] += item['total_img']
    rpt['total_lbl'] += item['total_lbl']
    rpt['total_ant'] += item['total_ant']
    rpt['total_items'] += 1
    if item['total_ant'] == 0:
      rpt['error_rel_filenames'].add(item['rel_filename'])

    total_ant_type = item['total_ant_type'][0]
    for ant_type in total_ant_type.keys():
      if 'total_ant_'+ant_type not in rpt:
        rpt['total_ant_'+ant_type] = 0
      rpt['total_ant_'+ant_type] += total_ant_type[ant_type]

  rpt['total_ant'] -= rpt['total_error_unlabeled_ant'] - rpt['total_error_ant']
  rpt['total_unique_rel_filenames'] = len(rpt['unique_rel_filenames'])
  rpt['total_rel_filenames'] = len(rpt['all_rel_filenames'])

  log.debug("=> len(unique_rel_filenames): {}".format(len(rpt['unique_rel_filenames'])))
  log.debug("=> total_unique_rel_filenames: {}".format(rpt['total_unique_rel_filenames']))
  log.debug("total_rel_filenames: {}".format(rpt['total_rel_filenames']))
  log.debug('* total_ant - total_error_unlabeled_ant - total_error_ant: {}'.format(rpt['total_ant']))
  log.debug('** total_img: {}'.format(rpt['total_img']))
  log.debug('total_error_ant: {}'.format(rpt['total_error_ant']))
  log.debug('total_error_img_notfound: {}'.format(rpt['total_error_img_notfound']))
  log.debug('total_error_img_reading: {}'.format(rpt['total_error_img_reading']))
  log.debug('total_error_unlabeled_ant: {}'.format(rpt['total_error_unlabeled_ant']))
  log.debug('total_lbl: {}'.format(rpt['total_lbl']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_images(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('IMAGES')
  images = db.get_collection(tblname)
  cur = images.find({})

  rpt = {
    'total_items': 0
    ,'unique_rel_filenames': set()
    ,'total_unique_rel_filenames': 0
    ,'unique_images': set()
    ,'total_images': set()
    ,'total_img': 0
  }

  for item in cur:
    rpt['unique_rel_filenames'].add(item['rel_filename'])
    rpt['unique_images'].add(item['filename'])
    rpt['total_images'].add(item['img_id'])
    rpt['total_img'] += 1
    rpt['total_items'] += 1

  rpt['unique_images'] = len(rpt['unique_images'])
  rpt['total_images'] = len(rpt['total_images'])
  rpt['total_unique_rel_filenames'] = len(rpt['unique_rel_filenames'])

  log.debug("=> len(unique_rel_filenames): {}".format(len(rpt['unique_rel_filenames'])))
  log.debug("=> total_unique_rel_filenames: {}".format(rpt['total_unique_rel_filenames']))
  log.debug('** total_img: {}'.format(rpt['total_img']))

  log.debug("len(unique_images): {}".format(rpt['unique_images']))
  log.debug("len(total_images): {}".format(rpt['total_images']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_annotations(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('ANNOTATIONS')

  stats = db.get_collection(tblname)
  cur = stats.find({})

  rpt = {
    'total_items': 0
    ,'total_ant': 0
    ,'unique_labels': set()
    ,'unique_images': set()
    ,'total_images': set()
    ,'unique_rel_filenames': set()
    ,'total_unique_rel_filenames': 0
  }

  for item in cur:
    rpt['unique_rel_filenames'].add(item['rel_filename'])
    rpt['unique_labels'].add(item['lbl_id'])
    rpt['unique_images'].add(item['image_name'])
    rpt['total_images'].add(item['img_id'])
    rpt['total_ant'] += 1
    rpt['total_items'] += 1

  rpt['unique_labels'] = len(rpt['unique_labels'])
  rpt['unique_images'] = len(rpt['unique_images'])
  rpt['total_images'] = len(rpt['total_images'])
  rpt['total_unique_rel_filenames'] = len(rpt['unique_rel_filenames'])

  log.debug("=> len(unique_rel_filenames): {}".format(len(rpt['unique_rel_filenames'])))
  log.debug("=> total_unique_rel_filenames: {}".format(rpt['total_unique_rel_filenames']))
  log.debug("* total_ant: {}".format(rpt['total_ant']))
  log.debug("** len(total_images): {}".format(rpt['total_images']))
  log.debug("** len(unique_images): {}".format(rpt['unique_images']))
  log.debug("** len(unique_labels): {}".format(rpt['unique_labels']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_release(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('RELEASE')
  logs = db.get_collection(tblname)

  rpt = {
    'total_items': 0
    ,'rel_ids': []
    ,'total_annon_file_processed': 0
  }

  if logs:
    cur = logs.find({},{'_id':0})
    if cur:
      for item in cur:
        rel = {}
        rel[ item['rel_id'] ] = item['timestamp']
        rpt['rel_ids'].append(rel)
        rpt['total_annon_file_processed'] += item['total_annon_file_processed']
        rpt['total_items'] += 1

  log.debug("=> len(rel_ids): {}".format(len(rpt['rel_ids'])))
  log.debug("rel_ids: {}".format(rpt['rel_ids']))
  log.debug("total_annon_file_processed: {}".format(rpt['total_annon_file_processed']))
  log.debug("total_items: {}".format(rpt['total_items']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_modelinfo(db):
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('MODELINFO')
  modelinfo = db.get_collection(tblname)

  rpt = {
    'total_items': 0
    ,'total_annon_file_processed': 0
    ,'model_ids': None
    ,'weights_path': None
  }

  if modelinfo:
    items = list(modelinfo.find({},{'_id':0}))
    rpt['total_items'] = len(items)
    rpt['model_ids'] = [o['uuid'] for o in items]
    rpt['weights_path'] = [o['weights_path'] for o in items]

  log.debug("items: {}".format(items))
  log.debug("len(items): {}".format(rpt['total_items']))
  log.debug("model_ids: {}".format(rpt['model_ids']))
  log.debug("weights_path: {}".format(rpt['weights_path']))
  log.debug("---x---x---x---\n")

  return rpt


def tbl_aids(db):
  """
  TODO
  - cmd as user input which can be train, evaluate, predict, publish, report
  """
  log.info("-----------------------------")
  tblname = annonutils.get_tblname('AIDS')
  aids = db.get_collection(tblname)
  rpt = {
    'total_items': 0
    ,'dbnames': []
    ,'dbnames_with_exp_id': {}
    ,'items': []
    ,'total_annon_file_processed': 0
    ,'stats': None
  }

  cmd = 'train'

  if cmd not in rpt['dbnames_with_exp_id']:
    rpt['dbnames_with_exp_id'][cmd] = []

  if aids:
    # cur = aids.find({},{'_id':0, 'anndb_id':1, 'anndb_id':1, 'dbname':1, 'classes':1})
    cur = aids.find({},{'_id':0})

    ## https://stackoverflow.com/questions/36229123/return-only-matched-sub-document-elements-within-a-nested-array
    ## query = {'train':{'$elemMatch':{'uuid':'exp-1e329cfa-2156-491f-b41a-171e62284cf6'}}},{'_id':0,'dbname':1,'train.$':1}
    ## aids.find(query)

    if cur:
      for item in cur:
        rpt['items'].append(item)
        rpt['dbnames'].append(item['dbname'])
        exp = item[cmd]
        exp_id = None
        if len(exp) > 0:
          exp_id = [o['uuid'] for o in exp]

        x = {}
        x[ item['dbname'] ] = exp_id
        rpt['dbnames_with_exp_id'][cmd].append(x)
        rpt['total_items'] += 1

  log.debug("=> len(dbnames): {}".format(len(rpt['dbnames'])))
  # log.debug('items: {}'.format(items))
  log.debug("dbnames: {}".format(rpt['dbnames']))
  log.debug("total_items: {}".format(rpt['total_items']))
  log.debug("cmd, dbnames_with_exp_id: {}, {}".format(cmd, rpt['dbnames_with_exp_id'][cmd]))
  log.debug("---x---x---x---\n")

  return rpt


def verify_anndb(db, tbls):
  log.info("-----------------------------")

  rpt_summary = {}
  for tbl in tbls:
    fname = 'tbl_'+tbl
    log.info('fname: {}'.format(fname))
    fn = getattr(this, fname)
    rpt = fn(db)
    rpt_summary[tbl] = rpt


  # log.info("rpt_summary:{}".format(rpt_summary))

  return rpt_summary


def get_annotation_data(cfg, dbname):
  log.info("-----------------------------")
  DBCFG = cfg['DBCFG']
  PXLCFG = DBCFG['PXLCFG']
  mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))
  db = mclient[dbname]

  # tbls = ['ANNOTATIONS', 'IMAGES', 'CLASSINFO', 'STATS']
  tbls_with_split = PXLCFG['tbls_with_split']

  aids_splits_criteria = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]
  splits = aids_splits_criteria[0]

  stats = {}
  aidsdata = {}
  for tbl in tbls_with_split:
    collection = db.get_collection(tbl)
    if collection:
      for split in splits:
        data = list(collection.find({'subset':split},{'_id':0}))
        if split not in aidsdata:
          aidsdata[split] = {}
          stats[split] = {}
        aidsdata[split][tbl] = data
        stats[split][tbl] = len(data)
  
  tbls = PXLCFG['tbls']
  for tbl in tbls:
    collection = db.get_collection(tbl)
    if collection:
      for split in splits:
        data = list(collection.find({'_id':0}))
        aidsdata[tbl] = data
        stats[tbl] = len(data)

  mclient.close()

  # log.debug("stats: {}".format(stats))
  log.debug("---x---x---x---\n")

  return aidsdata


def write_rpt_summary_annon(cfg, args, rpt_summary):
  log.info("-----------------------------")

  from bson.json_util import dumps

  timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())
  logs_basepath = os.path.join(os.getenv('AI_LOGS'),'annon')

  ## create logs_basepath if does not exists 
  common.mkdir_p(logs_basepath)

  DBCFG = cfg['DBCFG']
  ANNONCFG = DBCFG['ANNONCFG']
  dbname = ANNONCFG['dbname']
  filepath_errors = None

  filepath = os.path.join(logs_basepath, dbname+'-summary-'+timestamp+'.json')
  log.debug("filepath: {}".format(filepath))
  with open(filepath,'w') as fw:
    # json_str = JSONEncoder().encode(rpt_summary)
    # json_str = json.encode(rpt_summary, cls=JSONEncoder)
    json_str = dumps(rpt_summary)
    # fw.write(json.dumps(json_str))
    # https://stackoverflow.com/questions/45539242/write-json-to-a-file-without-writing-escape-backslashes-to-file
    json.dump(json.loads(json_str), fw)

  ## write filepath_errors
  if 'errors' in rpt_summary and rpt_summary['errors']['errors_for_reporting'] and len(rpt_summary['errors']['errors_for_reporting']) > 0:
    filepath_errors = os.path.join(logs_basepath, dbname+'-errors-'+timestamp+'.json')
    log.debug("filepath_errors: {}".format(filepath_errors))
    with open(filepath_errors,'w') as fw:
      json_str = dumps(rpt_summary['errors']['errors_for_reporting'])
      json.dump(json.loads(json_str), fw)

  return [filepath, filepath_errors]


def write_aids_to_file(cfg, args, rpt_summary):
  log.info("-----------------------------")

  filepaths = {}
  if 'aids' not in rpt_summary:
    return filepaths

  from bson.json_util import dumps
  dbnames = rpt_summary['aids']['dbnames']
  if dbnames and len(dbnames) > 0:
    for dbname in dbnames:
      aidsdata = get_annotation_data(cfg, dbname)

      timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())
      logs_basepath = os.path.join(os.getenv('AI_LOGS'), 'annon', dbname)
      ## create logs_basepath if does not exists 
      common.mkdir_p(logs_basepath)
      aidsdata_keys = aidsdata.keys()
      log.info("aidsdata.keys: {}".format(aidsdata_keys))
      for split in aidsdata_keys:
        filepath = os.path.join(logs_basepath,split+'-'+timestamp+'.json')
        filepaths[split] = [filepath]
        with open(filepath,'w') as fw:
          json_str = dumps(aidsdata[split])
          json.dump(json.loads(json_str), fw)

  return filepaths


def main(cfg, args):
  tic = time.time()
  log.info("-----------------------------")

  DBCFG = cfg['DBCFG']
  ANNONCFG = DBCFG['ANNONCFG']
  mclient = MongoClient('mongodb://'+ANNONCFG['host']+':'+str(ANNONCFG['port']))
  dbname = ANNONCFG['dbname']
  log.info("ANNONCFG['dbname']: {}".format(dbname))
  db = mclient[dbname]

  # tbls = ['stats','log','images','annotations','errors','classinfo','release','aids']
  # tbls = ['classinfo']
  tbls = [ tbl.lower() for tbl in ANNONCFG['tbls'] ]

  ## Generated the report summary
  rpt_summary = verify_anndb(db, tbls)

  mclient.close()

  filepath_annon = write_rpt_summary_annon(cfg, args, rpt_summary)

  filepaths_aids = write_aids_to_file(cfg, args, rpt_summary)
  log.info("filepath_annon: {}\nfilepaths_aids: {}\n".format(filepath_annon, filepaths_aids))
  
  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))


def parse_args():
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Annotation parser for VGG Via tool files'
    ,formatter_class=RawTextHelpFormatter)

  args = parser.parse_args()
  
  return args


if __name__ == '__main__':
  args = parse_args()

  main(appcfg, args)
