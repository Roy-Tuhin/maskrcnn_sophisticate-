
## TF object_detection API

* https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md
  * [Installation](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md)
  * [TFRecord creation](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/preparing_inputs.md)
  * [Configure training pipeline](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/configuring_jobs.md)
* https://github.com/tensorflow/models/tree/master/research/object_detection/g3doc
* https://github.com/tensorflow/models/tree/master/research/object_detection/dataset_tools
* https://www.tensorflow.org/datasets/catalog/coco


* **dataset_tools**
  * /codehub/external/tensorflow/models/research/object_detection/dataset_tools

```bash
cd /codehub/external/tensorflow/models/research/object_detection/dataset_tools
export PYTHONPATH=/codehub/external/tensorflow/models/research
python -m create_coco_tf_record.py

export PYTHONPATH=$PYTHONPATH:/codehub/external/tensorflow/models/research/slim
cd /codehub/scripts/data-public
source tf_ods_train.sh
```


```bash
tensorflow.python.framework.errors_impl.NotFoundError: Unsuccessful TensorSliceReader constructor: Failed to find any matching files for /aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco/model.ckpt
```

https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md


wget -c http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_coco_2018_03_29.tar.gz
/aimldl-dat/data-mobile/ssd_mobilenet_v2_coco_2018_03_29

## Fixes for tf >= 2

* tf.app, tf.gfile, tf.flags
```bash
  File "/codehub/external/tensorflow/models/research/object_detection/dataset_tools/create_coco_tf_record.py", line 50, in <module>
    flags = tf.app.flags
AttributeError: module 'tensorflow' has no attribute 'app'

  File "/codehub/external/tensorflow/models/research/object_detection/dataset_tools/create_coco_tf_record.py", line 52, in <module>
    tf.flags.DEFINE_boolean('include_masks', False,
AttributeError: module 'tensorflow' has no attribute 'flags'

  File "/codehub/external/tensorflow/models/research/object_detection/dataset_tools/create_coco_tf_record.py", line 71, in <module>
    tf.logging.set_verbosity(tf.logging.INFO)
AttributeError: module 'tensorflow' has no attribute 'logging'

/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-24/bin/python: Error while finding module specification for 'create_coco_tf_record.py' (AttributeError: module 'create_coco_tf_record' has no attribute '__path__')

```

https://stackoverflow.com/questions/58628439/upgrading-tf-contrib-slim-manually-to-tf-2-0


WARNING: The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
If you depend on functionality not listed there, please file an issue.

Traceback (most recent call last):
  File "object_detection/model_main.py", line 26, in <module>
    from object_detection import model_lib
  File "/codehub/external/tensorflow/models/research/object_detection/model_lib.py", line 28, in <module>
    from object_detection import exporter as exporter_lib
  File "/codehub/external/tensorflow/models/research/object_detection/exporter.py", line 24, in <module>
    from object_detection.builders import model_builder
  File "/codehub/external/tensorflow/models/research/object_detection/builders/model_builder.py", line 35, in <module>
    from object_detection.models import faster_rcnn_inception_resnet_v2_feature_extractor as frcnn_inc_res
  File "/codehub/external/tensorflow/models/research/object_detection/models/faster_rcnn_inception_resnet_v2_feature_extractor.py", line 30, in <module>
    from nets import inception_resnet_v2
ModuleNotFoundError: No module named 'nets'




### pascal VOC

app = tf.app
app = tf.compat.v1.app
flags = app.flags

```bash
  File "object_detection/dataset_tools/create_pascal_tf_record.py", line 41, in <module>
    flags = tf.app.flags
AttributeError: module 'tensorflow' has no attribute 'app'

/codehub/external/tensorflow/models/research/object_detection/model_main.py
```

python_io = tf.python_io
python_io = tf.compat.v1.python_io
```bash
  File "object_detection/dataset_tools/create_pascal_tf_record.py", line 162, in main
    writer = tf.python_io.TFRecordWriter(FLAGS.output_path)
AttributeError: module 'tensorflow' has no attribute 'python_io'
```

gfile = tf.gfile
gfile = tf.compat.v1.gfile
```bash
  File "/codehub/external/tensorflow/models/research/object_detection/utils/dataset_util.py", line 62, in read_examples_list
    with tf.gfile.GFile(path) as fid:
AttributeError: module 'tensorflow' has no attribute 'gfile'

  File "/codehub/external/tensorflow/models/research/object_detection/utils/label_map_util.py", line 138, in load_labelmap
    with tf.gfile.GFile(path, 'r') as fid:
AttributeError: module 'tensorflow' has no attribute 'gfile'

  File "object_detection/dataset_tools/create_pascal_tf_record.py", line 179, in main
    with tf.gfile.GFile(path, 'r') as fid:

  File "object_detection/dataset_tools/create_pascal_tf_record.py", line 91, in dict_to_tf_example
    with tf.gfile.GFile(full_path, 'rb') as fid:
```



### Oxford-IIIT pet

Traceback (most recent call last):
  File "object_detection/dataset_tools/create_pet_tf_record.py", line 46, in <module>
    flags = tf.app.flags
AttributeError: module 'tensorflow' has no attribute 'app'

  File "object_detection/dataset_tools/create_pet_tf_record.py", line 325, in <module>
    tf.app.run()

  File "/codehub/external/tensorflow/models/research/object_detection/dataset_tools/tf_record_creation_util.py", line 43, in <listcomp>
    for file_name in tf_record_output_filenames
AttributeError: module 'tensorflow' has no attribute 'python_io'


## Misc Local Installation Issues

```bash
2020-01-25 14:10:11.732160: W tensorflow/stream_executor/platform/default/dso_loader.cc:55] Could not load dynamic library 'libnvinfer.so.6'; dlerror: libnvinfer.so.6: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /usr/local/lib:/usr/lib/x86_64-linux-gnu::/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server:/usr/local/cuda/lib64
2020-01-25 14:10:11.732270: W tensorflow/stream_executor/platform/default/dso_loader.cc:55] Could not load dynamic library 'libnvinfer_plugin.so.6'; dlerror: libnvinfer_plugin.so.6: cannot open shared object file: No such file or directory; LD_LIBRARY_PATH: /usr/local/lib:/usr/lib/x86_64-linux-gnu::/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server:/usr/local/cuda/lib64
2020-01-25 14:10:11.732278: W tensorflow/compiler/tf2tensorrt/utils/py_utils.cc:30] Cannot dlopen some TensorRT libraries. If you would like to use Nvidia GPU with TensorRT, please make sure the missing libraries mentioned above are installed properly.
I0125 14:10:12.257973 139845631825728 create_pascal_tf_record.py:172] Reading from PASCAL VOC2012 dataset.
I0125 14:10:12.275494 139845631825728 create_pascal_tf_record.py:179] On image 0 of 5823
/codehub/external/tensorflow/models/research/object_detection/utils/dataset_util.py:81: FutureWarning: The behavior of this method will change in future versions. Use specific 'len(elem)' or 'elem is not None' test instead.
  if not xml:
```