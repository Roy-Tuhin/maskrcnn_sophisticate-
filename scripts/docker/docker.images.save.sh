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