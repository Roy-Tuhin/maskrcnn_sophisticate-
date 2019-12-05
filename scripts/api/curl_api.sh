#!/bin/bash

##----------------------------------------------------------
### curl script for api testing
##----------------------------------------------------------
#
# API_URL=$(echo ${API_URL} | replace '4040' '4141')
# echo "curl -X POST -F image=@${image} ${API_URL}"
# curl -X POST -F image=@${image} ${API_URL} &

# https://stackoverflow.com/questions/19116016/what-is-the-right-way-to-post-multipart-form-data-using-curl
# curl -X POST -F image=@${image} -F q=matterport-coco_things-1 "${API_URL}"

# # Ref: https://blog.keras.io/building-a-simple-keras-deep-learning-rest-api.html
# The -X flag and POST value indicates we're performing a POST request.
# We supply -F image=@dog.jpg to indicate we're submitting form encoded data.
# The image key is then set to the contents of the dog.jpg file.
# Supplying the @ prior to dog.jpg implies we would like cURL to load the contents of the image and pass the data to the request.
# Finally, we have our endpoint: http://localhost:5000/predict
#
## https://stackoverflow.com/questions/2953646/how-can-i-declare-and-use-boolean-variables-in-a-shell-script/21210966#21210966
#
## https://stackoverflow.com/questions/17293162/redirect-curl-output-to-stdout-and-log-files
## curl -o $OUTPUTFILE $URL 2>&1 | tee $LOGFILE 
# https://unix.stackexchange.com/questions/532731/how-to-redirect-curl-output-to-file-and-as-bash-function-parameter
#
##----------------------------------------------------------


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"

source "${SCRIPTS_DIR}/apicfg.sh"

function exec_curl() {
  local image=$1

  if [ -z ${image} ]; then
    image=${IMAGE_PATH}
  fi
  image_name=$(echo ${image} | rev | cut -d'/' -f 1 | rev)

  # echo ${image}
  # echo ${API_URL}
  # echo ${API_MODEL_KEY}
  # echo ${IMAGE_ARRAY[@]}
  local timestamp=$(date -d now +'%d%m%y_%H%M%S')

  local base_log_dir=${AI_LOGS}/api/curl-${timestamp}
  mkdir -p ${base_log_dir}

  local prog_log="${base_log_dir}"

# response="$(curl -H "Accept: application/json" -H "Content-Type:application/json" -X POST -F image=@${image} ${API_URL})"

  if [ ${BATCH_TEST} = true ]; then
    for image in "${IMAGE_ARRAY[@]}"; do
      image_name=$(echo ${image} | rev | cut -d'/' -f 1 | rev)
      log_filepath=${prog_log}/${image_name}.json
      curlopt=$(echo -H "Accept: application/json" -X POST -F image=@${image} ${API_URL})
      curl ${curlopt} -o ${log_filepath} | tee -a ${log_filepath} &
    done
  else
    log_filepath=${prog_log}/${image_name}.json
    if [ -z ${API_MODEL_KEY} ]; then
      curlopt=$(echo -H "Accept: application/json" -X POST -F image=@${image} ${API_URL})
      curl ${curlopt} -o ${log_filepath} | tee -a ${log_filepath} &
    else
      curlopt=$(echo -H "Accept: application/json" -X POST -F image=@${image} -F q=${API_MODEL_KEY} ${API_URL})
      curl ${curlopt} -o ${log_filepath} | tee -a ${log_filepath} &
    fi
  fi
}

exec_curl $1
