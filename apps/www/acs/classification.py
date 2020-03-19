__author__ = 'saqibmobin'
__version__ = '1.0'

import fastai
from fastai.vision import *

import numpy as np
import pandas as pd
import os
import sys
import cv2
import shutil
import warnings
warnings.filterwarnings('ignore')
import simplejson
import re

import time
# ts = time.localtime()
# a = (time.strftime("%d%m%Y %H%M%S", ts))
# date = a[:8]
# time = a[9:]
# time_stamp = "{}_{}".format(date,time)

BASEPATH = "/aimldl-dat/data-gaze/AIML_Annotation/ACS_Kerala_2019_2020/18122019"
ANNON_FILEPATH = os.path.join(BASEPATH, "Categorized_Excel.xlsx")
IMAGES_PATH = os.path.join(BASEPATH, "Image")

export_file_url = '/codehub/tmp'
export_file_name = 'export.pkl'
out_path = "/aimldl-dat/data-gaze/AIML_Annotation/ACS_Kerala_2019_2020/Output"

image_folder = "/aimldl-dat/data-gaze/AIML_Annotation/ACS_Kerala_2019_2020/Dump/Image/R/"

xlsx_file = pd.ExcelFile(ANNON_FILEPATH)
acs_df = xlsx_file.parse('Datasheet')

# o_path = os.path.join(out_path, time_stamp)
# os.mkdir(o_path)

# poi_path = os.path.join(o_path, "POI")
# non_poi_path = os.path.join(o_path, "NON_POI")
# os.mkdir(poi_path)
# os.mkdir(non_poi_path)

def create_directories(time_stamp):
	o_path = os.path.join(out_path, time_stamp)
	os.mkdir(o_path)
	poi_path = os.path.join(o_path, "POI")
	non_poi_path = os.path.join(o_path, "NON_POI")
	os.mkdir(poi_path)
	os.mkdir(non_poi_path)
	return o_path, poi_path, non_poi_path

def create_timestamp():
	ts = time.localtime()
	a = (time.strftime("%d%m%Y %H%M%S", ts))
	date = a[:8]
	t = a[9:]
	time_stamp = "{}_{}".format(date,t)
	return time_stamp

def remove_null(df):

	i = 0
	for what in df.Description:
			if re.search('Null', what):
					n = df.loc[i]["Image_Path"]
					df.drop(i, axis=0, inplace=True)
			i+=1
	df.reset_index(inplace=True, drop=True)
	return df

def df_to_dict(df):

	image_dict = {}
	for i in range(len(df)):
			camera = df["Image_Path"][i].split("\\")[4]
	#     image_name = df["Image_Path"][i].split("\\")[5][:14]
			image_name = df["Image_Path"][i].split("\\")[4] + '/' + df["Image_Path"][i].split("\\")[5][:14]
	#     image_path = os.path.join(BASEPATH, camera, image_name, ".jpg")
			annon = df["Ftr_Cry"][i]
			if image_name in image_dict.keys():
					image_dict[image_name].append(annon)
			else:
					image_dict[image_name] = [annon]

	image_dict  = simplejson.loads(simplejson.dumps(image_dict, ignore_nan=True))
	return image_dict

def remove_redundant_label(tags):

		for i in range(len(tags)):
				if i==0:
						if tags[i] != None:
								new = tags[i] + ' '
				else:
						if tags[i] != None:
								new += tags[i] + ' '
		unique = np.unique(new[:-1].split(' '))
		for i in range(len(unique)):
				if i==0:
						lis = unique[i]+ ' '
				else:
						lis += unique[i] + ' '
		return lis[:-1]

def create_dataframe(image_dict):
	df = pd.DataFrame(columns=["Image","Tags"])
	i = 0
	for key in image_dict:
			df.loc[i] = [key] + [image_dict[key]]
			df.loc[i]["Tags"] = remove_redundant_label(df.loc[i]["Tags"])
			i += 1
	return df

def create_dataset(acs_df):
	_df = remove_null(acs_df)
	image_dict = df_to_dict(_df)
	train_val_df = create_dataframe(image_dict)

	src = (ImageList.from_df(train_val_df, IMAGES_PATH, suffix='.jpg')
				 .split_by_rand_pct(0.2)
				 .label_from_df(label_delim=' '))
	tfms = get_transforms()
	data = (src.transform(size=128)
				.databunch().normalize(imagenet_stats))
	return data

def train(data):
	arch = models.resnet34

	acc_02 = partial(accuracy_thresh, thresh=0.2)
	f_score = partial(fbeta, thresh=0.2)
	learn = cnn_learner(data, arch, metrics=[acc_02, f_score])

	learn.fit_one_cycle(10, slice(3.98E-02, 4.37E-02))

	export_file = os.path.join(export_file_url, export_file_name)
	learn.export(export_file)

def prepare_inference_data(image_folder):
	test_data = ImageList.from_folder(image_folder)
	return test_data

def save_prediction_images(poi_list, non_poi_list, poi_path, non_poi_path):
	for image in poi_list.values():
		shutil.copy(image[0], poi_path)
	for image in non_poi_list.values():
		shutil.copy(image, non_poi_path)

def save_csv(poi_list, non_poi_list, o_path):
	poi_df = pd.DataFrame(poi_list.values())
	poi_df.columns = ["Filepath", "Label"]
	poi_df.to_excel(o_path + "/POI_LIST.xls", header=True)

	non_poi_df = pd.DataFrame(non_poi_list.values())
	non_poi_df.columns = ["Filepath"]
	non_poi_df.to_excel(o_path + "/NON_POI_LIST.xls", header=True)

def inference(test_data):
	# model_file = os.path.join(export_file_url, export_file_name)
	learn = load_learner(export_file_url, export_file_name)
	print("------------------------>>>>")
	print(test_data)
	poi_list = {}
	non_poi_list = {}
	for i in range(len(test_data[:100])):
		image_filepath = test_data.items[i]
		image = test_data[i]
		cat = str(learn.predict(image)[0])
		if len(cat) > 0:
			poi_list[i] = str(image_filepath), cat
		else:
			non_poi_list[i] = str(image_filepath)
	return poi_list, non_poi_list

def predict(image_folder):
	# test_data = prepare_inference_data(image_folder)
	# poi_list, non_poi_list = inference(test_data)
	# save_csv(poi_list, non_poi_list)
	# save_prediction_images(poi_list, non_poi_list)
	time_stamp = create_timestamp()
	o_path, poi_path, non_poi_path = create_directories(time_stamp)
	test_data = prepare_inference_data(image_folder)
	poi_list, non_poi_list = inference(test_data)
	save_csv(poi_list, non_poi_list, o_path)
	save_prediction_images(poi_list, non_poi_list, poi_path, non_poi_path)

def main():
	# data = create_dataset(acs_df)
	# train(data)

	predict(image_folder)
	# test_data = prepare_inference_data(image_folder)
	# inference(test_data)

if __name__=='__main__':
	main()