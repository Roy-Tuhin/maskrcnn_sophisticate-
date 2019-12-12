#!/bin/bash


##----------------------------------------------------------
### docker add user
##----------------------------------------------------------

addgroup --gid "$DOCKER_GRP_ID" "$DOCKER_GRP"
adduser --disabled-password --force-badname --gecos '' "$DOCKER_USER" \
    --uid "$DOCKER_USER_ID" --gid "$DOCKER_GRP_ID" 2>/dev/null
usermod -aG sudo "$DOCKER_USER"
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
cp -r /etc/skel/. /home/${DOCKER_USER}
echo '
export PATH=${PATH}:/usr/local/bin

export PS1="\[\e[0;31m\]\u\[\033[00m\]@\h:\[\033[01;32m\]\t\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$"
alias lt="ls -lrth"
# ulimit -c unlimited
' >> "/home/${DOCKER_USER}/.bashrc"

# Set user files ownership to current user, such as .bashrc, .profile, etc.
chown ${DOCKER_USER}:${DOCKER_GRP} /home/${DOCKER_USER}
ls -ad /home/${DOCKER_USER}/.??* | xargs chown -R ${DOCKER_USER}:${DOCKER_GRP}