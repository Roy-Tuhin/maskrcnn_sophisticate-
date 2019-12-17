
1. configure env variable

ai_py_envvars

/codehub/scripts/config.sh

AI_ENVVARS['LANENET_ROOT']="${AI_ENVVARS['AI_HOME_EXT']}/lanenet-lane-detection"

generate configurations

/codehub/scripts
source setup.sh

2. create configuration files
a) modelinfo
/codehub/cfg/model/maybeshewill-rld-1-lanenet.yml


3. create arch file under 
/codehub/apps/falcon/arch/

use existing dnn as the starting point for APIs
cp mask_rcnn.py lanenet.py