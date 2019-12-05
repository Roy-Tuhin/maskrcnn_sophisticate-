# Create Git-Repo on the Internal Server

* Example illustrated to create `aimldl-cfg` repo for the first time on the server
* On the central server
  ```bash
  ## ssh to the server
  ssh <username>@xx.x.xx.100
  cd /xxx/yyy/zzz/git-repo
  mkdir -p aimldl-cfg
  cd aimldl-cfg
  git init --bare
  ```
* **On the client** which has the original code to be versioned, **first time push**
  ```bash
  cd /aimldl-cfg
  git init
  git remote add origin <username>@xx.x.xx.100:/xxx/yyy/zzz/git-repo/aimldl-cfg
  git remote -v
  git push --set-upstream origin master
  #git branch --set-upstream-to=origin/master
  ```
* **Other clients**
  ```bash
  git clone <username>@xx.x.xx.100:/xxx/yyy/zzz/git-repo/aimldl-cfg
  ```