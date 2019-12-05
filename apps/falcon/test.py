__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# Falcon framework for end-to-end DNN workflow

# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys
import time
import logging

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.path.join(this_dir,'..')

ROOT_DIR = os.path.join(APP_ROOT_DIR,'..')
BASE_PATH_CFG = os.path.join(ROOT_DIR,'cfg')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

log = logging.getLogger('__main__.'+__name__)

import _cfg_
import common
import apputil
import viz


def train(args, mode, appcfg):
  log.debug("---------------------------->")
  from falcon.arch import Model as M
  M.train(args, mode, appcfg)


def viz_annon(args, mode, appcfg):
  log.debug("---------------------------->")
  from falcon.arch import Model as M
  M.viz_annon(args, mode, appcfg)


def inspect_annon(args, mode, appcfg):
  log.debug("---------------------------->")
  from falcon.arch import Model as M
  M.inspect_annon(args, mode, appcfg)


def load_and_display(args, mode, appcfg):
  log.debug("---------------------------->")
  from falcon.arch import Model as M
  from importlib import import_module

  datacfg = M.get_datacfg(appcfg)
  log.debug("datacfg: {}".format(datacfg))
  datamod = import_module(datacfg.dataclass)
  datamodcls = getattr(datamod, datacfg.dataclass)
  dataset = datamodcls(datacfg.name)

  subset = args.eval_on
  log.debug("subset: {}".format(subset))

  # total_img, total_annotation, total_classes = dataset.load_data(appcfg, datacfg, subset)
  # log.debug("total_img, total_annotation, total_classes: {}, {}, {}".format(total_img, total_annotation, total_classes))

  dataset, num_classes, num_images, class_names, total_stats, total_verify = M.get_dataset_instance(dataset, appcfg, datacfg, subset)
  
  # colors = viz.random_colors(len(class_names))
  # log.debug("len(colors), colors: {},{}".format(len(colors), colors))

  log.info("class_names: {}".format(class_names))
  log.info("len(class_names): {}".format(len(class_names)))
  log.info("num_classes: {}".format(num_classes))
  log.info("num_images: {}".format(num_images))

  name = dataset.name
  log.info("dataset.name: {}".format(name))
  # datacfg.name = name
  # datacfg.classes = class_names
  # datacfg.num_classes = num_classes

  # # log.debug("dataset: {}".format(vars(dataset)))
  # log.debug("len(dataset.image_info): {}".format(len(dataset.image_info)))
  # log.debug("len(dataset.image_ids): {}".format(len(dataset.image_ids)))

  return


def load_model_and_weights(args, mode, appcfg):
  log.debug("---------------------------->")
  from falcon.arch import Model as M

  archcfg = M.get_archcfg(appcfg)
  log.debug("archcfg: {}".format(archcfg))
  cmdcfg = archcfg

  # modelcfg_path = os.path.join(appcfg.PATHS.AI_MODEL_CFG_PATH, cmdcfg.model_info)
  modelcfg_path = apputil.get_abs_path(appcfg, cmdcfg, 'AI_MODEL_CFG_PATH')
  log.info("modelcfg_path: {}".format(modelcfg_path))
  modelcfg = M.get_modelcfg(modelcfg_path)

  log.info("modelcfg: {}".format(modelcfg))
  
  num_classes_model = apputil.get_num_classes(modelcfg)
  name = modelcfg.name

  cmdcfg.name = name
  cmdcfg.config.NAME = name
  cmdcfg.config.NUM_CLASSES = num_classes_model
  
  dnnmod = M.get_module(cmdcfg.dnnarch)
  load_model_and_weights = M.get_module_fn(dnnmod, "load_model_and_weights")
  model = load_model_and_weights(args, mode, cmdcfg, modelcfg, appcfg)  

  status = True
  return status


