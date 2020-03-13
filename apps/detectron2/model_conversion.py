import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms
import sys
import os
import numpy as np
import cv2
import json
import random
import itertools
import logging
import logging.config
from easydict import EasyDict as edict
from importlib import import_module

sys.path.insert(1, '/codehub/external/detectron2')

from detectron2.config import config
from detectron2.engine import DefaultTrainer
from detectron2 import model_zoo
from detectron2.structures import BoxMode
from detectron2.data import DatasetCatalog, MetadataCatalog
from detectron2.utils import visualizer
from detectron2.utils.visualizer import ColorMode
from detectron2.modeling import build_model
from detectron2.checkpoint import DetectionCheckpointer
from detectron2.engine import DefaultPredictor
from detectron2.data import build_detection_test_loader
from detectron2.export import export_caffe2_model
from detectron2.export import add_export_config
from detectron2.config import get_cfg
from detectron2.evaluation import COCOEvaluator, inference_on_dataset, print_csv_format

AI_CODE_BASE_PATH = '/codehub'
BASE_PATH_CONFIG = os.path.join(AI_CODE_BASE_PATH,'config')
APP_ROOT_DIR = os.path.join(AI_CODE_BASE_PATH,'apps')

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(0, APP_ROOT_DIR)

import _cfg_
from annon.dataset.Annon import ANNON
import apputil

# from _log_ import logcfg
# log = logging.getLogger(__name__)
# logging.config.dictConfig(logcfg)

appcfg = _cfg_.load_appcfg(BASE_PATH_CONFIG)
appcfg = edict(appcfg)

HOST = "10.4.71.69"
# AI_ANNON_DATA_HOME_LOCAL ="/aimldl-dat/data-gaze/AIML_Annotation/ods_job_230119"
# AI_ANNON_DATA_HOME_LOCAL ="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_281219_125647"
# AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_310120_114556"
AI_ANNON_DATA_HOME_LOCAL="/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_100220_181246"
appcfg['APP']['DBCFG']['PXLCFG']['host'] = HOST
appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'] = AI_ANNON_DATA_HOME_LOCAL

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
    # dbname = "PXL-310120_175129"
    dbname = "PXL-100220_192533"
    exp_id = "train-eee128cb-d7a1-493a-9819-95531f507092"
    # exp_id = "train-422d30b0-f518-4203-9c4d-b36bd8796c62"
    # exp_id = "train-d79fe253-60c8-43f7-a3f5-42a4abf97b6c"
    # exp_id = "train-887c2e82-1faa-4353-91d4-2f4cdc9285c1"
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
#     log.debug("archcfg: {}".format(archcfg))
    cmdcfg = archcfg

    dataset, num_classes, num_images, class_names, total_stats, total_verify = apputil.get_dataset_instance(_appcfg, dbcfg, datacfg, subset)

#     log.debug("class_names: {}".format(class_names))
#     log.debug("len(class_names): {}".format(len(class_names)))
#     log.debug("num_classes: {}".format(num_classes))
#     log.debug("num_images: {}".format(num_images))

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
#     log.info("metadata: {}".format(metadata))

    return metadata

name = "hmd"
for subset in ["train", "val"]:
    metadata = load_and_register_dataset(name, subset, appcfg)

cfg = config.get_cfg()
# cfg.merge_from_file("/codehub/external/detectron2/configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")

cfg.DATALOADER.NUM_WORKERS = 0
cfg = add_export_config(cfg)
cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))

cfg.DATASETS.TRAIN = ("hmd_train",)
cfg.DATASETS.TEST = ("hmd_val",)

# cfg.DATASETS.TRAIN = ("balloon_train",)
# cfg.DATASETS.TEST = ("balloon_val",)

cfg.MODEL.ROI_HEADS.NUM_CLASSES = 3

# cfg.MODEL.WEIGHTS = "/codehub/tmp/model_final_balloon.pth"
# cfg.MODEL.WEIGHTS = "/codehub/apps/detectron2/temp/model_final_balloon.pth"
cfg.MODEL.WEIGHTS = "/codehub/apps/detectron2/release/model_final.pth"
# cfg.MODEL.DEVICE = "cpu"


# cfg.SOLVER.IMS_PER_BATCH = 2
# cfg.SOLVER.BASE_LR = 0.00025
# cfg.SOLVER.MAX_ITER = 350000    # 300 iterations seems good enough, but you can certainly train longer
# cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset
# # cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 512   # faster, and good enough for this toy dataset
# cfg.MODEL.ROI_HEADS.NUM_CLASSES = 3

cfg.freeze()

out_path = "./output"

torch_model = build_model(cfg)
DetectionCheckpointer(torch_model).resume_or_load(cfg.MODEL.WEIGHTS)

# get a sample data
data_loader = build_detection_test_loader(cfg, cfg.DATASETS.TEST[0])
first_batch = next(iter(data_loader))

# convert and save caffe2 model
caffe2_model = export_caffe2_model(cfg, torch_model, first_batch)
caffe2_model.save_protobuf(out_path)
# draw the caffe2 graph
caffe2_model.save_graph(os.path.join(out_path, "model.svg"), inputs=first_batch)