
## Environment Variables for AI

$AI_ANNON_DATA_HOME                 $AI_DATA                            $AI_KBANK                           $AI_REPORTS                         $AI_WEIGHTS_PATH
$AI_ANNON_DATA_HOME_LOCAL           $AI_DOC                             $AI_LOGS                            $AI_SCRIPTS                         $AI_WSGIPythonHome
$AI_ANNON_DB                        $AI_ENVVARS                         $AI_MNT                             $AI_VM_HOME                         $AI_WSGIPythonPath
$AI_ANNON_HOME                      $AI_GOOGLE_APPLICATION_CREDENTIALS  $AI_MODEL_CFG_PATH                  $AI_WEB_APP                         
$AI_APP                             $AI_HOME                            $AI_PY_ENVVARS                      $AI_WEB_APP_LOGS                    
$AI_CFG                             $AI_HOME_EXT                        $AI_PY_VENV_PATH                    $AI_WEB_APP_UPLOADS                 

* `$AI_ANNON_DATA_HOME_LOCAL`
  * HmdDataset.py
  * loads the images using this variable: `AI_ANNON_DATA_HOME_LOCAL`
  * `image_path = apputil.get_abs_path(appcfg, img, 'AI_ANNON_DATA_HOME_LOCAL')`
* `$AI_ENVVARS`
  * `AI_PY_ENVVARS:AI_DATA:AI_WEB_APP_UPLOADS:FASTER_RCNN:AI_ANNON_HOME:MASK_RCNN:AI_VM_HOME:AI_DOC:AI_ANNON_DATA_HOME_LOCAL:AI_WEB_APP:AI_ANNON_DB:AI_MODEL_CFG_PATH:CAFFE_ROOT:APACHE_HOME:AI_HOME_EXT:AI_WEIGHTS_PATH:AI_WEB_APP_LOGS:AI_REPORTS:AI_HOME:AI_GOOGLE_APPLICATION_CREDENTIALS:AI_MNT:AI_WSGIPythonHome:AI_CFG:AI_WSGIPythonPath:AI_SCRIPTS:AI_APP:AI_LOGS:AI_KBANK:AI_PY_VENV_PATH:AI_ANNON_DATA_HOME`


* **How and where to set the environment variables?**
  * `/codehub/scripts`
    * config.custom.sh
    * config.sh
  * execute:
    ```bash
    cd /codehub/scripts
    source setup.sh
    ```

```bash
python falcon.py predict --dataset PXL-051019_165419_051019_165647 --exp predict-1030d743-e70c-41ce-9864-7337e104f9db --path /aimldl-dat/samples/Trafic_Signs/100818_144130_16717_zed_l_623.jpg
```