def test1():
  """Test init for loading configuration
  """
  
  from pymongo import MongoClient
  
  aids_dbname = "PXL-260619_221820_050719_145559"
  exp_id = "exp-25b5043e-5706-41d1-82d7-2ba8637ef5cb"

  base_path_cfg = BASE_PATH_CFG
  appcfg = _cfg_.init(base_path_cfg)

  DBCFG = appcfg['APP']['DBCFG']

  PXLCFG = DBCFG['PXLCFG']
  mclient = MongoClient('mongodb://'+PXLCFG['host']+':'+str(PXLCFG['port']))
  dbname = PXLCFG['dbname']

  # ANNONCFG = DBCFG['ANNONCFG']
  # mclient = MongoClient('mongodb://'+ANNONCFG['host']+':'+str(ANNONCFG['port']))
  # dbname = ANNONCFG['dbname']

  db = mclient[dbname]

  tblname = 'AIDS'
  aids = db.get_collection(tblname)
  if aids:
    # cur = list(aids.find({'aids_dbname':aids_dbname, 'train':{'$elemMatch':{'exp_id':exp_id}}},{'_id':0,'train.$':1}))
    # cur = aids.find({'aids_dbname':aids_dbname, 'train':{'$elemMatch':{'exp_id':exp_id}}},{'_id':0})
    cur = aids.find_one({'aids_dbname':aids_dbname, 'train':{'$elemMatch':{'exp_id':exp_id}}},{'_id':0})
    if cur:
      item = cur
      item_name = item['aids_dbname']
      # item_name = item_name.split('-')[-1]

      if item_name not in appcfg.DATASET:
        appcfg.DATASET[item_name] = {}

      appcfg.DATASET[item_name]['cfg'] = item
      appcfg.DATASET[item_name]['cfg_file'] = aids_dbname
      appcfg.DATASET[item_name]['cfg_loaded'] = True
      
      appcfg.ACTIVE.DATASET = item_name

      train = item['train']
      if len(train) > 0:
        for exp in train:
          if exp['exp_id'] not in appcfg.ARCH:
            appcfg.ARCH[exp['exp_id']] = {}

          appcfg.ARCH[exp['exp_id']]['cfg'] = exp
          appcfg.ARCH[exp['exp_id']]['cfg_file'] = exp['exp_id']
          appcfg.ARCH[exp['exp_id']]['cfg_loaded'] = True

          if exp_id == exp['exp_id']:
            appcfg.ACTIVE.ARCH = exp_id
  
  mclient.close()
  log.debug("appcfg: {}".format(appcfg))

def test_load_model(args, mode, appcfg):
  log.debug("---------------------------->")
  from falcon.arch import Model as M

  archcfg = M.get_archcfg(appcfg)
  log.debug("archcfg: {}".format(archcfg))
  cmdcfg = archcfg

  modelcfg_path = os.path.join(appcfg.PATHS.AI_MODEL_CFG_PATH, cmdcfg.model_info)
  log.info("modelcfg_path: {}".format(modelcfg_path))
  modelcfg = M.get_modelcfg(modelcfg_path)
  class_names = apputil.get_class_names(modelcfg)
  log.debug("class_names: {}".format(class_names))

  num_classes = len(class_names)
  name = modelcfg.name

  cmdcfg.name = name
  cmdcfg.config.NAME = name
  cmdcfg.config.NUM_CLASSES = num_classes

  dnnmod = M.get_module(cmdcfg.dnnarch)

  weights_path = apputil.get_abs_path(appcfg, modelcfg, 'AI_WEIGHTS_PATH')
  cmdcfg['weights_path'] = weights_path

  load_model_and_weights = M.get_module_fn(dnnmod, "load_model_and_weights")
  model = load_model_and_weights(mode, cmdcfg, appcfg)

  log.debug("model: {}".format(model))

  # modelsummary_path = os.path.join(appcfg.PATHS.AI_LOGS, name+"-summary.txt")
  # log.debug("modelsummary_path: {}".format(modelsummary_path))

  # # msummary = model.keras_model.summary()
  # # log.debug("model.keras_model.summary(): {}".format(msummary))
  # # with open(modelsummary_path, 'w') as fw:
  # #   fw.write(msummary)

  return


def main(args, mode, appcfg):
  status = False

  mode = args.mode
  # cmd = args.command
  # dataset = args.dataset
  # exp = args.exp

  log.debug("appcfg: {}".format(appcfg))

  # load_model_and_weights(args, mode, appcfg)
  # load_and_display(args, mode, appcfg)
  # viz_annon(args, mode, appcfg)
  # inspect_annon(args, mode, appcfg)

  # train(args, mode, appcfg)
  test_load_model(args, mode, appcfg)

  return status


if __name__ == '__main__':
  log.info("Executing....")
  t1 = time.time()

  # test1()

  t2 = time.time()
  time_taken = (t2 - t1)
  ## TBD: reporting summary for every run
  log.info('Total time taken in processing: %f seconds' %(time_taken))


