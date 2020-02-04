#!/usr/bin/env python
# coding: utf-8

__author__ = 'saqibmobin'
__version__ = '1.0'

import os
import sys
import json
import random
import math
import re
import time
import numpy as np
import cv2
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from importlib import import_module
sys.path.insert(1, '/codehub/external/detectron2')
import yaml
import logging
import logging.config
from easydict import EasyDict as edict

from detectron2.evaluation import COCOEvaluator, inference_on_dataset
from detectron2.data import build_detection_test_loader
from detectron2.modeling import build_model
from detectron2 import model_zoo

#prediction
from detectron2.engine import DefaultPredictor
from detectron2.utils.visualizer import ColorMode
from detectron2.checkpoint import DetectionCheckpointer

AI_CODE_BASE_PATH = '/codehub'
BASE_PATH_CONFIG = os.path.join(AI_CODE_BASE_PATH,'config')
APP_ROOT_DIR = os.path.join(AI_CODE_BASE_PATH,'apps')

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(0, APP_ROOT_DIR)

import _cfg_
from annon.dataset.Annon import ANNON
import apputil

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

appcfg = _cfg_.load_appcfg(BASE_PATH_CONFIG)
appcfg = edict(appcfg)

HOST = "10.4.71.69"
# AI_ANNON_DATA_HOME_LOCAL ="/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119"
AI_ANNON_DATA_HOME_LOCAL ="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_281219_125647"
appcfg['APP']['DBCFG']['PXLCFG']['host'] = HOST
appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'] = AI_ANNON_DATA_HOME_LOCAL

## TODO: fix the path if any loading problem comes
## AI_DETECTRON_ROOT = "/codehub/external/detectron2"

from detectron2.structures import BoxMode
from detectron2.utils import visualizer
from detectron2.data import MetadataCatalog, DatasetCatalog
from detectron2.config import config
from detectron2.engine import DefaultTrainer

this = sys.modules[__name__]

def get_dataset_name(name, subset):
    return name + "_" + subset


def get_dataset_dicts(cfg, class_ids, id_map, imgs, anns, bbox_mode):
    # print(anns)

    ## => quick hack for running detectron2 with gaze data
    ## TODO: Convert to COCO -> if done in pre-processing, this step not required here

    imgs_anns = list(zip(imgs, anns))
    dataset_dicts = []
    extra_annotation_keys=None

    ## TODO: iscrowd is available in attributes as something like group
    ann_keys = ["iscrowd", "bbox", "keypoints", "category_id", "lbl_id"] + (extra_annotation_keys or [])
    num_instances_without_valid_segmentation = 0

    # print("imgs_anns: {}".format(imgs_anns[:2]))

    for (img_dict, anno_dict_list) in imgs_anns:
        # print("img_dict: {}".format(img_dict))
        # print("anno_dict_list: {}".format(len(anno_dict_list)))

        filtered_anns = []
        for key in anno_dict_list:
            if key["ant_type"]=="polygon":
                filtered_anns.append(key)

        # print("img_dict: {}".format(img_dict))
        # print("anno_dict_list: {}".format(len(anno_dict_list)))
        # print("filtered_anns: {}".format(len(filtered_anns)))
        # print("filtered_anns: {}".format(filtered_anns))
        # print("anno_dict_list: {}".format(anno_dict_list))
        if len(filtered_anns)!=0:
            image_path = apputil.get_abs_path(cfg, img_dict, 'AI_ANNON_DATA_HOME_LOCAL') ##image_root
            filepath = os.path.join(image_path, img_dict['filename'])
            record = {}
            record["file_name"] = filepath
            record["height"] = img_dict["height"]
            record["width"] = img_dict["width"]
            image_id = record["image_id"] = img_dict["img_id"] ## coco: id

            objs = []
            # for anno in anno_dict_list:
            for anno in filtered_anns:
                if anno["ant_type"]=="polygon":
                    assert anno["img_id"] == image_id ## image_id
                    obj = {key: anno[key] for key in ann_keys if key in anno}
                    ##TODO: convert bbbox to coco format
                    _bbox = obj['bbox']

                    ##TODO: verify what is BoxMode.XYWH_ABS
                    coco_frmt_bbox = [_bbox['xmin'], _bbox['ymin'], _bbox['width'], _bbox['height'] ]
                    #print("coco_frmt_bbox: {}".format(coco_frmt_bbox))
                    obj['bbox'] = coco_frmt_bbox
                    ## TODO: get polygon from shape_attributes and convert to coco format
                    #segm = anno.get("segmentation", None)


                    # assert not anno["region_attributes"]
                    # segm=None

                    # if anno["ant_type"]=="polygon":
                    anno = anno["shape_attributes"]
                    # print("anno: {}".format(anno))
                    px = anno["all_points_x"]
                    py = anno["all_points_y"]
                    poly = [(x + 0.5, y + 0.5) for x, y in zip(px, py)]
                    poly = [p for x in poly for p in x]

                    segm = [poly]

                    if segm:  # either list[list[float]] or dict(RLE)
                        if not isinstance(segm, dict):
                            # filter out invalid polygons (< 3 points)
                            segm = [poly for poly in segm if len(poly) % 2 == 0 and len(poly) >= 6]
                            if len(segm) == 0:
                                num_instances_without_valid_segmentation += 1
                                continue  # ignore this instance
                            obj["segmentation"] = segm

                    obj["bbox_mode"] = bbox_mode
                    obj["category_id"] = id_map[obj["lbl_id"]] ## category_id
                    objs.append(obj)

            record["annotations"] = objs
            dataset_dicts.append(record)

    return dataset_dicts


