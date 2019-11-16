#!/bin/bsh

#
# Commandline Simple Image Viewers
#

## https://github.com/derf/feh
# sudo apt install feh
#
man feh
feh
feh -Y -q -D 1 -R 5 -B white .
feh -q -D 1 -R 5 -B white -X  -d --draw-tinted --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white .
feh -Y -q -D 1 -R 5 -B white -W 800 .
feh -Y -q -D 1 -R 5 -B white -W 640 .
feh -Y -q -D 1 -R 5 -B white -g 640x480 .
feh -Y -q -D 1 -R 5 -B white -Z -g 640x480 .
feh -Y -q -D 1 -R 5 -B white -Z -g 640x480 --draw-exif .
feh -Y -q -D 1 -R 5 -B white -Z -g 640x480 -d --draw-tinted --draw-exif .
feh -Y -q -D 1 -R 5 -B white -Z -g 640x480 -d --draw-tinted --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -g 640x480 -d --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -W 700 -d --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -W 640 -d --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -H 640 -d --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -H 480 -d --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z --scale-down -d --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z --scale-down --draw-tinted --no-screen-clip --draw-exif --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -Z -z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -Z -z --draw-tinted --no-screen-clip --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -Z -z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -Z -z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" --auto-zoom  .
# feh -q -D 1 -R 5 -B white -Z -z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" --auto-zoom --zoom .
feh -q -D 1 -R 5 -Z -z --scale-down --draw-tinted --no-screen-clip --title "Title of Image Slideshow" --auto-zoom --zoom .
# feh -q -D 1 -R 5 -Z -z --scale-down -g 1280x720 --draw-tinted --no-screen-clip --title "Title of Image Slideshow" --auto-zoom --zoom .
# feh -q -D 1 -R 5 -Z -z --scale-down -g 1280x720 --draw-tinted --no-screen-clip --title "Title of Image Slideshow" --auto-zoom --zoom .
feh -Y -q -D 1 -R 5 -B white -Z -d --draw-tinted --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -z --scale-down -d --draw-tinted --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -z --scale-down -d --draw-tinted --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -X --scale-down -d --draw-tinted --title "Title of Image Slideshow" .
feh -Y -q -D 1 -R 5 -B white -Z -z -X --scale-down -d --draw-tinted --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -Z -z -X --scale-down -d --draw-tinted --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -X  -d --draw-tinted --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -X  -d --draw-tinted --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -X  --scale-down -d --draw-tinted --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -X  -d --draw-tinted --title "Title of Image Slideshow" .
feh -q -D 1 -R 5 -B white -X  -d --draw-tinted --title "Title of Image Slideshow" .
#
eog --slide-show .
eog --slide-show . --delay 1
#
# sudo apt install geeqie
#
# sudo apt install fbi
fbi -t 1 -1 .

# http://mirageiv.sourceforge.net/
# https://mycomputerhelp.net/2015/09/19/mirage-image-viewer-lightweight-linux-image-viewer-with-editing-tools-works-with-raspberry-pi-pc/
# sudo apt install mirage
mirage -fs .
