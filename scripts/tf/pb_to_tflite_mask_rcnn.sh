#!/bin/bash

pb_model_filepath=/aimldl-dat/release/vidteq/ods/7/mask_rcnn/weights/model-mask_rcnn-241219.pb
tflite_model_filepath=/aimldl-dat/release/vidteq/ods/7/mask_rcnn/weights/model-mask_rcnn-241219.pb.tflit

# bazel run --config=opt tensorflow/lite/toco:toco -- \

bazel run -c opt tensorflow/lite/toco:toco -- \
--input_file=${pb_model_filepath} \
--output_file=${tflite_model_filepath} \
--input_shapes=1,1280,1280,3 \
--input_arrays=normalized_input_image_tensor \
--output_arrays='TFLite_Detection_PostProcess','TFLite_Detection_PostProcess:1','TFLite_Detection_PostProcess:2','TFLite_Detection_PostProcess:3' \
--inference_type=QUANTIZED_UINT8 \
--mean_values=128 \
--std_values=128 \
--change_concat_input_ranges=false \
--allow_custom_ops