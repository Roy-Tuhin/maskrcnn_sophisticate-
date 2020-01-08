#!/bin/bash

function cuda_select() {
  if [ -L /usr/local/cuda ]; then
    ls -ltr /usr/local/cuda
    local SET_CUDA_VER

    echo "Enter CUDA VERSION X.Y eg: 8.0, 9.0, 9.1, 9.2, 10.0, 10.1, 10.2"
    read SET_CUDA_VER
    if [ ! -z ${SET_CUDA_VER} ]; then
      echo "You entered SET_CUDA_VER: ${SET_CUDA_VER}"
      if [ -d /usr/local/cuda-${SET_CUDA_VER} ]; then
        echo "Executing following..."
        echo "sudo rm -rf /usr/local/cuda"
        echo "sudo ln -s /usr/local/cuda-${SET_CUDA_VER} /usr/local/cuda"
        sudo rm -rf /usr/local/cuda
        sudo ln -s /usr/local/cuda-${SET_CUDA_VER} /usr/local/cuda
        echo ""
        echo "Update the specific gcc version for the respective CUDA version."
        echo "Ref: gcc.install.sh and gcc-update-alternatives.sh"
        echo ""
        nvcc --version
      else
        echo "Specified cuda version is not installed!"
      fi
    else
      echo "You have not specified any cuda version to select!"
    fi
  else
    echo "cuda is not configured as a symbolic link and hence cannot be configured in this way yet!"
    echo "Before proedding configure cuda as a symbolic link to the specific version: ref: 'cuda.config.sh'"
  fi
}

cuda_select
