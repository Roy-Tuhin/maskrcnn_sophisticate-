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

from PIL import Image
from io import BytesIO

import test

test.post_image_to_api(IMAGE_PATH, API_URL)

