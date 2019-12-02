# How to clone and create the git repo first time setup


* Code hub installer script: run the following command on command prompt
  ```bash
  wget -O - https://raw.githubusercontent.com/mangalbhaskar/codehub/master/scripts/codehub.init.sh | bash
  ```
* `codehub.init.sh` execcutes following instructions:
  ```bash
  #!/bin/bash

  sudo apt update
  sudo apt install -y git
  #
  sudo mkdir -p /codehub
  sudo chown -R $(id -un):$(id -gn) /codehub
  #
  git clone --recurse-submodules https://github.com/mangalbhaskar/codehub.git /codehub
  cd /codehub
  git submodule update --init --recursive

  cd /codehub/scripts
  source setup.sh
  ```