def get_data(subset, _appcfg):
    ## TODO: to be passed through cfg

    cmd = "train"
    # dbname = "PXL-291119_180404"
    # dbname = "PXL-301219_174758"
    dbname = "PXL-310120_175129"
    # exp_id = "train-422d30b0-f518-4203-9c4d-b36bd8796c62"
    # exp_id = "train-d79fe253-60c8-43f7-a3f5-42a4abf97b6c"
    exp_id = "train-887c2e82-1faa-4353-91d4-2f4cdc9285c1"
    eval_on = subset
    # log.debug(_appcfg)
    # log.info(_appcfg['APP']['DBCFG']['PXLCFG'])
    # log.info(_appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'])

    ## datacfg and dbcfg
    _cfg_.load_datacfg(cmd, _appcfg, dbname, exp_id, eval_on)
    datacfg = apputil.get_datacfg(_appcfg)
    dbcfg = apputil.get_dbcfg(_appcfg)
    # log.info("datacfg: {}".format(datacfg))
    # log.info("dbcfg: {}".format(dbcfg))

    ## archcfg, cmdcfg
    _cfg_.load_archcfg(cmd, _appcfg, dbname, exp_id, eval_on)
    archcfg = apputil.get_archcfg(_appcfg)
    log.debug("archcfg: {}".format(archcfg))
    cmdcfg = archcfg

    dataset, num_classes, num_images, class_names, total_stats, total_verify = apputil.get_dataset_instance(_appcfg, dbcfg, datacfg, subset)

    log.debug("class_names: {}".format(class_names))
    log.debug("len(class_names): {}".format(len(class_names)))
    log.debug("num_classes: {}".format(num_classes))
    log.debug("num_images: {}".format(num_images))

    name = dataset.name
    datacfg.name = name
    datacfg.classes = class_names
    datacfg.num_classes = num_classes

    cmdcfg.name = name
    cmdcfg.config.NAME = name
    cmdcfg.config.NUM_CLASSES = num_classes

    annon = ANNON(dbcfg, datacfg, subset=subset)

    class_ids = datacfg.class_ids if 'class_ids' in datacfg and datacfg['class_ids'] else []
    class_ids = annon.getCatIds(catIds=class_ids) ## cat_ids
    classinfo = annon.loadCats(class_ids) ## cats
    id_map = {v: i for i, v in enumerate(class_ids)}

    img_ids = sorted(list(annon.imgs.keys()))

    imgs = annon.loadImgs(img_ids)
    anns = [annon.imgToAnns[img_id] for img_id in img_ids]

    return class_ids, id_map, imgs, anns


def load_and_register_dataset(name, subset, _appcfg):
    class_ids, id_map, imgs, anns = get_data(subset, _appcfg)

    DatasetCatalog.register(name+"_"+subset, lambda subset=subset: get_dataset_dicts(_appcfg, class_ids, id_map, imgs, anns, BoxMode.XYWH_ABS))
    # DatasetCatalog.register("balloon_" + d, lambda d=d: get_balloon_dicts("/aimldl-dat/temp/balloon/" + d))
    # MetadataCatalog.get(name+"_"+subset).set(thing_classes=["balloon"])

    metadata = MetadataCatalog.get(name+"_"+subset)
    metadata.thing_classes = class_ids
    # metadata.thing_dataset_id_to_contiguous_id = id_map
    log.info("metadata: {}".format(metadata))

    return metadata


###--------------------------------------->


