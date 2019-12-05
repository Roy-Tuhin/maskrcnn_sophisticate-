# TEPPr Workflow

* TEPPr is Training (train), Evaluation (evaluate), Prediction (predict), Publish (publish), Reporting (report)
* Router
  * Routes TEPPr request to specific AI architecture through the common interface
  * Pixel:`/aimldl-cod/apps/pixel`: **deprecated**
    * 1st generation with different files as entry point for TEPPr
  * Falcon: `/aimldl-cod/apps/falcon`
    * 2nd generation with single entry and mongoDB support for integrated TEPPr workflow


## How to execute TEPPr Workflow

1. Create Annotations
2. Pre-process the annotations using Annon workflow: `/aimldl-cod/apps/annon`
  * **Refer:** `https://github.com/mangalbhaskar/annon`
  * a) Raw annotations to Annotation Database
  * b) Annotation Database to AI Dataset database
  * c) Create **AI Experiment** config file under: `/aimldl-cfg/arch`
    * `<orgname>-<id>-<relnum>-<arch>.yaml`
  * d) Create respective **Model Info** config file under: `/aimldl-cfg/model`
    * `<orgname>-<id>-<relnum>-<arch>.yaml`
  * e) Upload **Model Info** to database
    * Model Info from DB is used only for AI API. DB provides unique model id for each uploaded model
      * `weights_path` should be unique to upload the model info to DB. This constraint enforces to maintain the models in organized mechanism using file system for version management and release management
    * For TEP (Training-Evaluation-Prediction) i.e. at the desk of AI Engineer, it's `yml` file based only, as it provides for the flexibility and reduce DB overhead
    * Alternatively, if we want to use DB we can have a flag as `dev/prod` for the Model Info
  * f) Upload **AI Experiment**
    * Select the **AI Dataset (AIDS)** for which the experiment needs to be executed
    * An experiment is the a **TEP (Training-Evaluation-Prediction) cycle** which may or may not graduate for **Publishing** to the AI API port
    * Each items of TEP i.e. T, E, P are linked list to the item in the other; example
      ```python
      T=['x','y','z']
      E=['a','b','c','d']
      P=['u','v']
      ```
      * This means: 3 training experiments conducted; 4 Evaluations on the given 3 experiments and 2 predictions
      * Questions to be answered:
        * Which evaluation experiment happened for which training experiment?
        * Prediction happened for which training experiment?
        * Does evaluation happened for prediction experiment?
        * Does the training experiment `y` is build on the top of training experiment `x` or independent?
        * Are training experiments are associative in nature wrt to the prediction quality?
          * example:
      * Here we need to **track the unique model** and **hierarchy of the model** across the workflow. This would provide the insight on how the model is evolved over experiments. Thus knowing this relationship along with the respective set of configurations helps to re-produce the model from its starting point to current state given that the dataset varaibles are not changed.
      * One relationship posibiliy is:
        ```
        y->x;
        a->x; b->y; c->y; d->y;
        u->x; v->b->z
        ```
        * This means:
          * training experiment x was conducted first and then training experiment y; but training y started from where training x stopped; whereas training experiment `z` is independent and does not use the starting point. This only determines the relationship of pre-trained model which is used as the starting point and not the relationship of the hyperparameters or training schedule which is more complex in relationship and hence left for human interpretation by looking at the hyperparameters. 
          * evaluation experiment `a` is done for training experiment `x` and  evaluation experiment `b,c,d` for training experiment `y`. No evaluation experiment done for training experiment `z`
          * prediction experiment `u` is done directly before evaluation experiment for training experiment `x`; whereas prediction experiment `v` is done after the evaluation experiment `b` which is done for training experiment `x`
        * Plotting this relationships can provide with some intitution on how the series of experiments to be conducted 
3. T: Execute training
4. E: Execute evaluation
5. P: Execute prediction on samples
6. P: Publish and release trained models to AI API
7. r: Generate reports - at any steps reports can be generated
8. For batch processing and other utility scripts
  * `/aimldl-cod/scripts/teppr`


### Train - Training on the (AIDS) AI Dataset

1. **Prepare for training**
  * a) Create AI Dataset where each AI Dataset is separate Database / files
  * b) Create AI experiment which is specific to a architecture
  * c) Visualize Annotations in each subset of AI Dataset
    * This is required to ensure AI Dataset looks is overall OK
  * d) Inspect Annotations
    * This is required to ensure if algorithim steps performs as expected
    * There should be no errors at this stage
  ```bash
  cd /aimldl-cod/apps/falcon
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
  cd /aimldl-cod/apps/falcon
  python falcon.py --help
  #
  ## Example:
  python falcon.py train --dataset PXL-250719_174248_250719_174534 --exp uuid-18a6fe37-083b-4319-99f0-7f5822044c29 1>${AI_LOGS}/mask_rcnn/train.output-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
  ```
3. Batch Training - **Detailed Instructions TODO**
  ```bash
  cd /aimldl-cod/scripts/teppr
  source run_batch_train.sh 1>${AI_LOGS}/run_batch_train-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
  ```

### Evaluate

1. **Create Modelinfo File under directory: `/aimldl-cfg/model`. Refer exisiting modelinfo file**
  a) Update the classes name with the proper sequence in which model was trained. Get the classinfo details from the training logs output under `/aimldl-dat/logs`
  ```bash
  <org_name>-<problem_id>-<training_dir_timestamp_from_logs_dir>-<arch_name>.yml
  vidteq-hmd-280919_180453-mask_rcnn.yml
  ```
2. **Create Evaluate experiment and upload it to DB**
  * a) Modify the evaluate experiment details, and point to proper modelinfo file
  * b) Upload the evaluate experiment to db
    ```bash
    python cfg2db.py create --type experiment --from /aimldl-cfg/arch/<archspecific_experiment_yml_file> --exp evaluate --to <ai_datasets_id>
    ## example
    python cfg2db.py create --type experiment --from /aimldl-cfg/arch/280919_173500-69-8-mask_rcnn.yml --exp evaluate --to aids-87c0c094-755a-4771-bd70-23e6a7d742b3
    ```
3. **Run the `evaluate`**
  ```bash
  python falcon.py <cmd> --dataset <dbname> --on <split_name> --exp <exp_id> --iou <value between_0_and_1>
  ## example
  python falcon.py evaluate --dataset PXL-240919_175423_250919_122117 --on val --exp uuid-6c70ae92-4d03-4c43-9d33-9712efda213e --iou 0.5
  ```

### Predict

### Publish - Release Model to AI API Port

1. Create Model config release directory if does not already exists.
  ```bash
  mkdir -p /aimldl-cfg/model/release
  ```
2. Create a Model config file under `/aimldl-cfg/model`.
  * This file ideally should already exists and would have been created after training to test and evaluate the model.
  * copy the same file under `/aimldl-cfg/model`
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
  cd /aimldl-cod/scripts/annon
  source run_batch_cfg2db_modelinfo.sh 1>${AI_LOGS}/run_batch_cfg2db_modelinfo-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
  ```
