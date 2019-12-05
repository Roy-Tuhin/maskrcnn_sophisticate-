API_DOC = {
  'IDS':None
  ,'ARCHS': None
  ,'ORGNAME': None
  ,'API_VISION_BASE_URL': None
  ,'API_VERSION': None
  ,'DOCS':{
    'predict': {
      'deprecated':False
      ,'url':'<API_VISION_BASE_URL>/<API_VERSION>/predict'
      ,'type':'POST'
      ,'params':{
        'image':'<multipart/form-data; >'
        ,'q':'<orgname>-<id>-<rel_num>'
      }
      ,'description':'The main api call to make the predictions.'
      ,'examples':{
        '0':'curl -X POST -F image=@${image} "${apiurl}"'
      }
    }
    ,'batch_predict': {
      'deprecated':False
      ,'url':'<API_VISION_BASE_URL>/<API_VERSION>/predict'
      ,'type':'POST'
      ,'params':{
        'images':'array(<multipart/form-data>)'
        ,'q':'<orgname>-<id>-<rel_num>'
      }
      ,'description':'Under Development: Uses queue mechanism for prediction on the images. Input is the array of multipart/form-data images'
    }
    ,'models': {
      'deprecated':False
      ,'url':'<API_VISION_BASE_URL>/<API_VERSION>/models/[ [<orgname>][-<id>][-<rel_num>] ]'
      ,'type':'GET'
      ,'params':None
      ,'description':'Returns the original image'
      ,'examples':{
        '0':'<API_VISION_BASE_URL>/<API_VERSION>/models'
        ,'1':'<API_VISION_BASE_URL>/<API_VERSION>/models/vidteq'
        ,'2':'<API_VISION_BASE_URL>/<API_VERSION>/models/vidteq-hmd'
        ,'3':'<API_VISION_BASE_URL>/<API_VERSION>/models/vidteq-hmd-1'
      }
    }
    ,'tdd': {
      'deprecated':False
      ,'url':'<API_VISION_BASE_URL>/<API_VERSION>/tdd'
      ,'type':'POST'
      ,'params':None
      ,'description':'Used for test driven development and internal api testing.'
    }
  }
}
