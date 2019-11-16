#!/bin/bash

##----------------------------------------------------------
## lopocs
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## LOPoCS is a point cloud server written in Python, allowing to load Point Cloud from a PostgreSQL database thanks to the pgpointcloud extension
#
## https://github.com/Oslandia/lopocs
#
##----------------------------------------------------------

if [ -z $LSCRIPTS ];then
  LSCRIPTS="."
fi

source $LSCRIPTS/linuxscripts.config.sh

if [ -z "$BASEPATH" ]; then
  BASEPATH="$HOME/softwares"
  echo "Unable to get BASEPATH, using default path#: $BASEPATH"
fi

DIR="lopocs"
PROG_DIR="$BASEPATH/$DIR"

URL="https://github.com/Oslandia/$DIR.git"

echo "Number of threads will be used: $NUMTHREADS"
echo "BASEPATH: $BASEPATH"
echo "URL: $URL"
echo "PROG_DIR: $PROG_DIR"

if [ ! -d $PROG_DIR ]; then
  git -C $PROG_DIR || git clone $URL $PROG_DIR
else
  echo Gid clone for $URL exists at: $PROG_DIR
fi

if [ -d $PROG_DIR/build ]; then
  rm -rf $PROG_DIR/build
fi

## Ideally to be installed in its own virtual environment, somehow it fixed the nastly numpy warning 
## that came when running tensorflow

cd $PROG_DIR
python3 setup.py build
pip3 install -e .

cd $LINUX_SCRIPT_HOME


##----------------------------------------------------------
## Build Log
##----------------------------------------------------------

