#!/usr/bin/env python

# --------------------------------------------------------
# Copyright (c) 2018 VidTeq
# Licensed under The MIT License [see LICENSE for details]
# Written by Mangal Bhaskar
# --------------------------------------------------------
#
# http://flask.pocoo.org/docs/patterns/fileuploads/
#
# --------------------------------------------------------

import flask

from flask import request, redirect, url_for, send_from_directory, render_template
from flask_cors import CORS, cross_origin
from werkzeug import secure_filename
from flask import Response

import json
import cv2
from flask import jsonify
import time
import base64
##  pandas as pd

import os
import sys

BASE_PATH_CFG = '/aimldl-cfg'
APP_ROOT_DIR = os.path.join('/aimldl-cod','apps')

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(0, APP_ROOT_DIR)

## custom imports
import _cfg_
appcfg = _cfg_.load_appcfg(BASE_PATH_CFG)
API_VISION_BASE_URL = appcfg['APP']['API_VISION_BASE_URL']

from falcon.arch import Model


app = flask.Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

print("sys.path: {}".format(sys.path))


@app.route(API_VISION_BASE_URL+'/')
def get_vision_site():  
  return "<h1>Coming Soong Vision API Web Site!</h1><p>Refer: /api/vision/v1<p>"


@app.route("/")
def homepage():
  return "Welcome to the PyImageSearch Keras REST API!"


def setAndLoadModel(args):
  print("Inside setAndLoadModel::")
  print("args.ORG_NAME - args.ID - args.REL_NUM:: {} {} {}".format(args.ORG_NAME, args.ID, args.REL_NUM))

  # get model details
  modelDtls = Model.getDetails(args)

  if modelDtls is not None:
    app.config["MODEL_DTLS"] = modelDtls  
    print("setAndLoadModel:Model Details: {}".format(app.config["MODEL_DTLS"]))

    args.DNNARCH = app.config["MODEL_DTLS"]["DNNARCH"]
    ## TBD Null check doe DNN_MODULE
    app.config["DNN_MODULE"] = Util.getDnnModule(args) ## "pixel.faster_rcnn_end2end"
    # load model
    app.config["NET"] = Model.load(app.config["DNN_MODULE"], app.config["MODEL_DTLS"], args)
    return True
  
  return False


def getModelResponse(query_orgname, query_q, filename):
  if query_orgname:
    appcfg.ORG_NAME = query_orgname

  if query_q:
    id_relnum = query_q.split("-")
    appcfg.ID = id_relnum[0]
    appcfg.REL_NUM = id_relnum[1]

  try:
    # print("query paramas:: ORG_NAME - [ID,REL_NUM]:: {} {}".format(query_orgname, id_relnum))
    setAndLoadModel(appcfg)
  except Exception as e:
    print(e)
    res_code = 404
    mimetype = "application/json"
    msg = "'Not a Valid Model: check ORG_NAME, ID, REL_NUM!'"
    print("----: {}".format(msg))
    res = jsonify({'error': msg})
    res.status_code = 404
    return res

  try:
    print ('--------------------------')
    all_rows_for_all_classes = detect_in_image(filename)
    print ('===========================')

    ##TBD: set the proper response code
    # mimetype = "application/json"
    res_code = 200
    # res = Util.getResponse(json.dumps(all_rows_for_all_classes), res_code, mimetype)
    
    
    all_rows_for_all_classes['status_code'] = res_code
    # res_json = jsonify(all_rows_for_all_classes)
    res_json = Util.numpy_to_json(all_rows_for_all_classes)
    res = Response(res_json, status=res_code, mimetype='application/json')

    ## https://stackoverflow.com/questions/5085656/how-to-get-the-current-port-number-in-flask
    # res.headers['Link'] = 'http://10.4.71.69:4040'

  except Exception as e:
    print(e)
    # mimetype = "application/json"
    res_code = 500
    msg = "'It is probably a bug in the application, please report to: bhaskar@vidteq.com!'"
    print("----: {}".format(msg))
    res = jsonify({'error': msg})
    res.status_code = res_code
    return res

  return res


def allowed_file(filename):
  fn, ext = os.path.splitext(os.path.basename(filename))  
  return ext.lower() in appcfg['ALLOWED_IMAGE_TYPE']


def detect_in_image(filename):
    t1 = time.time()

    print ('detect_in_image: filename: {}'.format(filename))

    all_rows_for_all_classes = Model.exec_prediction(app.config["DNN_MODULE"], app.config["MODEL_DTLS"], app.config["NET"], [filename], appcfg.UPLOAD_FOLDER, appcfg.LOG_FOLDER, appcfg)

    t2 = time.time()
    time_taken = (t2 - t1)
    print ('Total time taken in detect_in_image: %f seconds' %(time_taken))

    return all_rows_for_all_classes


## TBD: parsing query parameters
def parse_query_params(query):
  return ""


