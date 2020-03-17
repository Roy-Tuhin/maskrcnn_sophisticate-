__author__ = 'saqibmobin'
__version__ = '2.0'

import os
import cv2
import sys
import json
import random
import yaml
import logging
import logging.config
from easydict import EasyDict as edict
import argparse
from argparse import RawTextHelpFormatter

sys.path.insert(1, '/codehub/external/detectron2')

from detectron2.evaluation import COCOEvaluator, inference_on_dataset
from detectron2.data import build_detection_test_loader
from detectron2.modeling import build_model
from detectron2 import model_zoo
from detectron2.engine import DefaultPredictor
from detectron2.utils.visualizer import ColorMode
from detectron2.checkpoint import DetectionCheckpointer
from detectron2.structures import BoxMode
from detectron2.utils import visualizer
from detectron2.data import MetadataCatalog, DatasetCatalog
from detectron2.config import config
from detectron2.engine import DefaultTrainer

AI_CODE_BASE_PATH = '/codehub'
BASE_PATH_CONFIG = os.path.join(AI_CODE_BASE_PATH,'config')
APP_ROOT_DIR = os.path.join(AI_CODE_BASE_PATH,'apps')

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(2, APP_ROOT_DIR)

import _cfg_
from annon.dataset.Annon import ANNON
import apputil
from _log_ import logcfg

from importlib import import_module
import common


log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)

appcfg = _cfg_.load_appcfg(BASE_PATH_CONFIG)
appcfg = edict(appcfg)

##DONE pass through config
with open("config.yml", 'r') as stream:
    hmd_detectron_config = yaml.safe_load(stream)

appcfg['APP']['DBCFG']['PXLCFG']['host'] = hmd_detectron_config['ANNON']['HOST']
appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'] = hmd_detectron_config['ANNON']['AI_ANNON_DATA_HOME_LOCAL']

this = sys.modules[__name__]

def get_dataset_name(name, subset):
    return name + "_" + subset

def get_dataset_dicts(cfg, class_ids, id_map, imgs, anns, bbox_mode, config):
    # print(anns)

    ## => quick hack for running detectron2 with gaze data

    imgs_anns = list(zip(imgs, anns))
    dataset_dicts = []
    extra_annotation_keys=None

    ann_keys = ["iscrowd", "bbox", "keypoints", "category_id", "lbl_id"] + (extra_annotation_keys or [])
    num_instances_without_valid_segmentation = 0

    # log.debug("imgs_anns: {}".format(imgs_anns[:2]))

    for (img_dict, anno_dict_list) in imgs_anns:
        # log.debug("img_dict: {}".format(img_dict))
        # log.debug("anno_dict_list: {}".format(len(anno_dict_list)))

        if config.MODEL.MASK_ON==True:

            filtered_anns = []
            for key in anno_dict_list:
                if key["ant_type"]=="polygon":
                    filtered_anns.append(key)

            # log.debug("img_dict: {}".format(img_dict))
            # log.debug("anno_dict_list: {}".format(len(anno_dict_list)))
            # log.debug("filtered_anns: {}".format(len(filtered_anns)))
            # log.debug("filtered_anns: {}".format(filtered_anns))
            # log.debug("anno_dict_list: {}".format(anno_dict_list))

            if len(filtered_anns)!=0:
                image_path = apputil.get_abs_path(cfg, img_dict, 'AI_ANNON_DATA_HOME_LOCAL') ##image_root
                filepath = os.path.join(image_path, img_dict['filename'])
                record = {}
                record["file_name"] = filepath
                record["image_name"] = img_dict['filename']
                # record["file_path"] = filepath
                record["height"] = img_dict["height"]
                record["width"] = img_dict["width"]
                image_id = record["image_id"] = img_dict["img_id"] ## coco: id

                objs = []
                # for anno in anno_dict_list:
                for anno in filtered_anns:
                    assert anno["img_id"] == image_id ## image_id
                    obj = {key: anno[key] for key in ann_keys if key in anno}
                    _bbox = obj['bbox']

                    coco_frmt_bbox = [_bbox['xmin'], _bbox['ymin'], _bbox['width'], _bbox['height'] ]
                    
                    # log.debug("coco_frmt_bbox: {}".format(coco_frmt_bbox))
                    
                    obj['bbox'] = coco_frmt_bbox
                    anno = anno["shape_attributes"]
                    
                    # log.debug("anno: {}".format(anno))
                    
                    px = anno["all_points_x"]
                    py = anno["all_points_y"]
                    poly = [(x + 0.5, y + 0.5) for x, y in zip(px, py)]
                    poly = [p for x in poly for p in x]
                    segm = [poly]
                    segm = [poly for poly in segm if len(poly) % 2 == 0 and len(poly) >= 6]
                    obj["segmentation"] = segm
                    obj["bbox_mode"] = bbox_mode
                    obj["category_id"] = id_map[obj["lbl_id"]] ## category_id
                    objs.append(obj)

                record["annotations"] = objs
                dataset_dicts.append(record)

        elif config.MODEL.MASK_ON==False:

            image_path = apputil.get_abs_path(cfg, img_dict, 'AI_ANNON_DATA_HOME_LOCAL') ##image_root
            filepath = os.path.join(image_path, img_dict['filename'])
            record = {}
            record["file_name"] = filepath
            record["image_name"] = img_dict['filename']
            record["height"] = img_dict["height"]
            record["width"] = img_dict["width"]
            image_id = record["image_id"] = img_dict["img_id"] ## coco: id

            objs = []
            for anno in anno_dict_list:
                assert anno["img_id"] == image_id ## image_id
                obj = {key: anno[key] for key in ann_keys if key in anno}
                _bbox = obj['bbox']
                coco_frmt_bbox = [_bbox['xmin'], _bbox['ymin'], _bbox['width'], _bbox['height'] ]

                # log.debug("coco_frmt_bbox: {}".format(coco_frmt_bbox))
                
                obj['bbox'] = coco_frmt_bbox
                segm = None
                obj["bbox_mode"] = bbox_mode
                obj["category_id"] = id_map[obj["lbl_id"]] ## category_id
                # obj["segmentation"] = segm
                objs.append(obj)

            record["annotations"] = objs
            dataset_dicts.append(record)

    return dataset_dicts

