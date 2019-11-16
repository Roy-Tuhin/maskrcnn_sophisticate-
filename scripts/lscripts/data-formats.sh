#!/bin/bash

# Data Formats

## HDF- Hierarchical Data Format

# https://stackoverflow.com/questions/24744969/installing-h5py-on-an-ubuntu-server
sudo apt-get install libhdf5-dev
pip install h5py
#sudo apt-get install python-h5py
sudo apt-get -y install vitables

# * https://www.hdfgroup.org/
# * https://earthobservatory.nasa.gov/Features/HDFEOS/
#   - h5py rests on an object-oriented Python wrapping of the HDF5 C API. Almost anything you can do from C in HDF5, you can do from h5py.
#   - HDF-EOS employs standard HDF objects, including images, tables, text, and data arrays.
# * http://vitables.org
# - The HDF5 format is great to store huge amount of numerical data and manipulate this data from numpy.
# - Once you are done with training using Keras, you can save your network weights in HDF5 binary data format. In order to use this, you must # have the h5py package installed, which we did during installation.
# - For example, it’s easily possible to slice multi-terabyte datasets stored on disk as if they were real numpy arrays. You can also store multiple datasets in a single file, iterate over them or check out the .shape and .dtype attributes.

# https://gilscvblog.com/2013/08/18/a-short-introduction-to-descriptors/#more-3
# https://en.wikipedia.org/wiki/Histogram_of_oriented_gradients
# http://octomap.github.io/
