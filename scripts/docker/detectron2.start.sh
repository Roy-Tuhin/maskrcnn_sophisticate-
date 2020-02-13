#!/bin/bash

# containerid=detectron2_2

# docker container stop detectron2_2 && docker container rm detectron2_2

docker run --gpus=all -it --name detectron2 -p 8888:8888 --ipc=host --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --volume="/aimldl-cod:/aimldl-cod:rw" --volume="/codehub:/codehub:rw" --volume="/aimldl-dat:/aimldl-dat:rw" --volume="/codehub-config:/codehub-config:rw" detectron2:v0

xhost + local:detectron2_2
docker container start detectron2_2
docker container attach detectron2_2

apt update
apt install vim sshfs


# jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root


## Open multiple bash terminal for already running container
docker exec -it container_name bash
## Example
docker exec -it detectron2 bash