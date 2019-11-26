
## Different submodules

* `scripts/docker/dockerfiles/cuda`
  * https://github.com/mangalbhaskar/mongo.git
* `scripts/docker/dockerfiles/mongo`
  * https://gitlab.com/nvidia/container-images/cuda.git


## FAQ's submodules

* **How to list submodules?**
  ```bash
  git config --file .gitmodules --get-regexp path | awk '{ print $2 }'
  # git config --file .gitmodules --get-regexp path
  ```
