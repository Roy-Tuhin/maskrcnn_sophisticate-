import sys
import random

from detectron2.data import datasets
from detectron2.data import DatasetCatalog, MetadataCatalog
import cv2
from detectron2.utils import visualizer

sys.path.insert(1, "/aimldl-cod/external/detectron2")

image_root = "/aimldl-dat/data-public/ms-coco-1/train2014"
json_file = "/aimldl-dat/data-public/ms-coco-1/annotations/instances_train2014.json"
dataset_name = "coco"
dataset_dicts_train = datasets.coco.load_coco_json(json_file, image_root, dataset_name)
DatasetCatalog.register(dataset_name, lambda dataset_dicts_train: dataset_dicts_train)

# MetadataCatalog.get("coco_train").set(thing_classes=["person", "bicycle", "car", "motorcycle", "airplane",
#                "bus", "train", "truck", "boat", "traffic light",
#                "fire hydrant", "stop sign", "parking meter", "bench", "bird",
#                "cat", "dog", "horse", "sheep", "cow", "elephant", "bear",
#                "zebra", "giraffe", "backpack", "umbrella", "handbag", "tie",
#                "suitcase", "frisbee", "skis", "snowboard", "sports ball",
#                "kite", "baseball bat", "baseball glove", "skateboard",
#                "surfboard", "tennis racket", "bottle", "wine glass", "cup",
#                "fork", "knife", "spoon", "bowl", "banana", "apple",
#                "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza",
#                "donut", "cake", "chair", "couch", "potted plant", "bed",
#                "dining table", "toilet", "tv", "laptop", "mouse", "remote",
#                "keyboard", "cell phone", "microwave", "oven", "toaster",
#                "sink", "refrigerator", "book", "clock", "vase", "scissors",
#                "teddy bear", "hair drier", "toothbrush"])


metadata = MetadataCatalog.get(dataset_name)
print("metadata: {}".format(metadata))
# MetadataCatalog.get(dataset_name).set(json_file=json_file, image_root=image_root, evaluator_type=dataset_name, **metadata)

metadata.thing_classes = ['person', 'bicycle', 'car', 'motorcycle', 'airplane']
metadata.thing_dataset_id_to_contiguous_id={1: 0, 2: 1, 3: 2, 4: 3, 5: 4}

# MetadataCatalog.get(dataset_name).set(thing_classes=thing_classes, metadata=thing_dataset_id_to_contiguous_id)

# MetadataCatalog.get(dataset_name).set(json_file=json_file, image_root=image_root, evaluator_type=dataset_name, metadata={})

N = 2
for d in random.sample(dataset_dicts_train, N):
    img = cv2.imread(d["file_name"])
    viz = visualizer.Visualizer(img[:, :, ::-1], metadata=metadata, scale=1)
    vis = viz.draw_dataset_dict(d)
    # vis.save("/aimldl-dat/temp/det02.jpg")
    # cv2.imwrite("/aimldl-dat/temp/det01.jpg", vis.get_image()[:, :, ::-1])
    cv2.imshow('', vis.get_image()[:, :, ::-1])
    # cv2.imshow('', img)
    cv2.waitKey(0)
