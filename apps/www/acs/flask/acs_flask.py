import fastai
from fastai.vision import *

import numpy as np
import pandas as pd
import os
import sys
import cv2
import simplejson
import re
import shutil
from flask import Flask, request, jsonify, render_template
import time

sys.path.append('../')

from classification import inference, prepare_inference_data, save_csv, save_prediction_images, create_directories, create_timestamp


BASEPATH = "/aimldl-dat/data-gaze/AIML_Annotation/ACS_Kerala_2019_2020/18122019"
ANNON_FILEPATH = os.path.join(BASEPATH, "Categorized_Excel.xlsx")
IMAGES_PATH = os.path.join(BASEPATH, "Image")

export_file_url = '/codehub/tmp'
export_file_name = 'export.pkl'
out_path = "/aimldl-dat/data-gaze/AIML_Annotation/ACS_Kerala_2019_2020/Output"

# image_folder = "/aimldl-dat/data-gaze/AIML_Annotation/ACS_Kerala_2019_2020/Dump/Image/R/"

# def create_directories(time_stamp):
# 	o_path = os.path.join(out_path, time_stamp)
# 	os.mkdir(o_path)
# 	poi_path = os.path.join(o_path, "POI")
# 	non_poi_path = os.path.join(o_path, "NON_POI")
# 	os.mkdir(poi_path)
# 	os.mkdir(non_poi_path)
# 	return o_path, poi_path, non_poi_path

# def create_timestamp():
# 	ts = time.localtime()
# 	a = (time.strftime("%d%m%Y %H%M%S", ts))
# 	date = a[:8]
# 	t = a[9:]
# 	time_stamp = "{}_{}".format(date,t)
# 	return time_stamp

def prediction(image_folder):
	time_stamp = create_timestamp()
	o_path, poi_path, non_poi_path = create_directories(time_stamp)
	test_data = prepare_inference_data(image_folder)
	poi_list, non_poi_list = inference(test_data)
	save_csv(poi_list, non_poi_list, o_path)
	save_prediction_images(poi_list, non_poi_list, poi_path, non_poi_path)
	return o_path

app = Flask(__name__)
# @app.route("/")
# def hello():
# 	return render_template('index.html')
	# return "Image classification example\n"

# @app.route("/predict", methods=["GET"])
# def predict():
#   url = request.args.get('url')
#   o_path = prediction(url)
#   json = {"Prediction_Directory": o_path}
#   return jsonify(json)

@app.route('/predict', methods=['GET','POST'])
def predict():
	# if request.method == 'GET':
	# 	return render_template("index.html")
	if request.method == 'POST':
		folder = request.form["Folder"]
		print("--------------------")
		print(folder)
		o_path = prediction(folder)
		path = str(o_path)
		# js = {"Prediction_Directory": o_path}
		return render_template("result.html", p = path)
	return render_template("index.html")

if __name__ == '__main__':
	app.run()