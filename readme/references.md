## Learning Resources - removed temporarily

**Deep Learning Notes**
* [AI Programme Overview](https://github.com/mangalbhaskar/technotes/blob/master/ppts-pdfs/AI-programme-slides.pdf)
* [Deep Learning](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning.md)
* [Deep Learning Hardware](https://github.com/mangalbhaskar/technotes/blob/master/https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-hardware.md)
* [Deep Learning Frameworks](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-frameworks.md)
* [Deep Learning Architectures](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-architectures.md)
* [Deep Learning Datasets and Creation](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-datasets-and-creation.md)
* [Deep Learning Applications](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-applications.md)
* [Deep Learning in Computer Vision and its Applications](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-in-computer-vision-and-its-applications.md)
* [Deep Learning Traffic Sign Detection Classification](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-traffic-sign-detection-classification.md)
  * tsr - traffic sign recognition
  * tsd - traffic sign detection
  * spd - sign post detection
* [Deep Learning NLP](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-nlp.md)
* [CBIR - Content Based Image Retrieval](https://github.com/mangalbhaskar/technotes/blob/master/cbir.ml.md)
* [Deep Learning Commercial Solutions](https://github.com/mangalbhaskar/technotes/blob/master/deep-learning-commercial-solutions.md)



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

