import os
import datetime
import glog as log
import json
import io

import flask
from flask import request, render_template, Response, send_from_directory, make_response
from flask_cors import CORS, cross_origin
from werkzeug import secure_filename

import apicfg
import helpers

ipm_image_save_path = apicfg.IPM_IMAGE_SAVE_PATH

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
  res = None
  try:
    image = request.files["image"]

    timestamp = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())
    ipm_image_name = timestamp+".png"

    image_name = secure_filename(image.filename)

    if image and helpers.allowed_file(image_name, apicfg.ALLOWED_IMAGE_TYPE):
      ipm_remap_file_path = apicfg.IPM_REMAP_FILE_PATH
      im, height, width = helpers.get_ipm_image(image, ipm_remap_file_path)

      response_as_json = apicfg.RESPONSE_AS_JSON
      if response_as_json:
        ## TODO: because images are saved on filesystem, automatic mechanism needs to be build in to purge the old data otherwise disk storage overflow may happen
        if not os.path.exists(ipm_image_save_path):
          os.makedirs(ipm_image_save_path)
          log.info("IPM images are saved in: {}".format(ipm_image_save_path))
        
        ipm_image_path = os.path.join(ipm_image_save_path, ipm_image_name)
        im.save(ipm_image_path)

        log.info("IPM image path: {}".format(ipm_image_path))

        res_code = 200
        apires['image_name'] = image_name
        apires['status_code'] = res_code
        apires['success'] = True
        apires['ipm_image_name'] = ipm_image_name
        apires['width'] = width
        apires['height'] = height
        apires['ipm_image_url'] = apicfg.API_BASE_URL+"/get_ipmimage/"+ipm_image_name
      else:
        ## Ref: https://geopyspark.readthedocs.io/en/v0.1.0/tutorials/greyscale_tile_server_example.html
        bio = io.BytesIO()
        im.save(bio, 'PNG')
        res = make_response(bio.getvalue())
        res.headers['Content-Type'] = 'image/png'
        res.headers['Content-Disposition'] = 'filename=%d.png' % 0

      log.info("Image Processed: {}".format(image_name))
    else:
      res_code = 400
      apires['image_name'] = image_name
      apires['status_code'] = res_code
      apires['description'] = 'Invalid Request'
      log.info("Invalid Request: {}".format(image_name))
  except Exception as e:
    res_code = 500
    apires['status_code'] = res_code
    log.error("Exception in detection", exc_info=True)

  if not res:
    res = Response(json.dumps(apires), status=res_code, mimetype='application/json')

  return res


if __name__ == "__main__":
  """
  Submit a request via cURL:
  curl -X POST -F image=@<image> 'http://localhost:<port>/ipm'
  """
  log.info("Please wait until server has fully started")
  app.run(debug = False, threaded = False)
