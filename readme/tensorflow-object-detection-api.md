# Tensorflow Object Detection API


* Clone Tensorflow models
    ```bash
    mkdir -p /codehub/external/tensorflow
    cd /codehub/external/tensorflow
    git clone https://github.com/tensorflow/models.git
    ```
* Data Preparation - create dataset in the TFRecord format

## Utility Scripts: [`/codehub/scripts/tf`](../scripts/tf)

```bash
├── aids_to_tf_record.sh
├── create_coco_tf_record.sh
├── pb_to_tflite_keras_retinanet.sh
├── pb_to_tflite_mask_rcnn.sh
├── pb_to_tflite.sh
├── tf_ckpt_to_pb_ssdmobilenet.sh
├── tf-get-modelzoo.sh
├── tfl_pred.sh
├── tf_pb_to_tflite.sh
├── tf_quantize_mobilenet_v2_on_imagenet.sh
└── tf_train.sh
```


## AIDS to TFRecord

* Utility script: [`/codehub/scripts/tf/aids_to_tf_record.sh`](../scripts/tf/aids_to_tf_record.sh)
  * AIDS to TFRecord
  * COCO from AIDS to TFRecord
* **NOTE:**
  * COCO from AIDS is enhanced coco to be compatible with TEPPr workflow. It's 100% compatible with the original coco format
  * ANNON and AIDS database is now compatible with 2014 coco format; though does not have the compatibility of RLE and panoptic dataset as it's not required as this moment


## Convert Original COCO to TFRecord

* Utility script: [`/codehub/scripts/tf/create_coco_tf_record.sh`](../scripts/tf/create_coco_tf_record.sh)
    ```bash
    python object_detection/dataset_tools/create_coco_tf_record.py --logtostderr \
    --train_image_dir="/aimldl-dat/data-public/ms-coco-1/train2014" \
    --val_image_dir="/aimldl-dat/data-public/ms-coco-1/val2014" \
    --test_image_dir="/aimldl-dat/data-public/ms-coco-1/test2014" \
    --train_annotations_file="/aimldl-dat/data-public/ms-coco-1/annotations/instances_train2014.json" \
    --val_annotations_file="/aimldl-dat/data-public/ms-coco-1/annotations/instances_val2014.json" \
    --testdev_annotations_file="/aimldl-dat/data-public/ms-coco-1/annotations/image_info_test2014.json" \
    --output_dir="/aimldl-dat/data-public/ms-coco-1/tfrecord"
    ```


## TFRecord Viewer

* Sample the TFRecord dataset & Visualize them once created using TFViewer
    ```bash
    cd /codehub/external
    git clone https://github.com/sulc/tfrecord-viewer.git
    #
    cd /codehub/external/tfrecord-viewer
    python tfviewer.py /aimldl-dat/data-public/ms-coco-1/tfrecord/coco_testdev.record-00001-of-00100
    python tfviewer.py /aimldl-dat/data-public/ms-coco-1/tfrecord/*
    ```


## Training

* Utility script: [`/codehub/scripts/tf/tf_train.sh`](../scripts/tf/tf_train.sh)
* Sample object detection configurations are under directory:
  * `/codehub/external/tensorflow/models/research/object_detection/samples/configs`
* Custom configs - Tensorflow Object Detection API
  * `/codehub/cfg/tf_ods_config`
    * [ssd_mobilenet_v2_annon-280220_172500.config](../cfg/tf_ods_config/ssd_mobilenet_v2_annon-280220_172500.config)
    * [ssd_mobilenet_v2_coco.config](../cfg/tf_ods_config/ssd_mobilenet_v2_coco.config)


## TensorFlow Lite Converter - TOCO

* https://github.com/tensorflow/tensorflow/tree/master/tensorflow/lite/toco
* Ref: [tensorflow toco](tensorflow-toco.md)



## References

* https://towardsdatascience.com/custom-object-detection-using-tensorflow-from-scratch-e61da2e10087
* https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
* https://github.com/tensorflow/models/issues/6100
* https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md
* https://github.com/tensorflow/models/tree/master/research/object_detection/g3doc


## Errors, Troubleshooting & Tips

* Sample the TFRecord dataset & Visualize them once created using TFViewer
* Clean up the logs before resuming the training or change the checkpoint in the config file
* **Failed to run optimizer ArithmeticOptimizer**
  * https://github.com/tensorflow/tensorflow/issues/26769#issuecomment-592905876
      ```bash
      2020-02-29 11:35:57.903698: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
      2020-02-29 11:35:57.903732: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
      2020-02-29 11:35:57.903742: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
      2020-02-29 11:35:57.903750: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
      ```
