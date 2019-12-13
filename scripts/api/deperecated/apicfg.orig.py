__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# config for api testing
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import socket

user=os.getenv('USER')
hostname=socket.gethostname()
ip=socket.gethostbyname(hostname)

GUNICORN_IP="0.0.0.0"
GUNICORN_IP="10.4.71.80"
GUNICORN_PORT="4040"
## Default Flask python server port
GUNICORN_PORT_FLASK_SERVER=5000

## Default Gunicorn python server port
GUNICORN_PORT_PYTH_SERVER=8000

LOAD_BALANCER_IP="10.4.71.69"
LOAD_BALANCER_PORT="8100"

API_MODEL_KEY="maybeshewill-rld-1"
API_MODEL_KEY="vidteq-hmd-1"
API_MODEL_KEY="vidteq-ods-7"
# API_MODEL_KEY=""

API_PREDICT_TYPE="polygon"
# API_PREDICT_TYPE="bbox"

## Load Balancer

# GUNICORN_IP=LOAD_BALANCER_IP
# GUNICORN_PORT=LOAD_BALANCER_PORT

# GUNICORN_PORT=GUNICORN_PORT_PYTH_SERVER
# GUNICORN_PORT=GUNICORN_PORT_FLASK_SERVER

# GUNICORN_PORT=4041
# GUNICORN_PORT=4141

## alpha
# GUNICORN_IP="10.4.71.69"

## jarvis
# GUNICORN_IP="10.4.71.86"

## ultron
# GUNICORN_IP="10.4.71.80"

## If Apache server is used as proxy
API_URL="http://"+GUNICORN_IP+"/~"+user+"/od/wsgi-bin/index.wsgi/api/vision/tdd"
API_URL="http://"+GUNICORN_IP+"/~"+user+"/od/wsgi-bin/index.wsgi/api/vision/predict/"+API_PREDICT_TYPE

## direct gunicorn server URLs
API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predict"
# API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predict/"+API_PREDICT_TYPE
# API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predictq"


## mask_rcnn samples
# IMAGE_PATH="/aimldl-dat/samples/mask_rcnn/100818_135946_16718_zed_l_057.jpg"
# IMAGE_PATH="/aimldl-dat/samples/mask_rcnn/291018_114921_16718_zed_l_109.jpg"
# IMAGE_PATH="/aimldl-dat/samples/mask_rcnn/311218_101900_16716_zed_l_053.jpg"
# IMAGE_PATH="/aimldl-dat/samples/mask_rcnn/100818_135420_16716_zed_l_032.jpg"
IMAGE_PATH="/aimldl-dat/samples/Trafic_Signs/100818_144130_16716_zed_l_640.jpg"

## lanenet samples
# IMAGE_PATH="/aimldl-dat/samples/lanenet/mini/7.jpg"


IMAGE_DIR="/aimldl-dat/samples/mask_rcnn"

## Initialize the number of requests for the stress test along with
## the sleep amount between requests

NUM_REQUESTS=500
# NUM_REQUESTS=100
# NUM_REQUESTS=1
SLEEP_COUNT=0.05
SLEEP_TIME=300
# SLEEP_TIME=30
SLEEP_TIME=3

IMAGE_API='http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getImage&image='
CSVFILE='/aimldl-dat/logs/020819_115937-934877967_JyKW5h.log.csv'
