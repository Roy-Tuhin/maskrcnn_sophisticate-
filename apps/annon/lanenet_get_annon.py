__author__ = 'nikhilbv'
__version__ = '1.0'

"""
# Get annotations from server
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by nikhilbv
# --------------------------------------------------------
"""
"""
# Usage
# --------------------------------------------------------
# python lanenet_get_annon.py --job_id <annotation_job_id>
# python lanenet_get_annon.py --job_id <rld_job_270919>
# --------------------------------------------------------
"""

from colorama import init 
from termcolor import colored
import datetime
import os

import argparse

def init_args():
  parser = argparse.ArgumentParser()
  parser.add_argument('--job_id', type=str, help='Annotation job_id')

  return parser.parse_args()

def get_annon(job_id):
  timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())
  to_path = '/aimldl-dat/data-gaze/AIML_Annotation'
  to_dir = os.path.join(to_path,'lnd_poc-'+ timestamp)
  print("to_dir : {}".format(to_dir))
  os.makedirs(to_dir, exist_ok=True)

  anno_basedir = "/data/samba/AIML_Annotation"
  anno_path = os.path.join(anno_basedir,job_id,"annotations")

  print(colored("Execute the following command manually", 'red')) 

  print("rsync -rP nikhil@10.4.71.121:"+anno_path+"/*"+" "+to_dir)

if __name__ == '__main__':
  args = init_args()
  get_annon(args.job_id)
