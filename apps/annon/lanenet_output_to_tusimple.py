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

import argparse
import os
import numpy as np
import glog as log
import json
from sympy import Point
from sympy.geometry import Segment
import math
import datetime
import sys

def convert(json_file):

  # log.info("json_file: {}".format(json_file))
  save_path = "/aimldl-dat/logs/lanenet/logs-evaluate/"
  assert os.path.exists(json_file), '{:s} not exist'.format(json_file)
  h_samples = np.arange(160,720,10)
  h_samples = h_samples.tolist()
  # with open(json_file,'r') as json_file:
  #   anno = json.load(json_file)
  # print(anno)
  tusimple_output = []
  with open(json_file, 'r') as file:
    for line_index, line in enumerate(file):
      info_dict = json.loads(line)
      # print(info_dict)
      
      # if line_index > 3:
        # break
      print("Index ----------------------------------> :{}".format(line_index))
      refSeg = []
      for y in h_samples:
        refSeg.append(Segment(Point(0,y),Point(1279,y)))

      # # annon_keys = list(anno.keys())
      # # annon_values = list(anno.values())

      # # N=5
      # # annon_values[:N]



      # for idx,k in enumerate(anno.keys()):
      #   print("idx------------------->: {}".format(idx))
      #   # print("idx: {}\nkey: {}".format(idx,k))
      
      #   key = anno[k]
      #   # print(key['regions'])
      #   print(anno['key'])
      #   if not key['regions']:
      #     continue
      x = []
      y = []
      x = info_dict['x_axis']
      y = info_dict['y_axis']
      print("x_axis : {}".format(x))
      print("y_axis : {}".format(y))
      if not len(x):
        # for i in range(len(h_samples)):
          # x.append(-2)
      # print("x_axis : {}".format(x))
        log.info("Error: x_axis not found")
        # sys.exit()
      if not len(y):
        # for i in range(len(h_samples)):
          # y.append(-2)
      # print("y_axis : {}".format(y))
        log.info("Error: y_axis not found")
        # sys.exit()
      if len(x) != len(y):
        log.info("No of lanes in x_axis and y_axis different")
        # sys.exit()  
      
      lanes = []
      for i in range(min(len(x),len(y))):
        sax = x[i]
        # print("sax : {}".format(sax))
        say = y[i]
        # print("say : {}".format(say))
        if len(sax) != len(say):
          log.info("Error: x y dont match : {}".format(i))
        setA = []
        last = None
        for j in range(min(len(sax),len(say))):  
          pt = Point(sax[j],say[j])
          if not last:
            last = pt
            continue
          setA.append(Segment(last,pt))
          last = pt
        lp = []
        for oneRef in refSeg:
          # print("oneRef : {}".format(oneRef))
          isect = []
          for oneSeg in setA:
            t = oneSeg.intersection(oneRef)
            # print("t : {}".format(t))
            if not len(t):
              continue
            if len(t) > 1:
              # log.info("Error multiple seg cut : {} {}".format(oneSeg,oneRef))
              continue
            isect.append(t[0])
          if not len(isect):
            lp.append(-2)
            continue 
          if len(isect) == 2 and math.ceil(isect[0].x) == math.ceil(isect[0].x):
            isect.pop() 
          if len(isect) > 1:
            # log.info("Error multiple lane cut : {} {} {}".format(setA,oneRef,isect))
            continue
          lp.append(math.ceil(isect[0].x))
          # log.info("lp : {}".format(lp))
          # log.info("type of lp : {}".format(type(lp)))
        lanes.append(lp) 
        # log.info("lanes : {}".format(lanes))

  #     # if not len(lanes):
  #     #   continue

      oneOut = {}     
      raw_file = info_dict['image_name']
      oneOut['lanes'] = lanes
      oneOut['h_samples'] = h_samples
      oneOut['raw_file'] = raw_file

      tusimple_output.append(oneOut)
      # log.info("tusimple_output : {}".format(tusimple_output))

    now = datetime.datetime.now()
    timestamp = "{:%d%m%y_%H%M%S}".format(now)
    
    with open(save_path+'tusimple-'+timestamp+'.json','w') as outfile:
      for items in tusimple_output:
        # log.info("items : {}".format(items))
        json.dump(items, outfile)
        outfile.write('\n')


def init_args():
  parser = argparse.ArgumentParser()
  parser.add_argument('--json_file', type=str, help='Path to via format annotations')

  return parser.parse_args()

if __name__ == '__main__':
  args = init_args()
  convert(args.json_file)