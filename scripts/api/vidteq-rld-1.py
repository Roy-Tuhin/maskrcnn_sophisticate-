GUNICORN_IP="10.4.71.31"
GUNICORN_PORT="4100"
API_MODEL_KEY="vidteq-rld-1"

API_PREDICT_TYPE="lane"
API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predict"
# API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predict/"+API_PREDICT_TYPE

IMAGE_PATH="/aimldl-dat/samples/lanenet/7.jpg"
