#!/bin/bash

# ## List images
# ## https://stackoverflow.com/questions/50285252/docker-images-output-as-json-using-format
# ## https://docs.docker.com/config/formatting/
# ## https://golang.org/pkg/text/template/
# docker images repo1 --format "{{json . }}"
# docker images --format "{{json .Repository }}:{{json .Tag}}"
# docker images --format "{{ .Repository }}:{{.Tag}}" | grep nvidia

# docker images --format "{{ .Repository }}:{{.Tag}}" | grep nvidia

# ## save image
# ## https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-using-a-repository#23938978
# docker save -o <path for generated tar file> <image name>

# ## load image
# docker load -i <path to image tar file>


# ## http://www.ivarch.com/programs/pv.shtml
# ## pv - Pipe Viewer - is a terminal-based tool for monitoring the progress of data through a pipeline. It can be inserted into any normal pipeline between two processes to give a visual indication of how quickly data is passing through, how long it has taken, how near to completion it is, and an estimate of how long it will be until completion.

# docker save <image> | bzip2 | pv | ssh user@host 'bunzip2 | docker load'

# ## to do this in reverse (remote to local):

# ssh target_server 'docker save image:latest | bzip2' | pv | bunzip2 | docker load

# ## Save the image with id:
# sudo docker save -o /home/matrix/matrix-data.tar matrix-data
# sudo docker load -i <path to copied image file>

# docker save <docker image name> | gzip > <docker image name>.tar.gz
# zcat <docker image name>.tar.gz | docker load



# ## backing up the container
# docker export CONTAINER_ID > my_container.tar

# cat my_container.tar | docker import - my_container:new


imagelist=($(docker images --format "{{ .Repository }}:{{.Tag}}:{{.ID}}"))
# imagelist=($(docker images --format "{{ .Repository }}:{{.Tag}}:{{.ID}}"| grep python))
echo "imagelist: ${imagelist[@]}"
basedir="images"
for img in "${imagelist[@]}"; do
  # echo "img: ${img}"
  # echo ${img}| cut -d':' -f1 | pv | ls
  repo=`echo ${img}| cut -d':' -f1`
  tag=`echo ${img}| cut -d':' -f2`
  imgid=`echo ${img}| cut -d':' -f3`
  img_filename=${tag}-${imgid}.tar.gz
  image_name=${repo}:${tag}

  echo "image_name: ${image_name}"
  echo "repo: ${repo}"
  echo "tag: ${tag}"
  echo "imgid: ${imgid}"
  echo "img_filename: ${img_filename}"

  mkdir -p ${basedir}/${repo}
  # docker save -o ${basedir}/${repo}/${img_filename} ${image_name}
  echo "docker save ${image_name} | gzip > ${basedir}/${repo}/${img_filename}"
  docker save ${image_name} | gzip > ${basedir}/${repo}/${img_filename}
done

# zcat images/3.7.0-alpine.tar.gz | docker load


