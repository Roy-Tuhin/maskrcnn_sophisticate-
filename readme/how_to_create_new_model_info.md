# How to create new model info

1. Model info files should be created under:
    * For dev and non-api: `/codehub/cfg/model`
    * For prod and API: `/codehub/cfg/model/release`
    * **TODO:** enhance with the `release_type` key in the model info to differentiate b/w dev and prod version
2. Model info yml files should be named in all **lower case letters** as follows:
    ```bash
    <org_name>-<problem_id>-<rel_num>-<dnnarch>.yml
    ```
    * Example: `vidteq-rld-1-lanenet.yml`, where:
      ```bash
      org_name=vidteq
      problem_id=rld
      rel_num=1
      dnnarch=lanenet
      ```
3. **Example** model info file for **rld** problem_id for **lanenet** DNN Arch
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
