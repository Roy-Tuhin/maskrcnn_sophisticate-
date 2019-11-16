#sudo -i
sudo echo "deb [arch=amd64] http://downloads.quanergyworks.com/qview/ubuntu/ trusty main" >> /etc/apt/sources.list
wget -O - http://downloads.quanergyworks.com/qview/key/quanergy.key | sudo apt-key add -
sudo add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl
sudo apt-get update
sudo apt-get install quanergy-qview 
