__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
# script for api testing
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""

import os
import sys

import requests
import base64

from importlib import import_module

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

this = sys.modules[__name__]

import apicfg


def call_vision_api(args, cfg):
  ## TODO: error/exception handling

  apimod = import_module(args.api_model_key)

  API_URL = getattr(apimod, 'API_URL')
  filepath = getattr(apimod, 'IMAGE_PATH')

  print("API_URL: {}".format(API_URL))
  print("filepath: {}".format(filepath))

  ## TODO: overide from cmd args
  # filepath = args.filepath

  time_stats, data = None, None

  with open(filepath,'rb') as im:
    res = requests.post(API_URL
      ,files={"image": im}
      # ,data={"name": name}
    )

    print("res: {}".format(res.status_code))
    if res.status_code == 200:
      tt = res.elapsed.total_seconds()

      data = res.json()

      status = True
      K = ['filepath', 'status', 'tt_turnaround']+list(data['timings'].keys())
      V = [filepath, status, tt] + list(data['timings'].values())
      time_stats = dict(zip(K,V))
    else:
      status = False
      K = ['filepath', 'status', 'tt_turnaround']
      V = [filepath, status, -1]
      time_stats = dict(zip(K,V))
  
  time_stats['data'] = data
  print("time_stats: {}".format(time_stats))

  return time_stats


def parse_args():
  import argparse

  parser = argparse.ArgumentParser()
  parser.add_argument("--api"
    ,dest="api_model_key"
    ,required=True)
  parser.add_argument("--image"
    ,dest="filepath"
    ,required=False)

  args = parser.parse_args()

  return args


if __name__ == '__main__':
  args = parse_args()
  call_vision_api(args, apicfg)
