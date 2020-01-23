# Steps and procedure of system update
## Development stage -
1. Create a model_info.yml in `/codehub/cfg/model/release` 

**Example** -
```yaml
classes: 
- BG
- lane
classinfo: null
config: null
dataset: lnd-291119_174355
dnnarch: lanenet
framework_type: tensorflow
id: rld
mode: inference
name: rld
num_classes: null
org_name: vidteq
problem_id: rld
rel_num: 1
weights: null
weights_path: vidteq/rld/1/lanenet/weights/vidteq-rld-1.pb
```
**Note** - 
Naming convention to be followed to deploy a model in CBR system
```bash
<'org_name'>-<'problem_id'>-<'rel_num'>-<'dnnarch'>.yml
Example - 'vidteq-rld-1-lanenet.yml'
```

2. Push the above created model_info.yml to oasis database
```bash
cd /codehub/scripts/annon
source run_release_modelinfo.sh <'db_name'>
source run_release_modelinfo.sh oasis
```

3. Develop a wrapper for original data in `/codehub/apps/falcon/arch`

**Note** - 
The file should be saved after the DNN architecture i.e `<'arch'>.py`

4. Create a script to start a port in `/codehub/apps/www/od/wsgi-bin`

**Example** -
```bash
ip=0.0.0.0
port=4100
api_model_key='vidteq-rld-1'
queue=false
gunicorn web_server:"main(API_MODEL_KEY='"${api_model_key}"', QUEUE='"${queue}"')" -b "${ip}:${port}"  --timeout 60 --log-level=debug
```
* Save the 
* Source the above script to start the port
```bash
cd /codehub/apps/www/od/wsgi-bin
source start.vidteq-rld-1.sh
```
5. Follow Test suite cases for system testing during updates for testing

## Production stage

1. Edit the `/codehub/scripts/config/systemd/gunicorn.service` accordingly
**Example** -
```bash
[Unit]
Description=Gunicorn Daemon
After=network.target docker.service

[Service]
User=<'username'>
Group=<'username'>
WorkingDirectory=/aimldl-cod/apps/www/od/wsgi-bin
Environment="PATH=/home/<'username'>/virtualmachines/virtualenvs/<'virtualenv'>/bin"
ExecStart=/home/<'username'>/virtualmachines/virtualenvs/<'virtualenv'>/bin/gunicorn web_server:"main(API_MODEL_KEY=<'api_model_key'>, QUEUE='false')" -b "0.0.0.0:<'port'>"

[Install]
WantedBy=multi-user.target

```

2. Run `/codehub/scripts/setup.services.sh`
```bash
cd /codehub/scripts
source setup.services.sh
```

3. Reboot the system
```bash
sudo reboot
```

4. Follow Test suite cases for system testing during updates for testing

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