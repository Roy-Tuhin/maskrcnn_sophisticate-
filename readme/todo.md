todo

* source code to be cloned inside the container - aimldl, codehub and tensorflow
* sudo option to be fixed for the user - password issue
* base image till virtual environment
* complete image with the fixes for aidev
* push image to the docker hub

* debug tensorflow compilation - docker image issue due `*.h` file missing
* delete docker hub repo, recreate it with fixed image with proper versions
* compile optimization tools



AIMLDL_ENV=production ##development

$ docker login --username=yourhubusername --email=youremail@company.com


## TODO Docker Container


- docker working of mask-rcnn issues
  - take user input for installation -> get the python environment name
  - use symlink for python environment using a common name
  - high computation time

- backward compatibility
  - moving the virtualenv to abs path can work with the symlink creation
    ```bash
    mkdir -p /virtualmachines/virtualenvs; rm -rf /virtualmachines/virtualenvs; ln -s /codehub/virtualmachines/virtualenvs /virtualmachines/virtualenvs
    ```


- Conver logs and data-mongo directories to symlinks
  * /codehub/scripts/utils/dir_to_link.sh


- annon - change the format to mscoco
- support for tfrecords
- enhance spec for classification
- user acceptance criteria for new model
- qgis python plugin - AI based


* Take user specific inputs for the configuration

* Create symlinks to all the release models inside the log directory -> so devloper can use release models witht he log file path without chaning the configuration
e

**Change List**

* BUILD_FOR_CUDA_VER is added in version.sh, defaults to 10.0
* virtual env path is moved out of codehub and now it's the system root by default
* config is moved out of codehub and now it's at the system root by default as /codehub-config
* /aimldl-dat/logs and /aimldl-dat/data-mongo are now symlinks


* aimldl.setup issues:
  - hard dependency on python due to paths.yml and app.yml file creation



## TODO

* **Bin List**
  * specifications to be created for annotations: ods, rld, rbd
  * annotation workflow to be updated for lanenet
  * read/spec update on environment variables for AI and CODEHUB environment variables
  * generate systemd scripts for gunicorn automatically from the setup scripts using user defined and detected options
  *  annon: verifydb.py to test with oasis release db change
  * aimldl-cod workflow diagram
  * clear instructions on how to execute TEPPr workflow
  * multiple model support on different ports, same machine. That means concept of default model key needs to be overridden at the server start time
  * API test scripts for different port simultaneously
  * queue and scheduler in prediction
  * production server configurations and scripts
    * as a service
    * load balancer
    * multi-model support
    * tensorflow memory management
    * mAP reports on published models
    * stress-test reports
  * docker command errors: provide debug logs when using docker shell scripts to the command line
  * Starting AI API port: throw error if DB connection is not up and running
  * annon - creating AI datasets should have same labels in different splits; currently gets different labels - bug
  * script to clone internal git repo for the first time setup, give the required inputs in the local config setup
  * docker script `gpg vs gpg2` conditional selection in docker image - put a note in mongodb setup
  * AI model version management using `git-lfs`
  * Full interation of TEPPr workflow items
  * tensorboard enhancements
  * integration of lanenet
  * hyper-tuning mask_rcnn
  * system stats usage reports
  * API usage stats in DB, prediction results and feature vector for CBIR consumption
  * motion_rcnn and medicalkitdetection for 3D extraction from mask_rcnn
  * `common.py` code redundancy to be removed


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

Training:
* keras: 2.2.2, tensorflow: 1.9.0, CUDA-9.0
* keras: 2.2.3 to 2.3.5, tensorflow: 1.13.1, CUDA-10.0

Prediction:
* In addition to above env, it also works with
* keras: 2.2.4, tensorflow: 1.14.0, CUDA-10.0


## Bugs

* New setup errors: python virtual environment - todo
    ```
    ERROR: jupyter-console 6.0.0 has requirement prompt-toolkit<2.1.0,>=2.0.0, but you'll have prompt-toolkit 3.0.2 which is incompatible.
    ERROR: locustio 0.13.5 has requirement gevent==1.5a2, but you'll have gevent 1.4.0 which is incompatible.
    Installing collected packages: numpy, numexpr, scipy, Six, python-dateutil, pyparsing, kiwisolver, cycler,
    ```
* CUDA 10.2 stack till tensorRT - todo
  * cuda: 10.2
  * libnvinfer-dev: 6.0.1-1+cuda10.2
* Fix the tensorRT version in Docker file wrt to specific CUDA, cuDNN version. Currently, latest tensorRT also gets installed - DONE
    ```
    libnvinfer5:
      Installed: 5.1.5-1+cuda10.1
      Candidate: 5.1.5-1+cuda10.1
      Version table:
     *** 5.1.5-1+cuda10.1 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
            100 /var/lib/dpkg/status
         5.1.5-1+cuda10.0 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         5.1.2-1+cuda10.1 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         5.1.2-1+cuda10.0 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
    (py_3_20191130_1909) @baaz@codehub-docker:16:25:26:tensorflow$apt-cache policy libnvinfer*
    libnvinfer-dev:
      Installed: (none)
      Candidate: 6.0.1-1+cuda10.2
      Version table:
         6.0.1-1+cuda10.2 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         6.0.1-1+cuda10.1 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         6.0.1-1+cuda10.0 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         5.1.5-1+cuda10.1 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         5.1.5-1+cuda10.0 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         5.1.2-1+cuda10.1 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
         5.1.2-1+cuda10.0 500
            500 https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64  Packages
    ```


