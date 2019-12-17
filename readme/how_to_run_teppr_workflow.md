# TEPPr Workflow

* TEPPr is Training (train), Evaluation (evaluate), Prediction (predict), Publish (publish), Reporting (report)
* Router
  * Routes TEPPr request to specific AI architecture through the common interface
  * Pixel:`/codehub/apps/pixel`: **deprecated**
    * 1st generation with different files as entry point for TEPPr
  * Falcon: `/codehub/apps/falcon`: **under active development**
    * 2nd generation with single entry and mongoDB support for integrated TEPPr workflow


## How to execute TEPPr Workflow

1. Create Annotations and AI Datasets
2. Visualize Annotations and AI Datasets
3. Create AI experiment
4. Inspect AI Datasets
5. T: Execute training
6. E: Execute evaluation
7. P: Execute prediction on samples
8. P: Publish and release trained models to AI API
9. r: Generate reports - at any steps reports can be generated
10. For batch processing and other utility scripts
  * `/codehub/scripts/teppr`


## 1. Create Annotations and AI Dataset

1. Create Annotations
  * [VGG VIA](https://gitlab.com/vgg/via)
2. Pre-process the annotations using `annon` workflow
  * **Refer:** [How to create annotation datasets](how_to_create_annotation_datasets.md)


## 2. Visualize Annotations and AI Dataset


1. Visualize annon DB (annotations without splits)
  ```bash
  cd /codehub/apps/falcon
  python falcon.py visualize --dataset annon
  ```
2. Visualize AI Datasets (annotations with data splits)
  ```bash
  cd /codehub/apps/falcon
  python falcon.py visualize --dataset <ai-datasets_with_splits_db_name> --on <train | test | val>
  ## examples
  python falcon.py visualize --dataset PXL-051019_165419_051019_165647 --on train
  python falcon.py visualize --dataset PXL-051019_165419_051019_165647 --on val
  python falcon.py visualize --dataset PXL-051019_165419_051019_165647 --on test
  ```


## 3. Create AI experiment

* A AI experiment consists of three stages `TEP` aka: `T: train`, `E: evaluate`, `P: predict` 
  * a) `train: training the model`
  * b) `evaluate: evaluation on train, val and test dataset` to give the accuracy metric from the output model from the training step
  * c) `predict: prediction on some sample test set` to visually analyze the output using the output model from the training step
* AI Engineer needs to create `TEP` configuration in a `yml` file
  * It should be created under directory: **`/codehub/cfg/arch/`**
  * File should be named as:
    * `<ddmmyy_hhmm00>-AIE<i>-<j>-<dnn_arch>.yml`, where
      * `<ddmmyy_hhmm00>` is the timestamp of creation date of the experiment
      * `AIE<i>` stands for AI Engineer ID who is the creator of the experiment file
      * `<j>` is the experiment number
      * `<dnn_arch>` is the DNN architecture name (without any spaces or hypen)
    * Example: `040919_162100-AIE3-1-mask_rcnn.yml`
  * Refer the sample provided for the format here: `[/codehub/apps/annon/samples/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml](../apps/annon/samples/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml)`
* Upload the AI experiment to the AI Dataset DB
  ```bash
  cd /codehub/apps/annon
  python teppr.py --help
  python teppr.py create --type experiment --from /path/to/<directory_or_yml_file> --to <ai_dataset__db_name> --exp <train | evaluate | predict>
  ## example
  python teppr.py create --type experiment --from /codehub/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-051019_165419_051019_165647 --exp train
  ```
  * This witll create new table in AI Dataset DB: `TRAIN` or update the entries if table exists
* Later, after training, update the yml file for evaluate and predict and then upload to DB individually
  ```bash
  cd /codehub/apps/annon
  python teppr.py create --type experiment --from /codehub/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-051019_165419_051019_165647 --exp evaluate
  python teppr.py create --type experiment --from /codehub/cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-051019_165419_051019_165647 --exp predict
  ```
  * This will create new table in AI Dataset DB: `EVALUATE`, `PREDICT` respectively or update the entries if table exists


## 3. Inspect AI Datasets

```bash
cd /codehub/apps/falcon
python falcon.py inspect_annon --dataset <ai-datasets_with_splits_db_name> --on <train | test | val> --exp <exp_id>

## examples
python falcon.py inspect_annon --dataset PXL-051019_165419_051019_165647 --on train --exp train-ead10044-9429-4967-babe-7aecf6b29ad7
python falcon.py inspect_annon --dataset PXL-051019_165419_051019_165647 --on val --exp train-ead10044-9429-4967-babe-7aecf6b29ad7
python falcon.py inspect_annon --dataset PXL-051019_165419_051019_165647 --on test --exp train-ead10044-9429-4967-babe-7aecf6b29ad7
```


## 5. `T`: Execute training

Train - Training on the (AIDS) AI Dataset

