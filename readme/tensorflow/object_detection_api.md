
## TF object_detection API

* https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_locally.md
  * [Installation](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md)
  * [TFRecord creation](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/preparing_inputs.md)
  * [Configure training pipeline](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/configuring_jobs.md)
* https://github.com/tensorflow/models/tree/master/research/object_detection/g3doc
* https://github.com/tensorflow/models/tree/master/research/object_detection/dataset_tools
* https://www.tensorflow.org/datasets/catalog/coco

cd /codehub/external/tensorflow/models/research/object_detection/
jupyter-notebook object_detection_tutorial-Copy1.ipynb


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


## Error logs


```bash
## https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi
## https://github.com/tensorflow/models/blob/master/research/object_detection/samples/configs/ssd_mobilenet_v2_quantized_300x300_coco.config

## set CONFIG_FILE=C:\\tensorflow1\models\research\object_detection\training\ssd_mobilenet_v2_quantized_300x300_coco.config
## set CHECKPOINT_PATH=C:\\tensorflow1\models\research\object_detection\training\model.ckpt-XXXX
## set OUTPUT_DIR=C:\\tensorflow1\models\research\object_detection\TFLite_model

# import sys
# print(sys.path)
# sys.path.append('/codehub/external/tensorflow/models/research')

export PYTHONPATH=/codehub/external/tensorflow/models/research:${PYTHONPATH}
export PYTHONPATH=/codehub/external/tensorflow/models/research/slim:${PYTHONPATH}
cd /codehub/external/tensorflow/models/research
# model.ckpt-3126
CHECKPOINT_PATH=/aimldl-dat/logs/tf_ods/model.ckpt-3126
OUTPUT_DIR=/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco/TFLite_model
mkdir -p ${OUTPUT_DIR}

python object_detection/export_tflite_ssd_graph.py \
  --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
  --trained_checkpoint_prefix=${CHECKPOINT_PATH} \
  --output_directory=${OUTPUT_DIR} \
  --add_postprocessing_op=true



# MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint

# https://github.com/tensorflow/models/issues/4156
```

https://github.com/tensorflow/models/issues/4137

How to quantize Mobilenet v2 ?
https://github.com/tensorflow/tensorflow/issues/19014


