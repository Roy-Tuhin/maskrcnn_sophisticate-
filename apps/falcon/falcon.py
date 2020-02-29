__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# Falcon framework for end-to-end DNN workflow

# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys
import time

import logging
import logging.config

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.path.join(this_dir,'..')
ROOT_DIR = os.path.join(APP_ROOT_DIR,'..')
BASE_PATH_CFG = os.path.join(ROOT_DIR,'cfg')

# APP_ROOT_DIR = os.getenv('AI_APP')
# ROOT_DIR = os.getenv('AI_HOME')
# BASE_PATH_CFG = os.getenv('AI_CFG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

import _cfg_
import apputil

print("sys.path: {}".format(sys.path))


def parse_args(commands):
  import argparse
  from argparse import RawTextHelpFormatter
  
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='DNN Application Framework.\n * Refer: `paths.yml` environment and paths configurations.\n\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--dataset'
    ,dest='dataset'
    ,metavar="/path/to/<name>.yml or AIDS (AI Dataset) database name"
    ,required=False
    ,help='Path to AIDS (AI Dataset) yml or AIDS ID/DatabaseName available in database`')

  parser.add_argument('--exp'
    ,dest='exp'
    ,metavar="/path/to/<name>.yml or Experiment Id in AIDS for the TEPPr"
    ,required=False
    ,help='Arch specific yml file or Experiment Id for the given AI Dataset for the TEPPr')

  parser.add_argument('--path'
    ,dest='path'
    ,metavar="/path/to/image(s)_or_video(s)"
    ,help='Input: Path of images/videos folder or image/video file or text file containing image names.')

  parser.add_argument('--on'
    ,dest='eval_on'
    ,metavar="[train | val | test]"
    ,help='provide the dataset type "on" against which prediction results would be compared with.')
  
  parser.add_argument('--iou'
    ,dest='iou'
    ,metavar="IoU threshold"
    ,help='provide IoU threshold.')

  parser.add_argument('--tdd'
    ,dest='tdd_mode'
    ,help='Runs the Test Driven Development entry point, to quickly test the functionalities'
    ,action='store_true')

  parser.add_argument('--save_viz'
    ,dest='save_viz'
    ,help='Save the visualization for `predict`'
    ,action='store_true')
  parser.add_argument('--show_bbox'
    ,dest='show_bbox'
    ,help='Save the bbox for `predict`'
    ,action='store_true')

  parser.add_argument('--modelinfo'
    ,dest='create_modelinfo'
    ,help='Option for `train`, but if this option generate only the modelinfo yml template instead of training'
    ,action='store_true')

  args = parser.parse_args()    

  # Validate arguments
  cmd = args.command

  cmd_supported = False

  for c in commands:
    if cmd == c:
      cmd_supported = True

  if not cmd_supported:
    log.error("'{}' is not recognized.\n"
          "Use any one: {}".format(cmd,', '.join(commands)))
    sys.exit(-1)

  if cmd == "evaluate":
    assert args.dataset,\
           "Provide --dataset"
    assert args.exp,\
           "Provide --exp"
    assert args.eval_on,\
           "Provide --on"
    assert args.iou,\
           "Provide --iou"
    ## User input from the shell script to the python, hence needs to typecast to proper datatype
    args.iou = float(args.iou)
    mode = "inference"
  elif cmd == "predict":
    assert args.exp,\
           "Provide --exp"
    assert args.path,\
           "Provide --path"
    mode = "inference"
  elif cmd == "train":
    assert args.dataset,\
           "Provide --dataset"
    assert args.exp,\
           "Provide --exp"
    mode = "training"
  elif cmd == "visualize":
    assert args.dataset,\
           "Provide --dataset"
    mode = "training"
  elif cmd == "inspect_annon":
    assert args.dataset,\
           "Provide --dataset"
    assert args.eval_on,\
           "Provide --eval_on"
    assert args.exp,\
           "Provide --exp"
    mode = "training"
  else:
    mode = "inference"
    raise Exception("Undefined command!")

  args.mode = mode

  return args


def main(args):
  """TODO: JSON RESPONSE
  All errors and json response needs to be JSON compliant and with proper HTTP Response code
  A common function should take responsibility to convert into API response
  """
  try:
    log.info("----------------------------->\nargs:{}".format(args))
    mode = args.mode
    cmd = args.command
    dataset = args.dataset
    exp = args.exp
    eval_on = args.eval_on if 'eval_on' in args else None

    ## dataset is a file or ID, check by the extension
    appcfg = _cfg_.loadcfg(cmd, dataset, exp, eval_on)

    ##
    from falcon.arch import Model
    # from arch import Model

    if args.tdd_mode:
      fn = getattr(Model, 'tdd')
    else:
      fn = getattr(Model, cmd)

    log.debug("fn: {}".format(fn))
    log.debug("cmd: {}".format(cmd))
    log.debug("---x---x---x---")
    if fn:
      ## Within the specific command, route to python module for specific architecture
      fn(args, mode, appcfg)
    else:
      log.error("Unknown fn:{}".format(cmd))
  except Exception as e:
    log.error("Exception occurred", exc_info=True)

  return


if __name__ == '__main__':
  log.debug("Executing....")
  t1 = time.time()

  commands = ['train', 'predict', 'evaluate', 'visualize', 'inspect_annon']
  args = parse_args(commands)
  log.debug("args: {}".format(args))

  main(args)

  t2 = time.time()
  time_taken = (t2 - t1)
  ## TBD: reporting summary for every run
  log.debug('Total time taken in processing: %f seconds' %(time_taken))
