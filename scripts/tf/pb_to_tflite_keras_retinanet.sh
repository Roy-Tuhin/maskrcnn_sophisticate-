#!/bin/bash

# cd /codehub/scripts/mobile
pb_model_filepath=/aimldl-dat/data-public/fizyr/retinanet/resnet50_coco_best_v2.1.0.pb
tflite_model_filepath=/aimldl-dat/data-public/fizyr/retinanet/resnet50_coco_best_v2.1.0.pb.tflite

# output_arrays='filtered_detections/map/TensorArray', 'filtered_detections/map/TensorArray_1'
output_arrays='filtered_detections/map/TensorArrayV2Stack/TensorListStack','filtered_detections/map/TensorArrayV2Stack_1/TensorListStack','filtered_detections/map/TensorArrayV2Stack_2/TensorListStack'
# bazel run --config=opt tensorflow/lite/toco:toco -- \

cd /codehub/external/tensorflow/tensorflow
bazel run -c opt tensorflow/lite/toco:toco -- \
--input_file=${pb_model_filepath} \
--output_file=${tflite_model_filepath} \
--input_shapes=1,750,1333,3 \
--input_arrays=normalized_input_image_tensor \
--output_arrays=${output_arrays} \
--inference_type=QUANTIZED_UINT8 \
--mean_values=128 \
--std_values=128 \
--change_concat_input_ranges=false \
--allow_custom_ops