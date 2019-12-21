Setting up nodejs (8.10.0~dfsg-2ubuntu0.4) ...
update-alternatives: using /usr/bin/nodejs to provide /usr/bin/js (js) in auto mode
Processing triggers for libc-bin (2.27-3ubuntu1) ...

Command 'npm' not found, but can be installed with:

sudo apt install npm


Command 'npm' not found, but can be installed with:

sudo apt install npm

v8.10.0
mkdir: cannot create directory ‘/.npm-packages’: Permission denied
touch: cannot touch '/.npmrc': Permission denied
bash: /.npmrc: Permission denied
bash: ${CODEHUB_ENV_FILE}: ambiguous redirect
bash: ${CODEHUB_ENV_FILE}: ambiguous redirect
bash: ${CODEHUB_ENV_FILE}: ambiguous redirect
update_env_file: command not found


ln: failed to create symbolic link '/usr/local/cuda/lib64/stubs/libcuda.so.1': File exists
./cuda-10.0-with-tensorrt.aptget-install.sh: line 72: /etc/ld.so.conf.d/z-cuda-stubs.conf: Permission denied
Reading package lists... Done
Building dependency tree       




+ mktemp -d
+ export GNUPGHOME=/tmp/tmp.QXEGMvACEI
+ gpg2 --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
gpg: keybox '/tmp/tmp.QXEGMvACEI/pubring.kbx' created
gpg: keyserver receive failed: Cannot assign requested address
The command '/bin/sh -c set -ex;     apt-get update;   apt-get install -y --no-install-recommends     wget   ;   if ! command -v $gpgcmd > /dev/null; then     apt-get install -y --no-install-recommends gnupg dirmngr gnupg2;   fi;   rm -rf /var/lib/apt/lists/*;     dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')";   wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch";   wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc";   export GNUPGHOME="$(mktemp -d)";   $GPGCMD --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4;   $GPGCMD --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu;   command -v gpgconf && gpgconf --kill all || :;   rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc;   chmod +x /usr/local/bin/gosu;   gosu --version;   gosu nobody true;     wget -O /js-yaml.js "https://github.com/nodeca/js-yaml/raw/${JSYAML_VERSION}/dist/js-yaml.js";     apt-get purge -y --auto-remove wget' returned a non-zero code: 2
