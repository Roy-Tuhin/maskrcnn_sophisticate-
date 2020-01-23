# How to Setup Environment - AIMLDL

**NOTE:**
* After system installation, all the python scripts should be run within the virtualenv setup until specified otherwise
* **Configurations files**
  * a) **Absolute paths**:`/codehub/scripts/paths.py`
  * b) **Application configurations**:`/codehub/scripts/app.py`
  * c) **API documentation**: `/codehub/scripts/api_doc.py`
  * d) **Local Custom Settings**: `/codehub/scripts/aimldl.config.sh`


## 1. Change the local environment configurations

* get the details on the python environment settings
  ```bash
  lsvirtualenv
  cdvirtualenv
  ```
* Set the proper values for `AI_PY_VENV_NAME` and `AI_WSGIPythonHome` accordingly in file: `/codehub/scripts/aimldl.config.sh`
* Execute the `aimldl.setup.sh` script to regenrate configurations
  ```bash
  cd /codehub/scripts
  source aimldl.setup.sh
  ```
* Check the python path by using `ls` command, this path should exists on the filesystem:
  ```bash
  ls -ltr ${AI_WSGIPythonPath}
  ls -ltr ${AI_WSGIPythonHome}
  ```


## 2. For getting the mount commands for remote system - **optional**

* Utility for mount over `sshfs`
  ```bash
  cd /codehub/scripts/utils
  cp config.mount.example.sh config.mount.local.sh
  ```


## 3. Clone the internal git repos

* documentation and knowledge bank is not required in production setup
  ```bash
  cd /
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-doc /aimldl-doc
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-rpt /aimldl-rpt
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-kbank /aimldl-kbank
  ```


## 4. Directory and environment variable setup

* This will create the required directory strucutres, environment varaibles, path and app configuration files
    ```bash
    cd /codehub/scripts
    source aimldl.setup.sh
    ```
* All config files are generated here: `/codehub/config`


## 5. Install Docker stack

Docker stack: docker-ce, docker-compose, nvidia-container-runtime for docker

1. Install `docker-ce`
    ```bash
    cd /codehub/scripts/docker
    source docker-ce.install.sh
    ```
2. **re-boot system**
3. verify docker installation
    ```bash
    sudo service docker start
    docker run hello-world
    ```
4. Check and remove all the containers
    ```bash
    docker container ps -a
    dids=$(docker container ps -a --format "{{.ID}}"); docker container rm $dids
    ```
5. Install `docker-compose`
    ```bash
    cd /codehub/scripts/docker
    source docker-compose.install.sh
    ```
6. Install and configure `nvidia-container-runtime`
    ```bash
    cd /codehub/scripts/docker
    source nvidia-container-runtime.install.sh
    ```


## 6. Install MongoDB

* **Note:**
  * This is required for end-to-end TEPPr workflow
  * Configuration files - **Ideally nothing needs to be changed**
    * a) docker environment configurations are defined in: `/codehub/scripts/docker/docker.env.sh`
    * b) MongoDB configurations are defined in: `/codehub/scripts/config/mongod.conf`
  * If mongodb is already installed on host system stop the mongodb service on host system, before installing mongodb docker container
1. **Install mongodb as a docker container** - **preferred**
    * Build mongodb docker image
    * `mongodb` user and group id fixes. Refer [mongo custom image](https://github.com/mangalbhaskar/mongo/tree/master/4.1) 
      ```bash
      cd /codehub/scripts/docker/dockerfiles/mongo
      source docker.buildimg.mongodb-userfix.sh <mongodb-version> <docker-image-tag>
      ## For Ubuntu 16.04
      source docker.buildimg.mongodb-userfix.sh 4.0 mongouid
      ## For Ubuntu 18.04, Kali 2019.2
      source docker.buildimg.mongodb-userfix.sh 4.1 mongouid
      ```
    * Create mongodb docker container
      ```bash
      cd /codehub/scripts/docker
      source docker.createcontainer-mongo.sh
      ```
    * Test mongodb docker container
      ```bash
      cd /codehub/scripts/docker
      source docker.exec-mongo.sh
      ```
2. **Install Mongo Client to access mongodb from UI** - **This is optional but preferred if you are new to mongodb**
    * [compass download](https://www.mongodb.com/products/compass)
    * [compass installation docs](https://docs.mongodb.com/compass/master/install/)
    * Install the downloaded deb package:
      ```bash
      sudo dpkg -i $HOME/Downloads/mongodb-compass-community_1.18.0_amd64.deb
      sudo apt -y install libgconf-2-4
      ## some dependency errors would come, execute the aptitude command and continue
      sudo aptitude -y install libgconf-2-4
      ```
    * Launch mongo client:
      ```bash
      mongodb-compass-community
      ```


## 7. Create DNN Setup

* **NOTE:**
  * All the required code should be installed under: `/codehub/external`
  * Install individual DNN repos; refer script`/codehub/scripts/setup.external.sh`

1. Install minimal required dnns
    ```bash
    cd /codehub/scripts
    #
    ## contains all the external git references
    # source setup.external.sh
    #
    ## only minimal external git references
    source setup.external-min.sh
    ```


## 8. Deploy AI Models / Setup Pre-trained models

* Ref: [How to deploy AI models](how_to_deploy_ai_models.md)
