#!/bin/bash

##----------------------------------------------------------
## TOCO
##----------------------------------------------------------
## Ref:
## https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi
## https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/running_on_mobile_tensorflowlite.md
##----------------------------------------------------------


## tf mobilenet-v2
##----------------------------------------------------------

# model_basepath=/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco-25022020_175950/TFLite_model/270220_151738
model_basepath=/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_annon-280220_172500/TFLite_model/290220_163433


model=tflite_graph
input_arrays=normalized_input_image_tensor
input_shapes='1,300,300,3'
# output_arrays='MobilenetV2/Predictions/Reshape_1'
output_arrays=TFLite_Detection_PostProcess,TFLite_Detection_PostProcess:1,TFLite_Detection_PostProcess:2,TFLite_Detection_PostProcess:3

## keras-retinanet
##----------------------------------------------------------
# model=resnet50_coco_best_v2.1.0.pb
# model_basepath=/aimldl-dat/data-public/fizyr/retinanet
# input_arrays=normalized_input_image_tensor
# input_shapes='1,750,1333,3'
# # output_arrays='filtered_detections/map/TensorArray', 'filtered_detections/map/TensorArray_1'
# output_arrays='filtered_detections/map/TensorArrayV2Stack/TensorListStack','filtered_detections/map/TensorArrayV2Stack_1/TensorListStack','filtered_detections/map/TensorArrayV2Stack_2/TensorListStack'

pb_model_filepath=${model_basepath}/${model}.pb
tflite_model_filepath=${model_basepath}/${model}.tflite

tf_src_path=/codehub/external/tensorflow/tensorflow
cd ${tf_src_path}

# bazel run --config=opt tensorflow/lite/toco:toco -- \
bazel run -c opt tensorflow/lite/toco:toco -- \
--input_file=${pb_model_filepath} \
--output_file=${tflite_model_filepath} \
--input_shapes=${input_shapes} \
--input_arrays=${input_arrays} \
--output_arrays=${output_arrays} \
--inference_type=FLOAT \
--mean_values=128.0 \
--std_values=128.0 \
--change_concat_input_ranges=false \
--default_ranges_min=0 \
--default_ranges_max=6 \
--allow_custom_ops

# ./bazel-bin/tensorflow/contrib/lite/toco/toco \
#   --input_file=$INPUT_PB_GRAPH \
#   --output_file=$OUTPUT_TFLITE_FILE \
#   --input_format=TENSORFLOW_GRAPHDEF --output_format=TFLITE \
#   --inference_type=QUANTIZED_UINT8 \
#   --input_shapes="1,300, 300,3" \
#   --input_arrays=normalized_input_image_tensor \
# --output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3' \
#   --std_values=128.0 --mean_values=128.0 \
#   --allow_custom_ops --default_ranges_min=0 --default_ranges_max=6

##----------------------------------------------------------
# --mean_values=128.0 \
# --std_values=128.0 \
# --mean_values=128 \
# --std_values=128 \
# --inference_type=QUANTIZED_UINT8 \
# --inference_type=FLOAT \


##----------------------------------------------------------
## Errors & Logs
##----------------------------------------------------------

## ERROR: Unrecognized option: --noincompatible_remove_legacy_whole_archive
## bazel version incompatibility with tensorflow version
##-------

# INFO: Found applicable config definition build:v2 in file /codehub/external/tensorflow/tensorflow/.bazelrc: --define=tf_api_version=2 --action_env=TF2_BEHAVIOR=1
# ERROR: Config value opt is not defined in any .rc file
# https://github.com/tensorflow/tensorflow/issues/23613#issuecomment-440757155
##-------
# https://github.com/tensorflow/models/issues/6028

# 2020-02-27 13:24:36.933867: F tensorflow/lite/toco/tooling_util.cc:1728] Array FeatureExtractor/MobilenetV2/Conv/Relu6, which is an input to the DepthwiseConv operator producing the output array FeatureExtractor/MobilenetV2/expanded_conv/depthwise/Relu6, is lacking min/max data, which is necessary for quantization. If accuracy matters, either target a non-quantized output format, or run quantized training with your model from a floating point checkpoint to change the input graph to contain min/max information. If you don't care about accuracy, you can pass --default_ranges_min= and --default_ranges_max= for easy experimentation.

