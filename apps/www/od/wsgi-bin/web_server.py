__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# Flask based main application
# Note: Redis server should be running, before running this script
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys
import time

import flask
from flask_cors import CORS
from flask import Blueprint

import redis

import logging
import logging.config

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


def main(*args, **kwargs):
  """Initialize the core application.
  """
  # app = Flask(__name__, instance_relative_config=False)
  # app.config.from_object('config.Config')

  app = flask.Flask(__name__)
  cors = CORS(app)
  with app.app_context():
    import _cfg_
    import routes

    import web_model

    app.logger = log

    appcfg = _cfg_.load_appcfg(BASE_PATH_CONFIG)
    DBCFG = appcfg['APP']['DBCFG']
    REDISCFG = DBCFG['REDISCFG']

    ## connect to Redis server
    rdb = redis.StrictRedis(host=REDISCFG['host'], port=REDISCFG['port'], db=REDISCFG['db'])
    app.config['RDB'] = rdb

    log.debug("appcfg: {}".format(appcfg))

    ## CAUTION: Be careful what you app to the app as it may override certain key values
    ## do not pass any keys and always check when creating if new parameters are going to override existing
    log.info("Before: app.config.keys(): {}".format(app.config.keys()))
    for k in kwargs:
      if k:
        print("k, kwargs[k]: {}, {}".format(k, kwargs[k]))
        app.config[k.upper()] = kwargs[k]

    log.info("After: app.config.keys(): {}".format(app.config.keys()))

    app.config['CORS_HEADERS'] = 'Content-Type'

    ## Initialize modelinfo
    API_VISION_URL = appcfg['APP']['API_VISION_URL']
    app.config['API_VISION_URL'] = API_VISION_URL
    app.config['APPCFG'] = appcfg

    mroute = routes.construct_bp(appcfg)
    app.register_blueprint(mroute)

    log.info("app.config: {}".format(app.config))
    USE_QUEUE =  False
    if 'QUEUE' in app.config and app.config['QUEUE'].lower() in ("yes", "true", "t", "1"):
      USE_QUEUE =  True

    if not USE_QUEUE:
      API_DEFAULT_MODEL_KEY = appcfg['APP']['API_DEFAULT_MODEL_KEY']
      if 'API_MODEL_KEY' in app.config:
        API_DEFAULT_MODEL_KEY = app.config['API_MODEL_KEY']

      log.info("Starting the server in Non-queue mode")
      modelinfo = web_model.load_model(appcfg, API_DEFAULT_MODEL_KEY)
      app.config['MODELINFO'] = modelinfo

  return app
