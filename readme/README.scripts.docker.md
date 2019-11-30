# Docker Images for AI development

## AIDEV

* **Requirements**
  * nvidia-container-runtime
  * Docker 19.03.1
* **Key Highlights**
  * Meant only for **development** activity and **not for production use**
  * `python3`, `virtualenv` and `virtualwrapper` installed and provide pre-created virtualenv
  * `vim` editor installed
  * Normal user created
  * `sudo` enabled inside docker for the normal user
  * Images would create container with privileged access so that developer can execute `uid`, `gid` fixes i.e. mapping of host system uid/gid to docker user uid/gid. This is essential to work with volume mount point, where all the data is on the host system
  * docker images compatible with following github-repo:
    * [mangalbhaskar/aimldl](https://github.com/mangalbhaskar/aimldl)
    * [mangalbhaskar/codehub](https://github.com/mangalbhaskar/codehub)
* **Tags**
  * `${CUDA_VERSION}-cudnn-${CUDNN_VERSION}-devel-${OS}-${WHICHONE}-v${VERSION}-${timestamp}`
  * where:
    * `${timestamp}` - creation timestamp in `YYYYMMDD_HHMM` format
    * `${WHICHONE}` - image category for AI work
* **Image categories**
  1. `aidevmin`
    * virtualenv contains only minimum python packages
    * **Usage**: Use this if you require more control over what python packages you want to install
  2. `aidev`
    * virtualenv contains **many** python packages
    * tensorflow compilation compatible bazel is installed; bazel is required if you want to build tensorflow from source
    * Latest tensorflow and keras (uninstall and re-install specific version if required)
    * **Usage**: Use this if you want most of the required latest python packages and AI dependencies for AI development work
* **NOTE**
  * The user inside the docker: **username**:`baaz`, **password**:`baaz`
  * `PY_VENV_PATH=/virtualmachines/virtualenvs` - user specific virtual environment path
  * `DOCKER_BASEPATH=/external4docker` - for volume mount to the host. To be used to clone the source code on the host, but compile inside docker.
  * `DOCKER_SETUP_PATH=/docker-installer` - setup scripts
  * `WORK_BASE_PATH=/codehub` - for volume mount with the [codehub repo](https://github.com/mangalbhaskar/codehub)
  * `OTHR_BASE_PATHS=/aimldl-cod /aimldl-rpt /aimldl-doc /aimldl-kbank /aimldl-dat /aimldl-cfg` - for volume mount with the [aimldl repo](https://github.com/mangalbhaskar/aimldl)
* **Images**
  * **`10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v5-tf1.13.1-20191130_1909`**
    * `tensorflow-gpu==1.13.1`
  * **`9.0-cudnn-7.6.4.38-devel-ubuntu16.04-aidev-v5-tf1.9.0-20191130_1858`**
    * `tensorflow-gpu==1.9.0` and `keras==2.2.2`
    * Ref: https://github.com/matterport/Mask_RCNN/issues/1808
  * **`9.0-cudnn-7.6.4.38-devel-ubuntu16.04-aidevmin-v5-20191130_1819`**
  * **`10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v5-20191130_1606`**
    * `tensorflow-gpu==2.0.2`
  * **`10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v5-20191130_1340`**
  * **`10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-4-20191128_1444`**
    * `tensorflow-gpu==2.0.2`
    * no direct root access


## Mongo DB

* **Requirements**
* **Key Highlights**
  * Kali Linux 2019.1 does not have the native support for mongoDB; when trying to install MongoDB from official Docker Image it has conflict with uid and gid on the Kali Linux hence mongodb user uid,gid mapping fix was done, for more details refer the  [README.useridfix.md](https://github.com/mangalbhaskar/mongo/blob/8c8a8c9bd1930ac70d22c10f8e1bf9312acc2e9a/README.useridfix.md)
  * [MongoDB 4.1 Dockerfile.mongodb-userfix](https://github.com/mangalbhaskar/mongo/blob/8c8a8c9bd1930ac70d22c10f8e1bf9312acc2e9a/4.1/Dockerfile.mongodb-userfix)
  * Works on Ubuntu 18.04 LTS and Kali Linux 2019.1
* **Tags**
  * `mongodb-v{MONGODB_VERSION}-${BUILTON}-v${VERSION}-${timestamp}`
  * where:
    * ${timestamp} - creation timestamp in `YYYYMMDD_HHMM` format
* **Image categories**
* **NOTE**
* **Images**
  * **`mongodb-v4.1.13-kalilinux-2019.1-v1-151110_000700`**


## Dockerfiles and Containers

* Docker Images for the [aimldl repo on github: https://github.com/mangalbhaskar/aimldl](https://github.com/mangalbhaskar/aimldl)
* All the docker images are build from [these scripts repo](https://github.com/mangalbhaskar/aimldl/tree/master/scripts/docker), though it can be build independently. Using these scripts ensures the creation of stateless containers for `aimldl` and `codehub` work
* Source dockerfiles and utility scripts: [mangalbhaskar/codehub - scripts/docker](https://github.com/mangalbhaskar/codehub/tree/master/scripts/docker)


### 1. **Build Images**

* **Note**
  * Adjust the required versions for python related libs according to CUDA version in the ai requriements
    * `/codehub/scripts/docker/dockerfiles/installer/lscripts/python.requirements-ai.txt`
    * https://github.com/matterport/Mask_RCNN/issues/1808
* a) **aidevmin**
  ```bash
  cd /codehub/scripts/docker
  source docker.buildimg-aidev.sh aidevmin-devel-gpu
  ```
* b) **aidev**
  ```bash
  cd /codehub/scripts/docker
  source docker.buildimg-aidev.sh aidev-devel-gpu
  ```
* c) **nvidia/cuda**
  * Ensure you should have `cuda` repo cloned: `https://gitlab.com/nvidia/container-images/cuda.git` at path: `/codehub/scripts/docker/dockerfiles/cuda`. This is already avaiable as the submodule to `codehub` repo
  * Edit the script: `/codehub/scripts/docker/docker.buildimg-cuda.sh` for your requirements
  * Execute to build cuda/cudnn images
    ```bash
    cd /codehub/scripts/docker
    source docker.buildimg-cuda.sh
    ```
  * create aidevmin/aidev from the generated image
  * Edit the script: `/codehub/scripts/docker/docker.env-aidev.sh`
    * Update with the same `OS`, `CUDA_VERSION`, and `CUDNN_VERSION` and `CUDNN_MAJOR_VERSION`
    * Increment the VERSION=5; otherwise previous version would be used; or delete the previous image and use the same version
      ```bash
      cd /codehub/scripts/docker
      source docker.buildimg-aidev.sh aidev-devel-gpu
      source docker.buildimg-aidev.sh aidevmin-devel-gpu
      ```


### 2. **Create Containers**

* Create containers with **aidev** or **aidevmin**
  ```bash
  cd /codehub/scripts/docker
  source docker.createcontainer-aidev.sh <image_name> <whichone>
  ## example
  ## aidevmin
  source docker.createcontainer-aidev.sh mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v5-20191130_1340 aidevmin-devel-gpu
  ## aidev
  source docker.createcontainer-aidev.sh mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v5-20191130_1606 aidev-devel-gpu
  ```


### 3. **Execute Containers**

* Execute container interactively:
  ```bash
  cd /codehub/scripts/docker
  source docker.exec-aidev.sh <container_name>
  ## example
  ## aidevmin
  source docker.exec-aidev.sh aidevmin-devel-gpu-5
  ## aidev
  source docker.exec-aidev.sh aidev-devel-gpu-5
  ```


## How to report Issues & custom docker image requirements

* Use the git-hub issues on the [aimldl repo here](https://github.com/mangalbhaskar/aimldl/issues) and create the new issue: bug/requirement
