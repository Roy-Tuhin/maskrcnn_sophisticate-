# How to Setup Environment

**NOTE:**
* After system installation, all the python scripts should be run within the virtualenv setup until specified otherwise
* **Configurations files**
  * a) **Absolute paths**:`/codehub/scripts/paths.py`
  * b) **Application configurations**:`/codehub/scripts/app.py`
  * c) **API documentation**: `/codehub/scripts/api_doc.py`
  * d) **Local Custom Settings**: `/codehub/scripts/config.custom.sh`

## 1. Change the local environment configurations
  * get the details on the python environment settings
  ```bash
  lsvirtualenv
  cdvirtualenv
  ```
  * set the proper values for `AI_WSGIPythonPath` and `AI_WSGIPythonHome` accordingly in file: `/codehub/scripts/config.custom.sh`


## 2. For getting the mount commands for remote system - **optional**
  ```bash
  cd /codehub/scripts
  cp config.mount.example.sh config.mount.local.sh
  ```


## 3. Clone the internal git repos
  * `/aimldl-cfg` is mandatory internal git repo, also for the production setup
  * documentation and knowledge bank is not required in production setup
  ```bash
  cd /
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-cfg /aimldl-cfg
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-doc /aimldl-doc
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-rpt /aimldl-rpt
  git clone xxxxx@xx.x.xx.100:/home/xxxx/yyyy/git-repo/aimldl-kbank /aimldl-kbank
  ```


## 4. Directory and environment variable setup
  * This will create the required directory strucutres, environment varaibles, path and app configuration files
    ```bash
    cd /codehub/scripts
    source setup.sh
    ```
  * All config files are generated here: `/aimldl-cfg`


## 5. Install Docker

1. Install docker-ce
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
    cd /codehub/scripts/docker/mongo
    source docker.buildimg.mongodb-userfix.sh <mongodb-version> <docker-image-tag>
    ## For Ubuntu 16.04
    source docker.buildimg.mongodb-userfix.sh 4.0 mongouid
    ## For Ubuntu 18.04, Kali 2019.2
    source docker.buildimg.mongodb-userfix.sh 4.1 mongouid
    ```
  * Create mongodb docker container
    ```bash
    cd /codehub/scripts/docker
    source docker.setup.sh
    ```
  * Test mongodb docker container
    ```bash
    cd /codehub/scripts/docker
    source docker.exec.sh
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


## 8. Setup Pre-trained models

1. the model configuration files should be available under: `/aimldl-cfg/model/release`
2. the model/weight files should be available under: `/aimldl-dat/release`. This should follow the below directory structue
  ```bash
  ├── matterport
  │   └── coco_things
  │       └── 1
  │           └── mask_rcnn
  │               └── weights
  └── vidteq
      ├── bsg
      │   └── 1
      │       └── mask_rcnn
      │           └── weights
      ├── coco_things
      │   └── 1
      │       └── mask_rcnn
      │           └── weights
      ├── hmd
      │   ├── 1
      │   │   └── mask_rcnn
      │   │       └── weights
      │   ├── 2
      │   │   └── mask_rcnn
      │   │       └── weights
      │   ├── 3
      │   │   └── mask_rcnn
      │   │       └── weights
      │   └── 6
      │       └── mask_rcnn
      │           └── weights
      ├── road_asphalt
      │   └── 1
      │       └── mask_rcnn
      │           └── weights
      ├── road_segmentation
      │   └── 1
      │       └── mask_rcnn
      │           └── weights
      ├── tsd
      │   ├── 4
      │   │   └── mask_rcnn
      │   │       └── weights
      │   └── 5
      │       └── mask_rcnn
      │           └── weights
      └── tsdr
          └── 1
              └── mask_rcnn
                  └── weights
  ```
3. Upload/release the models to the database. Used by the AI API port.
  * uploaded logs are generated here for each model: `/aimldl-dat/logs/annon`
    ```bash
    cd /codehub/scripts/annon
    source run_release_modelinfo.sh <annon_db>
    ## Example:
    source run_release_modelinfo.sh annon_v3
    ```
4. Verify if modelinfo is loaded in the database
  * check in the database directly using mongoclient
  * use annon workflow for verification:
    ```bash
    cd /codehub/apps/annon
    python verifydb.py
    ```
  * summary report: `<dbname>_summary-<ddmmyy>_<hhmmss>.json` is generated in command line and also at the annon logs path: `/aimldl-dat/logs/annon`
  * verify that relative path inforation for `modelinfo->weights_path` in the `annon_summary` report matches with the path on the file system at: `/aimldl-dat/release`
5. copy the sample images for quick testing to the path: `/aimldl-dat/samples`
6. Setup the AI API. **Refer**: [apps.www.od.md](apps.www.od.md)
