
# # https://stackoverflow.com/questions/57796368/attributeerror-importerror-on-scipy-misc-image-functions-e-x-imread-imresize
# # pip install -U scipy==1.0.0

# # 2020-01-05 16:23:35.397643: E tensorflow/stream_executor/cuda/cuda_dnn.cc:334] Could not create cudnn handle: CUDNN_STATUS_INTERNAL_ERROR
# # 2020-01-05 16:23:35.415030: E tensorflow/stream_executor/cuda/cuda_dnn.cc:334] Could not create cudnn handle: CUDNN_STATUS_INTERNAL_ERROR
# https://github.com/tensorflow/tensorflow/issues/24496
# ## https://github.com/tensorflow/tensorflow/issues/28254
# from tensorflow.compat.v1 import InteractiveSession
# config = tf.ConfigProto()
# config.gpu_options.allow_growth = True
# session = InteractiveSession(config=config)

# # https://www.reddit.com/r/docker/comments/8kp9h9/errors_with_python_and_locale/
# # /codehub/external/tensorflow/models/research/vid2depth/util.py
# def format_number(n):
#   """Formats number with thousands commas."""
#   locale.setlocale(locale.LC_ALL, 'en_US.utf8')
#   return locale.format('%d', n, grouping=True)
# 
# sudo dpkg-reconfigure locales

# https://github.com/tensorflow/models/files/2594393/icp_op.zip
# https://github.com/tensorflow/models/issues/5168#issuecomment-439813177
# https://stackoverflow.com/questions/51385792/tensorflow-vid2depth-icp-op-load-fails-dynamic-module-and-init-function
# https://github.com/ClementPinard/SfmLearner-Pytorch


# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/using_your_own_dataset.md
# https://medium.com/test-ttile/kitti-3d-object-detection-dataset-d78a762b5a4

python inference.py \
  --kitti_dir /aimldl-dat/data-public/vid2depth/kitti-raw-uncompressed \
  --output_dir /aimldl-dat/logs/vid2depth \
  --kitti_video 2011_09_26/2011_09_26_drive_0009_sync \
  --model_ckpt /aimldl-dat/release/vid2depth/model_model-119496/model-119496

# LANG=C
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8