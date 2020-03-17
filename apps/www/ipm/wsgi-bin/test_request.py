# USAGE
# python simple_request.py

# import the necessary packages
import requests
import datetime
import os
import cv2

# initialize the REST API endpoint URL along with the input
## python server
SERVER_IP = "0.0.0.0"
SERVER_PORT = "5050"

API_BASE_URL = "http://"+SERVER_IP+":"+SERVER_PORT
API_URL = API_BASE_URL+"/ipm"

# image path
IMAGE_PATH = "/aimldl-dat/samples/lanenet/7.jpg"

# timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())
# debug_image_dir = '/aimldl-dat/logs/lanenet/debug'
# debug_image_path = os.path.join(debug_image_dir,timestamp)
# os.makedirs(debug_image_path)
# tmp_ipm_image_path = os.path.join(debug_image_path, "tmp_ipm_image.png")

with open(IMAGE_PATH, "rb") as im:
  res = requests.post(API_URL, files={"image":im})
  # res = requests.post(API_URL, files={"image":im, "basepath":debug_image_dir})
  data = res.json()
  print("response : {}".format(data))

# with open(tmp_ipm_image_path, 'wb') as of:
#   res.raw.decode_content = True
#   of.write(res.content)

