# How to Setup Lanenet and Api Port

## Setup Lanenet


**Credits**
* https://github.com/MaybeShewill-CV/lanenet-lane-detection
* https://github.com/nikhilbv/TuSimple-lane-classes


**1. Clone the lanenet repository**
  ```bash
  cd /aimldl-cod/external
  git clone https://github.com/nikhilbv/lanenet-lane-detection.git
  ```
**2. Change the working environment (python3 is required)**
  ```bash
  workon py_<tab-key>
  ```
**3. Install the required packages** - skip if the required packages are aleady present and required minimum version is already installed
  ```bash
  cd /aimldl-cod/external/lanenet-lane-detection
  pip install -r requirements.txt
  ```
**4. Download tusimple dataset** - Required for training; skip if only setting up for prediction
  ```bash
  google-chrome https://github.com/TuSimple/tusimple-benchmark/issues/3
  ```
  * Extact and put the content in folder: `/aimldl-dat/data-public/tusimple/`
**5. Download the pre-trained lanenet model**
  ```bash
  google-chrome https://www.dropbox.com/sh/tnsf0lw6psszvy4/AAA81r53jpUI3wLsRW6TiPCya?dl=0
  ```
  * Extract the zip file and put the content in folder: `/aimldl-dat/release/tusimple/`
  * Create the symlink for the model folder to point to the directory in within the lanet folder as given below:
    ```bash
    mkdir -p /aimldl-cod/external/lanenet-lane-detection/model
    ln -s /aimldl-dat/release/tusimple /aimldl-cod/external/lanenet-lane-detection/model/tusimple_lanenet_vgg
    ```
**6. Download the VGG16** - required for training from scratch
  ```bash
  google-chrome https://mega.nz/#!YU1FWJrA!O1ywiCS2IiOlUCtCpI6HTJOMrneN-Qdv3ywQP5poecM
  ```
  * Extract and put the content in folder: `/aimldl-dat/release/vgg16/`
  * Create the symlink
    ```bash
    ln -s /aimldl-dat/release/vgg16/vgg16.npy /aimldl-cod/external/lanenet-lane-detection/data/vgg16.npy
    ```
**7. To test a single image on the pre-trained lanenet model**
  ```bash
  cd /aimldl-cod/external/lanenet-lane-detection
  ## example-1
  python tools/test_lanenet.py --weights_path ./model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt  --image_path ./data/tusimple_test_image/0.jpg
  ## example-2
  python tools/test_lanenet.py --weights_path ./model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt  --image_path /aimldl-cod/practice/nikhil/sample-images/7.jpg
  ```
  * prediction results are image `.png` and `.json` are stored in the same directory: `/aimldl-cod/external/lanenet-lane-detection`: `image-*.png and pred-*.json`
  * Visualise the results:
    ```bash
    cd /aimldl-cod/external/lanenet-lane-detection
    python visualize_pred.py --image ./data/tusimple_test_image/0.jpg --json <pred-*.json>
    python visualize_pred.py --image /aimldl-cod/practice/nikhil/sample-images/7.jpg --json <pred-*.json>
    ## example-1:
    python visualize_pred.py --image ./data/tusimple_test_image/0.jpg --json pred-0-180919_105557.json
    ## example-2
    python visualize_pred.py --image /aimldl-cod/practice/nikhil/sample-images/7.jpg --json pred-7-180919_105730.json
    ```
  * press `CTR+C` on command line to close the visualization
**8. To generate training samples**
  * Firstly, download the `Tusimple dataset` and extract the files to the local disk
  * Then run the following command to generate the training samples and the `train.txt` file:
    ```bash
    cd /aimldl-cod/external/lanenet-lane-detection
    python tools/generate_tusimple_dataset.py --src_dir <path/to/your/unzipped/file>
    ## example
    python tools/generate_tusimple_dataset.py --src_dir /aimldl-dat/data-public/tusimple/train_set
    ```
