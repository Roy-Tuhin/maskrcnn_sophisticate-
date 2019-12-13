#!/bin/bash

# for i in $(seq 1 1 5); do echo $i; python call_api.py --api vidteq-rld-1; done

function test_pyapi() {
  source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/apicfg.sh

  api_model_key_test=${API_MODEL_KEY}
  N=${NUM_REQUESTS}

  if [ ! -z $1 ]; then
    api_model_key_test=$1
  fi

  for i in $(seq 1 1 ${N}); do
    echo ${i}
    # echo "python call_api.py --api ${api_model_key_test}"
    # python call_api.py --api ${api_model_key_test}
    
    for filepath in "${IMAGE_ARRAY[@]}"; do
      echo ${filepath}
      # echo "python call_api.py --api ${api_model_key_test} --image ${filepath}"
      python call_api.py --api ${api_model_key_test} --image ${filepath}
    done
  done
}

test_pyapi $1
