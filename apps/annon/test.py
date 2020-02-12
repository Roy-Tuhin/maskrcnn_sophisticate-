import numpy as np
import logging
import logging.config

from _annoncfg_ import appcfg as cfg
from _aidbcfg_ import dbcfg as datacfg

import dataset.datasplit
from dataset.Annon import ANNON

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

def get_annon_data(cfg, datacfg):
  """filter images based on the specific filter_by

  TODO:
  * annotation filtering based on stats on total images, total annotations, area (mask, bbox)
  """
  log.info("\nget_annon_data:-----------------------------")

  annon = ANNON(cfg, datacfg)
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

  images = annon.getImgIds(catIds=lbl_ids)
  annotations = annon.getAnnIds(catIds=lbl_ids)
  # annotations = annon.getAnnIds(imgIds=images, catIds=lbl_ids, areaRng=[])
  annotations = annon.getAnnIds(imgIds=images, catIds=lbl_ids)

  ## make sure that the K have a fixed order before shuffling
  ## https://cs230-stanford.github.io/train-dev-test-split.html
  T = len(images)
  log.info("Size: => {}".format(T))

  cfg_aids_randomizer = cfg['AIDS_RANDOMIZER']
  if cfg_aids_randomizer['ENABLE']:
    if cfg_aids_randomizer['USE_SEED']:
      np.random.seed(T) ## provides consistent shuffle given that 'T' is same between two different execution of the script
    ## Shuffle K
    np.random.shuffle(images)

  img_lbl_arr = np.zeros([len(images), len(lbl_ids)], int)
  for j, lbl_id in enumerate(lbl_ids):
    img_col = img_lbl_arr[:,j]
    img_ids = annon.getImgIds(catIds=lbl_id)
    log.info("lbl_id, len(img_ids): {}, {}".format(lbl_id, len(img_ids)))
    if img_ids and len(img_ids) > 0:
      img_col[np.where(np.in1d(images, img_ids))] += 1

  ## split the images using splitting algorithm
  images_splits, splited_indices, splited_indices_per_label = datasplit.do_data_split(cfg, images, lbl_ids, img_lbl_arr)
  log.info("len(images_splits): {}".format(len(images_splits)))
  for split in images_splits:
    log.info("len(split): {}".format(len(split)))


  ## Create AIDS - AI Datasets
  aids_splits_criteria = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]
  # splits, prcntg = aids_splits_criteria[0], aids_splits_criteria[1]
  splits = aids_splits_criteria[0] ## directory names
  aids = {}
  stats = {}
  

  log.info("-----------------lbl_ids: {}".format(lbl_ids))
  for i, fnn in enumerate(images_splits):
    log.info("\nTotal Images in: {}, {}, {}".format(splits[i], len(fnn), type(fnn)))
    imgIds = list(fnn)
    annIds = annon.getAnnIds(imgIds=imgIds, catIds=lbl_ids)
    catIds = annon.getCatIds(catIds=lbl_ids)

    log.info("catIds: {}".format(catIds))

    classinfo = annon.loadCats(ids=catIds)
    log.info("classinfo: {}".format(classinfo))

    if splits[i] not in aids:
      aids[splits[i]] = {
        'IMAGES':None
        ,'ANNOTATIONS': None
        ,'CLASSINFO_SPLIT':None
        ,'STATS':None
      }

    if splits[i] not in stats:
      stats[splits[i]] = {
        'labels':''
        ,'total_annotations':0
        ,'classinfo':''
        ,"labels": []
        ,"annotation_per_img": []
        ,"label_per_img": []
        ,"total_unique_images": set()
        ,"total_images": 0
        ,"maskarea": []
        ,"bboxarea": []
        ,"colors": None
      }

    stats[splits[i]]['total_images'] += len(imgIds)
    stats[splits[i]]['total_annotations'] += len(annIds)

    aids[splits[i]]['IMAGES'] = annon.loadImgs(ids=imgIds)
    aids[splits[i]]['ANNOTATIONS'] = annon.loadAnns(ids=annIds)
    aids[splits[i]]['CLASSINFO_SPLIT'] = classinfo
    aids[splits[i]]['STATS'] = stats

    log.info("stats: {}".format(stats))
    # log.info("aids[splits[i]]['IMAGES']: {}".format(aids['train']))
    # log.info("aids: {}".format(aids))

  return aids, stats


aids, stats = get_annon_data(cfg, datacfg)