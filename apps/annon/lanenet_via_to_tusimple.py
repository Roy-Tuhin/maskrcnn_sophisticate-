__author__ = 'nikhilbv'
__version__ = '1.0'

# 
"""
# Convert via format annotations to tusimple format
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by nikhilbv
# --------------------------------------------------------
"""

# Usage
# python lanenet_via_to_tusimple.py --json_file /aimldl-dat/data-gaze/AIML_Annotation/lnd_poc_011019-111520/images-p1-110919_AT1_via205_270919.json 1>/aimldl-dalogs/lanenet_annon/via_to_tusimple-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
#

import argparse
import os
import numpy as np
import glog as log
import json
from sympy import Point
from sympy.geometry import Segment
import math
import datetime
import time

def convert(json_file):

  tic = time.time()
  log.info("json_file: {}".format(json_file))
  assert os.path.exists(json_file), '{:s} not exist'.format(json_file)
  h_samples = np.arange(160,720,10)
  h_samples = h_samples.tolist()
  with open(json_file,'r') as json_file:
    anno = json.load(json_file)
    refSeg = []
    for y in h_samples:
      refSeg.append(Segment(Point(0,y),Point(1279,y)))

    # log.info("anno : {}".format((anno))
  # annon_keys = list(anno.keys())
  # annon_values = list(anno.values())

  # N=5
  # annon_values[:N]

  tusimple_output = []

  for idx,k in enumerate(anno.keys()):
    log.info("idx------------------->: {}".format(idx))
    # print("idx: {}\nkey: {}".format(idx,k))
    # if idx > 3:
    #   break
    key = anno[k]
    # print(key['regions'])
    # print(anno['key'])
    if not key['regions']:
      continue
    lanes = []
    for one in key['regions']:
      sax = one['shape_attributes']['all_points_x']
      # print("type of sax : {}".format(type(sax)))
      say = one['shape_attributes']['all_points_y']
      # print("type of say : {}".format(type(say)))
      if len(sax) != len(say):
        log.info("Error: x y dont match : {}".format(one))
        print("Error: x y dont match : {}".format(one))
      setA = []
      last = None
      for i in range(min(len(sax),len(say))):  
        pt = Point(sax[i]*2/3,say[i]*2/3,evaluate=False)
        if not last:
          last = pt
          continue
        setA.append(Segment(last,pt))
        last = pt
      log.info("setA : {}".format(setA))
      lp = []
      for oneRef in refSeg:
        print("oneRef : {}".format(oneRef))
        isect = []
        for oneSeg in setA:
          t = oneSeg.intersection(oneRef)
          print("t : {}".format(t))
          if not len(t):
            continue
          if len(t) > 1:
            log.info("Error multiple seg cut : {} {}".format(oneSeg,oneRef))
            print("Error multiple seg cut : {} {}".format(oneSeg,oneRef))
            continue
          isect.append(t[0])
        if not len(isect):
          lp.append(-2)
          continue 
        if len(isect) == 2 and math.ceil(isect[0].x) == math.ceil(isect[0].x):
          isect.pop() 
        if len(isect) > 1:
          log.info("Error multiple lane cut : {} {} {}".format(setA,oneRef,isect))
          continue
        lp.append(math.ceil(isect[0].x))
      # log.info("lp : {}".format(lp))
      # log.info("type of lp : {}".format(type(lp)))
      lanes.append(lp); 

    if not len(lanes):
      continue

    oneOut = {}     
    raw_file=key['filename']
    oneOut['lanes'] = lanes
    oneOut['h_samples'] = h_samples
    oneOut['raw_file'] = raw_file

    tusimple_output.append(oneOut)
    
  now = datetime.datetime.now()
  timestamp = "{:%d%m%y_%H%M%S}".format(now)

  to_file = json_file.replace('.json','-tusimple.json') 
  
  with open(to_file,'w') as outfile:
    for items in tusimple_output:
      log.info("items : {}".format(items))
      json.dump(items, outfile)
      outfile.write('\n')

  log.info('\nDone (t={:0.2f}s)\n'.format(time.time()- tic))

def init_args():
  parser = argparse.ArgumentParser()
  parser.add_argument('--json_file', type=str, help='Path to via format annotations')

  return parser.parse_args()

if __name__ == '__main__':
  args = init_args()
  convert(args.json_file)