**9. To generate the tensorflow records files**
  ```bash
  cd /aimldl-cod/external/lanenet-lane-detection
  python data_provider/lanenet_data_feed_pipline.py --dataset_dir ./data/training_data_example --tfrecords_dir ./data/training_data_example/tfrecords
  ## example
  python data_provider/lanenet_data_feed_pipline.py --dataset_dir /aimldl-dat/data-public/tusimple/train_set/training --tfrecords_dir /aimldl-dat/data-public/tusimple/train_set/training/tfrecords
  ```
**10. To train lanenet on tusimple dataset**
  * To train using `vgg` as pretrained model
    ```bash
    cd /aimldl-cod/external/lanenet-lane-detection
    python tools/train_lanenet.py --net vgg --dataset_dir ./data/training_data_example -m 0
    ## example
    python tools/train_lanenet.py --net vgg --dataset_dir /aimldl-dat/data-public/tusimple/train_set/training -m 0 1>logs/lanenet-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
    ```
  * Can also continue the training process from the snapshot by:
    ```bash
    cd /aimldl-cod/external/lanenet-lane-detection
    python tools/train_lanenet.py --net vgg --dataset_dir data/training_data_example/ --weights_path path/to/your/last/checkpoint -m 0
    ## example
    python tools/train_lanenet.py --net vgg --dataset_dir /aimldl-dat/data-public/tusimple/train_set/training --weights_path path/to/your/last/checkpoint -m 0 1>logs/lanenet-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
    ```
**11. To evaluate lanenet on whole tusimple directory**
  ```bash
  cd /aimldl-cod/external/lanenet-lane-detection
  python tools/evaluate_lanenet_on_tusimple.py --image_dir <ROOT_DIR>/<TUSIMPLE_DATASET>/test_set/clips --weights_path ./model/tusimple_lanenet_vgg/tusimple_lanenet.ckpt --save_dir <ROOT_DIR>/<TUSIMPLE_DATASET>/test_set/test_output
  ## example
  python tools/evaluate_lanenet_on_tusimple.py --image_dir /aimldl-dat/data-public/tusimple-sub/test_set/clips --weights_path /aimldl-cod/external/lanenet-lane-detection/model/tusimple_lanenet_vgg/tusimple_lanenet_vgg_2019-08-14-14-17-49.ckpt-80001 --save_dir /aimldl-cod/external/lanenet-lane-detection/tmp
  ```
**12. To visualize the ground truth annotations**
  ```bash
  cd /aimldl-cod/external
  git clone https://github.com/nikhilbv/TuSimple-lane-classes.git
  cd /aimldl-cod/external/TuSimple-lane-classes
  python tusimple_visualizer.py --root /path/to/dataset --labels labels_json_file.json
  ## example
  python tusimple_visualizer.py --root /aimldl-dat/data-public/tusimple-sub/train_set/ --labels label_data_0313.json
  ```

## Setup Lanenet Api Port

**Credits**
* https://github.com/jrosebr1/simple-keras-rest-api

* **Clone and start the API server**
  ```bash
  cd /aimldl-cod/external
  git clone https://github.com/nikhilbv/simple-keras-rest-api.git lanenet-server
  cd /aimldl-cod/external/lanenet-server
  python lanenet_server.py
  ```
## Quick API Testing

1. using `curl`
  ```bash
  cd /aimldl-cod/external/lanenet-server/api
  ## apicfg.sh -> change the configuration for testing
  source curl_api.sh
  ```

* custom configuration
* Test from the web
  * access the url from the web:`http://localhost:5050/predict`
  * upload the image and verify if API json response is returned or not
* create test scripts: call_api.py, stress_test.py


## References

* [Lanenet](https://github.com/MaybeShewill-CV/lanenet-lane-detection)
* [Simple Flask API](https://github.com/jrosebr1/simple-keras-rest-api)
* http://flask.pocoo.org/docs/patterns/fileuploads/
* https://stackoverflow.com/questions/49511753/python-byte-image-to-numpy-array-using-opencv
* https://stackoverflow.com/questions/46136478/flask-upload-how-to-get-file-name
* https://www.programcreek.com/python/example/60712/werkzeug.secure_filename
* https://stackoverflow.com/questions/39801728/using-flask-to-load-a-txt-file-through-the-browser-and-access-its-data-for-proce
