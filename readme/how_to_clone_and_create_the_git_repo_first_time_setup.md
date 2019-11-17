# How to clone and create the git repo first time setup

* `/codehub` is preferred to have username agnostic convention
  ```bash
  sudo apt update
  sudo apt install -y git
  #
  sudo mkdir -p /codehub
  sudo chown -R $(id -un):$(id -gn) /codehub
  #
  git clone --recurse-submodules https://github.com/mangalbhaskar/codehub.git /codehub
  cd /codehub
  git submodule update --init --recursive
  ```