def visualize(args, mode, _appcfg):
    name = "hmd"
    subset = "train"
    dataset_name = get_dataset_name(name, subset)
    metadata = load_and_register_dataset(name, subset, _appcfg)
    dataset_dicts = DatasetCatalog.get(dataset_name)

    N = 30
    for d in random.sample(dataset_dicts, N):
            # print("d: {}".format(d))
            # print("annos: {}".format(d.get("annotations", None)))
            # print("annos: {}".format(d.get("annotations", None)[0]))
            image_filepath = d["file_name"]
            # image_filepath = "/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119/images/images-p2-050219_AT2/291018_114342_16718_zed_l_057.jpg"
            # image_filepath = "/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119/images/images-p2-050219_AT2/291018_114252_16716_zed_l_099.jpg"
            im = cv2.imread(image_filepath)
         
            # visualize_predictions(im, outputs, metadata)
            v = visualizer.Visualizer(im[:, :, ::-1],
                   metadata=metadata)

            v = v.draw_dataset_dict(d)
            cv2.imshow('', v.get_image()[:, :, ::-1])
            cv2.waitKey(0)


def train(args, mode, _appcfg):
    name = "hmd"
    for subset in ["train", "val"]:
        metadata = load_and_register_dataset(name, subset, _appcfg)

    cfg = config.get_cfg()
    cfg.merge_from_file("/aimldl-cod/external/detectron2/configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
    cfg.DATASETS.TRAIN = ("hmd_train","hmd_val")
    cfg.DATASETS.TEST = ()
    cfg.DATALOADER.NUM_WORKERS = 2
    # cfg.MODEL.WEIGHTS = "detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl"  # initialize from model zoo
    cfg.MODEL.WEIGHTS = "/codehub/apps/detectron2/release/model_final.pth"
    cfg.SOLVER.IMS_PER_BATCH = 2
    cfg.SOLVER.BASE_LR = 0.00025
    cfg.SOLVER.MAX_ITER = 350000    # 300 iterations seems good enough, but you can certainly train longer
    # cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset
    cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 512   # faster, and good enough for this toy dataset
    cfg.MODEL.ROI_HEADS.NUM_CLASSES = 3  # only has one class (ballon)

    os.makedirs(cfg.OUTPUT_DIR, exist_ok=True)
    trainer = DefaultTrainer(cfg) 
    trainer.resume_or_load(resume=False)
    trainer.train()


def predict(args, mode, _appcfg):
    name = "hmd"
    subset = "val"
    BASE_IMAGE_PATH = "/aimldl-dat/samples/Trafic_Signs"

    if args.path:
        BASE_IMAGE_PATH = args.path
    
    print("BASE_IMAGE_PATH: {}".format(BASE_IMAGE_PATH))

    dataset_name = get_dataset_name(name, subset)

    cfg = config.get_cfg()
    # cfg.merge_from_file("/aimldl-cod/external/detectron2/configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
    cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))

    cfg.DATALOADER.NUM_WORKERS = 2
    cfg.SOLVER.IMS_PER_BATCH = 2
    cfg.SOLVER.BASE_LR = 0.00025
    # cfg.SOLVER.MAX_ITER = 300    # 300 iterations seems good enough, but you can certainly train longer
    cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset
    cfg.MODEL.ROI_HEADS.NUM_CLASSES = 3
    

    cfg.OUTPUT_DIR = "/codehub/apps/detectron2/release"
    cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, "model_final.pth")

    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.7   # set the testing threshold for this model
    cfg.DATASETS.TEST = (dataset_name)
    # print("cfg: {}".format(cfg.dump()))
    
    #Predict from a directory
    metadata = MetadataCatalog.get(dataset_name).set(thing_classes=['signage', 'traffic_light', 'traffic_sign'])
    # print("Metadata: {}".format(metadata))


    predictor = DefaultPredictor(cfg)

    for image in os.listdir(BASE_IMAGE_PATH):

        image_filepath = os.path.join(BASE_IMAGE_PATH, image)

        # image_filepath = "/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119/images/images-p2-050219_AT2/291018_114342_16718_zed_l_057.jpg"
        # image_filepath = "/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119/images/images-p2-050219_AT2/291018_114252_16716_zed_l_099.jpg"
        # print("image_filepath: {}".format(image_filepath))
        
        im = cv2.imread(image_filepath)
        
        outputs = predictor(im)

        # visualize_predictions(im, outputs, metadata)
        v = visualizer.Visualizer(im[:, :, ::-1],
               metadata=metadata,
               instance_mode=ColorMode.SEGMENTATION)
        v = v.draw_instance_predictions(outputs["instances"].to("cpu"))
        cv2.imshow('', v.get_image()[:, :, ::-1])
        cv2.waitKey(0)

    ##Predict from dataset
    # metadata = load_and_register_dataset(name, subset, _appcfg)
    # dataset_dicts = DatasetCatalog.get(dataset_name)

    # output_pred_filepath = os.path.join(cfg.OUTPUT_DIR, 'pred.json')

    # N = 10
    # with open(output_pred_filepath,'a') as fw:
    #     # for i, d in enumerate(dataset_dicts):
    #     for d in random.sample(dataset_dicts, N):
    #         image_filepath = d["file_name"]
    #         # image_filepath = "/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119/images/images-p2-050219_AT2/291018_114342_16718_zed_l_057.jpg"
    #         # image_filepath = "/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119/images/images-p2-050219_AT2/291018_114252_16716_zed_l_099.jpg"
    #         im = cv2.imread(image_filepath)
         
    #         outputs = predictor(im)
    #         # outputs = predictor.model(im)

    #         one = { 'result' : outputs, 'filepath': image_filepath}
    #         fw.write(json.dumps(str(one)))
    #         fw.write('\n')

    #         print(one)
    #         # visualize_predictions(im, outputs, metadata)
    #         v = visualizer.Visualizer(im[:, :, ::-1],
    #                metadata=metadata,
    #                instance_mode=ColorMode.SEGMENTATION
    #         )
    #         v = v.draw_instance_predictions(outputs["instances"].to("cpu"))
    #         cv2.imshow('', v.get_image()[:, :, ::-1])
    #         cv2.waitKey(0)