03rd-Aug-2018:
1. Ubuntu 16.04 LTS vs Ubuntu 18.04 LTS Flag creation in configuration file
  - to enable Ubuntu version specific installation



## Technotes

https://ersanpreet.wordpress.com/2019/03/02/road-map-for-custom-object-detection-with-tensorflow-api/
https://ersanpreet.wordpress.com/2019/03/27/creating-your-own-custom-model-for-object-detection-tensorflow-api-part-6/
https://ersanpreet.wordpress.com/2019/04/13/testing-custom-object-detection-model-part-7/

https://cv-tricks.com/tensorflow-tutorial/save-restore-tensorflow-models-quick-complete-tutorial/
http://www-personal.umich.edu/~timtu/site/share/Tensorflow_03_saveRestore/

https://nbviewer.jupyter.org/github/tensorflow/tensorflow/blob/master/tensorflow/examples/tutorials/deepdream/deepdream.ipynb

https://github.com/tensorflow/examples/blob/master/community/en/r1/deepdream.ipynb

https://stackoverflow.com/questions/33759623/tensorflow-how-to-save-restore-a-model




https://stackoverflow.com/questions/11092511/python-list-of-unique-dictionaries

[{'id': 1, 'name': 'john', 'age': 34}, {'id': 1, 'name': 'john', 'age': 34}, {'id': 2, 'name': 'hanna', 'age': 30}]
list({v['name']:v for v in L}.values())
list({v['id']:v for v in L}.values())


/codehub/external/tensorflow/models/research/slim/nets/mobilenet/README.md

MACs, also sometimes known as MADDs - the number of multiply-accumulates needed
to compute an inference on a single image is a common metric to measure the
efficiency of the model.

Full size Mobilenet V3 on image size 224 uses ~215
Million MADDs (MMadds) while achieving accuracy 75.1%, while Mobilenet V2 uses
~300MMadds and achieving accuracy 72%. By comparison ResNet-50 uses
approximately 3500 MMAdds while achieving 76% accuracy.

All mobilenet V3 checkpoints were trained with image resolution 224x224

https://www.tensorflow.org/lite/performance/post_training_quantization

quantization-aware training
However, doing so requires some model modifications to add fake   quantization nodes, whereas the post-training quantization techniquesuse an existing pre-trained model.

https://github.com/tensorflow/tensorflow/tree/r1.14/tensorflow/contrib/quantize

https://www.tensorflow.org/lite/guide/inference

https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/python/lite_test.py

https://medium.com/@prasadpal107/saving-freezing-optimizing-for-inference-restoring-of-tensorflow-models-b4146deb21b5

.pbtxt: This holds a network of nodes, each representing one operation, connected to each other as inputs and outputs. We will use it for freezing our graph. You can open this file and check if some nodes are missing for debugging purpose.

.meta files holds ,more than just the structure of the graph like MetaInfoDef , GraphDef SaverDef , CollectionDef . Whereas .pbtxt files holds only the structure of the graph.

This file contains a serialized MetaGraphDef protocol buffer. The MetaGraphDef is designed as a serialization format that includes all of the information required to restore a training or inference process (including the GraphDef that describes the dataflow, and additional annotations that describe the variables, input pipelines, and other relevant information). For example, the MetaGraphDef is used by TensorFlow Serving to start an inference service based on your trained model. We are investigating other tools that could use the MetaGraphDef for training.

Assuming that you still have the Python code for your model, you do not need the MetaGraphDef to restore the model, because you can reconstruct all of the information in the MetaGraphDef by re-executing the Python code that builds the model. To restore from a checkpoint, you only need the checkpoint files that contain the trained weights, which are written periodically to the same directory.


Freezing the graph
why we need it?


When we need to keep all the values of the variables and the Graph in a single file we do it with freezing the graphs.



https://stackoverflow.com/questions/55757380/get-input-and-output-node-name-from-ckpt-and-meta-files-tensorflow
https://stackoverflow.com/questions/36195454/what-is-the-tensorflow-checkpoint-meta-file


```python
from tensorflow.summary import FileWriter

sess = tf.Session()
tf.train.import_meta_graph("/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco/model.ckpt-3125.meta")
FileWriter("/aimldl-dat/logs/tf_ods/ssd_mobilenet_v2_coco/__tb", sess.graph)
```


https://github.com/akimach/tfgraphviz
https://medium.com/@afetulhak/how-to-find-input-and-output-node-names-for-yolov3-from-tensorflow-pb-file-using-google-colab-2dc0f9e73258

https://developer.arm.com/solutions/machine-learning-on-arm/developer-material/how-to-guides/optimizing-neural-networks-for-mobile-and-embedded-devices-with-tensorflow/determine-the-names-of-input-and-output-nodes



https://github.com/tensorflow/models/issues/6892

https://www.easy-tensorflow.com/tf-tutorials/basics/graph-and-session

http://web.stanford.edu/class/cs20si/lectures/notes_02.pdf
https://cs224d.stanford.edu/lectures/CS224d-Lecture7.pdf

https://codelabs.developers.google.com/codelabs/recognize-flowers-with-tensorflow-on-android/#7



