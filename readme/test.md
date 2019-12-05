
cd /aimldl-cod/apps/annon
vi _annoncfg_.py
DBCFG['ANNONCFG']
,'dbname': 'annon_v3'

python annon_to_db.py --help
python annon_to_db.py create --from /aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_240919_121321/annotations

python db_to_aids.py --help
python db_to_aids.py create --by AIE3 --did hmd



cd /aimldl-cod/scripts
vi appcfg.py
DBCFG['ANNONCFG']
,'dbname': 'annon_v3'
source setup.sh


/aimldl-cod/apps/falcon
python falcon.py --help
python falcon.py visualize --dataset annon_v3
python falcon.py visualize --dataset PXL-161019_102459 --on test
python falcon.py visualize --dataset PXL-161019_102459 --on val
python falcon.py visualize --dataset PXL-161019_102459 --on train

cd /aimldl-cod/apps/annon
python teppr.py --help
python teppr.py create --type experiment --from /aimldl-cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-161019_102459 --exp train

train-40a82ba1-10aa-4a53-9e3b-bd87fa494588

/aimldl-cod/apps/falcon
python falcon.py --help
python falcon.py inspect_annon --dataset PXL-161019_102459 --on train --exp train-40a82ba1-10aa-4a53-9e3b-bd87fa494588


python teppr.py create --type experiment --from /aimldl-cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-161019_102459 --exp evaluate
evaluate-0b317019-a2d4-4ab8-b9ef-6929eb9734fd

python teppr.py create --type experiment --from /aimldl-cfg/arch/040919_162100-AIE3-1-mask_rcnn.yml --to PXL-161019_102459 --exp predict
predict-5068184a-347e-4b8d-928e-ccdcb1f08d0d

/aimldl-cod/apps/falcon
python falcon.py --help
python falcon.py predict --dataset PXL-161019_102459 --path /aimldl-dat/samples --iou 0.9 --exp predict-5068184a-347e-4b8d-928e-ccdcb1f08d0d
python falcon.py predict --dataset PXL-161019_102459 --path /aimldl-dat/samples/311218_101900_16716_zed_l_053.jpg --iou 0.9 --exp predict-5068184a-347e-4b8d-928e-ccdcb1f08d0d --save_viz


/aimldl-cod/apps/falcon
python falcon.py --help
python falcon.py evaluate --dataset PXL-161019_102459 --on test --iou 0.9 --exp evaluate-0b317019-a2d4-4ab8-b9ef-6929eb9734fd
