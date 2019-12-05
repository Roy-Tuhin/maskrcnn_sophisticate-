#!/usr/bin/env python
# -*- coding: utf-8 -*-

# workon vpy3
# python
# import numpy
# numpy.__version__
# import theano
# theano.__version__
# import tensorflow
# tensorflow.__version__
# import keras
# keras.__version__
# import torch
# torch.__version__
# import cv2
# cv2.__version__

import tensorflow as tf
print(tf.__version__)
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))

## check if GPU enabled
## https://stackoverflow.com/questions/38009682/how-to-tell-if-tensorflow-is-using-gpu-acceleration-from-inside-python-shell
sess = tf.Session(config=tf.ConfigProto(log_device_placement=True))
