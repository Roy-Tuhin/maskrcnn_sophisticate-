#!/usr/bin/env python

# --------------------------------------------------------
# Copyright (c) 2018 VidTeq
# Licensed under The MIT License [see LICENSE for details]
# Written by Mangal Bhaskar
# --------------------------------------------------------

import os.path as osp
# import numpy as np

import pixel.Util as Util


## TBD: Error Handling with proper message and default to something executable
## earlier: getModelDetails
def getDetails(args):
  ## Path retrival convention
  # # <basepath>/<org_name>/<problem_id>/<rel_num>/<dir_type>/<arch>/<file_name>

  # print("getDetails:args: {}".format(args))
  print("getDetails:args: {}".format(args.ORG_NAME))

  dtls = None
  PROBLEM_ID = args.APIS.vision.ids[args.ID].name
  print("getDetails:PROBLEM_ID: {}".format(PROBLEM_ID))

  modelcfg = args.NETS[args.ORG_NAME][PROBLEM_ID][args.REL_NUM]
  print("Model::getDetails:modelcfg:: {}".format(modelcfg))
  if modelcfg is None:
    print("-----------------------------------------=====")
    raise Exception('Not a Valid Model: check ORG_NAME, ID, REL_NUM')
    return dtls
  
  dtls = {}
  dtls["PROBLEM_ID"] = modelcfg.PROBLEM_ID
  dtls["ID"] = modelcfg.ID
  dtls["DNNARCH"] = modelcfg.DNNARCH
  dtls["CLASSES"] = modelcfg.CLASSES
  dtls["FRAMEWORK_TYPE"] = modelcfg.FRAMEWORK_TYPE

  if "config" in modelcfg:
    dtls["config"] = modelcfg.config


  basepath = osp.join(args.DNN_MODEL_PATH, args.ORG_NAME, PROBLEM_ID, args.REL_NUM, modelcfg.DNNARCH)

  if modelcfg.FRAMEWORK_TYPE == "caffe":
      prototxt = modelcfg.prototxt      
      dtls["prototxt_test"] = osp.join(basepath, "prototxt", prototxt.test)
      dtls["prototxt_train"] = osp.join(basepath, "prototxt", prototxt.train)

  weights = modelcfg.weights
  dtls["weights"] = osp.join(basepath, "weights", weights)

  ## TBD: this function should not check if file(s) exists or not.
  ## And, the check should happen at the callee end
  if not osp.isfile(dtls["weights"]):
      raise IOError(('{:s} not found.\n (Old message, to be updated!) Did you run ./data/script/'
                 'fetch_faster_rcnn_models.sh?').format(dtls["weights"]))
  
  dtls["basepath"] = basepath
  print("Model::getDetails:dtls:: {}".format(dtls))

  return dtls


## TBD: error handling
def load(dnn, modelDtls, args ):
  model = None
  loadModel = Util.get(dnn, "loadModel")
  if loadModel:
    model = loadModel(modelDtls, args)
    # loadWeights = Util.get(dnn, "loadWeights")
    # loadWeights(modelDtls, model)

  # mod = import_module(dnn)
  # if mod:
  #   loadModel = getattr(mod, "loadModel")
  #   model = loadModel(modelDtls, args)

  # print("load: {}".format(mod))
  return model


def warmup(dnn, net):
  fn = Util.get(dnn, "warmup")
  if fn:
    fn(net)


def exec_prediction(dnn, modelDtls, net, im_names, path, out_file, __appcfg):
  print("Inside: Model::exec_prediction")
  total = len(im_names)
  count = 0
  all_rows_for_all_classes = None
  print("exec_prediction:: outfile:"+out_file)
  print("exec_prediction:: Total images to be predicted:".format(str(total)))
  
  print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
  ## DNN specific calls dunamic binding
  # mod = import_module(dnn)
  # fn = getattr(mod, "predict")

  print("dnn: {}".format(dnn))
  fn = Util.get(dnn, "predict")
  if not fn:
    print("fn: no function in the module: TBD exit")

  FILE_DELIMITER = __appcfg.FILE_DELIMITER
  for im_name in im_names:
    ## TBD: out_file with timestamp

    # fileName = Util.getOutFileName(out_file, im_name, ".csv", __appcfg)
    # print("exec_prediction:: fileName: {}".format(fileName))
    # # fileName = getCsvFileName(out_file, im_name, __appcfg)

    # with open(fileName,'w') as f:
    #   header = Util.getOutFileHeader(FILE_DELIMITER)
    #   f.write(header+'\n')

    ## vis detection output
    all_rows_for_all_classes = fn(modelDtls, net, im_name, path, out_file, __appcfg)
    print("exec_prediction::all_rows_for_all_classes: {}".format(all_rows_for_all_classes))
    ++count

    # if __appcfg.VIS_DETECTIONS:
    #   Util.vis_detections_from_csvfile(im_name, FILE_DELIMITER, path, out_file, __appcfg)
    # else:
    #   Util.delete_no_detection_csvfile(im_name, FILE_DELIMITER, path, out_file, __appcfg)

    print("-----------------------")
  
  return all_rows_for_all_classes


def exec_training(args, model):
  import imgaug  # https://github.com/aleju/imgaug (pip3 install imgaug)
  ## load dataset

  ### training dataset
  dataclass = args.dataclass
  mod = import_module(dataclass)
  dataset_train = dataclass()
  dataset_train.load_data(args.dataset, "train")
  dataset_train.prepare()

  ### validation dataset
  dataset_val = dataclass()
  dataset_val.load_data(args.dataset, "val")
  dataset_val.prepare()

  ### Image Augmentation
  ## Right/Left flip 50% of the time
  augmentation = imgaug.augmenters.Fliplr(0.5)

  ### training schedule
  # Training - Stage 1
  print("Training network heads")
  model.train(dataset_train, dataset_val,
              learning_rate=config.LEARNING_RATE,
              epochs=40,
              layers='heads',
              augmentation=augmentation)

  # Training - Stage 2
  # Finetune layers from ResNet stage 4 and up
  print("Fine tune Resnet stage 4 and up")
  model.train(dataset_train, dataset_val,
              learning_rate=config.LEARNING_RATE,
              epochs=120,
              layers='4+',
              augmentation=augmentation)

  # Training - Stage 3
  # Fine tune all layers
  print("Fine tune all layers")
  model.train(dataset_train, dataset_val,
              learning_rate=config.LEARNING_RATE / 10,
              epochs=160,
              layers='all',
              augmentation=augmentation)

  return