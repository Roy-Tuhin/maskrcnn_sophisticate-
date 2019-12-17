# How to Setup AI API

## NOTES
* modelinfo should already be loaded in the database before running the web application
* sample data should be available at path: `/aimldl-dat/samples`


## Setup

* Create the symlink to the apache root directory - **if Apache server is used with wsgi**
  ```bash
  cd $HOME/public_html
  ln -s /codehub/apps/www/od
  sudo service apache2 restart
  ```
* quick testing:
  ```bash
  cd /codehub/apps/www/od/wsgi-bin
  gunicorn web_server:app
  ```
* Test from the web
  * access the url from the web:`http://127.0.0.1:8000/`
  * upload the image and verify if API json response is returned or not
* Test from the command line
  ```bash
  cd /codehub/scripts/api
  ## change the sample image name and path inside the shell script
  #
  ## apicfg.sh -> change the configuration for testing
  source curl_api.sh
  ```


## Deployment Options

1. **Flask server**
  * not recommened in production
  * not working
  * Error
    * https://stackoverflow.com/questions/51127344/tensor-is-not-an-element-of-this-graph-deploying-keras-model
      ```
      ## ValueError: Tensor Tensor("mrcnn_detection/Reshape_1:0", shape=(1, 100, 6), dtype=float32, device=/device:GPU:0) is not an element of this graph
      ```
2. **Gunicorn server** - recommended for now
  * previous deployment
  * working with performance fixes
  * **todo:** get the IP address from the setup configurations
    ```bash
    ip="a.b.c.d"
    gunicorn web_server:app -b "$ip:4040"
    ```
3. **Apache server**
  * experimental
  * working with performance fixes similar performance to gunicorn server
4. **(Apache + Redis) server**
  * experimental
  * code in place, not yet tested
    ```bash
    sudo service apache2 start
    redis-server
    python model_server.py
    ```
5. **(Gunicorn + Redis) server**
  * experimental
  * code in place, not yet tested
6. **(nginx + Gunicorn + Redis) server**
  * not yet explored


## Quick API Testing

1. using `curl`
  ```bash
  cd /codehub/scripts/api
  ## apicfg.sh -> change the configuration for testing
  source curl_api.sh
  ```
2. using `python`
  ```bash
  cd /codehub/scripts/api
  ## apicfg.py -> change the configuration for testing
  python call_api.py
  ```

##  Credits
* pyimagesearch
  * [part-1](https://blog.keras.io/building-a-simple-keras-deep-learning-rest-api.html)
  * [part-2](https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/)
  * [Pyimagesearch: part-3: Deep learning in production with Keras, Redis, Flask, and Apache](https://www.pyimagesearch.com/2018/02/05/deep-learning-production-keras-redis-flask-apache/)


## References
* http://flask.pocoo.org/docs/patterns/fileuploads/
* https://stackoverflow.com/questions/49511753/python-byte-image-to-numpy-array-using-opencv
* https://stackoverflow.com/questions/46136478/flask-upload-how-to-get-file-name
* https://www.programcreek.com/python/example/60712/werkzeug.secure_filename
* https://stackoverflow.com/questions/39801728/using-flask-to-load-a-txt-file-through-the-browser-and-access-its-data-for-proce
