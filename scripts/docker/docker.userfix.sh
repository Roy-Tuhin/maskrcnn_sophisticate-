#!/bin/bash


function docker_userfix() {
  local SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${SCRIPTS_DIR}/docker.config.sh"

  addgroup --gid "${HUSER_GRP_ID}" "${HUSER_GRP}"
  adduser --disabled-password --force-badname --gecos '' "${HUSER}" \
      --uid "${DUSER_ID}" --gid "${HUSER_GRP_ID}" 2>/dev/null
  usermod -aG sudo "${HUSER}"
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
  cp -r /etc/skel/. /home/${HUSER}
  echo '
  export PATH=${PATH}:/usr/local/bin

  export PS1="\[\e[0;31m\]\u\[\033[00m\]@\h:\[\033[01;32m\]\t\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$"
  alias lt="ls -lrth"
  # ulimit -c unlimited
  ' >> "/home/${HUSER}/.bashrc"

  # Set user files ownership to current user, such as .bashrc, .profile, etc.
  chown ${HUSER}:${HUSER_GRP} /home/${HUSER}
  ls -ad /home/${HUSER}/.??* | xargs chown -R ${HUSER}:${HUSER_GRP}
}

docker_userfix
