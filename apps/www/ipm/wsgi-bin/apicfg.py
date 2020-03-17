## python server
SERVER_IP = "0.0.0.0"
SERVER_PORT = "5050"

API_BASE_URL = "http://"+SERVER_IP+":"+SERVER_PORT
API_URL = API_BASE_URL+"/ipm"

LOG_FOLDER = '/aimldl-dat/logs'

IPM_IMAGE_SAVE_PATH = '/aimldl-dat/logs/www/ipm/out'

IMAGE_PATH = "/aimldl-dat/samples/lanenet/7.jpg"
WEIGHTS_PATH = "/codehub/external/lanenet-lane-detection/model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt"

# Set to true if you want to resize to 720*1280
# RESIZE = 'True'
RESIZE = "Flase"
ALLOWED_IMAGE_TYPE = ['.pdf','.png','.jpg','.jpeg','.tiff','.gif']
# initialize the number of requests for the stress test along with
# the sleep amount between requests
NUM_REQUESTS = 500
# NUM_REQUESTS=1
SLEEP_COUNT = 0.05
SLEEP_TIME = 300
SLEEP_TIME = 3

IMAGE_API = 'http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getImage&image='

IPM_REMAP_FILE_PATH = 'data/tusimple_ipm_remap.yml'

# RESPONSE_AS_JSON = True
RESPONSE_AS_JSON = False

# DEBUG = False