# imagelist: mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v7-20191211_1739:7128d332c24d mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20191211_1656:50dbbeb953a3 tensorflow/tensorflow:devel:f138802e5390 nvidia/cuda:9.0-cudnn-7.6.4.38-devel-ubuntu16.04:869f6fec7f54 nvidia/cuda:9.0-devel-ubuntu16.04:869f6fec7f54 nvidia/cuda:9.0-runtime-ubuntu16.04:53e28bfcb2d0 httpd:latest:d4a061d58465 nvidia/cuda:9.0-base-ubuntu16.04:4592f7559467 redis:redis-latest:a5872ad64c01 nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04:2ffdc4989c0c nvidia/cuda:10.0-devel-ubuntu18.04:3a79c12184df nvidia/cuda:10.0-runtime-ubuntu18.04:cf35c0a96857 nvidia/cuda:10.0-base-ubuntu18.04:da02332dfcfb portainer/portainer:latest:d1219c88aa21 ubuntu:16.04:5f2bf26e3524 tensorflow/tensorflow:devel-gpu-py3:86e502766639 web:latest:3510563f329f ammaorg/aquiladb:latest:1f9697b82b3e nvidia/cuda:latest:946e78c7b298 tensorflow/tensorflow:1.14.0-gpu-py3-jupyter:60c989453335 mongouid:latest:f3c72327bdb0 mangalbhaskar/aimldl:mongodb-v4.1.13-kalilinux-2019.1-v1-151110_000700:f3c72327bdb0 takacsmark/swarm-example:1.0:92c30c1b7828 mongo:latest:0fb47b43df19 ubuntu:18.04:7698f282e524 ubuntu:bionic:7698f282e524 ubuntu:latest:7698f282e524 tensorflow/tensorflow:1.13.1-gpu-py3-jupyter:26b85a1c8892 mongo:4.0.3:05b3651ee24e python:3.7.0-alpine:cf41883b24b8
# image_name: mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v7-20191211_1739
# repo: mangalbhaskar/aimldl
# tag: 10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v7-20191211_1739
# imgid: 7128d332c24d
# img_filename: 10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v7-20191211_1739-7128d332c24d.tar.gz
# docker save mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v7-20191211_1739 | gzip > images/mangalbhaskar/aimldl/10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidevmin-v7-20191211_1739-7128d332c24d.tar.gz
# image_name: mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20191211_1656
# repo: mangalbhaskar/aimldl
# tag: 10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20191211_1656
# imgid: 50dbbeb953a3
# img_filename: 10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20191211_1656-50dbbeb953a3.tar.gz
# docker save mangalbhaskar/aimldl:10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20191211_1656 | gzip > images/mangalbhaskar/aimldl/10.0-cudnn-7.6.4.38-devel-ubuntu18.04-aidev-v7-20191211_1656-50dbbeb953a3.tar.gz
# image_name: tensorflow/tensorflow:devel
# repo: tensorflow/tensorflow
# tag: devel
# imgid: f138802e5390
# img_filename: devel-f138802e5390.tar.gz
# docker save tensorflow/tensorflow:devel | gzip > images/tensorflow/tensorflow/devel-f138802e5390.tar.gz
# image_name: nvidia/cuda:9.0-cudnn-7.6.4.38-devel-ubuntu16.04
# repo: nvidia/cuda
# tag: 9.0-cudnn-7.6.4.38-devel-ubuntu16.04
# imgid: 869f6fec7f54
# img_filename: 9.0-cudnn-7.6.4.38-devel-ubuntu16.04-869f6fec7f54.tar.gz
# docker save nvidia/cuda:9.0-cudnn-7.6.4.38-devel-ubuntu16.04 | gzip > images/nvidia/cuda/9.0-cudnn-7.6.4.38-devel-ubuntu16.04-869f6fec7f54.tar.gz
# image_name: nvidia/cuda:9.0-devel-ubuntu16.04
# repo: nvidia/cuda
# tag: 9.0-devel-ubuntu16.04
# imgid: 869f6fec7f54
# img_filename: 9.0-devel-ubuntu16.04-869f6fec7f54.tar.gz
# docker save nvidia/cuda:9.0-devel-ubuntu16.04 | gzip > images/nvidia/cuda/9.0-devel-ubuntu16.04-869f6fec7f54.tar.gz
# image_name: nvidia/cuda:9.0-runtime-ubuntu16.04
# repo: nvidia/cuda
# tag: 9.0-runtime-ubuntu16.04
# imgid: 53e28bfcb2d0
# img_filename: 9.0-runtime-ubuntu16.04-53e28bfcb2d0.tar.gz
# docker save nvidia/cuda:9.0-runtime-ubuntu16.04 | gzip > images/nvidia/cuda/9.0-runtime-ubuntu16.04-53e28bfcb2d0.tar.gz
# image_name: httpd:latest
# repo: httpd
# tag: latest
# imgid: d4a061d58465
# img_filename: latest-d4a061d58465.tar.gz
# docker save httpd:latest | gzip > images/httpd/latest-d4a061d58465.tar.gz
# image_name: nvidia/cuda:9.0-base-ubuntu16.04
# repo: nvidia/cuda
# tag: 9.0-base-ubuntu16.04
# imgid: 4592f7559467
# img_filename: 9.0-base-ubuntu16.04-4592f7559467.tar.gz
# docker save nvidia/cuda:9.0-base-ubuntu16.04 | gzip > images/nvidia/cuda/9.0-base-ubuntu16.04-4592f7559467.tar.gz
# image_name: redis:redis-latest
# repo: redis
# tag: redis-latest
# imgid: a5872ad64c01
# img_filename: redis-latest-a5872ad64c01.tar.gz
# docker save redis:redis-latest | gzip > images/redis/redis-latest-a5872ad64c01.tar.gz
# image_name: nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04
# repo: nvidia/cuda
# tag: 10.0-cudnn-7.6.4.38-devel-ubuntu18.04
# imgid: 2ffdc4989c0c
# img_filename: 10.0-cudnn-7.6.4.38-devel-ubuntu18.04-2ffdc4989c0c.tar.gz
# docker save nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04 | gzip > images/nvidia/cuda/10.0-cudnn-7.6.4.38-devel-ubuntu18.04-2ffdc4989c0c.tar.gz
# image_name: nvidia/cuda:10.0-devel-ubuntu18.04
# repo: nvidia/cuda
# tag: 10.0-devel-ubuntu18.04
# imgid: 3a79c12184df
# img_filename: 10.0-devel-ubuntu18.04-3a79c12184df.tar.gz
# docker save nvidia/cuda:10.0-devel-ubuntu18.04 | gzip > images/nvidia/cuda/10.0-devel-ubuntu18.04-3a79c12184df.tar.gz
# image_name: nvidia/cuda:10.0-runtime-ubuntu18.04
# repo: nvidia/cuda
# tag: 10.0-runtime-ubuntu18.04
# imgid: cf35c0a96857
# img_filename: 10.0-runtime-ubuntu18.04-cf35c0a96857.tar.gz
# docker save nvidia/cuda:10.0-runtime-ubuntu18.04 | gzip > images/nvidia/cuda/10.0-runtime-ubuntu18.04-cf35c0a96857.tar.gz
# image_name: nvidia/cuda:10.0-base-ubuntu18.04
# repo: nvidia/cuda
# tag: 10.0-base-ubuntu18.04
# imgid: da02332dfcfb
# img_filename: 10.0-base-ubuntu18.04-da02332dfcfb.tar.gz
# docker save nvidia/cuda:10.0-base-ubuntu18.04 | gzip > images/nvidia/cuda/10.0-base-ubuntu18.04-da02332dfcfb.tar.gz
# image_name: portainer/portainer:latest
# repo: portainer/portainer
# tag: latest
# imgid: d1219c88aa21
# img_filename: latest-d1219c88aa21.tar.gz
# docker save portainer/portainer:latest | gzip > images/portainer/portainer/latest-d1219c88aa21.tar.gz
# image_name: ubuntu:16.04
# repo: ubuntu
# tag: 16.04
# imgid: 5f2bf26e3524
# img_filename: 16.04-5f2bf26e3524.tar.gz
# docker save ubuntu:16.04 | gzip > images/ubuntu/16.04-5f2bf26e3524.tar.gz
# image_name: tensorflow/tensorflow:devel-gpu-py3
# repo: tensorflow/tensorflow
# tag: devel-gpu-py3
# imgid: 86e502766639
# img_filename: devel-gpu-py3-86e502766639.tar.gz
# docker save tensorflow/tensorflow:devel-gpu-py3 | gzip > images/tensorflow/tensorflow/devel-gpu-py3-86e502766639.tar.gz
# image_name: web:latest
# repo: web
# tag: latest
# imgid: 3510563f329f
# img_filename: latest-3510563f329f.tar.gz
# docker save web:latest | gzip > images/web/latest-3510563f329f.tar.gz
# image_name: ammaorg/aquiladb:latest
# repo: ammaorg/aquiladb
# tag: latest
# imgid: 1f9697b82b3e
# img_filename: latest-1f9697b82b3e.tar.gz
# docker save ammaorg/aquiladb:latest | gzip > images/ammaorg/aquiladb/latest-1f9697b82b3e.tar.gz
