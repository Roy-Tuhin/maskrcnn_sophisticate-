# Annotation Workflow Setup

* As long as the requirements are met, there are no other further dependency
* But, for a workflow with more people or machines it becomes cumbersome to manage. Utility scripts and file/folder conventions are created to address this.
* Optionally, MongoDB with Docker can be used
  * suggested, mongodb container
  * https://github.com/mangalbhaskar/mongo/tree/master/4.1
  * It is tricky to keep the Data Volumes consistently available to the host system,  keeping the uid and gid mapping intact, proper read, write, read-only permissions for the shared data


## Quick Start

* Copy the annotations and respective images in the required annotation directories 
* **Run Demo**: `source run_annon_demo.sh`


## Overview

1. Create Annotation Database (annon) from RAW annotations
2. Create AI Dataset (AIDS DB) from Annotation Database
3. Create modelinfo
4. Create AI Experiment
5. Verify details and generate report
6. Execute TEPPr workflow


## 1. **Create Annotation Database (annon) from RAW annotations**

* If `--to` is not present, it will use database
  ```bash
  cd /aimldl-cod/apps/annon
  python annon_to_db.py --help
  python annon_to_db.py create --from /path/to/annotation/<directory_OR_annotation_json_file>
  ## example
  python annon_to_db.py create --from /aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/annotations/
  ```
* **Visualize annon DB (annotations without splits)**
  ```bash
  cd /aimldl-cod/apps/falcon
  python falcon.py visualize --dataset annon
  ```

## 2. **Create AI Dataset (AIDS DB) from Annotation Database**

* if `--from` and `--to` are not present, it will use database
  ```bash
  cd /aimldl-cod/apps/annon
  python db_to_aids.py --help
  python db_to_aids.py create --by <AI_Engineer_ID>
  ## example
  python db_to_aids.py create --by AIE3
  ```
* Execution of this script would create new Database: `PXL-<annon_db_creation_timestamp>_<ai_dataset_creation_timestamp>`
* example: `PXL-051019_165419_051019_165647`. The timestamps are in `<ddmmyy_hhmmss>` format
* **Visualize AI Datasets (annotations with data splits)**
  ```bash
  cd /aimldl-cod/apps/falcon
  python falcon.py visualize --dataset <ai-datasets_with_splits_db_name> --on <train | test | val>
  ## examples
  python falcon.py visualize --dataset PXL-051019_165419_051019_165647 --on train
  python falcon.py visualize --dataset PXL-051019_165419_051019_165647 --on val
  python falcon.py visualize --dataset PXL-051019_165419_051019_165647 --on test
  ```


## 3. **Create modelinfo configuration file for any pre-trained model to be used during training experiment**

* Modelinfo `yml` files are the bindings for a model with respective labels, architecture, framework and other configurations
* It should be created under directory: **`/aimldl-cfg/model/`**
* Refer the sample provided for the format here: `[/aimldl-cod/apps/annon/samples/cfg/model/matterport-coco_things-1-mask_rcnn.yml](../apps/annon/samples/cfg/model/matterport-coco_things-1-mask_rcnn.yml)`


## 4. **Create AI Experiment**

* A AI experiment consists of three stages `TEP` aka: `T: train`, `E: evaluate`, `P: predict` 
  * a) `train: training the model`
  * b) `evaluate: evaluation on train, val and test dataset` to give the accuracy metric from the output model from the training step
  * c) `predict: prediction on some sample test set` to visually analyze the output using the output model from the training step
* AI Engineer needs to create `TEP` configuration in a `yml` file
  * It should be created under directory: **`/aimldl-cfg/arch/`**
  * File should be named as:
    * `<ddmmyy_hhmm00>-AIE<i>-<j>-<dnn_arch>.yml`, where
      * `<ddmmyy_hhmm00>` is the timestamp of creation date of the experiment
      * `AIE<i>` stands for AI Engineer ID who is the creator of the experiment file
      * `<j>` is the experiment number
      * `<dnn_arch>` is the DNN architecture name (without any spaces or hypen)
    * Example: `040919_162100-AIE3-1-mask_rcnn.yml`
  * Refer the sample provided for the format here: `[/aimldl-cod/apps/annon/samples/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml](../apps/annon/samples/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml)`
* Upload the AI experiment to the AI Dataset DB
  ```bash
  cd /aimldl-cod/apps/annon
  python teppr.py --help
  python teppr.py create --type experiment --from /path/to/<directory_or_yml_file> --to <ai_dataset__db_name> --exp <train | evaluate | predict>
  ## example
  python teppr.py create --type experiment --from /aimldl-cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-051019_165419_051019_165647 --exp train
  ```
  * This witll create new table in AI Dataset DB: `TRAIN` or update the entries if table exists
* Later, after training, update the yml file for evaluate and predict and then upload to DB individually
  ```bash
  cd /aimldl-cod/apps/annon
  python teppr.py create --type experiment --from /aimldl-cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-051019_165419_051019_165647 --exp evaluate
  python teppr.py create --type experiment --from /aimldl-cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-051019_165419_051019_165647 --exp predict
  ```
  * This will create new table in AI Dataset DB: `EVALUATE`, `PREDICT` respectively or update the entries if table exists


## 5. **Verify details and generate report**

* report will be generated: `${AI_ANNON}/annon/annon_summary-<ddmmyy_hhmmss>.json`
  ```bash
  python verifydb.py --help
  python verifydb.py
  ```


## 6. Execute TEPPr workflow

* **[Ready for executing TEPPr workflow on how to execute training, evaluation, prediction steps](how_to_run_teppr_workflow.md)**
