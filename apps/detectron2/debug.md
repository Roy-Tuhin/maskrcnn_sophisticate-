
>>> np.__version__
'1.18.0'


2019-12-31 11:25:37,340:[INFO]:[__main__]:[hmd_detectron2.py:202 - load_and_register_dataset() ]: metadata: Metadata(name='hmd_train', thing_classes=['signage', 'traffic_light', 'traffic_sign'], thing_dataset_id_to_contiguous_id={'signage': 0, 'traffic_light': 1, 'traffic_sign': 2})
2019-12-31 11:25:37,355:[WARNING]:[detectron2.config.compat]:[compat.py:110 -        guess_version() ]: Config '/aimldl-cod/external/detectron2/configs/COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml' has no VERSION. Assuming it to be compatible with latest v2.
2019-12-31 11:25:37,609:[INFO]:[detectron2.data.build]:[logger.py:157 -          log_first_n() ]: Distribution of instances among all 3 categories:
|  category  | #instances   |   category    | #instances   |   category   | #instances   |
|:----------:|:-------------|:-------------:|:-------------|:------------:|:-------------|
|  signage   | 1627         | traffic_light | 1643         | traffic_sign | 3323         |
|            |              |               |              |              |              |
|   total    | 6593         |               |              |              |              |
2019-12-31 11:25:37,609:[WARNING]:[detectron2.evaluation.coco_evaluation]:[coco_evaluation.py:58 -             __init__() ]: json_file was not found in MetaDataCatalog for 'hmd_train'
2019-12-31 11:25:37,610:[INFO]:[detectron2.data.datasets.coco]:[coco.py:411 - convert_to_coco_json() ]: Converting dataset annotations in 'hmd_train' to COCO format ...)
2019-12-31 11:25:37,663:[INFO]:[detectron2.data.datasets.coco]:[coco.py:302 - convert_to_coco_dict() ]: Converting dataset dicts into COCO format
2019-12-31 11:25:38,173:[INFO]:[detectron2.data.datasets.coco]:[coco.py:372 - convert_to_coco_dict() ]: Conversion finished, num images: 2950, num annotations: 6593
2019-12-31 11:25:38,175:[INFO]:[detectron2.data.datasets.coco]:[coco.py:415 - convert_to_coco_json() ]: Caching annotations in COCO format: /codehub/apps/detectron2/release/hmd_train_coco_format.json
2019-12-31 11:25:42,145:[INFO]:[fvcore.common.checkpoint]:[checkpoint.py:97 -                 load() ]: Loading checkpoint from /codehub/apps/detectron2/release/model_final.pth
2019-12-31 11:25:42,330:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:105 - inference_on_dataset() ]: Start inference on 2950 images
2019-12-31 11:25:50,656:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 50/2950. 0.1612 s / img. ETA=0:07:47
2019-12-31 11:25:58,729:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 100/2950. 0.1613 s / img. ETA=0:07:39
2019-12-31 11:26:07,006:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 150/2950. 0.1628 s / img. ETA=0:07:35
2019-12-31 11:26:15,662:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 200/2950. 0.1654 s / img. ETA=0:07:34
2019-12-31 11:26:23,919:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 250/2950. 0.1654 s / img. ETA=0:07:26
2019-12-31 11:26:32,320:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 300/2950. 0.1658 s / img. ETA=0:07:19
2019-12-31 11:26:40,392:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 350/2950. 0.1652 s / img. ETA=0:07:09
2019-12-31 11:26:48,917:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 400/2950. 0.1659 s / img. ETA=0:07:02
2019-12-31 11:26:57,940:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 450/2950. 0.1675 s / img. ETA=0:06:58
2019-12-31 11:27:05,420:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 500/2950. 0.1657 s / img. ETA=0:06:45
2019-12-31 11:27:13,251:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 550/2950. 0.1649 s / img. ETA=0:06:35
2019-12-31 11:27:21,899:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 600/2950. 0.1655 s / img. ETA=0:06:29
2019-12-31 11:27:30,562:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 650/2950. 0.1661 s / img. ETA=0:06:22
2019-12-31 11:27:38,690:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 700/2950. 0.1659 s / img. ETA=0:06:13
2019-12-31 11:27:47,712:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 750/2950. 0.1669 s / img. ETA=0:06:07
2019-12-31 11:27:56,357:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 800/2950. 0.1672 s / img. ETA=0:05:59
2019-12-31 11:28:04,816:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 850/2950. 0.1674 s / img. ETA=0:05:51
2019-12-31 11:28:13,115:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 900/2950. 0.1673 s / img. ETA=0:05:42
2019-12-31 11:28:21,590:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 950/2950. 0.1674 s / img. ETA=0:05:34
2019-12-31 11:28:30,278:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1000/2950. 0.1677 s / img. ETA=0:05:27
2019-12-31 11:28:38,758:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1050/2950. 0.1678 s / img. ETA=0:05:18
2019-12-31 11:28:47,425:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1100/2950. 0.1681 s / img. ETA=0:05:10
2019-12-31 11:28:55,861:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1150/2950. 0.1681 s / img. ETA=0:05:02
2019-12-31 11:29:04,568:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1200/2950. 0.1683 s / img. ETA=0:04:54
2019-12-31 11:29:12,751:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1250/2950. 0.1682 s / img. ETA=0:04:45
2019-12-31 11:29:21,362:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1300/2950. 0.1683 s / img. ETA=0:04:37
2019-12-31 11:29:30,206:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1350/2950. 0.1686 s / img. ETA=0:04:29
2019-12-31 11:29:39,026:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1400/2950. 0.1689 s / img. ETA=0:04:21
2019-12-31 11:29:47,468:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1450/2950. 0.1689 s / img. ETA=0:04:13
2019-12-31 11:29:56,097:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1500/2950. 0.1690 s / img. ETA=0:04:05
2019-12-31 11:30:04,856:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1550/2950. 0.1692 s / img. ETA=0:03:56
2019-12-31 11:30:13,492:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1600/2950. 0.1693 s / img. ETA=0:03:48
2019-12-31 11:30:22,009:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1650/2950. 0.1694 s / img. ETA=0:03:40
2019-12-31 11:30:30,233:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1700/2950. 0.1692 s / img. ETA=0:03:31
2019-12-31 11:30:38,505:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1750/2950. 0.1691 s / img. ETA=0:03:22
2019-12-31 11:30:47,196:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1800/2950. 0.1692 s / img. ETA=0:03:14
2019-12-31 11:30:55,844:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1850/2950. 0.1693 s / img. ETA=0:03:06
2019-12-31 11:31:04,449:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1900/2950. 0.1694 s / img. ETA=0:02:57
2019-12-31 11:31:13,211:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 1950/2950. 0.1696 s / img. ETA=0:02:49
2019-12-31 11:31:22,048:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2000/2950. 0.1697 s / img. ETA=0:02:41
2019-12-31 11:31:30,711:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2050/2950. 0.1698 s / img. ETA=0:02:32
2019-12-31 11:31:39,219:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2100/2950. 0.1698 s / img. ETA=0:02:24
2019-12-31 11:31:47,913:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2150/2950. 0.1699 s / img. ETA=0:02:15
2019-12-31 11:31:56,626:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2200/2950. 0.1700 s / img. ETA=0:02:07
2019-12-31 11:32:05,218:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2250/2950. 0.1701 s / img. ETA=0:01:59
2019-12-31 11:32:13,782:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2300/2950. 0.1701 s / img. ETA=0:01:50
2019-12-31 11:32:22,691:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2350/2950. 0.1703 s / img. ETA=0:01:42
2019-12-31 11:32:31,258:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2400/2950. 0.1703 s / img. ETA=0:01:33
2019-12-31 11:32:39,827:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2450/2950. 0.1703 s / img. ETA=0:01:25
2019-12-31 11:32:48,334:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2500/2950. 0.1703 s / img. ETA=0:01:16
2019-12-31 11:32:57,083:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2550/2950. 0.1704 s / img. ETA=0:01:08
2019-12-31 11:33:05,874:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2600/2950. 0.1705 s / img. ETA=0:00:59
2019-12-31 11:33:14,294:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2650/2950. 0.1705 s / img. ETA=0:00:51
2019-12-31 11:33:22,787:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2700/2950. 0.1705 s / img. ETA=0:00:42
2019-12-31 11:33:31,399:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2750/2950. 0.1705 s / img. ETA=0:00:34
2019-12-31 11:33:40,041:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2800/2950. 0.1705 s / img. ETA=0:00:25
2019-12-31 11:33:48,728:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2850/2950. 0.1706 s / img. ETA=0:00:17
2019-12-31 11:33:57,503:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2900/2950. 0.1707 s / img. ETA=0:00:08
2019-12-31 11:34:06,032:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:135 - inference_on_dataset() ]: Inference done 2950/2950. 0.1707 s / img. ETA=0:00:00
2019-12-31 11:34:06,084:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:145 - inference_on_dataset() ]: Total inference time: 0:08:22 (0.170458 s / img per device, on 1 devices)
2019-12-31 11:34:06,084:[INFO]:[detectron2.evaluation.evaluator]:[evaluator.py:151 - inference_on_dataset() ]: Total inference pure compute time: 0:07:29 (0.152795 s / img per device, on 1 devices)
2019-12-31 11:34:06,191:[INFO]:[detectron2.evaluation.coco_evaluation]:[coco_evaluation.py:141 -    _eval_predictions() ]: Preparing results for COCO format ...
2019-12-31 11:34:06,195:[INFO]:[detectron2.evaluation.coco_evaluation]:[coco_evaluation.py:160 -    _eval_predictions() ]: Saving results to /codehub/apps/detectron2/release/coco_instances_results.json
2019-12-31 11:34:06,254:[INFO]:[detectron2.evaluation.coco_evaluation]:[coco_evaluation.py:169 -    _eval_predictions() ]: Evaluating predictions ...
Loading and preparing results...
DONE (t=0.02s)
creating index...
index created!
2019-12-31 11:34:06,279:[ERROR]:[__main__]:[hmd_detectron2.py:354 -                 main() ]: Exception occurred
Traceback (most recent call last):
  File "/usr/local/lib/python3.6/dist-packages/numpy/core/function_base.py", line 117, in linspace
    num = operator.index(num)
