#!/usr/bin/env python

import yaml
import os.path as osp

this_dir = osp.dirname(__file__)

configFileName = osp.join(this_dir,'..','paths.yml')

with open(configFileName, 'r') as f:
    cfg = yaml.safe_load(f)

with open(osp.join(this_dir,'..','dnncfg.yml'), 'r') as f:
    dnncfg = yaml.safe_load(f)