__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# Web server model script
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
#
## https://www.pyimagesearch.com/2018/02/05/deep-learning-production-keras-redis-flask-apache/
## https://medium.com/analytics-vidhya/deploy-machine-learning-models-with-keras-fastapi-redis-and-docker-4940df614ece
## https://github.com/shanesoh/deploy-ml-fastapi-redis-docker/blob/master/modelserver/main.py
#
## http://flask.pocoo.org/docs/patterns/fileuploads/
#
## TODO: Response Codes
#
# --------------------------------------------------------
"""
import os
import sys
import time

import redis

import logging
import logging.config

from pymongo import MongoClient
import json

## This imports web application minimum configuration paths
import web_cfg

BASE_PATH_CONFIG = web_cfg.BASE_PATH_CONFIG
APP_ROOT_DIR = web_cfg.APP_ROOT_DIR

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(0, APP_ROOT_DIR)

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)


from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

# log = logging.getLogger('__main__.'+__name__)

from falcon.arch import Model

import apputil
import img_common

log.debug("sys.path: {}".format(sys.path))


def get_modelcfg(cfg, api_model_key=''):
  """
  TODO
  - parameter checks as api_model_key is the client input
  - generic checks for SQLInjection
  - handle multiple concurrent connections
  """
  log.info("----------------------------->")
  log.info("api_model_key: {}".format(api_model_key))

  API_MODELINFO_TABEL = cfg['APP']['API_MODELINFO_TABEL']

  query = {}
  modelcfg = None
  log_dir = 'api'

  if api_model_key:
    log_dir = os.path.join(log_dir, api_model_key)

    model_pkey = api_model_key.split('-')
    log.info("model_pkey: {}".format(model_pkey))

    if len(model_pkey) > 0 and model_pkey[0]:
      query['org_name'] = model_pkey[0]
  
    if len(model_pkey) > 1 and model_pkey[1]:
      query['problem_id'] = model_pkey[1]

    ## TODO: release number change from integer to string
    if len(model_pkey) > 2 and model_pkey[2]:
      # query['rel_num'] = int(model_pkey[2])
      query['rel_num'] = model_pkey[2]

  DBCFG = cfg['APP']['DBCFG']
  OASISCFG = DBCFG['OASISCFG']
  log.debug("OASISCFG: {}".format(OASISCFG))
  mclient = MongoClient('mongodb://'+OASISCFG['host']+':'+str(OASISCFG['port']))
  dbname = OASISCFG['dbname']
  db = mclient[dbname]

  log.info("dbname, query: {}, {}".format(dbname, query))
  modelinfo = db.get_collection(API_MODELINFO_TABEL)

  if len(query) == 3:
    modelcfg = modelinfo.find_one(query, {'_id':0})
    if modelcfg:
      modelcfg['log_dir'] = log_dir
      weights_path = apputil.get_abs_path(cfg, modelcfg, 'AI_WEIGHTS_PATH')
      modelcfg['weights_path'] = weights_path
  else:
    modelcfg = list(modelinfo.find(query, {'_id':0}))

  log.info("modelcfg: {}".format(modelcfg))

  mclient.close()

  if type(modelcfg) != type([]):
    ## quick fix for name not present in config
    if modelcfg and modelcfg['config']:
      if 'name' in modelcfg:
          modelcfg['config']['NAME'] = modelcfg['name']
      if 'num_classes' in modelcfg:
        modelcfg['config']['NUM_CLASSES'] = modelcfg['num_classes']

  return modelcfg


def load_modelinfo(cfg, api_model_key):
  log.info("----------------------------->")
  log.info("api_model_key: {}".format(api_model_key))
  modelinfo = {}
  modelinfo['API_MODEL_KEY'] = None
  modelinfo['MODEL'] = None
  modelinfo['MODELCFG'] = None
  modelinfo['DETECT'] = None
  modelinfo['DETECT_WITH_JSON'] = None
  modelinfo['DETECT_BATCH'] = None
  modelinfo['DNNARCH'] = None

  try:  
    modelcfg = get_modelcfg(cfg, api_model_key)
    log.debug("modelcfg: {}".format(modelcfg))
    if modelcfg:
      mode = modelcfg['mode']
      dnnarch = modelcfg['dnnarch']
      dnnmod = Model.get_module(dnnarch)
      load_model_and_weights = Model.get_module_fn(dnnmod, "load_model_and_weights")
      model = load_model_and_weights(mode, modelcfg, cfg)
      log.info("model: {}".format(model))

      detect = Model.get_module_fn(dnnmod, "detect")
      detect_with_json = Model.get_module_fn(dnnmod, "detect_with_json")
      detect_batch = Model.get_module_fn(dnnmod, "detect_batch")

      modelinfo['API_MODEL_KEY'] = api_model_key
      modelinfo['MODEL'] = model
      modelinfo['MODELCFG'] = modelcfg
      modelinfo['DETECT'] = detect
      modelinfo['DETECT_WITH_JSON'] = detect_with_json
      modelinfo['DETECT_BATCH'] = detect_batch
      modelinfo['DNNARCH'] = dnnarch
    else:
      # log.error("No modelinfo found for the criteria!")
      raise Exception("No modelinfo found for the criteria!")
  except Exception as e:
    msg = "'Not a Valid Model or error in loading model and weights'"
    log.error("Exception occurred: {}".format(msg), exc_info=True)

  return modelinfo


def load_model(cfg, api_model_key):
  log.info("----------------------------->")
  # modelinfo = app.config['MODELINFO']
  modelinfo = load_modelinfo(cfg, api_model_key)
  return modelinfo


def purge_queue(rdb, qname):
  """
  Ref:
  https://stackoverflow.com/questions/24915181/rq-empty-delete-queues
  """
  while True:
    jid = rdb.lpop(qname)
    if jid is None:
      break
    rdb.delete(jid)
    log.info("deleted from queue: {}".format(jid))

  log.info("purge_queue Completed!")


def poll_from_queue(cfg, modelinfo):
  """poll_from_queue let the in coming request daved in In-memory data desgn be helpfull
  Continually poll for new images to classify/predict

  TODO: How to have different queues for different model server or if same queue can serve different model server
  I guess because uuid is used to put in the redis queue, different queue may not be required, lets see how things evolve
  """
  log.debug("modelinfo: {}".format(modelinfo))

  DBCFG = cfg['APP']['DBCFG']
  REDISCFG = DBCFG['REDISCFG']

  dnnarch = modelinfo['DNNARCH']
  model = modelinfo['MODEL']
  modelcfg = modelinfo['MODELCFG']
  class_names = modelcfg['classes']

  detect = modelinfo['DETECT']
  detect_batch = modelinfo['DETECT_BATCH']
  detect_with_json = modelinfo['DETECT_WITH_JSON']

  ## connect to Redis server
  rdb = redis.StrictRedis(host=REDISCFG['host'], port=REDISCFG['port'], db=REDISCFG['db'])

  purge_queue(rdb, REDISCFG['image_queue'])
  while True:
    # queue = rdb.lrange(REDISCFG['image_queue'], 0, REDISCFG['batch_size'] )
    queue = rdb.lrange(REDISCFG['image_queue'], 0, 1 )
    ids = []

    for q in queue:
      q = json.loads(q.decode('utf-8'))
      log.info("q['id']: {}".format(q['id']))
      log.info("q['image_name']: {}".format(q['image_name']))
      log.info("q['shape']: {}".format(q['shape']))

      im = img_common.base64_decode_numpy_array_from_string(q['image'],q['shape'][1:])
      log.info("type(im), im.shape: {}, {}".format(type(im), im.shape))

      ids.append(q['id'])
      batch = [im]
      # batch.append(im)
      # if batch is None:
      #   # batch = im
      #   batch = np.vstack([im])
      # else:
      #   batch = np.vstack([batch, im])

      if len(ids) > 0:
        log.info("len(batch): {}".format(len(batch)))

        output = detect_batch(model, verbose=1, modelcfg=modelcfg, batch=batch, class_names=class_names)
        log.info("len(output): {}".format(len(output)))

        for _id in ids:
          ## do somethings with the data
          print(": {}".format(id))
          rdb.set(_id, json.dumps(output))
          rdb.ltrim(REDISCFG['image_queue'], len(ids), -1)

        # rdb.set(ids, json.dumps(output))
        # rdb.ltrim(REDISCFG['image_queue'], len(ids), -1)

      time.sleep(float(REDISCFG['server_sleep']))


def parse_args():
  import argparse
  from argparse import RawTextHelpFormatter
  
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='Model Server:\nIn standalone mode run as the Model Server and uses redis queue.\n\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument('--id'
    ,dest='api_model_key'
    ,metavar="api_model_key"
    ,required=False
    ,help='Refer MODEL_INFO table of Annon database for available ids')

  args = parser.parse_args()    

  return args


def main(args):
  """Main entry for running the model server in the standalone mode for the queue
  """
  import _cfg_
  appcfg = _cfg_.load_appcfg(BASE_PATH_CONFIG)
  log.debug("appcfg: {}".format(appcfg))

  API_DEFAULT_MODEL_KEY = appcfg['APP']['API_DEFAULT_MODEL_KEY']
  if 'api_model_key' in args and args.api_model_key is not None:
    API_DEFAULT_MODEL_KEY = args.api_model_key

  log.debug("API_DEFAULT_MODEL_KEY: {}".format(API_DEFAULT_MODEL_KEY))
  modelinfo = load_modelinfo(appcfg, API_DEFAULT_MODEL_KEY)

  poll_from_queue(appcfg, modelinfo)


if __name__ == "__main__":
  args = parse_args()
  main(args)
