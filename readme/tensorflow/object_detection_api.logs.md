```bash
(py_3-6-8_2020-01-23) @alpha@alpha-Precision-3630-Tower:11:12:14:data-public$source tf_ods_train.sh 
/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:526: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint8 = np.dtype([("qint8", np.int8, 1)])
/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:527: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_quint8 = np.dtype([("quint8", np.uint8, 1)])
/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:528: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint16 = np.dtype([("qint16", np.int16, 1)])
/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:529: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_quint16 = np.dtype([("quint16", np.uint16, 1)])
/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:530: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint32 = np.dtype([("qint32", np.int32, 1)])
/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:535: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  np_resource = np.dtype([("resource", np.ubyte, 1)])

WARNING: The TensorFlow contrib module will not be included in TensorFlow 2.0.
For more information, please see:
  * https://github.com/tensorflow/community/blob/master/rfcs/20180907-contrib-sunset.md
  * https://github.com/tensorflow/addons
If you depend on functionality not listed there, please file an issue.

WARNING:tensorflow:Forced number of epochs for all eval validations to be 1.
WARNING:tensorflow:Expected number of evaluation epochs is 1, but instead encountered `eval_on_train_input_config.num_epochs` = 0. Overwriting `num_epochs` to 1.
WARNING:tensorflow:Estimator's model_fn (<function create_model_fn.<locals>.model_fn at 0x7fd3509d36a8>) includes params argument, but params are not passed to Estimator.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/framework/op_def_library.py:263: colocate_with (from tensorflow.python.framework.ops) is deprecated and will be removed in a future version.
Instructions for updating:
Colocations handled automatically by placer.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/builders/dataset_builder.py:86: parallel_interleave (from tensorflow.contrib.data.python.ops.interleave_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use `tf.data.experimental.parallel_interleave(...)`.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/core/preprocessor.py:197: sample_distorted_bounding_box (from tensorflow.python.ops.image_ops_impl) is deprecated and will be removed in a future version.
Instructions for updating:
`seed2` arg is deprecated.Use sample_distorted_bounding_box_v2 instead.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/inputs.py:168: to_float (from tensorflow.python.ops.math_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.cast instead.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/builders/dataset_builder.py:158: batch_and_drop_remainder (from tensorflow.contrib.data.python.ops.batching) is deprecated and will be removed in a future version.
Instructions for updating:
Use `tf.data.Dataset.batch(..., drop_remainder=True)`.
WARNING:root:Variable [FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_2_3x3_s2_512/weights] is available in checkpoint, but has an incompatible shape with model variable. Checkpoint shape: [[1, 1, 256, 512]], model variable shape: [[3, 3, 256, 512]]. This variable will not be initialized from the checkpoint.
WARNING:root:Variable [FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_3_3x3_s2_256/weights] is available in checkpoint, but has an incompatible shape with model variable. Checkpoint shape: [[1, 1, 128, 256]], model variable shape: [[3, 3, 128, 256]]. This variable will not be initialized from the checkpoint.
WARNING:root:Variable [FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_4_3x3_s2_256/weights] is available in checkpoint, but has an incompatible shape with model variable. Checkpoint shape: [[1, 1, 128, 256]], model variable shape: [[3, 3, 128, 256]]. This variable will not be initialized from the checkpoint.
WARNING:root:Variable [FeatureExtractor/MobilenetV2/layer_19_2_Conv2d_5_3x3_s2_128/weights] is available in checkpoint, but has an incompatible shape with model variable. Checkpoint shape: [[1, 1, 64, 128]], model variable shape: [[3, 3, 64, 128]]. This variable will not be initialized from the checkpoint.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/ops/array_grad.py:425: to_int32 (from tensorflow.python.ops.math_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.cast instead.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/ops/array_grad.py:425: to_int32 (from tensorflow.python.ops.math_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.cast instead.
2020-01-27 11:12:43.379505: I tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA
2020-01-27 11:12:43.464552: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:998] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2020-01-27 11:12:43.465584: I tensorflow/compiler/xla/service/service.cc:150] XLA service 0x14edc640 executing computations on platform CUDA. Devices:
2020-01-27 11:12:43.465599: I tensorflow/compiler/xla/service/service.cc:158]   StreamExecutor device (0): GeForce GTX 1080, Compute Capability 6.1
2020-01-27 11:12:43.484875: I tensorflow/core/platform/profile_utils/cpu_utils.cc:94] CPU Frequency: 3696000000 Hz
2020-01-27 11:12:43.485714: I tensorflow/compiler/xla/service/service.cc:150] XLA service 0x14edc350 executing computations on platform Host. Devices:
2020-01-27 11:12:43.485728: I tensorflow/compiler/xla/service/service.cc:158]   StreamExecutor device (0): <undefined>, <undefined>
2020-01-27 11:12:43.485856: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1433] Found device 0 with properties: 
name: GeForce GTX 1080 major: 6 minor: 1 memoryClockRate(GHz): 1.7335
pciBusID: 0000:01:00.0
totalMemory: 7.92GiB freeMemory: 6.17GiB
2020-01-27 11:12:43.485869: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 11:12:43.486247: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 11:12:43.486256: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 11:12:43.486261: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 11:12:43.486308: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py:1266: checkpoint_exists (from tensorflow.python.training.checkpoint_management) is deprecated and will be removed in a future version.
Instructions for updating:
Use standard file APIs to check for files with this prefix.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py:1266: checkpoint_exists (from tensorflow.python.training.checkpoint_management) is deprecated and will be removed in a future version.
Instructions for updating:
Use standard file APIs to check for files with this prefix.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py:1070: get_checkpoint_mtimes (from tensorflow.python.training.checkpoint_management) is deprecated and will be removed in a future version.
Instructions for updating:
Use standard file utilities to get mtimes.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py:1070: get_checkpoint_mtimes (from tensorflow.python.training.checkpoint_management) is deprecated and will be removed in a future version.
Instructions for updating:
Use standard file utilities to get mtimes.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/eval_util.py:796: to_int64 (from tensorflow.python.ops.math_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.cast instead.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/eval_util.py:796: to_int64 (from tensorflow.python.ops.math_ops) is deprecated and will be removed in a future version.
Instructions for updating:
Use tf.cast instead.
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/utils/visualization_utils.py:498: py_func (from tensorflow.python.ops.script_ops) is deprecated and will be removed in a future version.
Instructions for updating:
tf.py_func is deprecated in TF V2. Instead, use
    tf.py_function, which takes a python function which manipulates tf eager
    tensors instead of numpy arrays. It's easy to convert a tf eager tensor to
    an ndarray (just call tensor.numpy()) but having access to eager tensors
    means `tf.py_function`s can use accelerators such as GPUs as well as
    being differentiable using a gradient tape.
    
WARNING:tensorflow:From /codehub/external/tensorflow/models/research/object_detection/utils/visualization_utils.py:498: py_func (from tensorflow.python.ops.script_ops) is deprecated and will be removed in a future version.
Instructions for updating:
tf.py_func is deprecated in TF V2. Instead, use
    tf.py_function, which takes a python function which manipulates tf eager
    tensors instead of numpy arrays. It's easy to convert a tf eager tensor to
    an ndarray (just call tensor.numpy()) but having access to eager tensors
    means `tf.py_function`s can use accelerators such as GPUs as well as
    being differentiable using a gradient tape.
    
2020-01-27 11:23:01.512314: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 11:23:01.512386: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 11:23:01.512392: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 11:23:01.512411: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 11:23:01.512496: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 11:23:03.167391: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 11:23:03.167425: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 11:23:03.167434: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 11:23:03.167442: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
creating index...
index created!
creating index...
index created!
Running per image evaluation...
Evaluate annotation type *bbox*
DONE (t=265.04s).
Accumulating evaluation results...
DONE (t=49.53s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.097
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.204
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.081
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.004
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.045
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.180
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.124
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.192
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.206
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.013
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.127
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.362
2020-01-27 11:55:06.329296: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 11:55:06.329376: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 11:55:06.329382: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 11:55:06.329402: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 11:55:06.329476: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 11:55:07.946691: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 11:55:07.946742: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 11:55:07.946768: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 11:55:07.946777: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
creating index...
index created!
creating index...
index created!
Running per image evaluation...
Evaluate annotation type *bbox*
DONE (t=264.37s).
Accumulating evaluation results...
DONE (t=43.59s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.097
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.204
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.081
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.004
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.045
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.180
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.124
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.191
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.205
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.013
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.126
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.361
2020-01-27 12:27:59.723942: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 12:27:59.723995: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 12:27:59.724016: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 12:27:59.724023: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 12:27:59.724117: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 12:28:01.391270: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 12:28:01.391323: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 12:28:01.391334: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 12:28:01.391359: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
creating index...
index created!
creating index...
index created!
Running per image evaluation...
Evaluate annotation type *bbox*
DONE (t=259.78s).
Accumulating evaluation results...
DONE (t=49.61s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.097
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.204
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.082
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.004
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.045
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.179
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.124
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.191
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.205
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.014
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.126
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.360
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py:966: remove_checkpoint (from tensorflow.python.training.checkpoint_management) is deprecated and will be removed in a future version.
Instructions for updating:
Use standard file APIs to delete files with this prefix.
WARNING:tensorflow:From /codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/tensorflow/python/training/saver.py:966: remove_checkpoint (from tensorflow.python.training.checkpoint_management) is deprecated and will be removed in a future version.
Instructions for updating:
Use standard file APIs to delete files with this prefix.
2020-01-27 13:00:15.452927: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 13:00:15.452989: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 13:00:15.452995: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 13:00:15.453000: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 13:00:15.453059: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 13:00:17.102561: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 13:00:17.102597: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 13:00:17.102607: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 13:00:17.102615: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
creating index...
index created!
creating index...
index created!
Running per image evaluation...
Evaluate annotation type *bbox*
DONE (t=256.93s).
Accumulating evaluation results...
DONE (t=46.10s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.097
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.203
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.082
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.004
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.045
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.179
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.124
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.191
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.205
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.014
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.125
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.360
2020-01-27 13:32:02.625912: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 13:32:02.625987: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 13:32:02.625993: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 13:32:02.626014: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 13:32:02.626076: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 13:32:04.239571: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 13:32:04.239606: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 13:32:04.239631: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 13:32:04.239656: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
creating index...
index created!
creating index...
index created!
Running per image evaluation...
Evaluate annotation type *bbox*
DONE (t=258.34s).
Accumulating evaluation results...
DONE (t=53.09s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.097
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.203
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.082
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.004
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.045
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.180
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.124
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.191
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.205
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.014
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.124
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.361
2020-01-27 14:04:37.673014: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 14:04:37.673086: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 14:04:37.673106: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 14:04:37.673111: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 14:04:37.685732: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 14:04:39.300420: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 14:04:39.300457: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 14:04:39.300481: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 14:04:39.300501: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
creating index...
index created!
creating index...
index created!
Running per image evaluation...
Evaluate annotation type *bbox*
DONE (t=258.76s).
Accumulating evaluation results...
DONE (t=98.02s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.097
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.202
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.083
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.004
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.044
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.180
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.125
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.191
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.205
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.014
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = 0.122
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = 0.361
2020-01-27 14:37:45.995753: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1512] Adding visible gpu devices: 0
2020-01-27 14:37:46.643261: I tensorflow/core/common_runtime/gpu/gpu_device.cc:984] Device interconnect StreamExecutor with strength 1 edge matrix:
2020-01-27 14:37:46.643344: I tensorflow/core/common_runtime/gpu/gpu_device.cc:990]      0 
2020-01-27 14:37:46.643369: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1003] 0:   N 
2020-01-27 14:37:46.643607: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1115] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 5999 MB memory) -> physical GPU (device: 0, name: GeForce GTX 1080, pci bus id: 0000:01:00.0, compute capability: 6.1)
2020-01-27 14:37:51.959412: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 14:37:51.959447: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_2. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 14:37:51.959458: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_6. Error: Pack node (stack_10) axis attribute is out of bounds: 0
2020-01-27 14:37:51.959467: W ./tensorflow/core/grappler/optimizers/graph_optimizer_stage.h:241] Failed to run optimizer ArithmeticOptimizer, stage RemoveStackStridedSliceSameAxis node ChangeCoordinateFrame/strided_slice_7. Error: Pack node (stack_10) axis attribute is out of bounds: 0
```

