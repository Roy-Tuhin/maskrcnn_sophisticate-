---
title: codehub
description: codehub is an opinionated software development environment workflow
author: mangalbhaskar
created: 16th-Nov-2019
updated: 07th-Jan-2020
tags: ubuntu, linuxscripts, docker, aimldl, android, raspberry-pi
---


**Table of Contents**
* TOC
{:toc}


# codehub

`codehub` is an **opinionated** software development environment workflow


## Disclaimer

* This is an opinionated workflow based on my individual preferences to organize my software development activities and digital content. If you do not like the concept of **opinionated** workflow, please do not use this repo.
* I've tried my best to provide link for references and due credits in individual files for any piece of code if applicable, so that anybody reading the code can directly refer those links for better understanding; and any missing credits/references are unintentional.
* It's forever opensource with commercial friendly license, though type of license may change.


## Getting Started - First Time Setup


1. **Run the installer script**
    * This step clones and initializes the `/codehub` repo on the local system
    * Installer script executes this setup script:`/codehub/scripts/setup.sh`
    * Run the following command on command prompt to clone and initialize the git repo on the local system:
      ```bash
      wget -O - https://raw.githubusercontent.com/mangalbhaskar/codehub/master/scripts/codehub.init.sh | bash
      ```
    * **IMP NOTE:**
      * Close the terminal and **open the new terminal for the next steps** for the environment variables to reflect in the shell
2. **Install the required software**
    * Ref: [How to Setup System and Install Required Software](readme/scripts.system.md)
    * Before setting up AI environment, ensure that the python is installed and virtualenv is properly configured. Default path of virtualenv would be: `/codehub/virtualmachines/virtualenvs`. This is to ensure maximum portability.
3. **Setup AI environment**
    * Ref: [How to Setup AI Environment](readme/how_to_setup_env.md)
4. **Setup AI API, deploy AI models**
    * Ref: [How to Setup AI API](readme/apps.www.od.md)
5. **Configure AI API to auto-start on system boot**
    * Ref: [How to deploy start api automatically on system boot](readme/how_to_start_api_automatically_on_system_boot.md)


## Docker Setup for AI Development

**Docker Images**
* [hub.docker.com - mangalbhaskar/aimldl](https://hub.docker.com/r/mangalbhaskar/aimldl)


## Design Philosophy

* **Save time by automating the repetitive steps** in setting up the development environment and toolchain
  * Provide sustainable and re-producible setup workflow and data-pipeline
* **Ease the migrating from one system to another**, in case of new setup after formatting of the system, system crashes
  * **Enforce consistency** in software development activities across individuals and team
  * **Taking care of system nuances** like change in the user name, uid, gid and other subtle yet critical differences
* **Maintaining diversity in project dependencies** by providing consistent docker containers, virtual environments
* **Compatibility** for different type of devices; desktop/laptops, mobile, raspberry-pi and other edge devices
* **Multi-purpose built** for tasks with or without docker containers
  * Computer Vision and Image Processing
  * AI: Machine Learning, Deep Learning
  * 3D GIS - Photogrammetry, Point Cloud, LiDAR, 3D Modeling
  * Data Analysis, Data Visualization
  * VR, AR
  * Computer Graphics, VFX, 3D
* **`codehub` strive to strike this by providing flexible conventions to:**
  * Create directories for code, data, configurations, logs etc.
    * Creating separate directories based on functionality, growth rate in expected size and velocity of change
    * All the top level directories can be managed independently
    * Top level directories can be stored on different remote locations and mounted locally to work across distributed systems
  * Creating consistent local and remote system mount points with proper permissions for distributed system workflow
  * Creating up-to-date documentations, specifications and knowledge sharing collaterals
  * Empowers the developer to implement the distributed workflow across different machines and devices
  * Provide automation scripts
  * Limits to linux specific projects only
  * Creates a dedicated AI workflow referred as: **`aimldl`**
    * Plug-n-play of different DNN architectures, external software components and libraries
  * Empowering individuals to setup the practice code repo that is shared within team
  * Encouraging seamless integration with cloud services - storage, apis, project management tools, communication channels


## Howto's

* **How to setup the toolchain for first time?**
  * [How to clone and create the git repo first time setup](readme/how_to_clone_and_create_the_git_repo_first_time_setup.md)
  * [How to Setup System and Install Required Software](readme/scripts.system.md)
* **How to setup toolchain for AI development and production?**
  * [How to Setup AI Environment](readme/how_to_setup_env.md)
  * [How to Setup AI API](readme/apps.www.od.md)
  * [How to debug setup, workflow and apps](readme/how_to_debug_setup_workflow_and_apps.md)
  * [How to create new model info for deploying AI models](readme/how_to_create_new_model_info.md)
  * [How to integrate new DNN arch with the teppr workflow](readme/how_to_integrate_new_dnn_arch_with_the_teppr_workflow.md)
* **How to setup pipeline for `aimldl`?**
  * [How to create Annotation Datasets](readme/how_to_create_annotation_datasets.md)
  * [How to execute TEPPr workflow](readme/how_to_run_teppr_workflow.md)
* **System code/model release, updates, upgrades and testing**
  * [How to deploy start api automatically on system boot](readme/how_to_start_api_automatically_on_system_boot.md)
  * [How to configure api using loadbalancer](readme/how_to_configure_api_using_loadbalancer.md)
  * [How to deploy AI API in production](readme/how_to_deploy_ai_api_in_production.md)
  * [How to deploy AI models](readme/how_to_deploy_ai_models.md)
  * [How to update the production system](readme/how_to_update_the_production_system.md)
* **archives - only for references; deprecated**
  * [How to setup lanenet and api port](readme/how_to_setup_lanenet_and_api_port.md)


### Design & Specifications 

* [System Design](readme/spec.system-design.md)
* [AI Environment Variables Explained](readme/apps.environment-variables-explained.md)
* [Annotation Workflow](readme/spec.apps.annon.md)
* **Other README**
  * [FAQ's](readme/faqs.md)
  * [scripts.lscripts](readme/scripts.lscripts.md)
  * [scripts.docker](readme/scripts.docker.md)
  * [submodules](readme/submodules.md)
  * [external](readme/external.md)
  * [todo](readme/todo.md)
  * [changelist](readme/changelist.md)


## Copyright and License

* Images/Annotations (if any) are copyright of the contributor(s). All rights reserved.
* Licensed under [see LICENSE for details]
  ```
  Copyright (c):

  2019-2020 mangalbhaskar a.k.a Bhaskar Mangal

  2019-2020 Vidteq India Pvt. Ltd. - A MapmyIndia Company
  Written by mangalbhaskar
  ```
