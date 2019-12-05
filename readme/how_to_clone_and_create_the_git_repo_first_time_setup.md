# How to clone and create the git repo first time setup

## codehub

* Installer script: run the following command on command prompt
  ```bash
  wget -O - https://raw.githubusercontent.com/mangalbhaskar/codehub/master/scripts/codehub.init.sh | bash
  ```

## aimldl

* `/aimldl-cod` is preferred to have username agnostic convention
* clone the repo at the system root path along with submodules repo:
* `/aimldl-rpt`, `/aimldl-doc`, `/aimldl-kbank`, `/aimldl-dat`, `/aimldl-cfg` - These are internal repo related to data, document and knowledge management. Thus clone them based on internal git-repo setup
* Installer script: run the following command on command prompt
  ```bash
  wget -O - https://raw.githubusercontent.com/mangalbhaskar/aimldl/master/scripts/aimldl.init.sh | bash
  ```
