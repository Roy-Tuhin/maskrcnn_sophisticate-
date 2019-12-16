#!/bin/bash

## based on dockerfile builds
sudo apt -y update
sudo apt -y install --no-install-recommends \
  build-essential \
  ca-certificates \
  gnupg2 \
  libcurl3-dev \
  libfreetype6-dev \
  libhdf5-serial-dev \
  libzmq3-dev \
  software-properties-common \
  pkg-config \
  rsync \
  unzip \
  zip \
  zlib1g-dev \
  wget \
  curl \
  git \
  swig \
  grep \
  vim \
  sudo \
  libpng-dev \
  libjpeg-dev \
  automake \
  libtool
