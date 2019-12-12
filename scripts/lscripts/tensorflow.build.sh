#!/bin/bash

## https://www.tensorflow.org/install/source

mkdir -p /codehub/tmp
cd /external4docker/tensorflow

## tf 1.13.1, bazel 0.21.0
## https://github.com/tensorflow/tensorflow/issues/10289
## https://github.com/bazelbuild/bazel/issues/6648
bazel build --config=opt --config=cuda --action_env PATH="$PATH"  --incompatible_strict_action_env=false //tensorflow/tools/pip_package:build_pip_package
bazel build --config=opt --config=cuda --action_env PATH="$PATH"  --incompatible_strict_action_env=false //external4docker/tensorflow/tensorflow/tools/pip_package:build_pip_package
bazel build --verbose_failures --config=opt --config=cuda --action_env PATH="$PATH"  --incompatible_strict_action_env=false //external4docker/tensorflow/tensorflow/tools/pip_package:build_pip_package




bazel build --color=yes --curses=yes --config=cuda\
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    tensorflow_serving/model_servers:tensorflow_model_server



./bazel-bin/tensorflow/tools/pip_package/build_pip_package /codehub/tmp/tensorflow_pkg


# #To build a pip package for TensorFlow with GPU support, invoke the following command:
# bazel build --config=opt --config=cuda --incompatible_load_argument_is_label=false //tensorflow/tools/pip_package:build_pip_package

# bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.1 --copt=-msse4.2 --config=cuda -k //tensorflow/tools/pip_package:build_pip_package


# bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package 

# #The bazel build command builds a script named build_pip_package. Running this script as follows will build a .whl file within the /tmp/tensorflow_pkg directory:
# ##bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
# bazel-bin/tensorflow/tools/pip_package/build_pip_package tensorflow_pkg

# bazel-bin/tensorflow/tools/pip_package/build_pip_package

# # Generate whl
# bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
# # sudo pip2 install <pckNam_that_ws_generated_in_revious_step>


tensorflow/tensorflow:devel
tensorflow/tensorflow:devel-gpu-py3

docker run -it -w /tensorflow -v $PWD:/mnt -e HOST_PERMS="$(id -u):$(id -g)" tensorflow/tensorflow:devel-gpu-py3 bash
docker run -it -w /tensorflow -v $PWD:/mnt -e HOST_PERMS="$(id -u):$(id -g)" -u $(id -u):$(id -g) tensorflow/tensorflow:devel-gpu-py3 bash