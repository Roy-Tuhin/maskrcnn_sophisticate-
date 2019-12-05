__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).

# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
## Example:
# --------------------------------------------------------

## TODO:
# --------------------------------------------------------
- The script needs to be sync with the annotation specification of the VGG VIA tool being used

## Future wok:
# --------------------------------------------------------
- Extend the script to support `scalable` annotation tool
"""


import os
import sys
import time
import datetime

import glob
import shutil
import json

import logging
import logging.config

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

from _annoncfg_ import appcfg
import annonutils
import common

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)


def merge_ann(cfg, from_path, to_path, move_file=False):
  """copy annotation data from multiple folders to a single destination folder
  """
  tic = time.time()
  log.info("\nrelease_anndb:-----------------------------")
  timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))

  base_to_path = common.getBasePath(to_path)
  log.info("base_to_path: {}".format(base_to_path))

  ## Get only top level directories
  ## Ref:
  ## https://stackoverflow.com/questions/141291/how-to-list-only-top-level-directories-in-python
  ## https://stackoverflow.com/questions/4568580/python-glob-multiple-filetypes
  aijobs = next(os.walk(base_from_path))[1]
  aijobs_path = [os.path.join(base_from_path,x) for x in aijobs]
  exts = appcfg['ALLOWED_IMAGE_TYPE']
  files_to_copy = {x:{
    'annotations':glob.glob(os.path.join(base_from_path, x, 'annotations', '*.json'))
    # ,'images': [item for sublist in [glob.glob(os.path.join(base_from_path, x, 'images') + '/*/*'+ext) for ext in exts  for x in aijobs ] for item in sublist]
  } for x in aijobs}
  
  images_annotated = {
    'files':[]
    ,'unique':set()
    ,'not_found':set()
  }

  stats = {}
  groups = []

  IMAGE_API = cfg['IMAGE_API']
  USE_IMAGE_API = IMAGE_API['ENABLE']
  SAVE_LOCAL_COPY = True
  # NO_OF_ANNON_FILES_THRESHOLD = 5
  
  for i, x in enumerate(files_to_copy):
    log.info("\n[{}]x:-----------------------------{}".format(i,x))
    for y in files_to_copy[x]:
      log.info("y:-------{}".format(y))
      filepaths = files_to_copy[x][y]
      if y not in stats:
        stats[y] = {'count':0, 'unique':set(), 'total':0 }
        groups.append(y)

      stats[y]['total'] += len(filepaths)
      for j, src_filepath in enumerate(filepaths):
        index = -1 if y=='annotations' else -2

        filename = os.path.basename(src_filepath)
        
        ## if annotations, read it fetch images from it
        if y == 'annotations':
          with open(src_filepath,'r') as fr:
            ref = annonutils.parse_annon_filename(filename)
            annotations = json.load(fr)
            annon_file_name = {}
            for ak,av in annotations.items():
              # imgpath, base_path_img = annonutils.getImgPath(base_from_path, ref['image_dir'])
              base_path_img = os.path.join(base_to_path, 'images', ref['image_dir'])
              filepath_img = os.path.join(base_path_img, av['filename'])
              if av['filename'] not in annon_file_name:
                annon_file_name[av['filename']] = {
                  'annotations': []
                  ,'imagename': av['filename']
                  ,'metadata': {}
                  ,'image_dir': ref['image_dir']
                }
              annon_file_name[av['filename']]['annotations'].append(av['regions'])

              if USE_IMAGE_API:
                get_img_from_url_success = annonutils.get_image_from_url(IMAGE_API, av['filename'], base_path_img, save_local_copy=SAVE_LOCAL_COPY)
                if get_img_from_url_success:
                  images_annotated['files'].append(av['filename'])
                  images_annotated['unique'].add(av['filename'])
                else:
                  images_annotated['not_found'].add(av['filename'])

        basedir = os.path.sep.join(os.path.dirname(src_filepath).split(os.path.sep)[index:])
        dst_to_basedir = os.path.join(base_to_path, basedir)

        stats[y]['unique'].add(filename)
        stats[y]['count'] += 1
        log.info("stats[y]['count']:{}, [x:j]:[{}:{}]: Exists: {} \n src_filepath: {}".format(stats[y]['count'], x, j, os.path.exists(src_filepath), src_filepath))
        log.info("basedir: {}".format(basedir))
        log.info("dst_to_basedir: {}".format(dst_to_basedir))

        # ## Ref: https://www.pythoncentral.io/how-to-copy-a-file-in-python-with-shutil/
        common.mkdir_p(dst_to_basedir)
        shutil.copy2(src_filepath, dst_to_basedir)

  for g in groups:
    stats[g]['unique'] = len(stats[g]['unique'])
  
  
  stats['images_annotated'] = {
    'files': len(images_annotated['files'])
    ,'unique': len(images_annotated['unique'])
    ,'not_found': len(images_annotated['not_found'])
  }
  log.info("\nstats: {}".format(stats))
  log.info('\nDone (t={:0.2f}s)\n'.format(time.time()- tic))


def main(cfg, args):
  from_path = args.from_path
  to_path = args.to_path

  db_data_dir = merge_ann(cfg, from_path, to_path)
  log.info("-------")
  log.info("ANNDB Database path: db_data_dir: {}".format(db_data_dir))
  log.info("-------")


def parse_args():
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Annotation parser for VGG Via tool files'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/annotation/<directory_OR_annotation_json_file>'
    ,required=True)

  parser.add_argument('--to'
    ,dest='to_path'
    ,help='/path/to/anndb_root'
    ,required=True)

  args = parser.parse_args()
  
  ## Validate arguments
  from_path, to_path = args.from_path, args.to_path
  for d in [from_path, to_path]:
    if not os.path.exists(d):
      raise NotADirectoryError("{}".format(d))
  
  return args


if __name__ == '__main__':
  args = parse_args()
  main(appcfg, args)