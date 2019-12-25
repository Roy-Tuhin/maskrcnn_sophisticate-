import logging
import logging.config

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

def test_1():
  """
    annondata.py: get_annon_data(cfg, datacfg)
  """
  from _annoncfg_ import appcfg as cfg
  from _aidbcfg_ import dbcfg as datacfg
  from dataset.Annon import ANNON

  ANNONCFG = cfg['DBCFG']['ANNONCFG']
  annon = ANNON(dbcfg=ANNONCFG, datacfg=datacfg)
  lbl_ids =  annon.getCatIds()
  log.info("-----------------lbl_ids, len(lbl_ids): {}, {}".format(lbl_ids, len(lbl_ids)))

  # images =  annon.getImgIds()
  # log.info("-----------------len(images): {}".format(len(images)))

  images_for_lbl_ids =  annon.getImgIds(catIds=lbl_ids)
  log.info("-----------------len(images_for_lbl_ids): {}".format(len(images_for_lbl_ids)))

  # imgIds = ['img-b0ef88d8-8705-4bbf-ad9d-bce8f5a4794f', 'img-7b72f0aa-0e47-4cee-9fc0-8d09bbe253af']
  # images_for_lbl_ids =  annon.getImgIds(imgIds=imgIds, catIds=lbl_ids)

  images_for_lbl_ids =  annon.getImgIds(catIds=lbl_ids)
  log.info("-----------------len(images_for_lbl_ids): {}".format(len(images_for_lbl_ids)))

  catToImgs = annon.catToImgs
  log.info("catToImgs: {}".format(len(catToImgs)))

  _img_ids = []
  for i, lbl_id in enumerate(lbl_ids):
    _ids = catToImgs[lbl_id]
    log.info("i, lbl_id, _ids: {}, {}, {}".format(i, lbl_id, len(_ids)))
    _img_ids += _ids

  log.info("lengths: _img_ids, set(_img_ids): {}, {}".format(len(_img_ids), len(set(_img_ids))))

if __name__ == '__main__':
  test_1()