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
* keras: 2.2.2, tensorflow: 1.9.0, CUDA-9.0
* keras: 2.2.3 to 2.3.5, tensorflow: 1.131.1, CUDA-10


## Bugs

* Fix the tensorRT version in Docker file wrt to specific CUDA, cuDNN version. Currently, latest tensorRT also gets installed
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

## Bugs

/codehub/scripts/aimldl.sh: line 434: lsvirtualenv: command not found
/codehub/scripts/aimldl.sh: line 435: workon: command not found
yml_filepath: /codehub/scripts/../config/paths.yml
yml_filepath: /codehub/scripts/../config/app.yml



# Technotes

## Shell script

* https://www.computerhope.com/unix/adduser.htm
* https://www.cyberciti.biz/faq/linux-change-user-group-uid-gid-for-all-owned-files/
* https://wiki.bash-hackers.org/scripting/debuggingtips
* https://stackoverflow.com/questions/17804007/how-to-show-line-number-when-executing-bash-script


## Git

https://stackoverflow.com/questions/11868447/how-can-i-remove-an-entry-in-global-configuration-with-git-config
git config --global --edit

git config --global --unset user.name
git config --global --unset user.email