https://github.com/numpy/numpy/issues/7289
```bash
import numpy as np
np.__version__
>>> '1.18.1'

np.linspace(2.0, 3.0, num=5)
>>> array([2.  , 2.25, 2.5 , 2.75, 3.  ])

 numpy.linspace(2.0, 3.0, 0.25)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'numpy' is not defined
>>> np.linspace(2.0, 3.0, 0.25)
Traceback (most recent call last):
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/numpy/core/function_base.py", line 117, in linspace
    num = operator.index(num)
TypeError: 'float' object cannot be interpreted as an integer

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<__array_function__ internals>", line 6, in linspace
  File "/codehub/virtualmachines/virtualenvs/py_3-6-8_2020-01-23/lib/python3.6/site-packages/numpy/core/function_base.py", line 121, in linspace
    .format(type(num)))


python -c "import numpy as np;print(np.__version__)"
1.17.4

import numpy as np
np.linspace(2.0, 3.0, num=5)
>>>array([2.  , 2.25, 2.5 , 2.75, 3.  ])

np.linspace(2.0, 3.0, 0.25)
>>>array([], dtype=float64)
```

Ah ok the third argument is always supposed to be a number of samples, and never a step (as like as in the range built-in). It's a bit misleading, maybe a deprecated message would help to understand this behavior but I don't get exactly what do you plan to implement (I could try to fix it if it's not a major change)


https://github.com/Kyubyong/dc_tts/issues/11


https://github.com/tensorflow/models/issues/3922


[Object detection] Mismatch between pretrained model and configs for ssd_mobilenet_v2_coco #5315
https://github.com/tensorflow/models/issues/5315
https://github.com/tensorflow/models/issues/5315#issuecomment-507392690
https://github.com/tensorflow/models/commit/324d6dc3b52d7219d4ef48b1e4b7f9e4086f11fd#diff-1976a26347451b0de26f1a11dcf376c9L56

ObjectDetection API not suitable for tf 2.0.0-alpha0 
https://github.com/tensorflow/models/issues/6423

Until the Object Detection API is updated to TensorFlow 2 simply use TensorFlow 1.15 (pip install tensorflow==1.15). It still contains contrib and also a complete implementation of the 2.0 API. Using the compat.v2 module you can already ensure that your code (except for the Object Detection API part of course) will work with 2.0. Check the TensorFlow 1.15 release notes for further information.