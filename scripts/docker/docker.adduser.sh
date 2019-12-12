#!/bin/bash

## https://www.computerhope.com/unix/adduser.htm
## https://www.cyberciti.biz/faq/linux-change-user-group-uid-gid-for-all-owned-files/
## https://wiki.bash-hackers.org/scripting/debuggingtips

function docker_adduser() {
  # source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/docker.config.sh

  addgroup --gid "${HUSER_GRP_ID}" "${HUSER_GRP}"
  adduser --disabled-password --force-badname --gecos '' "${HUSER}" --uid "${HUSER_ID}" --gid "${HUSER_GRP_ID}" 2>/dev/null
  usermod -aG sudo "${HUSER}"
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

  # addgroup --gid "${HUSER_GRP_ID}" "${HUSER_GRP}"
  # useradd -ms /bin/bash ${HUSER} --uid ${HUSER_ID} --gid ${HUSER_ID}
  # echo "${HUSER}:${HUSER}" | chpasswd
  # adduser ${HUSER} sudo
  # echo "user ALL=(root) NOPASSWD:ALL" >> /etc/sudoers.d/user
  # echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/user

  cp -r /etc/skel/. /home/${HUSER}
  echo '
  export PATH=${PATH}:/usr/local/bin

  export PS1="\[\e[0;31m\]\u\[\033[00m\]@\h:\[\033[01;32m\]\t\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$"
  alias lt="ls -lrth"
  alias l="ls -lrth"
  # ulimit -c unlimited
  ' >> "/home/${HUSER}/.bashrc"

  # Set user files ownership to current user, such as .bashrc, .profile, etc.
  chown ${HUSER}:${HUSER_GRP} /home/${HUSER}
  ls -ad /home/${HUSER}/.??* | xargs chown -R ${HUSER}:${HUSER_GRP}
}

docker_adduser
