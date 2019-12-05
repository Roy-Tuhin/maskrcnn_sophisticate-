#!/bin/bash

# local pyver=3
# local pyenv=$(lsvirtualenv -b | grep ^py_$pyver | tr '\n' ',' | cut -d',' -f1)
# workon ${pyenv}

ip=0.0.0.0

## TODO: different guicorn server for different model
# port=4040
# api_model_key='vidteq-hmd-1'
# queue=true
queue=false

# port=4041
# api_model_key='maybeshewill-rld-1'

port=4100
api_model_key='vidteq-rld-1'

## https://unix.stackexchange.com/questions/229049/how-to-increment-local-variable-in-bash
# workers=$(($(cut -f 2 -d '-' /sys/devices/system/cpu/online)+2))
# echo "Total number of gunicorn works: 2*(CPU) + 1: ${workers}"

## gunicorn web_server:app -b "$ip:$port"

# gunicorn web_server:app -b "$ip:$port" --timeout 60 --log-level=debug

## gunicorn web_server:app -b "$ip:$port" --timeout 120 --graceful-timeout 90 --log-level=debug
## gunicorn --workers=${workers} web_server:app -b "$ip:$port"

gunicorn web_server:"main(API_MODEL_KEY='"${api_model_key}"', QUEUE='"${queue}"')" -b "${ip}:${port}"  --timeout 60 --log-level=debug