def get_data(subset, _appcfg):
    ## DONE: to be passed through cfg
    CMD = hmd_detectron_config['AIDS']['CMD']
    DBNAME = hmd_detectron_config['AIDS']['DBNAME']
    EXP_ID = hmd_detectron_config['AIDS']['EXP_ID']
    EVAL_ON = subset
    # log.debug(_appcfg)
    # log.info(_appcfg['APP']['DBCFG']['PXLCFG'])
    # log.info(_appcfg['PATHS']['AI_ANNON_DATA_HOME_LOCAL'])

    ## datacfg and dbcfg
    _cfg_.load_datacfg(CMD, _appcfg, DBNAME, EXP_ID, EVAL_ON)
    datacfg = apputil.get_datacfg(_appcfg)
    dbcfg = apputil.get_dbcfg(_appcfg)
    # log.info("datacfg: {}".format(datacfg))
    # log.info("dbcfg: {}".format(dbcfg))

    ## archcfg, cmdcfg
    _cfg_.load_archcfg(CMD, _appcfg, DBNAME, EXP_ID, EVAL_ON)
    archcfg = apputil.get_archcfg(_appcfg)
    # log.debug("archcfg: {}".format(archcfg))
    cmdcfg = archcfg

    dataset, num_classes, num_images, class_names, total_stats, total_verify = apputil.get_dataset_instance(_appcfg, dbcfg, datacfg, subset)

    # log.debug("class_names: {}".format(class_names))
    # log.debug("len(class_names): {}".format(len(class_names)))
    # log.debug("num_classes: {}".format(num_classes))
    # log.debug("num_images: {}".format(num_images))

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

    conf = Config(args, config)
    cfg = conf.merge(conf.arch, conf.cfg)

    dataset_name = get_dataset_name(name, subset)
    DatasetCatalog.register(dataset_name, lambda subset=subset: get_dataset_dicts(_appcfg, class_ids, id_map, imgs, anns, BoxMode.XYWH_ABS, cfg))

    metadata = MetadataCatalog.get(dataset_name)
    metadata.thing_classes = class_ids
    metadata.thing_dataset_id_to_contiguous_id = id_map

    log.info("metadata: {}".format(metadata))

    return metadata

