__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).

# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
## Example:
# --------------------------------------------------------

## TODO:
# --------------------------------------------------------

## Future wok:
# --------------------------------------------------------

"""

import os
import sys
import glob
import datetime
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
import annon_to_db as anndb, db_to_aids as aids, aids_cfg as aidscfg
import common

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)


def annon_release(cfg, from_path, path_anndb, path_aids, path_cfg):
    anndb_data_dir = anndb.release_anndb(cfg, from_path, path_anndb)
    aids_data_dir = aids.release_aids(cfg, anndb_data_dir, path_aids)
    cfg_filepath = aidscfg.release_dbcfg(cfg, aids_data_dir, path_cfg)

    return anndb_data_dir, aids_data_dir, cfg_filepath


def main(appcfg, args):
  from_path, path_anndb, path_aids, path_cfg = args.from_path, args.path_anndb, args.path_aids, args.path_cfg
  
  if args.command == 'create':
    anndb_data_dir, aids_data_dir, cfg_filepath = annon_release(appcfg, from_path, path_anndb, path_aids, path_cfg)
    
    log.info("-------")
    log.info(" anndb_data_dir: {} \n aids_data_dir: {} \n cfg_filepath: {}".format(anndb_data_dir, aids_data_dir, cfg_filepath))
    log.info("-------")


def parse_args(commands):
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Annotation parser for VGG Via tool files'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/annotation/<directory_OR_annotation_json_file>'
    ,required=True)

  parser.add_argument('--anndb'
    ,dest='path_anndb'
    ,help='/path/to/anndb_root_directory'
    ,required=True)

  parser.add_argument('--aids'
    ,dest='path_aids'
    ,help='/path/to/aids_root_directory'
    ,required=True)

  parser.add_argument('--cfg'
    ,dest='path_cfg'
    ,help='/path/to/cfg/dataset_root_directory'
    ,required=True)
  
  args = parser.parse_args()
  
  # Validate arguments
  cmd = args.command

  cmd_supported = False

  for c in commands:
    if cmd == c:
      cmd_supported = True

  if not cmd_supported:
    log.info("'{}' is not recognized.\n"
          "Use any one: {}".format(cmd,', '.join(commands)))
    sys.exit(-1)

  from_path, path_anndb, path_aids, path_cfg = args.from_path, args.path_anndb, args.path_aids, args.path_cfg
  for d in [from_path, path_anndb, path_aids, path_cfg]:
    if not os.path.exists(d):
      raise NotADirectoryError("{}".format(d))
    
  return args


if __name__ == '__main__':
  commands = ['create', 'verify']
  args = parse_args(commands)

  main(appcfg, args)