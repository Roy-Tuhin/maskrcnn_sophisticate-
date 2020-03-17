import requests
from PIL import Image
import io

def post_image_to_api(image_path, api_url):
  with open(image_path, "rb") as im:
    res = requests.post(api_url, files={"image":im})
    img = Image.open(io.BytesIO(res.content))
    img.show()

  ## TODO: Fix for json response
  # with open(IMAGE_PATH, "rb") as im:
  #   res = requests.post(API_URL, files={"image":im})
  #   data = res.json()
  #   print("response : {}".format(data))

