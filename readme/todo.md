todo

* source code to be cloned inside the container - aimldl, codehub and tensorflow
* sudo option to be fixed for the user - password issue
* base image till virtual environment
* complete image with the fixes for aidev
* push image to the docker hub



AIMLDL_ENV=production ##development

$ docker login --username=yourhubusername --email=youremail@company.com

---

## Different Container for uilding Scalable AI as a microservice


**Requirements**
* redis
  * redis server, port to communicate wth model server and gunicorn
  * cpu only - gpu not required
* mongodb
  * volume mount, 27017 port to be exposed
  * cpu only - gpu not required
* full fledged ai
  * gunicorn
  * model-server


**full fledged AI container requirements**
* different arch have different AI frameworks requirement to run
* dnn is dependent on specific version os AI framework
* GPU (nvidia) accessibility inside the container is the must
* different CUDA, cuDNN, tensorRT version may be required
* per container; gpu memory must be configurable and limits to smooth functioning
* multiple gpu-containers should be able to run on the same physical system


Mask_RCNN
* keras: 2.2.2, tensorflow: 1.9.0, CUDA-9.0
* keras: 2.2.3 to 2.3.5, tensorflow: 1.131.1, CUDA-10