def evaluate(args, mode, _appcfg):
    name = "hmd"
    
    #uncomment if using trainer.model
    # for subset in ["train", "val"]:
    #     metadata = load_and_register_dataset(name, subset, _appcfg)
    
    # subset = "test"
    subset = "val"
    metadata = load_and_register_dataset(name, subset, _appcfg)    
    
    dataset_name = get_dataset_name(name, subset)

    dataset_dicts = DatasetCatalog.get(dataset_name)


    cfg = config.get_cfg()
    cfg.merge_from_file("/aimldl-cod/external/detectron2/configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
    cfg.DATASETS.TRAIN = ("hmd_train","hmd_val")
    cfg.DATASETS.TEST = (dataset_name)


    cfg.OUTPUT_DIR = "/codehub/apps/detectron2/release"
    cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, "model_final.pth")

    cfg.DATALOADER.NUM_WORKERS = 2
    cfg.SOLVER.IMS_PER_BATCH = 2
    cfg.SOLVER.BASE_LR = 0.00025

    cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset
    cfg.MODEL.ROI_HEADS.NUM_CLASSES = 3
    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.7

    # mapper = DatasetMapper(cfg, False)
    _loader = build_detection_test_loader(cfg, dataset_name)
    evaluator = COCOEvaluator(dataset_name, cfg, False, output_dir=cfg.OUTPUT_DIR)

    # trainer = DefaultTrainer(cfg)
    # trainer.resume_or_load(resume=True)
    # model = trainer.model

    # predictor = DefaultPredictor(cfg)
    # model = predictor.model

    file_path = cfg.MODEL.WEIGHTS
    model = build_model(cfg)
    DetectionCheckpointer(model).load(file_path)

    inference_on_dataset(model, _loader, evaluator)


def tdd(args, mode, _appcfg):
    log.info("Test Driven Development: TDD")
    log.info("_appcfg: {}".format(_appcfg))


def main(args):
  """TODO: JSON RESPONSE
  All errors and json response needs to be JSON compliant and with proper HTTP Response code
  A common function should take responsibility to convert into API response
  """
  try:
    log.info("----------------------------->\nargs:{}".format(args))
    mode = args.mode
    cmd = args.command

    fn = getattr(this, cmd)

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


def parse_args(commands):
  import argparse
  from argparse import RawTextHelpFormatter
  
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='DNN Application Framework.\n * Refer: `paths.yml` environment and paths configurations.\n\n',formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--from',
                      dest='path',
                      metavar="/path/to/image(s)",
                      required=False,
                      help='image filepath for prediction')

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
    mode = "inference"
  elif cmd == "predict":
    mode = "inference"
  elif cmd == "train":
    mode = "training"
  elif cmd == "visualize":
    mode = "training"
  elif cmd == "inspect_annon":
    mode = "training"
  else:
    mode = "inference"

  args.mode = mode

  return args


if __name__ == '__main__':
    commands = ['train', 'predict', 'evaluate', 'visualize', 'inspect_annon', 'tdd']
    args = parse_args(commands)
    log.debug("args: {}".format(args))

    main(args)