# $ sudo pip3 install -e .
# The directory '/home/bhaskar/.cache/pip/http' or its parent directory is not owned by the current user and the cache has been disabled. Please check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
# The directory '/home/bhaskar/.cache/pip' or its parent directory is not owned by the current user and caching wheels has been disabled. check the permissions and owner of that directory. If executing pip with sudo, you may want sudo's -H flag.
# Obtaining file:///home/bhaskar/softwares/lopocs
# Requirement already satisfied: flask>=0.12 in /usr/local/lib/python3.6/dist-packages (from lopocs==0.1.dev0)
# Collecting flask-restplus==0.10.1 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/89/43/6b24a9c910129435d83beed5088b444b4705bae66c20cefe3798f2a0725a/flask_restplus-0.10.1-py2.py3-none-any.whl (1.0MB)
#     100% |████████████████████████████████| 1.0MB 598kB/s 
# Collecting flask-cors==3.0.2 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/4f/4f/ea10ca247c21b6512766cf730621697ec2766fb2f712245b2c00983a57b1/Flask_Cors-3.0.2-py2.py3-none-any.whl
# Collecting psycopg2-binary>=2.6.2 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/3f/4e/b9a5cb7c7451029f67f93426cbb5f5bebedc3f9a8b0a470de7d0d7883602/psycopg2_binary-2.7.5-cp36-cp36m-manylinux1_x86_64.whl (2.7MB)
#     100% |████████████████████████████████| 2.7MB 474kB/s 
# Collecting pyyaml==3.12 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz (253kB)
#     100% |████████████████████████████████| 256kB 1.2MB/s 
# Collecting pygdal<2.2.5,>=2.2.4 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/fd/17/21ebd7820c4d41f35c08f785bda6c239b26f0f3887d594b0dee8ba4eeb06/pygdal-2.2.4.3.tar.gz (428kB)
#     100% |████████████████████████████████| 430kB 882kB/s 
# Collecting redis==2.10.5 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/08/c1/457428f7507e27ba7144758a7b716ea35766e6d602f4a0c16e443ab3d381/redis-2.10.5-py2.py3-none-any.whl (60kB)
#     100% |████████████████████████████████| 61kB 782kB/s 
# Collecting py3dtiles==1.0.2 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/f0/ff/831472a4908823b0d8ab737c666c973de2e1bc8e454126e24878c0e2cf96/py3dtiles-1.0.2-py3-none-any.whl
# Requirement already satisfied: click==6.7 in /usr/local/lib/python3.6/dist-packages (from lopocs==0.1.dev0)
# Collecting requests==2.13.0 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/7e/ac/a80ed043485a3764053f59ca92f809cc8a18344692817152b0e8bd3ca891/requests-2.13.0-py2.py3-none-any.whl (584kB)
#     100% |████████████████████████████████| 593kB 277kB/s 
# Collecting lazperf==1.2.1 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/0f/03/6504cf309ff7278649f536a65b85edddcb51deba575079f3d7afc3b7f1b7/lazperf-1.2.1.tar.gz (190kB)
#     100% |████████████████████████████████| 194kB 2.0MB/s 
# Collecting numpy==1.14.3 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/71/90/ca61e203e0080a8cef7ac21eca199829fa8d997f7c4da3e985b49d0a107d/numpy-1.14.3-cp36-cp36m-manylinux1_x86_64.whl (12.2MB)
#     100% |████████████████████████████████| 12.2MB 138kB/s 
# Collecting pyproj==1.9.5.1 (from lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/29/72/5c1888c4948a0c7b736d10e0f0f69966e7c0874a660222ed0a2c2c6daa9f/pyproj-1.9.5.1.tar.gz (4.4MB)
#     100% |████████████████████████████████| 4.4MB 316kB/s 
# Requirement already satisfied: Jinja2>=2.10 in /usr/local/lib/python3.6/dist-packages (from flask>=0.12->lopocs==0.1.dev0)
# Requirement already satisfied: Werkzeug>=0.14 in /usr/local/lib/python3.6/dist-packages (from flask>=0.12->lopocs==0.1.dev0)
# Requirement already satisfied: itsdangerous>=0.24 in /usr/local/lib/python3.6/dist-packages (from flask>=0.12->lopocs==0.1.dev0)
# Collecting aniso8601>=0.82 (from flask-restplus==0.10.1->lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/17/13/eecdcc638c0ea3b105ebb62ff4e76914a744ef1b6f308651dbed368c6c01/aniso8601-3.0.2-py2.py3-none-any.whl
# Collecting jsonschema (from flask-restplus==0.10.1->lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/77/de/47e35a97b2b05c2fadbec67d44cfcdcd09b8086951b331d82de90d2912da/jsonschema-2.6.0-py2.py3-none-any.whl
# Requirement already satisfied: six>=1.3.0 in /usr/lib/python3/dist-packages (from flask-restplus==0.10.1->lopocs==0.1.dev0)
# Requirement already satisfied: pytz in /usr/local/lib/python3.6/dist-packages (from flask-restplus==0.10.1->lopocs==0.1.dev0)
# Collecting triangle (from py3dtiles==1.0.2->lopocs==0.1.dev0)
#   Downloading https://files.pythonhosted.org/packages/30/4d/e3c2992521f610ffb25fd7fc6e442279d53c5120c586060ff5547c863b97/triangle-20170429.tar.gz (1.4MB)
#     100% |████████████████████████████████| 1.4MB 709kB/s 
# Requirement already satisfied: cython in /usr/lib/python3/dist-packages (from py3dtiles==1.0.2->lopocs==0.1.dev0)
# Requirement already satisfied: MarkupSafe>=0.23 in /usr/lib/python3/dist-packages (from Jinja2>=2.10->flask>=0.12->lopocs==0.1.dev0)
# Installing collected packages: aniso8601, jsonschema, flask-restplus, flask-cors, psycopg2-binary, pyyaml, numpy, pygdal, redis, pyproj, triangle, py3dtiles, requests, lazperf, lopocs
#   Found existing installation: PyYAML 3.13
#     Uninstalling PyYAML-3.13:
#       Successfully uninstalled PyYAML-3.13
#   Running setup.py install for pyyaml ... done
#   Found existing installation: numpy 1.15.0
#     Uninstalling numpy-1.15.0:
#       Not removing or modifying (outside of prefix):
#       /usr/bin/f2py
#       Successfully uninstalled numpy-1.15.0
#   Running setup.py install for pygdal ... done
#   Running setup.py install for pyproj ... done
#   Running setup.py install for triangle ... done
#   Found existing installation: requests 2.18.4
#     Not uninstalling requests at /usr/lib/python3/dist-packages, outside environment /usr
#   Running setup.py install for lazperf ... done
#   Running setup.py develop for lopocs
# Successfully installed aniso8601-3.0.2 flask-cors-3.0.2 flask-restplus-0.10.1 jsonschema-2.6.0 lazperf-1.2.1 lopocs numpy-1.14.3 psycopg2-binary-2.7.5 py3dtiles-1.0.2 pygdal-2.2.4.3 pyproj-1.9.5.1 pyyaml-3.12 redis-2.10.5 requests-2.13.0 triangle-20170429
