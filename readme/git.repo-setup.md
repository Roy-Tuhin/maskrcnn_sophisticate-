## Server Setup - ONLY ONCE

1. Log into remote server and create bare git-repo
```bash
ssh -X swuser@10.4.71.100
cd /home/mapdata/software/git-repo/
mkdir -p aimldl-doc
cd aimldl-doc
git init --bare
```

## Client

1. On Client: Creator - **ONLY ONCE**
```bash
touch .gitignore
git init
git remote add origin swuser@10.4.71.100:/home/mapdata/software/git-repo/aimldl-doc
git add -A
git commit -m'first cut files'
git push -u origin master
git push --set-upstream origin master
##
git pull && git rm test.txt  && git commit -m'removed test' && git push
```

2. On Client: Anyone else - **Any number of time**
```bash
sudo mkdir -p /aimldl-doc
cd /aimldl-doc
sudo chown -R $(id -un):$(id -gn) .
cd /
git clone swuser@10.4.71.100:/home/mapdata/software/git-repo/aimldl-doc /aimldl-doc
##
touch test.txt && git add test.txt && git commit -m'testing' && git push
```
