# FAQ's

## How to add new sub-module to the parent repo
  * https://git-scm.com/book/en/v2/Git-Tools-Submodules
  ```bash
  git submodule add <git-repo-url> <dirName-optional>
  ```

## How to Create Git-Repo on the Internal Server

* Example illustrated to create `aimldl-doc` repo for the first time on the server
* On the central server
  ```bash
  ## ssh to the server
  ssh <username>@xx.x.xx.100
  cd /xxx/yyy/zzz/git-repo
  mkdir -p aimldl-doc
  cd aimldl-doc
  git init --bare
  ```
* **On the client** which has the original code to be versioned, **first time push**
  ```bash
  cd /aimldl-doc
  git init
  git remote add origin <username>@xx.x.xx.100:/xxx/yyy/zzz/git-repo/aimldl-doc
  git remote -v
  git push --set-upstream origin master
  #git branch --set-upstream-to=origin/master
  ```
* **Other clients**
  ```bash
  git clone <username>@xx.x.xx.100:/xxx/yyy/zzz/git-repo/aimldl-doc
  ```
