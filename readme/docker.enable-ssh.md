&& apt-get install -y ffmpeg libportaudio2 openssh-server python3-pyqt5 xauth


apt install openssh-server  \
&& mkdir /var/run/sshd \
&& mkdir /root/.ssh \
&& chmod 700 /root/.ssh \
&& ssh-keygen -A \
&& sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication no/" /etc/ssh/sshd_config \
&& sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
&& sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
&& grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config


ENTRYPOINT ["sh", "-c", "/usr/sbin/sshd && bash"]
CMD ["bash"]


Note that if you plan on SSH’ing into the Docker host as well (like I did from my laptop to the docker host), you need to set X11Forwarding to yes in /etc/ssh/sshd_config on the docker host as well. Then reload and restart the SSH daemon (on Ubuntu this was systemctl daemon-reload && systemctl restart sshd).

https://sean.lane.sh/posts/2019/07/Running-the-Real-Time-Voice-Cloning-project-in-Docker/


Add the following to your SSH config at ~/.ssh/config on the docker host (or create the file if it doesn’t exists):

Host voice
    Hostname localhost
    Port 2150
    User root
    ForwardX11 yes
    ForwardX11Trusted yes



docker run -it --rm --init --runtime=nvidia \
  --ipc=host --volume="$PWD:/workspace" \
  -e NVIDIA_VISIBLE_DEVICES=0 -p 2150:22 \
  --device /dev/snd voice-base
nvidia-smi
cd /workspace/Real-Time-Voice-Cloning
python demo_cli.py
exit


The option --device /dev/snd should allow the container to pass sound to the docker host, though I wasn’t able to get sound working going from laptop->docker_host->container.


From the docker host, this is done with:

ssh -X voice