TypeError: 'numpy.float64' object cannot be interpreted as an integer

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "hmd_detectron2.py", line 350, in main
    fn(args, mode, appcfg)
  File "hmd_detectron2.py", line 325, in evaluate
    inference_on_dataset(model, _loader, evaluator)
  File "/codehub/external/detectron2/detectron2/evaluation/evaluator.py", line 155, in inference_on_dataset
    results = evaluator.evaluate()
  File "/codehub/external/detectron2/detectron2/evaluation/coco_evaluation.py", line 132, in evaluate
    self._eval_predictions(set(self._tasks))
  File "/codehub/external/detectron2/detectron2/evaluation/coco_evaluation.py", line 175, in _eval_predictions
    if len(self._coco_results) > 0
  File "/codehub/external/detectron2/detectron2/evaluation/coco_evaluation.py", line 478, in _evaluate_predictions_on_coco
    coco_eval = COCOeval(coco_gt, coco_dt, iou_type)
  File "/usr/local/lib/python3.6/dist-packages/pycocotools/cocoeval.py", line 75, in __init__
    self.params = Params(iouType=iouType) # parameters
  File "/usr/local/lib/python3.6/dist-packages/pycocotools/cocoeval.py", line 527, in __init__
    self.setDetParams()
  File "/usr/local/lib/python3.6/dist-packages/pycocotools/cocoeval.py", line 506, in setDetParams
    self.iouThrs = np.linspace(.5, 0.95, np.round((0.95 - .5) / .05) + 1, endpoint=True)
  File "<__array_function__ internals>", line 6, in linspace
  File "/usr/local/lib/python3.6/dist-packages/numpy/core/function_base.py", line 121, in linspace
    .format(type(num)))
TypeError: object of type <class 'numpy.float64'> cannot be safely interpreted as an integer.
