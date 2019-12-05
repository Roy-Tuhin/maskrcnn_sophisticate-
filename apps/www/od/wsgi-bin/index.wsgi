__author__ = 'mangalbhaskar'
__version__ = '1.0'
"""
## The WSGI configuration
# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
"""
import os
import sys

BASE_PATH_CFG = '/aimldl-cfg'
APP_ROOT_DIR = os.path.join('/aimldl-cod','apps')
WEB_APP_NAME = 'od'
sys.path.insert(0, APP_ROOT_DIR)

# if APP_ROOT_DIR not in sys.path:
  # sys.path.insert(0, APP_ROOT_DIR)

import _cfg_
appcfg = _cfg_.load_appcfg(BASE_PATH_CFG)
# print("appcfg: {}".format(appcfg))

APP_PATHS = appcfg['PATHS']
APACHE_HOME = APP_PATHS['APACHE_HOME']
# AI_WSGIPythonPath = APP_PATHS['AI_WSGIPythonPath']
AI_WSGIPythonHome = APP_PATHS['AI_WSGIPythonHome']
APP_PATH = os.path.join(APACHE_HOME,WEB_APP_NAME,'wsgi-bin')

sys.path.insert(0, AI_WSGIPythonHome)
sys.path.insert(0, APP_PATH)
sys.path.insert(0, APP_ROOT_DIR)


# sys.path.insert(0, "/home/baaz/virtualmachines/virtualenvs/py_3-7-3_2019-05-07/lib/python3.7/site-packages/")
# sys.path.insert(0, "/home/baaz/public_html/infinity/wsgi-bin")

# print("sys.path: {}".format(sys.path))

## Initialize WSGI app object

# from index import app as application
# application.debug = True

# from index import app
from web_server import app
application = app
# application.debug = True
