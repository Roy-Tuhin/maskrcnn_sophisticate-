#!/bin/bash

## Ref:
## https://learn.sparkfun.com/tutorials/computer-vision-and-projection-mapping-in-python/all

## first time setup: need to make sure that everything is up to date
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade

## Launch the Raspberry Pi Config
sudo raspi-config

# Under the Interfacing Options tab, enable the Camera module. You’ll need to reboot before the changes take effect. If you think you’ll use the features, it can be convenient to enable ssh and VNC while you’re at it

# The Raspberry Pi has a built-in command line application called raspistill that will allow you to capture a still image. Open a terminal window and enter the following command

raspistill -o image.jpg

sudo reboot


# Dlib is a modern C++ toolkit containing machine learning algorithms and tools for creating complex software in C++ to solve real world problems.

sudo apt-get install libcblas.so.3
sudo apt-get install libatlas3-base
sudo apt-get install libjasper-dev

## python
pip install opencv-contrib-python
pip install "picamera[array]"
pip install imutils
pip install dlib

## Calibrate the Camera
## Camera calibration is one of those really important steps that shouldn't be overlooked.

# Calibration allows us to gather the camera's intrinsic properties and distortion coefficients so we can correct it. The great thing here is that, as long as our optics or focus don't change, we only have to calibrate the camera once!

# camera calibration also allows us to determine the relationship between the camera's pixels and real world units (like millimeters or inches).

# I've tried other calibration techniques gathering multiple views as well, and I found putting the calibration image on a tablet was useful. The screen of the tablet is very flat, and the fact that image is emitted light, not reflected, makes the ambient lighting not matter.

# We also load in our charuco board. Charuco boards are a combination of aruco markers (think along the lines of QR code marker) and a chessboard pattern. With the combination of both technologies, it is actually possible to get sub pixel accuracy
# https://docs.opencv.org/3.4.3/df/d4a/tutorial_charuco_detection.html
