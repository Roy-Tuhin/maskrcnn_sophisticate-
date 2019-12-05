from pymongo import MongoClient

## https://api.mongodb.com/python/current/api/pymongo/collection.html

import os
import sys

import logging
import logging.config

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
ROOT_DIR = os.getenv('AI_HOME')
BASE_PATH_CFG = os.getenv('AI_CFG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

from annon._log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

import common
import annonutils


class MongoDB:
  db = None

  def __init__(self, dbname=None, host='localhost', port=27017):
    self.mclient = MongoClient('mongodb://'+host+':'+str(port))
    self.connect(dbname)


  def rename_collection(self, dbname, old_name, new_name, session=None, **kwargs):
    """Rename the collection.
    TODO:
    Error handling for, if old_name of the collection does not exists, error is thrown:
      `pymongo.errors.OperationFailure: source namespace does not exist`
    """
    mclient = self.mclient
    db = mclient[dbname]
    db[old_name].rename(new_name, session=None, **kwargs)


  def connect(self, dbname):
    if dbname:
      self.db = self.mclient[dbname]


  def get_collection(self, tblname):
    if tblname:
      db = self.db
      collection = db.get_collection(tblname)
    return collection


  def query_all(self, tblname):
    results = None
    if tblname:
      collection = self.get_collection(tblname)
      results = list(collection.find({},{'_id':0}))
    return results


  def write(self, tblname, tbldata, idx_col=None):
    res = None
    if tblname:
      collection = self.get_collection(tblname)
      ## create unique index
      if idx_col:
        index_name = 'index-'+idx_col
        log.info("index_name: {}".format(index_name))

        if index_name not in collection.index_information():
          # collection.create_index([(idx_col, pymongo.DESCENDING )], name=index_name, unique=True, background=True)
          collection.create_index(idx_col, name=index_name, unique=True, background=True)

        for doc in tbldata:
          # log.info("idx_col: {}, doc: {}".format(idx_col, doc))
          # log.info("doc[idx_col]: {}".format(doc[idx_col]))
          qfilter = {}
          qfilter[idx_col] = doc[idx_col]
          res = collection.update_one(
            qfilter
            ,{ '$setOnInsert': doc}
            ,upsert=True
          )
      else:
        res = collection.insert_one(tbldata)

    return res


  def close(self):
    self.mclient.close()


def tdd_rename(mongodb):
  dbname = 'annon'

  collections = ['ANNOTATIONS','CLASSINFO','ERRORS','IMAGES','LOG','STATS','IMAGELIST']
  for tblname in collections:
    old_collection_name = 'HMD_'+tblname
    new_collection_name = tblname
    mongodb.rename_collection(dbname, old_name=old_collection_name, new_name=new_collection_name)


def classinfo_bk(mongodb, dbname):
  old_collection_name = 'CLASSINFO'
  new_collection_name = 'CLASSINFO_BK'
  mongodb.rename_collection(dbname, old_name=old_collection_name, new_name=new_collection_name)


def classinfo_from_modelinfo(mongodb, dbname, filepath):
  modelinfo = common.yaml_load(filepath)
  log.info("modelinfo: {}".format(modelinfo))
  lbl_ids = modelinfo['classes']
  classinfo = [ {'lbl_id':lbl_id, 'source':'hmd', 'name':lbl_id} for lbl_id in lbl_ids[1:] ]
  tblname = annonutils.get_tblname('CLASSINFO')

  mongodb.connect(dbname)
  mongodb.write(tblname, classinfo, idx_col='lbl_id')


def change_classinfo(mongodb):
  # dbname = 'PXL-151019_175928'
  dbname = 'PXL-261019_112629'
  modelinfo_filepath = '/aimldl-cfg/model/release/vidteq-hmd-1-mask_rcnn.yml'

  # classinfo_bk(mongodb, dbname)
  classinfo_from_modelinfo(mongodb, dbname, modelinfo_filepath)


def main():
  mongodb = MongoDB()
  # tdd_rename(mongodb)
  change_classinfo(mongodb)


if __name__ == '__main__':
  main()
