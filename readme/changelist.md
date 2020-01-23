# Changelist


## v0.2.0


* pre-release patch required for lanenet
* **Release compatibility with DNN in `external` dir**:
  * Mask_RCNN: `rc-v3.1` and older
  * lanenet-lane-detection: `v2.0`; not compatible with the previous releases
* **lanenet enhancements**
  * prediction clipping
  * problem_id `rod` introduced for horizontal line predictions
  * `lanenet:rod` model pre-release - only in db but not on port
  * teppr workflow introduced
    * configs are externalized to yml files. It's working, though under progress.
    * batch execution for training and evaluation. Evaluation has some issue - takes more time
* mask_rcnn docker compatibility for TEPPr workflow
* detectron2 introduced
* mobile AI work changes in progress
* LICENSE update
* new python packages introduced for dev
* tensorflow-2 docker work in progress for mobile ai
* software stack installation for photogrammetry, gis using `lscripts` upgraded - opencv-4.2, new versions and softwares added



### **Major Changes in workflow**

* `/codehub/config` is moved to system root at `/codehub-config` to work seamlessly with docker containers and the host at the same time on the same system
* sub-directories under `/aimldl-data` are now symlink to timestamp based real directories with the same name.
  * This helps to take care of distributed storage and archiving the data without creating the copy of the data
* **caution - breaking changes**: fix manually on system update
  * `data-mongodb` is now symlinked - to be tested in the production
  * `/virtualmachines/virtualenvs` is symlined to `/codehub/virtualmachines/virtualenvs` - need to be manually fixed in the system
  * gunicorn service changes - **not tested; should not recreate service on existing setup!!**



## v0.1.0

* pre-release; migration from `aimldl` workflow to `codehub`
* **Release compatibility with DNN in `external` dir**:
  * Mask_RCNN: `rc-v3.0`
  * lanenet-lane-detection: `v1.0`
* Docker compatibility of dev and prod setup for AI introduced
* Server based AIMLDL development extended to mobile and edge devices
* lanenet integration with rld, rbd problem_id
* **archives**
  * Notes for AI API (Tesselate) v3 - scheduled
    * Modelinfo rel_num changed from int to string datatype in database; re-load the MODELINFO in production or change the datatype manually for all the records
    * Lanenet integration
    * breaking API changes: /predict changed to `/predict/bbox` and `/predict/polygon`
    * `/predict/lane` added for lanenet
    * Though, option for `q=<model_key>` added; have issues with switching between mask_rcnn and lanenet at runtime. If server started with single model; default model no issues
    * mask_rcnn limiting gpu memory changes
    * gunicorn server timeout setting increased from default 30 seconds to 60 seconds
  * 03rd-Aug-2018:
    1. Nvidia - driver, cuda, cudnn, tensorrt on Dell Latitude 5580 (Nvidia GeForce 940MX)
