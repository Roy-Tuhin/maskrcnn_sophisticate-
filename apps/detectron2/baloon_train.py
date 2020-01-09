import os
import numpy as np
import cv2
import json
import sys
import random
sys.path.insert(1, '/codehub/external/detectron2')
from detectron2.engine import DefaultTrainer
from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg
from detectron2 import model_zoo

from detectron2.structures import BoxMode
from detectron2.data import DatasetCatalog, MetadataCatalog
from detectron2.utils import visualizer
from detectron2.utils.visualizer import ColorMode
import itertools

# write a function that loads the dataset into detectron2's standard format
def get_balloon_dicts(img_dir):
    json_file = os.path.join(img_dir, "via_region_data.json")
    with open(json_file) as f:
        imgs_anns = json.load(f)

    dataset_dicts = []
    for idx, v in enumerate(imgs_anns.values()):
        record = {}
        
        filename = os.path.join(img_dir, v["filename"])
        height, width = cv2.imread(filename).shape[:2]
        
        record["file_name"] = filename
        record["image_id"] = idx
        record["height"] = height
        record["width"] = width
      
        annos = v["regions"]
        objs = []
        for _, anno in annos.items():
            assert not anno["region_attributes"]
            anno = anno["shape_attributes"]
            px = anno["all_points_x"]
            py = anno["all_points_y"]
            poly = [(x + 0.5, y + 0.5) for x, y in zip(px, py)]
            poly = list(itertools.chain.from_iterable(poly))

            obj = {
                "bbox": [np.min(px), np.min(py), np.max(px), np.max(py)],
                "bbox_mode": BoxMode.XYXY_ABS,
                "segmentation": [poly],
                "category_id": 0,
                "iscrowd": 0
            }
            objs.append(obj)
        record["annotations"] = objs
        dataset_dicts.append(record)
    return dataset_dicts

def register_dataset():
    for d in ["train", "val"]:
        DatasetCatalog.register("balloon_" + d, lambda d=d: get_balloon_dicts("/aimldl-dat/data-public/balloon_dataset/balloon/" + d))
        MetadataCatalog.get("balloon_" + d).set(thing_classes=["balloon"])

def train():
    balloon_metadata = MetadataCatalog.get("balloon_train")

    cfg = get_cfg()
    cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))
    cfg.DATASETS.TRAIN = ("balloon_train",)
    cfg.DATASETS.TEST = ()
    cfg.DATALOADER.NUM_WORKERS = 2
    cfg.MODEL.WEIGHTS = "detectron2://COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x/137849600/model_final_f10217.pkl"  # initialize from model zoo
    cfg.SOLVER.IMS_PER_BATCH = 2
    cfg.SOLVER.BASE_LR = 0.00025
    cfg.SOLVER.MAX_ITER = 500    # 300 iterations seems good enough, but you can certainly train longer
    cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset
    cfg.MODEL.ROI_HEADS.NUM_CLASSES = 1  # only has one class (ballon)
    cfg.OUTPUT_DIR = './output_baloon'

    os.makedirs(cfg.OUTPUT_DIR, exist_ok=True)
    trainer = DefaultTrainer(cfg) 
    trainer.resume_or_load(resume=False)
    trainer.train()

def predict():
    balloon_metadata = MetadataCatalog.get("balloon_val")
    cfg = get_cfg()
    cfg.merge_from_file("/aimldl-cod/external/detectron2/configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
    cfg.OUTPUT_DIR = './output_baloon'
    cfg.MODEL.WEIGHTS = os.path.join(cfg.OUTPUT_DIR, "model_final.pth")
    cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.7   # set the testing threshold for this model
    cfg.DATASETS.TEST = ("balloon_val", )
    predictor = DefaultPredictor(cfg)

    # dataset_dicts = get_balloon_dicts("balloon/val")
    dataset_dicts = DatasetCatalog.get("balloon_val")
    for d in random.sample(dataset_dicts, 3):    
        im = cv2.imread(d["file_name"])
        outputs = predictor(im)
        v = visualizer.Visualizer(im[:, :, ::-1],
                       metadata=balloon_metadata, 
                       scale=0.8, 
                       instance_mode=ColorMode.IMAGE_BW   # remove the colors of unsegmented pixels
        )
        v = v.draw_instance_predictions(outputs["instances"].to("cpu"))
        cv2.imshow('', v.get_image()[:, :, ::-1])
        cv2.waitKey(0)

if __name__ == '__main__':
    register_dataset()
    train()
    predict()