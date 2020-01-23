#!/bin/bash

FILE=${HOME}/.bashrc
echo "Modifying ${FILE}"
LINE="source /codehub/config/codehub.env.sh"
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="source /codehub/config/aimldl.env.sh"
grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

source ${FILE}

pip install IPython[all] jupyter_nbextensions_configurator
pip install pymongo easydict
pip install arrow pandas
pip install scikit-image
pip uninstall numpy
pip install numpy==1.17.5


cd /codehub/apps

# jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root