# https://github.com/tensorflow/tensorflow/issues/20605
# https://www.tensorflow.org/lite/performance/post_training_quantization
# https://github.com/tensorflow/tensorflow/issues/33611
# https://medium.com/tensorflow/tensorflow-model-optimization-toolkit-post-training-integer-quantization-b4964a1ea9ba
# https://www.tensorflow.org/lite/performance/quantization_spec
# Add the following options
# --default_ranges_min=0 \
# --default_ranges_max=10 \
##-------


##-------

# 2020-02-27 13:34:42.006556: W tensorflow/lite/toco/graph_transformations/quantize.cc:169] Constant array BoxPredictor_5/ClassPredictor/weights lacks MinMax information. To make up for that, we will now compute the MinMax from actual array elements. That will result in quantization parameters that probably do not match whichever arithmetic was used during training, and thus will probably be a cause of poor inference accuracy.
# 2020-02-27 13:34:42.008486: I tensorflow/lite/toco/graph_transformations/graph_transformations.cc:39] After quantization graph transformations pass 1: 106 operators, 268 arrays (240 quantized)
# 2020-02-27 13:34:42.014783: I tensorflow/lite/toco/graph_transformations/graph_transformations.cc:39] After quantization graph transformations pass 2: 101 operators, 263 arrays (243 quantized)
# 2020-02-27 13:34:42.019002: W tensorflow/lite/toco/graph_transformations/quantize.cc:169] Constant array anchors lacks MinMax information. To make up for that, we will now compute the MinMax from actual array elements. That will result in quantization parameters that probably do not match whichever arithmetic was used during training, and thus will probably be a cause of poor inference accuracy.
# 2020-02-27 13:34:42.019130: W tensorflow/lite/toco/graph_transformations/quantize.cc:656] (Unsupported TensorFlow op: TFLite_Detection_PostProcess) is a quantized op but it has a model flag that sets the output arrays to float.
# 2020-02-27 13:34:42.019137: W tensorflow/lite/toco/graph_transformations/quantize.cc:656] (Unsupported TensorFlow op: TFLite_Detection_PostProcess) is a quantized op but it has a model flag that sets the output arrays to float.
# 2020-02-27 13:34:42.019842: I tensorflow/lite/toco/graph_transformations/graph_transformations.cc:39] After quantization graph transformations pass 3: 99 operators, 261 arrays (244 quantized)
# 2020-02-27 13:34:42.020168: W tensorflow/lite/toco/graph_transformations/quantize.cc:656] (Unsupported TensorFlow op: TFLite_Detection_PostProcess) is a quantized op but it has a model flag that sets the output arrays to float.
# 2020-02-27 13:34:42.023908: I tensorflow/lite/toco/graph_transformations/graph_transformations.cc:39] Before shuffling of FC weights: 99 operators, 261 arrays (244 quantized)
# 2020-02-27 13:34:42.024659: I tensorflow/lite/toco/graph_transformations/graph_transformations.cc:39] Before Identify nearest upsample.: 99 operators, 261 arrays (244 quantized)
# 2020-02-27 13:34:42.027131: I tensorflow/lite/toco/allocate_transient_arrays.cc:345] Total transient array allocated size: 3060032 bytes, theoretical optimal value: 2700032 bytes.
# 2020-02-27 13:34:42.027414: I tensorflow/lite/toco/toco_tooling.cc:456] Estimated count of arithmetic ops: 1569538107 ops, equivalently 784769053 MACs
# 2020-02-27 13:34:42.027424: I tensorflow/lite/toco/toco_tooling.cc:471] Number of parameters: 6055360
# 2020-02-27 13:34:42.028122: W tensorflow/lite/toco/tflite/operator.cc:1595] Ignoring unsupported type in list attribute with key '_output_types'
