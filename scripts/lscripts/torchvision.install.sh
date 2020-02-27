#!/bin/bash

git clone --recursive https://github.com/pytorch/vision.git /codehub/external/vision

cd /codehub/external/vision

python setup.py install