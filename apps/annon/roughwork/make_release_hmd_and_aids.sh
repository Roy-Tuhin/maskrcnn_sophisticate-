#!/bin/bash

##----------------------------------------------------------
## Convenience Script generates the HMD and AIDS incrementaly
## - Manual edit and then run
## - Not an automation script rather a convenience script
##----------------------------------------------------------
## Usage:
##----------------------------------------------------------
#
## source make_release_hmd_and_aids.sh
## OR
## source make_release_hmd_and_aids.sh
## OR
## source make_release_hmd_and_aids.sh aids
#
##----------------------------------------------------------
#
## References
# * https://www.shellscript.sh/functions.html
# * https://stackoverflow.com/questions/8512462/shellscript-looping-through-all-files-in-a-folder
# * https://stackoverflow.com/questions/2953646/how-to-declare-and-use-boolean-variables-in-shell-script
# * https://alvinalexander.com/linux-unix/linux-shell-script-counter-math-addition-loop
# * https://stackoverflow.com/questions/22727107/how-to-find-the-last-field-using-cut
# * https://stackoverflow.com/questions/11144408/convert-string-to-date-in-bash
# * https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/
# * https://www.cyberciti.biz/tips/linux-unix-get-yesterdays-tomorrows-date.html
#
## date --debug -d '191231' +'%Y-%m-%d'
##----------------------------------------------------------


workon_pyenv() {
  pyenv="$(lsvirtualenv -b | grep ^py_$ver | tr '\n' ',' | cut -d',' -f1)"
  # echo $pyenv
  workon $pyenv
}

make_incremental_release() {
  # echo "Inside: create_hmd_incrementally"
  workon_pyenv
  count=0
  echo -e "sno,file_release_date,release_name"
  # echo -e "file_release_date,release_name"

  echo "$release_what"

  for i in $format;
  do
   if [[ "$i" == "$format" ]]
   then
      echo -e "$count,,"
   else
      count=`expr $count + 1`
      release_name=`echo $i| rev | cut -d'/' -f1 | rev`
      file_release_date=`echo $release_name| rev | cut -d'_' -f1 | rev | cut -d'.' -f1`
      
      # echo $count
      echo -e "$count,$file_release_date,$release_name"
      # echo -e "$file_release_date,$release_name"
      if [ $release_what != "aids" ];then
        if ! $test_mode; then
          echo "$i"
          python annon2.py --path $i
        else
          echo "$release_what"
          echo "$i"
        fi
      else
        if ! $test_mode; then
          echo "$i"
          python annon2.py --path $i --aids
        else
          echo "$release_what"
          echo "$i"
        fi
      fi
   fi
  done
}

##----------------------------------------------------------
### Main script starts here
##----------------------------------------------------------

## python version should be python3 only
ver=3

release_what=$1
annon_base_path=$2
hmd_release_date_in_ddmmyy=$3

## change to true for debugging
test_mode=false

if [ -z $annon_base_path ]; then
  annon_base_path="$HOME/Documents/ai-ml-dl-gaze/AIML_Annotation/ods_job_230119/annotations"
fi

if [ -z $release_what ]; then
  release_what="hmd"
fi

if [ $release_what != "aids" ];then
  # echo $release_what
  echo "------->"
  ##----------------------------------------------------------
  ## HMD Release
  ##----------------------------------------------------------

  format=$annon_base_path/*.json
  # echo $format

  make_incremental_release
else
  ##----------------------------------------------------------
  ## AIDS Release
  ##----------------------------------------------------------

  hmd_base_path="$annon_base_path/hmddb"


  ## hmd_release_date_in_ddmmyy
  ## Manual replace this scention
  if [ -z $hmd_release_date_in_ddmmyy ]; then
    echo $hmd_release_date_in_ddmmyy
  fi

  ## change this date as required
  hmd_release_date_in_ddmmyy=040419
  format="$hmd_base_path/$hmd_release_date_in_ddmmyy"_*
  # echo $format

  make_incremental_release
fi
