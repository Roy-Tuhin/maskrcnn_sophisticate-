__author__ = 'nikhilbv'
__version__ = '1.0'

"""
# Get images from server
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by nikhilbv
# --------------------------------------------------------
"""

"""
# Usage
# python lanenet_get_images.py --json_file <json_file>
# python lanenet_get_images.py --json_file /aimldl-dat/data-gaze/AIML_Annotation/images-p1-130919_AT1_via205_130919_tuSimple.json
"""

import argparse
import os
import sys
import time
import datetime
import tqdm
import glob
import shutil
import json

import glog as log

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

from _annoncfg_ import appcfg
import annonutils
import common

def get_image(cfg,json_file):

  log.info("json_file : {}".format(json_file))
  to_path = "/aimldl-dat/data-gaze/AIML_Database"
  log.info("to_path : {}".format(to_path))


  IMAGE_API = cfg['IMAGE_API']
  USE_IMAGE_API = IMAGE_API['ENABLE']
  SAVE_LOCAL_COPY = True

  images_annotated = {
    'files':[],
    'unique':set(),
    'not_found':set()
  }
  res_lanes = {
    '0_lanes':0,
    '1_lanes':0,
    '2_lanes':0,
    '3_lanes':0,
    '4_lanes':0,
    '5_lanes':0,
    '6_lanes':0
  }
  
  new_json = []
  
  tic = time.time()
  # log.info("\nrelease_anndb:-----------------------------")
  timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  # log.info("json_file: {}".format(json_file))
  # log.info("to_path: {}".format(to_path))

  save_path = os.path.join(to_path,'lnd-'+timestamp)
  # log.info("save_path: {}".format(save_path))
  common.mkdir_p(save_path)

  images_save_path = os.path.join(save_path,'images')
  log.info("images_save_path: {}".format(images_save_path))
  common.mkdir_p(images_save_path)

  with open(json_file, 'r') as file:
    json_lines = file.readlines()

    # Iterate over each image
    # for line_index,val in enumerate(json_lines):
    no_of_ann = 0
    for line_index,val in tqdm.tqdm(enumerate(json_lines), total = len(json_lines)):
      with_abs_path = {
        'lanes' : [],
        'h_samples' : [],
        'raw_file' : None
      }
      
      json_line = json_lines[line_index]
      sample = json.loads(json_line)
      image_name = sample['raw_file']
      lanes = sample['lanes']
      h_samples = sample['h_samples']
      res_lane = []
      
      # Download image
      if USE_IMAGE_API:
        get_img_from_url_success = annonutils.get_image_from_url(IMAGE_API, image_name, images_save_path, save_local_copy=SAVE_LOCAL_COPY, resize_image=True)  
        if get_img_from_url_success:
          images_annotated['files'].append(image_name)
          images_annotated['unique'].add(image_name)
        else:
          images_annotated['not_found'].add(image_name)

      # Number of lanes
      for lane in lanes:
        lane_id_found=False
        for lane_id in lane:
          if lane_id == -2:
            continue
          else:
            lane_id_found=True
            break
        if lane_id_found:
          no_of_ann += 1
          res_lane.append(lane)        
      if len(res_lane) == 0:
        res_lanes['0_lanes']=res_lanes['0_lanes']+1
      elif len(res_lane) == 1:
        res_lanes['1_lanes']=res_lanes['1_lanes']+1
      elif len(res_lane) == 2:
        res_lanes['2_lanes']=res_lanes['2_lanes']+1
      elif len(res_lane) == 3:
        res_lanes['3_lanes']=res_lanes['3_lanes']+1
      elif len(res_lane) == 4:
        res_lanes['4_lanes']=res_lanes['4_lanes']+1
      elif len(res_lane) == 5:
        res_lanes['5_lanes']=res_lanes['5_lanes']+1
      elif len(res_lane) == 6:
        res_lanes['6_lanes']=res_lanes['6_lanes']+1

      with_abs_path['lanes'] = lanes
      with_abs_path['h_samples'] = h_samples
      with_abs_path['raw_file'] = os.path.join(images_save_path,image_name)

      new_json.append(with_abs_path)
  
  json_name = json_file.split('/')[-1]
  new_json_name = json_name.split('.')[0]
  with open(save_path+'/'+new_json_name+'-'+timestamp+'.json','w') as outfile:
    for items in new_json:
      # log.info("items : {}".format(items))
      json.dump(items, outfile)
      outfile.write('\n')


  stats = {
    'files': len(images_annotated['files']),
    'unique': len(images_annotated['unique']),
    'not_found': len(images_annotated['not_found']),
    'no_of_ann' : no_of_ann,
    'number_of_images_per_lane' : res_lanes
  }

  log.info("\nstats: {}".format(stats))
  log.info('\nDone (t={:0.2f}s)\n'.format(time.time()- tic))

  with open(save_path+'/'+'stats'+'-'+timestamp+'.json', 'w') as f:
    json.dump(stats, f)

  # shutil.copy(json_file,save_path)

          
def main(cfg, args):
  json_file = args.json_file
  get_image(cfg,json_file)


def parse_args():
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Get image from server'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument('--json_file'
    ,dest='json_file'
    ,help='/path/to/annotation/<directory_OR_annotation_json_file>'
    ,required=True)

  args = parser.parse_args()
  
  return args

if __name__ == '__main__':
  args = parse_args()
  main(appcfg, args)