def pred_viz(im, outputs, metadata, output_path):
    v = visualizer.Visualizer(im[:, :, ::-1],
                   metadata=metadata,
                   instance_mode=ColorMode.SEGMENTATION
                )
    v = v.draw_instance_predictions(outputs["instances"].to("cpu"))

    if args.save_viz:
        cv2.imwrite(output_path, v.get_image()[:, :, ::-1])   

    cv2.imshow('', v.get_image()[:, :, ::-1])
    cv2.waitKey(0)

def convert_output_to_json(outputs, image_filename, metadata):
    reverse_id_mapping = {
                    v: k for k, v in metadata.thing_dataset_id_to_contiguous_id.items()
                    }

    uid = common.createUUID('pred')

    boxes = outputs['instances'].pred_boxes.tensor.cpu().numpy()
    boxes = BoxMode.convert(boxes, BoxMode.XYXY_ABS, BoxMode.XYWH_ABS)
    boxes = boxes.tolist()
    scores = outputs['instances'].scores.tolist()
    category_id = outputs['instances'].pred_classes.tolist()

    classes = []                   
    for cat in category_id:
        cat_name = reverse_id_mapping[cat]
        classes.append(cat_name)

    num_instances = len(scores)

    print(outputs)

    if num_instances == 0:
        return []

    for k in range(num_instances):
        if k == 0:
            jsonres = {
            image_filename: {
                "filename": image_filename,
                "size": 0,
                "regions": [
                      {
                        "region_attributes": {
                          "label": classes[k],
                          "score": scores[k],
                        },
                        "shape_attributes": {
                          "name": "rect",
                          "y": boxes[k][0],
                          "x": boxes[k][1],
                          "height": boxes[k][2],
                          "width": boxes[k][3]
                        }
                      },
                    ],
                "file_attributes": {
                    "width": 1920,
                    "height": 1280,
                    "uuid": uid
                  }
                }
            }
        else:
            jsonres[image_filename]["regions"].append({
                        "region_attributes": {
                          "label": classes[k],
                          "score": scores[k],
                        },
                        "shape_attributes": {
                          "name": "rect",
                          "y": boxes[k][0],
                          "x": boxes[k][1],
                          "height": boxes[k][2],
                          "width": boxes[k][3]
                        }
                      })

    return jsonres

class Config():
    def __init__(self, args, config):
        self.arch = args.arch
        self.cfg = config.get_cfg()

    def merge(self, arch, cfg):
        cfg.merge_from_file(arch)
        return cfg

###--------------------------------------->

def visualize(args, mode, _appcfg):
    name = "hmd"
    subset = "train"

    if args.subset:
        subset = args.subset

    dataset_name = get_dataset_name(name, subset)
    metadata = load_and_register_dataset(name, subset, _appcfg)
    dataset_dicts = DatasetCatalog.get(dataset_name)

    N = 20
    for d in random.sample(dataset_dicts, N):
            # log.debug("d: {}".format(d))
            # log.debug("annos: {}".format(d.get("annotations", None)))
            # log.debug("annos: {}".format(d.get("annotations", None)[0]))
            image_filepath = d["file_name"]
            im = cv2.imread(image_filepath)

            v = visualizer.Visualizer(im[:, :, ::-1],
                   metadata=metadata)

            v = v.draw_dataset_dict(d)
            cv2.imshow('', v.get_image()[:, :, ::-1])
            cv2.waitKey(0)

def train(args, mode, _appcfg):
    name = "hmd"
    for subset in ["train", "val"]:
        metadata = load_and_register_dataset(name, subset, _appcfg)

    conf = Config(args, config)
    cfg = conf.merge(conf.arch, conf.cfg)

    cfg.DATASETS.TRAIN = ("hmd_train","hmd_val")
    cfg.DATASETS.TEST = ()

    os.makedirs(cfg.OUTPUT_DIR, exist_ok=True)
    trainer = DefaultTrainer(cfg) 
    trainer.resume_or_load(resume=False)
    trainer.train()

