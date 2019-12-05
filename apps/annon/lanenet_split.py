__author__ = 'nikhilbv'
__version__ = '1.0'

"""
# Split database - train,test
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by nikhilbv
# --------------------------------------------------------
"""

"""
# Usage
# python split.py --json_file <json_file>
# python split.py --json_file /aimldl-dat/data-gaze/AIML_Database/lnd-011019_165046/images-p1-110919_AT1_via205_270919-tusimple.json
"""

import argparse
import os
import os.path as ops
import json
import random
import tqdm
import sys

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

import common

def init_args():
  parser = argparse.ArgumentParser()
  parser.add_argument('--json_file', type=str, help='Tusimple format json file')

  return parser.parse_args()

def split_train_test(json_file):
  assert ops.exists(json_file), '{:s} not exist'.format(json_file)
  
  base_path = common.getBasePath(json_file)
  print("base_path : {}".format(json_file))  

  train_dir = ops.join(base_path,"train")
  test_dir = ops.join(base_path,"test")
  print("train_dir : {}".format(train_dir))
  print("test_dir : {}".format(test_dir))
  # os.makedirs(train_dir, exist_ok=True)
  # os.makedirs(test_dir, exist_ok=True)

  res_lanes = {
    '0_lanes':0,
    '1_lanes':0,
    '2_lanes':0,
    '3_lanes':0,
    '4_lanes':0,
    '5_lanes':0,
    '6_lanes':0
  }
  no_of_lanes = {
    "zero_lane" : [],
    "one_lane" : [],
    "two_lane" : [],
    "three_lane" : [],
    "four_lane" : [],
    "five_lane" : [],
    "six_lane" : []
  }
  train = []
  test = []
  
  lines = []
  with open(json_file, 'r') as file:
    json_lines = file.readlines()

    # Iterate over each image
    for line_index,val in enumerate(json_lines):
      json_line = json_lines[line_index]
      sample = json.loads(json_line)
      # image_name = sample['raw_file']
      lanes = sample['lanes']
      res_lane = []

      for lane in lanes:
        lane_id_found=False
        for lane_id in lane:
          if lane_id == -2:
            continue
          else:
            lane_id_found=True
            break
        if lane_id_found:
          res_lane.append(lane)        
      if len(res_lane) == 0:
        # res_lanes['0_lanes']=res_lanes['0_lanes']+1
        no_of_lanes["zero_lane"].append(json_line)
        res_lanes['0_lanes']=len(no_of_lanes["zero_lane"])
      elif len(res_lane) == 1:
        no_of_lanes["one_lane"].append(json_line)
        res_lanes['1_lanes']=len(no_of_lanes["one_lane"])
      elif len(res_lane) == 2:
        # res_lanes['2_lanes']=res_lanes['2_lanes']+1
        no_of_lanes["two_lane"].append(json_line)
        res_lanes['2_lanes']=len(no_of_lanes["two_lane"])
      elif len(res_lane) == 3:
        # res_lanes['3_lanes']=res_lanes['3_lanes']+1
        no_of_lanes["three_lane"].append(json_line)
        res_lanes['3_lanes']=len(no_of_lanes["three_lane"])
      elif len(res_lane) == 4:
        # res_lanes['4_lanes']=res_lanes['4_lanes']+1
        no_of_lanes["four_lane"].append(json_line)
        res_lanes['4_lanes']=len(no_of_lanes["four_lane"])
      elif len(res_lane) == 5:
        # res_lanes['5_lanes']=res_lanes['5_lanes']+1
        no_of_lanes["five_lane"].append(json_line)
        res_lanes['5_lanes']=len(no_of_lanes["five_lane"])
      elif len(res_lane) == 6:
        # res_lanes['6_lanes']=res_lanes['6_lanes']+1
        no_of_lanes["six_lane"].append(json_line)
        res_lanes['6_lanes']=len(no_of_lanes["six_lane"])

  print(res_lanes)
  
  for i,k in enumerate(no_of_lanes.keys()):
    key = no_of_lanes[k]
    random.shuffle(key)
    tmp_train = []
    tmp_test = []
    split_size = int(0.85*len(key))
    # print("split_size :{}".format(split_size))
    if split_size > 0:
      tmp_train = key[:split_size]
      tmp_test = key[split_size:]
      train.append(tmp_train) 
      test.append(tmp_test) 
  train = [item for sublist in train for item in sublist]
  print('train : {}'.format(len(train)))
  test = [item for sublist in test for item in sublist]
  print('test : {}'.format(len(test)))

  with open(train_dir+"-tusimple"+".json",'w') as outfile:
    for item1 in train:
      outfile.write(item1)

  with open(test_dir+"-tusimple"+".json",'w') as outfile:
    for item2 in test:
      outfile.write(item2)

if __name__ == '__main__':
    args = init_args()
    split_train_test(args.json_file)

