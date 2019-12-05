#!/bin/bash

##----------------------------------------------------------
## feh script viewer utilitity for multiple slideshow at the sametime
## Tested on Kali Linux 2019, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## based on number of slideshow and screen-resolution find out the calculate rows and columns and determine the width and height of the slideshow window
#
## For Image: WxH=1920x1080 and AP=1.78, re-sized h,w can be: [{'w': 320, 'h': 192, 'ap': 1.67}, {'w': 448, 'h': 256, 'ap': 1.75}, {'w': 576, 'h': 320, 'ap': 1.8}, {'w': 640, 'h': 384, 'ap': 1.67}, {'w': 704, 'h': 384, 'ap': 1.83}, {'w': 768, 'h': 448, 'ap': 1.71}, {'w': 896, 'h': 512, 'ap': 1.75}, {'w': 960, 'h': 576, 'ap': 1.67}, {'w': 1024, 'h': 576, 'ap': 1.78}]
#
## width=640
## height=480
#
## https://www.raspberrypi.org/forums/viewtopic.php?p=1469102
## https://www.hecticgeek.com/2011/12/command-line-based-image-viewer-ubuntu-linux/
#
## https://www.cyberciti.biz/faq/how-do-i-find-out-screen-resolution-of-my-linux-desktop/
#
## xdpyinfo  | grep 'dimensions:'
## xrandr | grep '*'
#
## https://superuser.com/questions/196532/how-do-i-find-out-my-screen-resolution-from-a-shell-script
## How do I find out my screen resolution from a shell script?
## xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'
## W=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
## H=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
#
##
## https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash#918931
## IN="bla@some.com;john@home.com"
## https://stackoverflow.com/questions/18668556/comparing-numbers-in-bash
#
## https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed
#
## https://unix.stackexchange.com/questions/244372/how-to-execute-shell-command-produced-using-echo-and-sed
#
## https://unix.stackexchange.com/questions/198045/how-to-strip-the-last-slash-of-the-directory-path
#
## feh -Y -q -D ${delay} -R 5 -B white -Z -g ${width}x${height} -d --draw-tinted --draw-exif ${path1} & feh -Y -q -D 1 -R 5 -B white -Z -g ${width}x${height}+${width} -d --draw-tinted --draw-exif ${path2} &
#
## https://stackoverflow.com/questions/12722095/how-do-i-use-floating-point-division-in-bash#12722107
#
##----------------------------------------------------------

# set -x #echo on
# set +x

function create_slideshow() {
  local paths_in=$1
  if [ -z ${paths_in} ]; then
    echo "paths is missing, using default path!"

    local path1='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p3-250219_AT5/'
    local path2='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p2-120619_AT2/'
    local path3='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p1-271218_AT0/'
    local path4='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p1-271218_AT0/'
    local path5='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p1-271218_AT0/'
    local path6='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p1-271218_AT0/'
    local path7='/aimldl-dat/data-gaze/AIML_Annotation/ods_merged_on_050719/images/images-p1-271218_AT0/'

    local paths_in="${path1}"
    local paths_in="${path1};${path2}"
    local paths_in="${path1};${path2};${path3}"
    local paths_in="${path1};${path2};${path3};${path4}"
    local paths_in="${path1};${path2};${path3};${path4};${path5}"
    # local paths_in="${path1};${path2};${path3};${path4};${path5};${path6}"
    # local paths_in="${path1};${path2};${path3};${path4};${path5};${path6};${path7}"
    # return
  fi

  local paths_arr=(${paths_in//;/ })
  # echo ${paths_arr[@]}
  local items=${#paths_arr[@]}

  ## TODO: calculate total number of rows and columns for the number of image window based on total number of images to be viewed
  ## item, row, column, scale
  ## 1, 1, 1, fullscreen
  ## 2, 1, 2, scale-down 
  ## 3, 1, 3, scale-down 
  ## 4, 2, 2, scale-down 
  ## 5, 2, 3, scale-down 
  ## 6, 2, 3, scale-down 
  ##

  ## add the defailt delay to the total number of items as it takes more time to view each image window, 1 sec per imaage window
  local delay=$2
  if [ -z ${delay} ]; then
    echo "default delay us 1 second!"
    delay=${items}
  fi

  ## determine the screen resolution
  local W=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
  local H=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

  local gutter=10
  local maxcols=3
  local rows=0
  local cols=0

  if (( items%maxcols == 0 )); then
    rows=$(( items/maxcols ))
  else
    rows=$(( items/maxcols + 1))
  fi

  if (( items%maxcols == 0 )) || (( items > maxcols )); then
    cols=3
  else
    cols=$(( items%maxcols ))
  fi
  echo "Rows: ${rows}, Cols: ${cols}"

  local width=$((W/cols - gutter))
  local height=$((H/rows - gutter))

  local fehcmd=""
  local slideshowcmd=""
  local xoffset=0
  local yoffset=0
  local count=0

  ## determine how many slideshow needs to be created simultaneously; ideally not more than 3
  for path in "${paths_arr[@]}"; do
    count=$(expr ${count} + 1)
    echo "count: $count, rows: $rows, a: $(( count/rows))"
    if (( count == 1 )) && (( count%rows == 0)); then
    # if (( count == 1 )) || (( count/rows == rows)) && (( count%rows == 0)); then
      xoffset=0
    else
      xoffset=$(( xoffset + width + gutter))
    fi

    # echo ${xoffset}
    path=${path%/}
    # echo ${path}
    title=$(echo ${path} | rev | cut -d'/' -f1 | rev)
    # echo $title

    ## with border
    fehcmd="feh -Y -q -D ${delay} -R 5 -B white -Z -z --scale-down -g ${width}x${height}+${xoffset}+${yoffset} -d --draw-tinted --draw-exif --no-screen-clip --auto-zoom ${path}"
    
    ## borderless
    # fehcmd="feh -Y -q -D ${delay} -R 5 -B white -Z -z -x --scale-down -g ${width}x${height}+${xoffset} -d --draw-tinted --draw-exif --no-screen-clip --auto-zoom ${path}"
    slideshowcmd=${slideshowcmd}${fehcmd}" & "

    if (( count%maxcols == 0 )); then
      xoffset=0
      yoffset=$(( yoffset + height + gutter))
    fi
  done

  echo ${slideshowcmd}
  echo ${slideshowcmd} | bash
}

create_slideshow $1 $2