@app.route('/todo', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        print(request.values)

        file = request.files['file']

        if file and allowed_file( secure_filename(file.filename) ):
            # query_q = file.q
            ## TBD: query type

            t1 = time.time()
            filename = secure_filename(file.filename)
            print("appcfg.UPLOAD_FOLDER: {}".format(appcfg.UPLOAD_FOLDER))
            
            # Util.mkdir_p(appcfg.UPLOAD_FOLDER)

            file.save(os.path.join(appcfg.UPLOAD_FOLDER, filename))
            print ("filename to be predicted: {}".format(filename))
            print ('--------------------------')            
            t2 = time.time()
            time_taken = (t2 - t1)
            print ('Total time taken in upload_file: %f seconds' %(time_taken))

            print("request.values: {}".format(request.values))
            query_orgname = request.values['orgname']    
            print("query_orgname::")
            print(query_orgname)
            query_q = None
            if query_orgname:
              query_q = request.values['q-'+query_orgname]    
              print("query_q::")
              print(query_q)

            res = getModelResponse(query_orgname, query_q, filename)
            return res
    
    return render_template('index.html')


## TBD: Response Codes

@app.route(API_VISION_BASE_URL+'/')
def get_vision_site():  
  return "<h1>Coming Soong Vision API Web Site!</h1><p>Refer: /api/vision/v1<p>"


## Publishes the specifications of the Vision API for a particular version
## Version in the URL only used for publishing specification
## Version 'v1' should not be used in the acutal API CALL
# @app.route(API_VISION_BASE_URL+'/v1')
@app.route(API_VISION_BASE_URL+'/v1/')
def get_vision_api_spec():
  # data = json.dumps(appcfg.APIS)

  ##TBD: set the proper response code
  res_code = 200
  # mimetype = "application/json"
  # res = Util.getResponse(data, res_code, mimetype)  
  res = jsonify(appcfg.APIS)
  res.status_code = res_code

  return res

@app.route(API_VISION_BASE_URL+'/detect', methods=['POST'])
@cross_origin()
def upload_base64_file_and_detect_in_image():
  # <base64_image, image_name>
  # print("request: {}".format(request))
  # print("request.values: {}".format(request.values))
  base64_image = request.values.get("image")
  # print("base64_image: {}".format(base64_image))
  image_name = request.values.get("name")
  print("image_name: {}".format(image_name))
  query_q = request.values.get("q")
  print("query_q: {}".format(query_q))
  query_orgname = request.values.get("orgname")
  print("query_orgname: {}".format(query_orgname))

  # data = request.get_json()
  data = request;
  # print(data)
  if base64_image is None:
    print("No valid image!")
    res_code = 400
    # mimetype = "application/json"
    msg = "'Not a valid base64 image!'"
    # res = Util.getResponse(jsonify({'error': msg}), res_code, mimetype)
    print("----: {}".format(msg))
    res = jsonify({'error': msg})
    res.status_code = res_code
    return res
  else:
    print("base64_image::")
    # print(base64_image)

    all_rows_for_all_classes = ""

    print("image_name::")
    print(image_name)
    
    print("query_q::")
    print(query_q)

    print("query_orgname::")
    print(query_orgname)

    filename = os.path.join(appcfg.UPLOAD_FOLDER, image_name)
    with open(filename, "wb") as f:
      f.write(base64.b64decode(base64_image))
  
  res = getModelResponse(query_orgname, query_q, filename)
  # print("...................res: {}".format(res))
  return res


@app.route(API_VISION_BASE_URL+'/detections/<filename>')
@cross_origin()
def get_content(filename):
  # out_file = os.path.join(appcfg.LOG_FOLDER, filename)
  res = "null"
  im_name, ext = os.path.splitext(filename)
  FD = appcfg.FILE_DELIMITER
  print(im_name)
  print(ext)
  out_file = Util.getOutFileName(appcfg.LOG_FOLDER, im_name, ext, appcfg)
  print(out_file)
  if ext.lower() in appcfg['ALLOWED_FILE_TYPE']:
    # csv_file = pd.DataFrame(pd.read_csv(out_file, sep = ";", header = 0, index_col = False))
    # res = csv_file.to_json(orient = "records", date_format = "epoch", double_precision = 10, force_ascii = True, date_unit = "ms", default_handler = None)

    all_bbox = [] 
    if os.path.exists(out_file):
      for row in Util.readLine(out_file, FD, True):
        all_bbox.append(row)

    all_rows = {
      "bbox":all_bbox
    }

    res = json.dumps(Util.createResponseForVisionAPI(im_name, FD, appcfg.ID, all_rows, appcfg.API_VISION_BASE_URL))

  # elif ext.lower() in appcfg['ALLOWED_IMAGE_TYPE']:
  #   csvFileName = Util.getOutFileName(appcfg.LOG_FOLDER, filename, ".csv", appcfg)
  #   if not os.path.exists(out_file) and os.path.exists(csvFileName):
  #     ## create vis image
  #     detections = Util.vis_detections_from_csvfile(os.path.basename(out_file), FD, appcfg.UPLOAD_FOLDER, out_file, appcfg)
      
  #     if detections:
  #       res = send_from_directory(appcfg.LOG_FOLDER, filename)

  #   elif os.path.exists(out_file):
  #     res = send_from_directory(appcfg.LOG_FOLDER, filename)
    
  return res


@app.route(API_VISION_BASE_URL+'/uploads/<filename>')
@cross_origin()
def uploaded_file(filename):
  out_file = os.path.join(appcfg.UPLOAD_FOLDER, filename)
  res = "null"
  
  if os.path.exists(out_file):
    fn, ext = os.path.splitext(os.path.basename(out_file))

    if ext.lower() in appcfg['ALLOWED_IMAGE_TYPE']:
      print ('uploaded_file: filename: {}'.format(filename))
      res = send_from_directory(appcfg.UPLOAD_FOLDER, filename)
  
  return res



# setAndLoadModel(appcfg)

## TBD:: get host from config file
if __name__ == '__main__':
    # app.run(debug=True)
    app.run(debug=True, host='10.4.71.69')
    # Warmup
    # Model.warmup(app.config["DNN_MODULE"], app.config["NET"])