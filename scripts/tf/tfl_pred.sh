#!/bin/bash

##----------------------------------------------------------
## TFlite Prediction
##----------------------------------------------------------
## Ref:
## https://github.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/examples/python/label_image.py
## https://mc.ai/deploy-mobilenet-model-to-android-platform/
##----------------------------------------------------------
#
## Credits:
## https://github.com/EdjeElectronics/TensorFlow-Object-Detection-on-the-Raspberry-Pi
#
##----------------------------------------------------------



cd /codehub/scripts/tf/py

# wget https://raw.githubusercontent.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi/master/TFLite_detection_image.py --no-check-certificate
# wget https://raw.githubusercontent.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi/master/TFLite_detection_video.py --no-check-certificate
# wget https://raw.githubusercontent.com/EdjeElectronics/TensorFlow-Lite-Object-Detection-on-Android-and-Raspberry-Pi/master/TFLite_detection_webcam.py --no-check-certificate


python TFLite_detection_image.py --modeldir /aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_annon-280220_172500/TFLite_model/290220_163433 --graph tflite_graph.tflite --labels train-labelmap.txt --threshold 0.3 --image /aimldl-dat/samples/Trafic_Signs/images/100818_135420_16716_zed_l_032.jpg
python TFLite_detection_image.py --modeldir /aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_annon-280220_172500/TFLite_model/290220_163433 --graph tflite_graph.tflite --labels train-labelmap.txt --threshold 0.5 --imagedir /aimldl-dat/samples/Trafic_Signs/images

