---
title: Codehub
description: Codehub is the development environment toolchain
author: Bhaskar Mangal
created: 16th-Nov-2019
updated: 17th-Dev-2019
tags: Ubuntu, Linux Scripts, docker, AIMLDL
---


**Table of Contents**
* TOC
{:toc}


# Codehub


## Getting Started - First Time Setup


1. **Run the installer script**
    * This step clones and initializes the `/codehub` repo on the local system
    * Installer script executes this setup script:`/codehub/scripts/setup.sh`
    * Run the following command on command prompt to clone and initialize the git repo on the local system:
      ```bash
      wget -O - https://raw.githubusercontent.com/mangalbhaskar/codehub/master/scripts/codehub.init.sh | bash
      ```
2. **Install the required software**
    * Ref: [How to Setup System and Install Required Software](readme/scripts.system.md)
    * Before setting up AI environment, ensure that the python is installed and virtualenv is properly configured. Default path of virtualenv would be: `/codehub/virtualmachines/virtualenvs`. This is to ensure maximum portability.
3. **Setup AI environment**
    * Ref: [How to Setup AI Environment](readme/how_to_setup_env.md)
4. **Setup AI API**
    * Ref: [How to Setup AI API](readme/apps.www.od.md)
5. **Configure AI API to auto-start on system boot**
    * Ref: [How to deploy start api automatically on system boot](readme/how_to_start_api_automatically_on_system_boot.md)


## Docker Setup for AI Development

**Docker Images**
* [hub.docker.com - mangalbhaskar/aimldl](https://hub.docker.com/r/mangalbhaskar/aimldl)


## Specifications


**codehub - Design Philosophy:**
> What is it?

* Setting up the development environment, tools chains is time consuming and repetitive
* Migrating from one system to another, in case of new setup after formatting of the system, system crashes is a painful task
* During this, change in the user name, uid/gid and re-configuration is highly manual
* Containers plays key roles in creating such re-usable environment


**System build for multi-purpose tasks using docker containers**
* Computer Vision and Image Processing
* Machine Learning
* Deep Learning
* 3D GIS - Photogrammetry, Point Cloud, LiDAR, 3D Modeling
* Data Analysis, Data Visualization
* VR,AR
* Computer Graphics, VFX


**AIMLDL - Design Philosophy**

AIMLDL workflow and conventions for computer vision tasks.
* Creates the directory setup for code, data, configurations, logs
* Local and remote system mounts for distributed system workflow
* Concept is to separate directories based on functionality, growth rate and expected size, velocity of change
* All the top level directories can be managed independently
* They can be stored on different remote locations and mounted locally
* Provide sustainable and re-producible data-pipeline over time
* knowledge sharing across teams
* Distributed workflow across machines
* Plug-n-play of different DNN architectures


### AIMLDL

* [System Design](readme/spec.system-design.md)
* [AI Environment Variables Explained](readme/apps.environment-variables-explained.md)
* [Annotation Workflow](readme/spec.apps.annon.md)
* [FAQ's](readme/faqs.md)


## Howto's

### codehub - Howto

* [How to clone and create the git repo first time setup](readme/how_to_clone_and_create_the_git_repo_first_time_setup.md)
* [How to Setup System and Install Required Software](readme/scripts.system.md)


### AIMLDL - Howto

* [How to Setup AI Environment](readme/how_to_setup_env.md)
* [How to Setup AI API](readme/apps.www.od.md)
* [How to debug setup, workflow and apps](readme/how_to_debug_setup_workflow_and_apps.md)
* [How to deploy start api automatically on system boot](readme/how_to_start_api_automatically_on_system_boot.md)
* [How to configure api using loadbalancer](readme/how_to_configure_api_using_loadbalancer.md)
* [How to deploy AI API in production](readme/how_to_deploy_ai_api_in_production.md)


* [How to create Annotation Datasets](readme/how_to_create_annotation_datasets.md)
* [How to execute TEPPr workflow](readme/how_to_run_teppr_workflow.md)
* [How to setup lanenet and api port](readme/how_to_setup_lanenet_and_api_port.md)


## README

* [scripts.lscripts](readme/scripts.lscripts.md)
* [scripts.docker](readme/scripts.docker.md)
* [submodules](readme/submodules.md)
* [external](readme/external.md)


**TODO**
* [README - todo](readme/todo.md)


## ChangeList

* Notes for AI API (Tesselate) v3 - scheduled
  * Modelinfo rel_num changed from int to string datatype in database; re-load the MODELINFO in production or change the datatype manually for all the records
  * Lanenet integration
  * breaking API changes: /predict changed to `/predict/bbox` and `/predict/polygon`
  * `/predict/lane` added for lanenet
  * Though, option for `q=<model_key>` added; have issues with switching between mask_rcnn and lanenet at runtime. If server started with single model; default model no issues
  * mask_rcnn limiting gpu memory changes
  * gunicorn server timeout setting increased from default 30 seconds to 60 seconds


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



## TODO

* **Bin List**
  * specifications to be created for annotations: ods, rld, rbd
  * annotation workflow to be updated for lanenet
  * read/spec update on environment variables for AI and CODEHUB environment variables
  * generate systemd scripts for gunicorn automatically from the setup scripts using user defined and detected options
  *  annon: verifydb.py to test with oasis release db change
  * aimldl-cod workflow diagram
  * clear instructions on how to execute TEPPr workflow
  * multiple model support on different ports, same machine. That means concept of default model key needs to be overridden at the server start time
  * API test scripts for different port simultaneously
  * queue and scheduler in prediction
  * production server configurations and scripts
    * as a service
    * load balancer
    * multi-model support
    * tensorflow memory management
    * mAP reports on published models
    * stress-test reports
  * docker command errors: provide debug logs when using docker shell scripts to the command line
  * Starting AI API port: throw error if DB connection is not up and running
  * annon - creating AI datasets should have same labels in different splits; currently gets different labels - bug
  * script to clone internal git repo for the first time setup, give the required inputs in the local config setup
  * docker script `gpg vs gpg2` conditional selection in docker image - put a note in mongodb setup
  * AI model version management using `git-lfs`
  * Full interation of TEPPr workflow items
  * tensorboard enhancements
  * integration of lanenet
  * hyper-tuning mask_rcnn
  * system stats usage reports
  * API usage stats in DB, prediction results and feature vector for CBIR consumption
  * motion_rcnn and medicalkitdetection for 3D extraction from mask_rcnn
  * `common.py` code redundancy to be removed



## Disclaimer

* TODO


## Legal Disclaimer

* TODO


## Copyright and License

```
Copyright (c):

2019 mangalbhaskar a.k.a Bhaskar Mangal

2019 Vidteq India Pvt. Ltd. - A MapmyIndia Company
Written by mangalbhaskar
```
* Licensed under [see LICENSE for details]
* Images/Annotations (if any) under **samples, tests** are copyright of the contributor(s). All rights reserved.
