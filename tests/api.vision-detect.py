import requests

def call_post_1():
  # base_url="www.server.com"

  base_url="http://localhost:8383/anything"

  # final_url="/{0}/friendly/{1}/url".format(base_url,'blah')
  # payload = {'number': 2, 'value': 1}

  # r = requests.post(final_url, data=payload)
  # print(r.text) #TEXT/HTML
  # print(r.status_code, r.reason) #HTTP


  # final_url="/{0}/friendly/{1}/url".format(base_url,'blah')

  payload = {'key1': 'value1', 'key2': 'value2'}
  # final_url="http://httpbin.org/post"

  r = requests.post(base_url, data=payload)
  print(r.text)



## https://stackoverflow.com/questions/11551268/python-post-request-with-image-files
def call_vision_api(q=None, img=None, orgname=None, defaults=False):
  import base64
  import json

  if q is None:
    "tsd-2"

  if img is None:    
    img = '1.jpg'
  
  with open(img,'rb') as im:
    b64im = base64.b64encode(im.read())
    # print(b64im);
    
    if defaults:
      params = {
        "image": b64im
        ,"name": img
        ,"q": q
        ,"orgname": orgname
      }
    else:
      ## check for default values
      params = {
        "image": b64im
        ,"name": img
      }
    
    # print(params)
    apiurl = "http://10.4.71.69:4040/api/vision/detect"
    try:
      # requests.add_header("Content-type", "application/x-www-form-urlencoded; charset=UTF-8")
      res = requests.post(apiurl
        ,data=params
        ,headers={"content-type":"application/x-www-form-urlencoded; charset=UTF-8"}
      )
      # print(res.headers)
      # print(res.text)
      print("-----------------------")

      data = json.loads(res.text)
      print("data: {}".format(data))
      print("-----------------------")

      print("data['api']: {}".format(data['api']))
      
      print("-----------------------")

      detections = data['api']['detections']

      # import matplotlib.ply as plt
    except Exception as e:
      print(e)




if __name__ == '__main__':
  # call_post_1()
  
  ## test calls for orgname="mmi"
  ## orgname="mmi" is defaults in server configuration
  # call_vision_api(q='tsd-2', img="test.tsd-2.jpg")
  # call_vision_api(q='tsr-1', img="test-2.tsr-1.jpg")
  # call_vision_api(q='sdr-1', img="test.sdr-1.jpg")

  # workon py_3-6-5_2018-11-21
  # call_vision_api(q='road-1', img="test.road-1.jpg", orgname="vidteq")
  # call_vision_api(q='ballon-1', img="test.balloon-1.jpg", orgname="vidteq")
  # call_vision_api(q='coco-1', img="test.coco-1.jpg", orgname="vidteq")
  # #
  # call_vision_api(q='ods-1', img="test.ods-1.jpg", orgname="matterport")
  call_vision_api(img="test.tsd-2.jpg", defaults=True)
