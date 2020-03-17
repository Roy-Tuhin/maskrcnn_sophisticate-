import os
import cv2

from PIL import Image
import io
import numpy as np


def allowed_file(filename, allowed_image_type):
  fn, ext = os.path.splitext(os.path.basename(filename))
  return ext.lower() in allowed_image_type


def prepare_image(image):
  """
  Image has to mandatorly resize to fix size of 1280x720 (WxH)
  TODO: put this in config or input to the function
  """
  image_bytes = image.read()
  image = Image.open(io.BytesIO(image_bytes))
  # log.info("image_shape : {}".format(image.size))
  image = image.resize((1280,720), Image.ANTIALIAS)
  # log.info("Resized_image_shape : {}".format(image.size))

  image = np.array(image)

  # return the processed image
  return image


def load_remap_matrix(ipm_remap_file_path):
  """
  loads the IPM matrix given the matrix absoulte filepath
  """
  fs = cv2.FileStorage(ipm_remap_file_path, cv2.FILE_STORAGE_READ)

  remap_to_ipm_x = fs.getNode('remap_ipm_x').mat()
  remap_to_ipm_y = fs.getNode('remap_ipm_y').mat()

  ret = {
      'remap_to_ipm_x': remap_to_ipm_x,
      'remap_to_ipm_y': remap_to_ipm_y,
  }

  fs.release()

  return ret


def get_ipm_image(image, ipm_remap_file_path):
  """
  converts given image to birds-eye-view based on the given path to the IPM matrix
  and return the re-projected image as numpy array.

  Notte: re-projected images size is changed
  """
  image = prepare_image(image)

  remap_file_load_ret = load_remap_matrix(ipm_remap_file_path)
  remap_to_ipm_x = remap_file_load_ret['remap_to_ipm_x']
  remap_to_ipm_y = remap_file_load_ret['remap_to_ipm_y']

  ipm_image = cv2.remap(image, remap_to_ipm_x, remap_to_ipm_y, interpolation=cv2.INTER_NEAREST)
  height, width = ipm_image.shape[0], ipm_image.shape[1]
  im = Image.fromarray(ipm_image)

  return im, height, width