1. **Prepare for training**
  * a) Create AI Dataset where each AI Dataset is separate Database / files
  * b) Create AI experiment which is specific to a architecture
  * c) Visualize Annotations in each subset of AI Dataset
    * This is required to ensure AI Dataset looks is overall OK
  * d) Inspect Annotations
    * This is required to ensure if algorithim steps performs as expected
    * There should be no errors at this stage
  ```bash
  cd /codehub/apps/falcon
  python falcon.py --help
  #
  ## Visualize Annotations
  python falcon.py train --dataset PXL-250719_174248_250719_174534 --exp uuid-18a6fe37-083b-4319-99f0-7f5822044c29 --on train --viz_annon
  #
  ## Inspect Annotations
  python falcon.py train --dataset PXL-250719_174248_250719_174534 --exp uuid-18a6fe37-083b-4319-99f0-7f5822044c29 --on train --inspect_annon
  ```
2. **Execute training**
  * Refer: [train.sh](../apps/falcon/train.sh)
  ```bash
  cd /codehub/apps/falcon
  python falcon.py --help
  #
  ## Example:
  python falcon.py train --dataset PXL-250719_174248_250719_174534 --exp uuid-18a6fe37-083b-4319-99f0-7f5822044c29 1>${AI_LOGS}/mask_rcnn/train.output-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
  ```
3. Batch Training - **Detailed Instructions TODO**
  ```bash
  cd /codehub/scripts/teppr
  source run_batch_train.sh 1>${AI_LOGS}/run_batch_train-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
  ```


## 6. `E`: Execute evaluation

Evaluate Trained Model on train, val and test AI Datasets
* Refer: [train.sh](../apps/falcon/evaluate.sh)

1. **Create Modelinfo File under directory: `/codehub/cfg/model`. Refer exisiting modelinfo file**
  a) Update the classes name with the proper sequence in which model was trained. Get the classinfo details from the training logs output under `/aimldl-dat/logs`
  ```bash
  <org_name>-<problem_id>-<training_dir_timestamp_from_logs_dir>-<arch_name>.yml
  vidteq-hmd-280919_180453-mask_rcnn.yml
  ```
2. **Create Evaluate experiment and upload it to DB**
  * a) Modify the evaluate experiment details, and point to proper modelinfo file
  * b) Upload the evaluate experiment to db
    ```bash
    python cfg2db.py create --type experiment --from /codehub/cfg/arch/<archspecific_experiment_yml_file> --exp evaluate --to <ai_datasets_id>
    ## example
    python cfg2db.py create --type experiment --from /codehub/cfg/arch/280919_173500-69-8-mask_rcnn.yml --exp evaluate --to aids-87c0c094-755a-4771-bd70-23e6a7d742b3
    ```
3. **Run the `evaluate`**
  ```bash
  python falcon.py <cmd> --dataset <dbname> --on <split_name> --exp <exp_id> --iou <value between_0_and_1>
  ## example
  python falcon.py evaluate --dataset PXL-240919_175423_250919_122117 --on val --exp uuid-6c70ae92-4d03-4c43-9d33-9712efda213e --iou 0.5
  ```


## 7. `P`: Execute prediction on samples

Predict on some wild sample test images and visualize the results


## 8. `P`: Publish and release trained models to AI API

Publish - Release trained model to AI API Port

1. Create Model config release directory if does not already exists.
  ```bash
  mkdir -p /codehub/cfg/model/release
  ```
2. Create a Model config file under `/codehub/cfg/model`.
  * This file ideally should already exists and would have been created after training to test and evaluate the model.
  * copy the same file under `/codehub/cfg/model`
3. Copy the weights/model files under `/aimldl-dat/release`. 
  ```bash
  ├── <organization_name>
  │   └── <problem_id>
  │       └── <release_number>
  │           └── <dnn_arch_name>
  │               └── weights
  │                   └── <model_or_weights_file>
  ```
* Example directory structure:
  ```bash
  ├── matterport
  │   └── coco_things
  │       └── 1
  │           └── mask_rcnn
  │               └── weights
  │                   └── mask_rcnn_coco.h5
  ```
4. Upload the model config to 'MODELINFO' table in the database
  * model path is unique key hence, running the script again **does not create duplicate entry**
  ```bash
  cd /codehub/scripts/annon
  source run_batch_cfg2db_modelinfo.sh 1>${AI_LOGS}/run_batch_cfg2db_modelinfo-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
  ```

## 9. `r`: Generate reports - at any steps reports can be generated

Generate stats, visuaization, graphs on different data:

1. Annotations Database (annon)
2. AI Datasets (data splits)
3. On training experiment
  * date of execution, total duration, date of completion, configuration etc.
4. On evaluation experiment
  * On train, val and test datasets
  * date of execution, total duration, date of completion, configuration, scores etc.
5. On prediction
  * sample test image set without annotations
  * visualization output only


## 10. For batch processing and other utility scripts

TODO
