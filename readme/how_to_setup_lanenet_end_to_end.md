## End to end workflow of Lanenet
1. Manually creates a folder eg `lnd_poc_250913_123730` in path `/aimldl-dat/data-gaze/AIML_Annotation` & copy paste the annotation file from `10.4.71.121/samba5/AIML_Annotation/rld_job_110919/annotations`. Specify the annotation job_id everytime you run the command.
```bash
cd /aimldl-cod/apps/annon
python lanenet_get_annon.py --job_id <'job_id'>
python lanenet_get_annon.py --job_id rld_job_230919
```
2. Convert the annotation file from VIA format to tuSimple specific format
** Note ** - Make sure node package is installed and go through `readme` to execute the code or else install by -
```bash
npm install convert-via-format-to-tusimple-format
```
** Note ** - This will save the tusimple format json in the same path of input file
```bash
cd /aimldl-cod/apps/annon
node lanenet-convertviatotusimple.js <'path/to/VIA-format-annotation-file'>
node lanenet-convertviatotusimple.js /aimldl-dat/data-gaze/AIML_Annotation/lnd_poc-211019_115628/images-p1-230919_AT1_via205_081019.json
```
3. Get images from server
** Note ** - Creates a db in `/aimldl-dat/data-gaze/AIML_Database`
```bash
cd /aimldl-cod/apps/annon
python lanenet_get_images.py --json_file <'path/to/tusimple-format-json-file'>
python lanenet_get_images.py --json_file /aimldl-dat/data-gaze/AIML_Annotation/lnd_poc_151019_104019/images-p1-270919_AT1_via205_141019_tuSimple.json
```
4. Create splits respective to the number of lanes per image
** Note ** - Take the json from AIML_Database folder
```bash
cd /aimldl-cod/apps/annon
python lanenet_split.py --json_file <'path/to/tusimple-format-annotation-file'>
python lanenet_split.py --json_file /aimldl-dat/data-gaze/AIML_Database/lnd-181019_145803/images-p1-270919_AT1_via205_141019_tuSimple-181019_145803.json
```
5. Generate tusimple AI dataset
```bash
cd /aimldl-cod/apps/annon
python lanenet_db_to_aids.py --src_dir <'path/to/source-directory'>
python lanenet_db_to_aids.py --src_dir /aimldl-dat/data-gaze/AIML_Database/lnd-211019_141208/
```
6. Data Preparation
```bash
cd /aimldl-cod/external/lanenet-lane-detection
python data_provider/lanenet_data_feed_pipline.py --dataset_dir <'path/to/training-dataset'> --save_dir <'/data/totraining-data/tfrecords'>
python data_provider/lanenet_data_feed_pipline.py --dataset_dir /aimldl-dat/data-gaze/AIML_Aids/lnd-211019_181258/training --tfrecords_dir /aimldl-dat/data-gaze/AIML_Aids/lnd-211019_181258/training/tfrecords
```
7. Train
```bash
python tools/train_lanenet.py --net <'vgg'> --dataset_dir <'path/to/training-dataset'> -m 0
python tools/train_lanenet.py --net vgg --weights_path <'path/to/last-checkpoint'> --dataset_dir /aimldl-dat/data-public/tusimple/train_set/training -m 0 1>/aimldl-dat/logs/lanenet/train/lanenet-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
```
8. Predict
** Optional ** - Use `--pred 1` for predictions without gt and that will be saved in `predict` folder in save_dir
```bash
python tools/predict.py --src <'path/to/image/directory/json'> --weights_path <'path/to/weights'> --save_dir <'path/to/save_predictions'>
python tools/predict.py --src /aimldl-dat/samples/lanenet/7.jpg --weights_path model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt --save_dir /aimldl-dat/logs/lanenet/predict
python tools/predict.py --src /aimldl-dat/samples/lanenet --weights_path model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt --save_dir /aimldl-dat/logs/lanenet/predict
python tools/predict.py --src /aimldl-dat/data-gaze/AIML_Database/lnd-211019_120637/images-p1-230919_AT1_via205_081019_tuSimple-211019_120637.json --weights_path model/tusimple_lanenet_vgg/tusimple_lanenet_vgg.ckpt --save_dir /aimldl-dat/logs/lanenet/predict
```
9. Convert the xy format lanenet's output file to tuSimple specific format
** Note ** - This will save the tusimple format json in the same path of input file
```bash
cd /aimldl-cod/apps/annon
node lanenet-convertviatotusimple.js --pred <'path/to/XY-format_annotation_file'>
node lanenet-convertviatotusimple.js --pred /aimldl-dat/data-gaze/AIML_Annotation/lnd_poc-211019_115628/images-p1-230919_AT1_via205_081019.json
```
10. Evaluate
```bash
cd /aimldl-cod/external/tusimple-benchmark/evaluate
python lane.py <'path/to/prediction-json'> <'path/to/ground-truth-json'>
python lane.py /home/nikhil/Documents/nodeFormatter/prediction/pred.json /home/nikhil/Documents/nodeFormatter/prediction/gt.json
```