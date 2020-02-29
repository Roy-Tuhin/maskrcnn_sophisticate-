__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
# AI Model process script
# --------------------------------------------------------
# Copyright (c) 2020 mangalbhaskar
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
#
## https://www.pyimagesearch.com/2018/02/05/deep-learning-production-keras-redis-flask-apache/
#
# --------------------------------------------------------
"""

import redis
import json
import numpy as np

BASE_PATH_CFG = '/aimldl-cfg'
APP_ROOT_DIR = os.path.join('/aimldl-cod','apps')

if APP_ROOT_DIR not in sys.path:
  sys.path.insert(0, APP_ROOT_DIR)

## custom imports
import _cfg_
import common
appcfg = _cfg_.load_appcfg(BASE_PATH_CFG)

DBCFG = appcfg['APP']['DBCFG']
REDISCFG = DBCFG['REDISCFG']

print("appcfg: {}".format(appcfg))
print("sys.path: {}".format(sys.path))

## connect to Redis server
db = redis.StrictRedis(host=REDISCFG['host'], port=REDISCFG['port'], db=REDISCFG['db'])


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
    print('--------------------------')
    all_rows_for_all_classes = detect_in_image(filename)
    print('===========================')

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

    print('detect_in_image: filename: {}'.format(filename))

    all_rows_for_all_classes = Model.exec_prediction(app.config["DNN_MODULE"], app.config["MODEL_DTLS"], app.config["NET"], [filename], appcfg.UPLOAD_FOLDER, appcfg.LOG_FOLDER, appcfg)

    t2 = time.time()
    time_taken = (t2 - t1)
    print('Total time taken in detect_in_image: %f seconds' %(time_taken))

    return all_rows_for_all_classes


def main():
  print("* Loading model...")
  
  ## TODO - write code to load the model here
  
  print("* Model loaded")

  ## continually pool for new images to process
  while True:
    ## attempt to grab a batch of images from the database, then
    ## initialize the image IDs and batch of images themselves
    queue = db.lrange(REDISCFG['image_queue'], 0, REDISCFG['batch_size'] - 1)
    image_ids = []
    batch = None

    ## loop over the queue
    for Q in queue:
      ## deserialize the object and obtain the input image
      Q = json.loads(Q.decode("utf-8"))
      image = helpers.base64_decode_image(Q["image"],
        REDISCFG['image_dtype'],
        (1, REDISCFG['image_height'], REDISCFG['image_width'], REDISCFG['image_chans']))

      ## check to see if the batch list is None
      if batch is None:
        batch = image
      ## otherwise, stack the data
      else:
        batch = np.vstack([batch, image])

      ## update the list of image IDs
      image_ids.append(Q["id"])

    ## check to see if we need to process the batch
    if len(image_ids) > 0:
      ## process the batch
      print("* Batch size: {}".format(batch.shape))
     
      ## TODO: predict in batch mode, modify the model code

      preds = model.predict(batch)
      results = imagenet_utils.decode_predictions(preds)

      ## loop over the image IDs and their corresponding set of
      ## results from our model
      for (image_id, result_set) in zip(image_ids, results):
        ## initialize the list of output
        output = []

        ## loop over the results and add them to the list of output
        for (imagenet_id, label, prob) in result_set:
          r = {"label": label, "probability": float(prob)}
          output.append(r)

        ## store the output in the database, using
        ## the image ID as the key so we can fetch the results
        
        # db.set(image_id, json.dumps(output))
        db.set(image_id, common.numpy_to_json(output))

      ## remove the set of images from our queue
      db.ltrim(REDISCFG['image_queue'], len(image_ids), -1)

    ## sleep for a small amount
    time.sleep(REDISCFG['server_sleep'])

  return


## if this is the main thread of execution start the model server process
if __name__ == "__main__":
  main()
