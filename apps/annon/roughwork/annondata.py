import os
import sys

import logging
import logging.config

import numpy as np
from dataset.Annon import ANNON

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
ROOT_DIR = os.getenv('AI_HOME')
BASE_PATH_CFG = os.getenv('AI_CFG')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

this = sys.modules[__name__]

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)


def get_annon_data(cfg, args, datacfg):
  """filter images based on the specific filter_by

  TODO:
  * annotation filtering based on stats on total images, total annotations, area (mask, bbox)
  """
  log.info("\nget_annon_data:-----------------------------")

  ANNONCFG = cfg['DBCFG']['ANNONCFG']
  annon = ANNON(dbcfg=ANNONCFG, datacfg=datacfg)
  releaseinfo = annon.getReleaseId()

  filter_by = []
  filter_enable = cfg['AIDS_FILTER']['ENABLE']
  if filter_enable:
    filter_by = cfg['AIDS_FILTER'][ cfg['AIDS_FILTER']['BY'] ]
    # filter_by = np.array(cfg['AIDS_FILTER'][ cfg['AIDS_FILTER']['BY'] ])
    lbl_ids =  annon.getCatIds(catIds=filter_by)
    # lbl_ids = list(lbl_ids[np.where(np.in1d(lbl_ids, filter_by))])
    log.info("lbl_ids after filter: {}".format(lbl_ids))
  else:
    lbl_ids =  annon.getCatIds()

  log.info("lbl_ids: {}".format(lbl_ids))

  images_imgIds = annon.getImgIds(catIds=lbl_ids)
  # annotations = annon.getAnnIds(imgIds=images_imgIds, catIds=lbl_ids, areaRng=[])
  annotations = annon.getAnnIds(imgIds=images_imgIds, catIds=lbl_ids)
  classinfo = annon.loadCats(ids=lbl_ids)

  ## make sure that the K have a fixed order before shuffling
  ## https://cs230-stanford.github.io/train-dev-test-split.html
  T = len(images_imgIds)
  log.info("images_imgIds Size: => {}".format(T))

  cfg_aids_randomizer = cfg['AIDS_RANDOMIZER']
  if cfg_aids_randomizer['ENABLE']:
    if cfg_aids_randomizer['USE_SEED']:
      np.random.seed(T) ## provides consistent shuffle given that 'T' is same between two different execution of the script
    ## Shuffle K
    np.random.shuffle(images_imgIds)

  img_lbl_arr = np.zeros([len(images_imgIds), len(lbl_ids)], int)
  for j, lbl_id in enumerate(lbl_ids):
    img_col = img_lbl_arr[:,j]
    img_ids = annon.getImgIds(catIds=lbl_id)
    log.info("lbl_id, len(img_ids): {}, {}".format(lbl_id, len(img_ids)))
    if img_ids and len(img_ids) > 0:
      img_col[np.where(np.in1d(images_imgIds, img_ids))] += 1

  return annon, images_imgIds, annotations, classinfo, lbl_ids, img_lbl_arr

