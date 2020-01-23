# How to create new release


## Code release

* DNN Arch are not submodules and hence, they are loosely bound by the comments provided while creating the releases of individual DNN and of the codehub
* Create the release tags for individual DNN arch under `external` directory and **push the release tags to the repo**
  * Mention it's own release tag the comments for each DNN
* Create the release tag for the `codehub` and **push the release tag to the repo**
  * Mention the release tag of individual DNN arch in the comments for the `codehub` release tag
* **Example for `external/Mask_RCNN`** release tag: `rc-v3.1`
    ```bash
    git tag -a rc-v3.1 -m 'initial_epoch changes for training'
    git show rc-v3.1
    git push origin rc-v3.1
    # ## delete
    # git tag -d rc-v3.1
    # git push origin --delete rc-v3.1
    #
    ```
* **Example for `external/lanenet-lane-detection`** release tag: `v2.0`
    ```bash
    git tag -a v2.0 -m 'prediction clipping and lanenet:rod pre-release, depends on latest release of codehub'
    git show v2.0
    git push origin v2.0
    # ## delete
    # git tag -d v2.0
    # git push origin --delete v2.0
    #
    ```
* **Example for `/codehub`** release tag: `v0.2.0`
    ```bash
    git tag -a v0.2.0 -m 'mask_rcnn:rc-v3.1;lanenet:v2.0 - refer readme/changelist.md for details'
    git show v0.2.0
    git push origin v0.2.0
    # ## delete
    # git tag -d v0.2.0
    # git push origin --delete v0.2.0
    #
    ```

