
1. configure env variable

ai_py_envvars

/aimldl-cod/scripts/config.sh

AI_ENVVARS['LANENET_ROOT']="${AI_ENVVARS['AI_HOME_EXT']}/lanenet-lane-detection"

generate configurations

/aimldl-cod/scripts
source setup.sh

2. create configuration files
a) modelinfo
/aimldl-cfg/model/maybeshewill-rld-1-lanenet.yml


3. create arch file under 
/aimldl-cod/apps/falcon/arch/

use existing dnn as the starting point for APIs
cp mask_rcnn.py lanenet.py