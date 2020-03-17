import os
import datetime
import glog as log
import json

import flask
from flask import request, render_template, Response, send_from_directory
from flask_cors import CORS, cross_origin
from werkzeug import secure_filename

import apicfg
import helpers

ipm_image_save_path = apicfg.IPM_IMAGE_SAVE_PATH
print("IPM images are saved in: {}".format(ipm_image_save_path))

# initialize our Flask application and the Keras model
app = flask.Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route('/', methods=['GET', 'POST'])
def upload_file():
  if request.method == 'POST':
    res = process_request()
    return res

  return render_template('index.html')


@app.route("/get_ipmimage/<filename>", methods=["GET"])
def get_image(filename):
  res_code = 400
  apires = {
    'success': False
    ,'status_code': res_code
    ,'image_name': filename
  }
  ipm_image_path = os.path.join(ipm_image_save_path, filename)
  try:
    if os.path.exists(ipm_image_path):
      res = send_from_directory(ipm_image_save_path, filename)
    else:
      res_code = 400
      apires['status_code'] = res_code
      apires['description'] = 'File Not Found'
      res = Response(json.dumps(apires), status=res_code, mimetype='application/json')
      log.info("File Not Found")
  except Exception as e:
    res_code = 500
    apires['status_code'] = res_code
    apires['description'] = 'Internal Error'
    log.error("Exception in retriving image file", exc_info=True)
    res = Response(json.dumps(apires), status=res_code, mimetype='application/json')

  return res


@app.route("/ipm", methods=["POST"])
def process_request():
  """
  Main function for IPM AI API
  """
  res_code = 400
  apires = {
    'success': False
    ,'status_code': res_code
    ,'ipm_image_name': None
    ,'ipm_image_url': None
    ,'image_name': None
  }

  try:
    image = request.files["image"]
    if not os.path.exists(ipm_image_save_path):
      os.makedirs(ipm_image_save_path)

    timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())
    ipm_image_name = timestamp+".png"
    ipm_image_path = os.path.join(ipm_image_save_path, ipm_image_name)

    image_name = secure_filename(image.filename)

    if image and helpers.allowed_file(image_name, apicfg.ALLOWED_IMAGE_TYPE):
      ipm_remap_file_path = apicfg.IPM_REMAP_FILE_PATH
      im = helpers.get_ipm_image(image, ipm_remap_file_path)

      im.save(ipm_image_path)

      res_code = 200
      apires['image_name'] = image_name
      apires['status_code'] = res_code
      apires['success'] = True
      apires['ipm_image_name'] = ipm_image_name

      apires['ipm_image_url'] = apicfg.API_BASE_URL+"/get_ipmimage/"+ipm_image_name

      log.info("Image Processed")
    else:
      res_code = 400
      apires['image_name'] = image_name
      apires['status_code'] = res_code
      apires['description'] = 'Invalid Request'
      log.info("Invalid Request")
  except Exception as e:
    res_code = 500
    apires['status_code'] = res_code
    log.error("Exception in detection", exc_info=True)

  res = Response(json.dumps(apires), status=res_code, mimetype='application/json')
  return res


if __name__ == "__main__":
  """
  # USAGE
  # Start the server:
  #   python run_keras_server.py
  # Submit a request via cURL:
  #   curl -X POST -F image=@<image> 'http://localhost:<port>/ipm'
  # Submit a request via Python:
  # python simple_request.py

  # import the necessary packages
  """
  print(("* Loading Keras model and Flask starting server..."
    "please wait until server has fully started"))
  # app.run(debug = False, threaded = False, host=IP, port=PORT)
  app.run(debug = False, threaded = False)
