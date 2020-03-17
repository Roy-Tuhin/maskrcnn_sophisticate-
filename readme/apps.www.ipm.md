# IPM API

An easy, interface friendly cross-platform to generate bird's view images using inverse perspective mapping

## Start the server
```bash
cd /codehub/apps/www/ipm/wsgi-bin
./start.sh
```

## Quick API Testing
1. Using web browser
  * Open `http://0.0.0.0:5050/` in the browser after starting the server, select an image and click on send
  * The response should be bird's eye view of given image

2. Using `python`
```bash
cd /codehub/apps/www/ipm/wsgi-bin
python test_request.py
```

##  Credits

* [IMP Matrix](https://maybeshewill-cv.github.io/lanenet-lane-detection)
* https://github.com/MaybeShewill-CV/Easy-Ipm-Client
* [part-1](https://blog.keras.io/building-a-simple-keras-deep-learning-rest-api.html)
* [part-2](https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/)
* [part-3: Deep learning in production with Keras, Redis, Flask, and Apache](https://www.pyimagesearch.com/2018/02/05/deep-learning-production-keras-redis-flask-apache/)

## References

* https://www.pythonanywhere.com/forums/topic/13795/
* https://stackoverflow.com/questions/7391945/how-do-i-read-image-data-from-a-url-in-python