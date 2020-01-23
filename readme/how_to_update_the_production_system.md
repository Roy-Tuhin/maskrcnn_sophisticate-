# How to update the production system

**General Instructions**
* Do the Testing in the AI DEV machine first before updating the production system
* Update one system at a time; rollback/hold in case of critical failure / compatibility issues
* Follow/create test suite cases for system testing during updates for testing


## Steps

1. Update the changelist readme: [Changelist](changelist.md)
2. Create the new release, Ref: **[How to create new release](how_to_create_new_release.md)**
3. Update the system
4. Test the release, create/follow the test release cases
  * **System testing** - to be done by the developer
  * **Stress testing** - to be done by the developer
  * **UAT** - to be done by the consumer of the AI API port


## How to release/path the code

* Checkout the lastest releases of individual DNN arch and of the entire codehub
* **Example**:
    ```bash
    cd /codehub/external/Mask_RCNN
    git checkout rc-v3.1
    #
    cd /codehub/external/lanenet-lane-detection
    git checkout v2.0
    #
    cd /codehub
    git checkout v0.2.0
    ```
* Fix any merge conflicts, may be there for some local config file
* Make the changes in the configs if required and execute the setup scripts
  ```bash
  cd /codehub/scripts
  #
  ## make config changes if required - ideally not required if python evnironemnt is not changed
  vi aimldl.config.sh
  #
  source codehub.setup.sh
  source aimldl.setup.sh
  ```
* Verify & fix any virtual environment paths, data directory paths and symlinks
  * If required, open the new terminal, and verify and fix any issues in the `~/.bashrc` script


## How to updates/release AI models

* Ref: [How to deploy AI models](how_to_deploy_ai_models.md)
* **NOTE:**
  * Update the release information in the internal tracker: `/aimldl-rpt/work-updates/model_releases.xlsx`
  * Push this model release tracker in internal git repo and also sync it with the respective folder in the google-drive.


## System testing - Mandatory!

**Follow the test cases** as provided in the directory: `/aimldl-doc/tests`


1. Test the API manually through Tesselate API in the browser
  * Enter `<ip>:<port>` in the address bar
  * Click on choose file and select the image on the system
  * Click on `Submit` button
2. Using `pyapi.sh`
  * Configure the `apicfg.sh` in `/codehub/scripts/api`
  * Create a script for DNN architecture in `/codehub/scripts/api` and save after api_model_key i.e. `<api_model_key>.sh`
  * **Example:**
      ```bash
      GUNICORN_IP=10.4.71.31
      GUNICORN_PORT=4100
      API_MODEL_KEY="vidteq-rld-1"
      API_URL="http://${GUNICORN_IP}:${GUNICORN_PORT}/api/vision/v2/predict"
      IMAGE_PATH="/aimldl-dat/samples/lanenet/7.jpg"
      ```
  * Execute the `pyapi.sh` script
      ```bash
      cd /codehub/scripts/api
      source pyapi.sh <api_model_key>
      # example
      source pyapi.sh vidteq-rld-1
      ```

## Stress testing


## UAT testing
