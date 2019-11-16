#!/bin/bash

## CPU
THEANO_FLAGS=mode=FAST_RUN,device=cpu,floatX=float32 python theano.install-test.py

## GPU wuth CUDA

## 1
#DEVICE="cuda" THEANO_FLAGS=mode=FAST_RUN,device=cuda,floatX=float32 python theano.install-test.py

## 2
DEVICE="cuda" THEANO_FLAGS=floatX=float32,device=cuda,optimizer=None,dnn.include_path=$CUDA_HOME/include,dnn.library_path=/usr/lib/x86_64-linux-gnu python theano.install-test.py

## http://randomized.me/index.php/2016/05/01/theano-playing-with-gpu-on-ubuntu-16-04/

### 3D-R2N2 demo execution

## DEVICE="cuda" THEANO_FLAGS=floatX=float32,device=cuda,optimizer=None,dnn.include_path=$CUDA_HOME/include,dnn.library_path=/usr/lib/x86_64-linux-gnu python demo.py prediction.obj

## DEVICE="cuda" THEANO_FLAGS=floatX=float32,device=cuda,optimizer_including=cudnn,gpuarray.preallocate=0.8,dnn.conv.algo_bwd_filter=deterministic,dnn.conv.algo_bwd_data=deterministic,dnn.include_path=/usr/local/cuda/include,dnn.library_path=/usr/lib/x86_64-linux-gnu  python demo.py prediction.obj
