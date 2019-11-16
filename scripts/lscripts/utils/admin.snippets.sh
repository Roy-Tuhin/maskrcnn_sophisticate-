## https://esc.sh/blog/how-to-create-new-normal-user-with-sudo/

useradd -m username
passwd username
usermod -a -G sudo username
chsh -s /bin/bash username
