#!/bin/bash


function init_graphics_multemedia() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ##----------------------------------------------------------
  ## Graphics, Multimedia
  ##----------------------------------------------------------

  source ${LSCRIPTS}/vlc.install.sh
  source ${LSCRIPTS}/ffmpeg.install.sh
  ## source ${LSCRIPTS}/imagemagic.graphics.install.sh
  source ${LSCRIPTS}/inkscape.graphics.install.sh
  source ${LSCRIPTS}/gimp.graphics.install.sh
}

init_graphics_multemedia
