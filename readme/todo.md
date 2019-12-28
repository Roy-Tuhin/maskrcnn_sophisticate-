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

# Technotes


## Docker

**TIPS**
* to access remote mount point inside the docker; the container should be created/started after mounting remote filesystem locally

* TODO:
  * how to work on a docker container remotely


## Shell script

* https://www.computerhope.com/unix/adduser.htm
* https://www.cyberciti.biz/faq/linux-change-user-group-uid-gid-for-all-owned-files/
* https://wiki.bash-hackers.org/scripting/debuggingtips
* https://stackoverflow.com/questions/17804007/how-to-show-line-number-when-executing-bash-script


## Git

https://stackoverflow.com/questions/11868447/how-can-i-remove-an-entry-in-global-configuration-with-git-config
```bash
git config --global --edit
git config --global --unset user.name
git config --global --unset user.email
```

* How to use multi-user on the same repo on the same system


## Linux

**Create Linux Bootable USB**
* https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64
* https://linuxize.com/post/how-to-create-a-bootable-linux-usb-drive/
  ```bash
  echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
  sudo apt-get update
  sudo apt-get install balena-etcher-electron
  #
  ## uninstall
  # sudo apt-get remove balena-etcher-electron
  # sudo rm /etc/apt/sources.list.d/balena-etcher.list
  # sudo apt-get update
  ```

## IoT

* https://www.balena.io


* https://www.tensorflow.org/lite/performance/post_training_quant
* https://colab.research.google.com/github/tensorflow/tensorflow/blob/master/tensorflow/lite/g3doc/performance/post_training_quant.ipynb
* https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/g3doc/performance/post_training_quant.ipynb
* https://www.tensorflow.org/model_optimization/guide/get_started
* https://medium.com/tensorflow/tensorflow-model-optimization-toolkit-pruning-api-42cac9157a6a
* https://medium.com/tensorflow/tensorflow-model-optimization-toolkit-post-training-integer-quantization-b4964a1ea9ba
* https://medium.com/tensorflow/what-exactly-is-this-tfx-thing-1ac9e56531c
* https://medium.com/tensorflow/smilear-iqiyis-mobile-ar-solution-based-on-tensorflow-lite-7b39347b1b8d
* https://www.silverlineelectronics.in/raspberry-pi-3-board-pack-for-android-thing.html
* https://www.raspberrypi.org/search/camera+for+AI
* https://www.raspberrypi.org/documentation/raspbian/applications/camera.md
* https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up
* https://github.com/tensorflow/examples/blob/master/lite/examples/object_detection/raspberry_pi/README.md
* https://www.tensorflow.org/lite/examples/
* https://medium.com/tensorflow/introducing-the-model-optimization-toolkit-for-tensorflow-254aca1ba0a3
* https://medium.com/tensorflow/tensorflow-model-optimization-toolkit-float16-quantization-halves-model-size-cc113c75a2fa
* https://medium.com/tensorflow
* https://github.com/tensorflow/model-optimization
* https://www.tensorflow.org/install/source
* https://nanonets.com/blog/how-to-easily-detect-objects-with-deep-learning-on-raspberry-pi/
* https://www.balena.io/fin/


## Deep Learning

* convert coco data to TF records
  * https://github.com/CharlesShang/FastMaskRCNN/blob/master/libs/datasets/download_and_convert_coco.py
* Image Augmentor
  * https://github.com/mdbloice/Augmentor

