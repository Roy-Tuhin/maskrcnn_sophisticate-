__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# application routes
# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
from flask import request
from flask_cors import cross_origin
from flask import current_app, Blueprint

import web_api

def construct_bp(cfg):
  print("current_app: {}".format(current_app))
  API_VISION_URL = cfg['APP']['API_VISION_URL']

  # mroute = Blueprint('mroute', __name__, url_prefix=API_VISION_URL)
  mroute = Blueprint('mroute', __name__)

  @mroute.route('/', methods=['GET', 'POST'])
  def upload_file():
    return web_api.upload_file(current_app, request)


  @mroute.route(API_VISION_URL+'/')
  def get_vision_api_spec():
    return web_api.get_vision_api_spec(current_app, request)


  @mroute.route(API_VISION_URL+'/site/')
  def get_vision_site():  
    return web_api.get_vision_site(current_app, request)


  @mroute.route(API_VISION_URL+'/predictq', methods=['POST'])
  @cross_origin()
  def predictq():
    return web_api.predictq(current_app, request)


  ## for backward compatibility
  @mroute.route(API_VISION_URL+'/predict', methods=['POST'])
  @mroute.route(API_VISION_URL+'/predict/lane', methods=['POST'])
  @mroute.route(API_VISION_URL+'/predict/bbox', methods=['POST'])
  @cross_origin()
  def predict_any():
    return web_api.predict_any(current_app, request)


  @mroute.route(API_VISION_URL+'/predict/polygon', methods=['POST'])
  @cross_origin()
  def predict_polygon():
    return web_api.predict_polygon(current_app, request)


  @mroute.route(API_VISION_URL+'/models')
  @mroute.route(API_VISION_URL+'/models/')
  @mroute.route(API_VISION_URL+'/models/<api_model_key>', methods=['GET'])
  @cross_origin()
  def get_model_details(api_model_key=None):
    return web_api.get_model_details(current_app, request, api_model_key)


  @mroute.route(API_VISION_URL+'/tdd', methods=['POST'])
  def tdd_api():
    return web_api.tdd_api(current_app, request)

  return mroute