```
2020-02-24 17:00:26.733141: W tensorflow/core/framework/op_kernel.cc:1401] OP_REQUIRES failed at save_restore_v2_ops.cc:184 : Not found: Key FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint
Traceback (most recent call last):
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 1334, in _do_call
    return fn(*args)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 1319, in _run_fn
    options, feed_dict, fetch_list, target_list, run_metadata)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 1407, in _call_tf_sessionrun
    run_metadata)
tensorflow.python.framework.errors_impl.NotFoundError: Key FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint
   [[{{node save/RestoreV2}}]]
   [[{{node save/RestoreV2}}]]

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 1276, in restore
    {self.saver_def.filename_tensor_name: save_path})
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 929, in run
    run_metadata_ptr)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 1152, in _run
    feed_dict_tensor, options, run_metadata)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 1328, in _do_run
    run_metadata)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/client/session.py", line 1348, in _do_call
    raise type(e)(node_def, op, message)
tensorflow.python.framework.errors_impl.NotFoundError: Key FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]

Caused by op 'save/RestoreV2', defined at:
  File "object_detection/export_tflite_ssd_graph.py", line 143, in <module>
    tf.app.run(main)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/platform/app.py", line 125, in run
    _sys.exit(main(argv))
  File "object_detection/export_tflite_ssd_graph.py", line 139, in main
    FLAGS.max_classes_per_detection, use_regular_nms=FLAGS.use_regular_nms)
  File "/codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py", line 292, in export_tflite_graph
    saver = tf.train.Saver(**saver_kwargs)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 832, in __init__
    self.build()
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 844, in build
    self._build(self._filename, build_save=True, build_restore=True)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 881, in _build
    build_save=build_save, build_restore=build_restore)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 513, in _build_internal
    restore_sequentially, reshape)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 332, in _AddRestoreOps
    restore_sequentially)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 580, in bulk_restore
    return io_ops.restore_v2(filename_tensor, names, slices, dtypes)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/ops/gen_io_ops.py", line 1572, in restore_v2
    name=name)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/op_def_library.py", line 788, in _apply_op_helper
    op_def=op_def)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/util/deprecation.py", line 507, in new_func
    return func(*args, **kwargs)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/ops.py", line 3300, in create_op
    op_def=op_def)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/ops.py", line 1801, in __init__
    self._traceback = tf_stack.extract_stack()

NotFoundError (see above for traceback): Key FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]


During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 1286, in restore
    names_to_keys = object_graph_key_mapping(save_path)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 1591, in object_graph_key_mapping
    checkpointable.OBJECT_GRAPH_PROTO_KEY)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/pywrap_tensorflow_internal.py", line 370, in get_tensor
    status)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/errors_impl.py", line 528, in __exit__
    c_api.TF_GetCode(self.status.status))
tensorflow.python.framework.errors_impl.NotFoundError: Key _CHECKPOINTABLE_OBJECT_GRAPH not found in checkpoint

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "object_detection/export_tflite_ssd_graph.py", line 143, in <module>
    tf.app.run(main)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/platform/app.py", line 125, in run
    _sys.exit(main(argv))
  File "object_detection/export_tflite_ssd_graph.py", line 139, in main
    FLAGS.max_classes_per_detection, use_regular_nms=FLAGS.use_regular_nms)
  File "/codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py", line 306, in export_tflite_graph
    initializer_nodes='')
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/tools/freeze_graph.py", line 151, in freeze_graph_with_def_protos
    saver.restore(sess, input_checkpoint)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 1292, in restore
    err, "a Variable name or other graph key that is missing")
tensorflow.python.framework.errors_impl.NotFoundError: Restoring from checkpoint failed. This is most likely due to a Variable name or other graph key that is missing from the checkpoint. Please ensure that you have not altered the graph expected based on the checkpoint. Original error:

Key FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]

Caused by op 'save/RestoreV2', defined at:
  File "object_detection/export_tflite_ssd_graph.py", line 143, in <module>
    tf.app.run(main)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/platform/app.py", line 125, in run
    _sys.exit(main(argv))
  File "object_detection/export_tflite_ssd_graph.py", line 139, in main
    FLAGS.max_classes_per_detection, use_regular_nms=FLAGS.use_regular_nms)
  File "/codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py", line 292, in export_tflite_graph
    saver = tf.train.Saver(**saver_kwargs)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 832, in __init__
    self.build()
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 844, in build
    self._build(self._filename, build_save=True, build_restore=True)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 881, in _build
    build_save=build_save, build_restore=build_restore)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 513, in _build_internal
    restore_sequentially, reshape)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 332, in _AddRestoreOps
    restore_sequentially)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py", line 580, in bulk_restore
    return io_ops.restore_v2(filename_tensor, names, slices, dtypes)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/ops/gen_io_ops.py", line 1572, in restore_v2
    name=name)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/op_def_library.py", line 788, in _apply_op_helper
    op_def=op_def)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/util/deprecation.py", line 507, in new_func
    return func(*args, **kwargs)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/ops.py", line 3300, in create_op
    op_def=op_def)
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/ops.py", line 1801, in __init__
    self._traceback = tf_stack.extract_stack()

NotFoundError (see above for traceback): Restoring from checkpoint failed. This is most likely due to a Variable name or other graph key that is missing from the checkpoint. Please ensure that you have not altered the graph expected based on the checkpoint. Original error:

Key FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512_depthwise/BatchNorm/beta not found in checkpoint
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]
   [[node save/RestoreV2 (defined at /codehub/external/tensorflow/models/research/object_detection/export_tflite_ssd_graph_lib.py:292) ]]

(py_3-6-8_2020-01-23) @alpha@alpha-Precision-3630-Tower:17:00:27:data-public$
```

```bash
NETWORK_NAME="ssd_mobilenet_v2_coco"
OUTPUT_FILE=/aimldl-dat/logs/tf_ods/${timestamp}_inf_graph.pb
python object_detection/export_inference_graph.py \
  --alsologtostderr \
  --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
  --trained_checkpoint_prefix=${CHECKPOINT_PATH} \
  --batch_size=1 \
  --output_directory=${OUTPUT_DIR} \
  --model_name=${NETWORK_NAME} \
  --output_file=${OUTPUT_FILE} \
  --quantize
```

```
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/exporter.py:539: print_model_analysis (from tensorflow.contrib.tfprof.model_analyzer) is deprecated and will be removed after 2018-01-01.
Instructions for updating:
Use `tf.profiler.profile(graph, run_meta, op_log, cmd, options)`. Build `options` with `tf.profiler.ProfileOptionBuilder`. See README.md for details
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/profiler/internal/flops_registry.py:142: tensor_shape_from_node_def_name (from tensorflow.python.framework.graph_util_impl) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.compat.v1.graph_util.remove_training_nodes
422 ops no flops stats due to incomplete shapes.
Parsing Inputs...
Incomplete shape.
```
/codehub/external/tensorflow/models/research/slim/nets/mobilenet_v1.md
/codehub/external/tensorflow/models/research/slim/nets/mobilenet/README.md