def predict(args, mode, _appcfg):
    name = "hmd"
    subset = "val"

    if args.subset:
        subset = args.subset

    dataset_name = get_dataset_name(name, subset)

    PREDICTION_OUTPUT_PATH = "/aimldl-dat/samples/Predictions"

    conf = Config(args, config)
    cfg = conf.merge(conf.arch, conf.cfg)

    cfg.DATASETS.TEST = (dataset_name)
    cfg.OUTPUT_DIR = "/codehub/apps/detectron2/release"
    cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, "model_final.pth")

    output_pred_filepath = os.path.join(cfg.OUTPUT_DIR, 'pred.json')

    predictor = DefaultPredictor(cfg)

    if args.path:
        BASE_IMAGE_PATH = args.path
        
        print("BASE_IMAGE_PATH: {}".format(BASE_IMAGE_PATH))

        # log.debug("cfg: {}".format(cfg.dump()))
        
        #Predict from a directory
        dataset_name = "inference"
        class_ids = ['signage', 'traffic_light', 'traffic_sign']
        id_map = {v: i for i, v in enumerate(class_ids)}
        metadata = MetadataCatalog.get(dataset_name).set(thing_classes=class_ids)
        metadata.thing_dataset_id_to_contiguous_id = id_map

        log.debug("Metadata: {}".format(metadata))

        json_arr = []
        for image_filename in os.listdir(BASE_IMAGE_PATH):

            image_filepath = os.path.join(BASE_IMAGE_PATH, image_filename)
            output_path = PREDICTION_OUTPUT_PATH + "/" + image_filename

            im = cv2.imread(image_filepath)
            outputs = predictor(im)

            jsonres = convert_output_to_json(outputs, image_filename, metadata)
            json_arr.append(jsonres)

            pred_viz(im, outputs, metadata, output_path)

        if args.save_json:
            with open(output_pred_filepath,'a') as fw:
                fw.write(json.dumps(json_arr))

    else:
        #Predict from dataset
        metadata = load_and_register_dataset(name, subset, _appcfg)
        dataset_dicts = DatasetCatalog.get(dataset_name)

        N = 20
        
        json_arr = []
        for d in random.sample(dataset_dicts, N):
            image_filepath = d["file_name"]
            image_filename = d["image_name"]
            output_path = PREDICTION_OUTPUT_PATH + "/" + image_filename

            im = cv2.imread(image_filepath)
         
            outputs = predictor(im)

            jsonres = convert_output_to_json(outputs, image_filename, metadata)
            json_arr.append(jsonres)

            pred_viz(im, outputs, metadata, output_path)

        if args.save_json:
            with open(output_pred_filepath,'a') as fw:
                fw.write(json.dumps(json_arr))

def evaluate(args, mode, _appcfg):
    name = "hmd"
    subset = "val"

    if args.subset:
        subset = args.subset
    
    metadata = load_and_register_dataset(name, subset, _appcfg)    
    dataset_name = get_dataset_name(name, subset)
    dataset_dicts = DatasetCatalog.get(dataset_name)

    conf = Config(args, config)
    cfg = conf.merge(conf.arch, conf.cfg)
    cfg.DATASETS.TEST = (dataset_name)


    cfg.OUTPUT_DIR = "/codehub/apps/detectron2/release"
    cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, "model_final.pth")

    _loader = build_detection_test_loader(cfg, dataset_name)
    evaluator = COCOEvaluator(dataset_name, cfg, False, output_dir=cfg.OUTPUT_DIR)

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

    # log.debug("fn: {}".format(fn))
    # log.debug("cmd: {}".format(cmd))
    # log.debug("---x---x---x---")
    if fn:
      ## Within the specific command, route to python module for specific architecture
      fn(args, mode, appcfg)
    else:
      log.error("Unknown fn:{}".format(cmd))
  except Exception as e:
    log.error("Exception occurred", exc_info=True)

  return


def parse_args(commands):
  
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

  parser.add_argument('--arch',
                        dest='arch',
                        metavar="/path/to/archfile",
                        required=True,
                        help='arch config file')

  parser.add_argument('--subset',
                        dest='subset',
                        metavar="datatset split subset",
                        required=False,
                        help='subset of dataset split')

  parser.add_argument('--save_viz',
                        dest='save_viz',
                        help='Save the visualization for `predict`',
                        action='store_true')

  parser.add_argument('--save_json',
                        dest='save_json',
                        help='Save the json response for `predict`',
                        action='store_true')


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