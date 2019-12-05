

@app.route(API_VISION_BASE_URL+'/detect', methods=['POST'])
@cross_origin()
def upload_base64_file_and_detect_in_image():
  # <base64_image, image_name>
  # log.debug("request: {}".format(request))
  # log.debug("request.values: {}".format(request.values))
  base64_image = request.values.get("image")
  # log.debug("base64_image: {}".format(base64_image))
  image_name = request.values.get("name")
  log.debug("image_name: {}".format(image_name))
  query_q = request.values.get("q")
  log.debug("query_q: {}".format(query_q))
  query_orgname = request.values.get("orgname")
  log.debug("query_orgname: {}".format(query_orgname))

  # data = request.get_json()
  data = request;
  # log.debug(data)
  if base64_image is None:
    log.debug("No valid image!")
    res_code = 400
    # mimetype = "application/json"
    msg = "'Not a valid base64 image!'"
    # res = Util.getResponse(jsonify({'error': msg}), res_code, mimetype)
    log.debug("----: {}".format(msg))
    res = jsonify({'error': msg})
    res.status_code = res_code
    return res
  else:
    log.debug("base64_image::")
    # log.debug(base64_image)

    all_rows_for_all_classes = ""

    log.debug("image_name::")
    log.debug(image_name)
    
    log.debug("query_q::")
    log.debug(query_q)

    log.debug("query_orgname::")
    log.debug(query_orgname)

    filename = os.path.join(appcfg.UPLOAD_FOLDER, image_name)
    with open(filename, "wb") as f:
      f.write(base64.b64decode(base64_image))
  
  res = getModelResponse(query_orgname, query_q, filename)
  # log.debug("...................res: {}".format(res))
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

