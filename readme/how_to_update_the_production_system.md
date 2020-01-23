# How to update the production system

**General Instructions**
* Do the Testing in the AI DEV machine first before updating the production system
* Update one system at a time; rollback/hold in case of critical failure / compatibility issues
* Follow Test suite cases for system testing during updates for testing


## Code updates, patches and releases

* Create the release tags for individual DNN arch under `external` directory and **push the release tags to the repo**
  * Mention it's own release tag the comments for each DNN
* Create the release tag for the `codehub` and **push the release tag to the repo**
  * Mention the release tag of individual DNN arch in the comments for the `codehub` release tag
* Update the changelist readme: [Changelist](changelist.md)
* **How to create code release**
  * TODO: update this section


## AI model release for API

* [How to deploy AI models](how_to_deploy_ai_models.md)


## System upgrade


## Testing

* System testing
* UAT




# Test suite cases for system testing during updates
1. Test the API manually through Tesselate API in the browser
  * Enter <'ip'>:<'port'> in the address bar
  * Click on choose file and select the image on the system
  * Click on `Submit` button

| Test Scenario ID | Test Case ID | Test case desc | Test priority| Pre-requisite | Post-requisite | Test Execution Steps |
|---|---|---|---|---|---|---|
| Deploy-1 | Deploy-1A | api call - positive test case | High | Ubuntu 18.04 | | |


| S.No | Action | Inputs | Expected output | Actual output | Test results | Test Comments |
|---|---|---|---|---|---|---|
| 1 | Launch application | https://0.0.0.0:4100 | Tesselate API | Tesselate API | Pass | Launch successful | 
| 2 | Browse a image and click on Submit button | Image (720*1280) | JSON response | JSON response | Pass | successful response | 

2. Using pyapi.sh
* Configure the `apicfg.sh` in `/codehub/scripts/api`
* Create a script for DNN architecture in `/codehub/scripts/api` and save after api_model_key i.e. <'api_model_key'>.sh

**Example** -
```bash
GUNICORN_IP=10.4.71.31
GUNICORN_PORT=4100
API_MODEL_KEY="vidteq-rld-1"
API_URL="http://${GUNICORN_IP}:${GUNICORN_PORT}/api/vision/v2/predict"
IMAGE_PATH="/aimldl-dat/samples/lanenet/7.jpg"
```
* Run the `pyapi.sh`
```bash
cd /codehub/scripts/api
source pyapi.sh <'api_model_key'>
source pyapi.sh vidteq-rld-1
```

# Tracker for system updates, with release tags

|Sl No| Api model key|Codehub | MaskRcnn | Lanenet |
|---|---|---|---|---|---|
| 1 | vidteq-hmd-1 | | | |  
| 2 | vidteq-ods-7 | | | |  
| 3 | vidteq-rld-1 | | | |  
| 2 | vidteq-rbd-1 | | | |  