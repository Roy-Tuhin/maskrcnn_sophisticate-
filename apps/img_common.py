__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# common imgage pre-processing utils
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""

import sys
import numpy as np
import base64

from keras.preprocessing.image import img_to_array
from keras.applications import imagenet_utils


def base64_encode_numpy_array_to_string(a):
  """Credit: https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
  """
  # base64 encode the input NumPy array
  # return base64.b64encode(a).decode("utf-8")
  return base64.encodestring(a.tobytes()).decode('utf-8')


def base64_decode_numpy_array_from_string(a, shape, dtype='float32'):
  """Credit: https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/

  shape: (1, IMAGE_HEIGHT, IMAGE_WIDTH, IMAGE_CHANS)

  Ref:
  https://github.com/qiyuangong/image_classification_redis/blob/master/python/helpers.py
  """
  ## if this is Python 3, we need the extra step of encoding the
  ## serialized NumPy string as a byte object
  if sys.version_info.major == 3:
    a = bytes(a, encoding="utf-8")
 
  ## convert the string to a NumPy array using the supplied data
  ## type and target shape

  # a = np.frombuffer(base64.decodestring(a), dtype=dtype)
  # a = np.frombuffer(base64.decodebytes(a), dtype=dtype)
 
  a = np.fromstring(base64.decodestring(bytes(a.decode('utf-8'), 'utf-8')), dtype=dtype)
  if shape:
    a = a.reshape(shape)

  ## return the decoded image
  return a


# def prepare_image(im_non_numpy, target=None):
#   """ prepare image for detection
#   im_non_numpy is created using PIL
#     ```python
#     from PIL import Image

#     image = request.files["image"]
#     image_bytes = image.read()
#     im_non_numpy = Image.open(io.BytesIO(image_bytes))
#     ```
#   target = (IMAGE_WIDTH, IMAGE_HEIGHT)

#   Ref: https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
#   """
#   # if the image mode is not RGB, convert it
#   if im_non_numpy.mode != "RGB":
#     im_non_numpy = im_non_numpy.convert("RGB")

#   if target:
#     # resize the input image and preprocess it
#     im_non_numpy = im_non_numpy.resize(target)

#   im = np.array(im_non_numpy)
#   return im


def prepare_image(image, target=None):
  # if the image mode is not RGB, convert it
  if image.mode != "RGB":
    image = image.convert("RGB")
 
  if target:
    # resize the input image and preprocess it
    image = image.resize(target)

  image = img_to_array(image)
  image = np.expand_dims(image, axis=0)
  image = imagenet_utils.preprocess_input(image)
 
  # return the processed image
  return image


def resize(image, output_shape, order=1, mode='constant', cval=0, clip=True,
           preserve_range=False, anti_aliasing=False, anti_aliasing_sigma=None):
    """
    Credit: https://github.com/matterport/Mask_RCNN
    Mask R-CNN
    Common utility functions and classes.

    Copyright (c) 2017 Matterport, Inc.
    Licensed under the MIT License (see LICENSE for details)
    Written by Waleed Abdulla

    https://github.com/matterport/Mask_RCNN/blob/master/mrcnn/utils.py
    -------------
    A wrapper for Scikit-Image resize().

    Scikit-Image generates warnings on every call to resize() if it doesn't
    receive the right parameters. The right parameters depend on the version
    of skimage. This solves the problem by using different parameters per
    version. And it provides a central place to control resizing defaults.
    """
    if LooseVersion(skimage.__version__) >= LooseVersion("0.14"):
        # New in 0.14: anti_aliasing. Default it to False for backward
        # compatibility with skimage 0.13.
        return skimage.transform.resize(
            image, output_shape,
            order=order, mode=mode, cval=cval, clip=clip,
            preserve_range=preserve_range, anti_aliasing=anti_aliasing,
            anti_aliasing_sigma=anti_aliasing_sigma)
    else:
        return skimage.transform.resize(
            image, output_shape,
            order=order, mode=mode, cval=cval, clip=clip,
            preserve_range=preserve_range)


