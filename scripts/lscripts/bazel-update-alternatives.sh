#!/bin/bash

##----------------------------------------------------------
## bazel multiple version configuration
## Tested on Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## bazel required for ocmpiling tensorflow from source
## different version of tensorflow requries different bazel version
## Inspired from: gcc-update-alternatives.sh
#
##----------------------------------------------------------

## for multiple version
# sudo mv /usr/local/lib/bazel /usr/local/lib/bazel-${BAZEL_VER}
# sudo ln -s /usr/local/lib/bazel-${BAZEL_VER} /usr/local/lib/bazel
sudo update-alternatives --install /usr/local/bin/bazel bazel /usr/local/lib/bazel-${BAZEL_VER}/bin/bazel 200

## TF 1.15.0, max ver
sudo update-alternatives --install /usr/local/bin/bazel bazel /usr/local/lib/bazel-0.26.1/bin/bazel 200
## TF 1.15.0, min ver
sudo update-alternatives --install /usr/local/bin/bazel bazel /usr/local/lib/bazel-0.24.1/bin/bazel 150
## TF 1.13.1
sudo update-alternatives --install /usr/local/bin/bazel bazel /usr/local/lib/bazel-0.21.0/bin/bazel 100

sudo update-alternatives --config bazel
