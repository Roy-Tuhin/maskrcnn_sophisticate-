GUNICORN_IP="10.4.71.80"
GUNICORN_PORT="4040"
API_MODEL_KEY="vidteq-ods-7"

API_PREDICT_TYPE="polygon"
# API_PREDICT_TYPE="bbox"
API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predict"
API_URL="http://"+GUNICORN_IP+":"+GUNICORN_PORT+"/api/vision/v2/predict/"+API_PREDICT_TYPE

IMAGE_PATH="/aimldl-dat/samples/lanenet/7.jpg"