def resize_image(image, min_dim=None, max_dim=None, min_scale=None, mode="square"):
    """
    Credit: https://github.com/matterport/Mask_RCNN
    Mask R-CNN
    Common utility functions and classes.

    Copyright (c) 2017 Matterport, Inc.
    Licensed under the MIT License (see LICENSE for details)
    Written by Waleed Abdulla

    https://github.com/matterport/Mask_RCNN/blob/master/mrcnn/utils.py
    -------------
    Resizes an image keeping the aspect ratio unchanged.

    min_dim: if provided, resizes the image such that it's smaller
        dimension == min_dim
    max_dim: if provided, ensures that the image longest side doesn't
        exceed this value.
    min_scale: if provided, ensure that the image is scaled up by at least
        this percent even if min_dim doesn't require it.
    mode: Resizing mode.
        none: No resizing. Return the image unchanged.
        square: Resize and pad with zeros to get a square image
            of size [max_dim, max_dim].
        pad64: Pads width and height with zeros to make them multiples of 64.
               If min_dim or min_scale are provided, it scales the image up
               before padding. max_dim is ignored in this mode.
               The multiple of 64 is needed to ensure smooth scaling of feature
               maps up and down the 6 levels of the FPN pyramid (2**6=64).
        crop: Picks random crops from the image. First, scales the image based
              on min_dim and min_scale, then picks a random crop of
              size min_dim x min_dim. Can be used in training only.
              max_dim is not used in this mode.

    Returns:
    image: the resized image
    window: (y1, x1, y2, x2). If max_dim is provided, padding might
        be inserted in the returned image. If so, this window is the
        coordinates of the image part of the full image (excluding
        the padding). The x2, y2 pixels are not included.
    scale: The scale factor used to resize the image
    padding: Padding added to the image [(top, bottom), (left, right), (0, 0)]
    """
    # Keep track of image dtype and return results in the same dtype
    image_dtype = image.dtype
    # Default window (y1, x1, y2, x2) and default scale == 1.
    h, w = image.shape[:2]
    window = (0, 0, h, w)
    scale = 1
    padding = [(0, 0), (0, 0), (0, 0)]
    crop = None

    if mode == "none":
        return image, window, scale, padding, crop

    # Scale?
    if min_dim:
        # Scale up but not down
        scale = max(1, min_dim / min(h, w))
    if min_scale and scale < min_scale:
        scale = min_scale

    # Does it exceed max dim?
    if max_dim and mode == "square":
        image_max = max(h, w)
        if round(image_max * scale) > max_dim:
            scale = max_dim / image_max

    # Resize image using bilinear interpolation
    if scale != 1:
        image = resize(image, (round(h * scale), round(w * scale)),
                       preserve_range=True)

    # Need padding or cropping?
    if mode == "square":
        # Get new height and width
        h, w = image.shape[:2]
        top_pad = (max_dim - h) // 2
        bottom_pad = max_dim - h - top_pad
        left_pad = (max_dim - w) // 2
        right_pad = max_dim - w - left_pad
        padding = [(top_pad, bottom_pad), (left_pad, right_pad), (0, 0)]
        image = np.pad(image, padding, mode='constant', constant_values=0)
        window = (top_pad, left_pad, h + top_pad, w + left_pad)
    elif mode == "pad64":
        h, w = image.shape[:2]
        # Both sides must be divisible by 64
        assert min_dim % 64 == 0, "Minimum dimension must be a multiple of 64"
        # Height
        if h % 64 > 0:
            max_h = h - (h % 64) + 64
            top_pad = (max_h - h) // 2
            bottom_pad = max_h - h - top_pad
        else:
            top_pad = bottom_pad = 0
        # Width
        if w % 64 > 0:
            max_w = w - (w % 64) + 64
            left_pad = (max_w - w) // 2
            right_pad = max_w - w - left_pad
        else:
            left_pad = right_pad = 0
        padding = [(top_pad, bottom_pad), (left_pad, right_pad), (0, 0)]
        image = np.pad(image, padding, mode='constant', constant_values=0)
        window = (top_pad, left_pad, h + top_pad, w + left_pad)
    elif mode == "crop":
        # Pick a random crop
        h, w = image.shape[:2]
        y = random.randint(0, (h - min_dim))
        x = random.randint(0, (w - min_dim))
        crop = (y, x, min_dim, min_dim)
        image = image[y:y + min_dim, x:x + min_dim]
        window = (0, 0, min_dim, min_dim)
    else:
        raise Exception("Mode {} not supported".format(mode))
    return image.astype(image_dtype), window, scale, padding, crop

