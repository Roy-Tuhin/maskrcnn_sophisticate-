#!/bin/bash

## Ref:
# https://www.cyberciti.biz/faq/bash-iterate-array/

## contactenate files with new line
## list_path="$HOME/Documents/ai-ml-dl-gaze/AIML_Database_Test/release/050619_203319/images-p1-230119_AT2_via205_010219"
## paste --delimiter=\\n --serial $list_path/image*.txt > $list_path/all-images.txt


imagelist_csv="${HOME}/Documents/ai-ml-dl-gaze/AIML_Database_Test/data/050619_233029/IMAGELIST.csv"
copy_to_base_path="${HOME}/Documents/aimldl/apps/annon/samples/AIML_Annotation"

copy_images() {
  declare -a imagepaths=(`cat $imagelist_csv | cut -d',' -f3`)
  declare -a image_base_path=(`cat $imagelist_csv | cut -d',' -f2`)
  local i
  local total=${#imagepaths[*]}
  for (( i=0; i<=$(( $total -1 )); i++ ));do
    # echo ${imagepaths[$i]}
    # mkdir -p $copy_to_base_path/${image_base_path[$i]}
    cp "${imagepaths[$i]}" "$copy_to_base_path/${image_base_path[$i]}"
  done
}

copy_images