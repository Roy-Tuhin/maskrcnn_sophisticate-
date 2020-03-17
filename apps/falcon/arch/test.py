import requests
import cv2

resp = requests.post("http://localhost:8888/predict", json={"url": '/aimldl-dat/samples/mask_rcnn/100818_135420_16716_zed_l_032.jpg'})

print(resp)
# test_url = "http://localhost:8888/predict"
# content_type = 'image/jpeg'
# headers = {'content-type': content_type}

# img = cv2.imread('/aimldl-dat/samples/mask_rcnn/100818_135420_16716_zed_l_032.jpg')
# # encode image as jpeg
# _, img_encoded = cv2.imencode('.jpg', img)
# # send http request with image and receive response
# response = requests.post(test_url, data=img_encoded.tostring(), headers=headers)