# http://jd.benow.ca/
# https://github.com/java-decompiler/jd-gui

sudo apt install libgtk2.0-0
sudo apt-get -f install

sudo apt-get install  libgtk2.0-0:i386

# http://dulanja.blogspot.in/2013/01/how-to-install-jd-gui-on-ubuntu-64-bit.html
sudo apt-get install libgtk2.0-0:i386 libxxf86vm1:i386 libsm-dev:i386

# https://support.humblebundle.com/hc/en-us/articles/202759400-Installing-32-bit-libs-on-a-64-bit-Linux-system

# https://askubuntu.com/questions/359156/how-do-you-run-a-32-bit-program-on-a-64-bit-version-of-ubuntu
#sudo dpkg --add-architecture i386
#sudo apt-get update

# www.linuxquestions.org/questions/linux-software-2/gtk-message-failed-to-load-module-canberra-gtk-module-936168/
#sudo apt-get install libcanberra-gtk3-module

sudo apt-cache search libcanberra
sudo apt-cache policy libcanberra-gtk3-0
sudo apt-cache policy libcanberra-gtk3-0:i386

sudo apt-get install libcanberra-gtk3-0:i386


## OpenSfM

# https://github.com/mapillary/OpenSfM/issues/184

cmake .. -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC


sudo pip install sphinx
sudo pip install sphinx_rtd_theme
sudo pip install sphinx-autobuild

cd doc
make livehtml

# http://www.sphinx-doc.org/en/stable/install.html
# http://ceres-solver.org/installation.html

# https://launchpad.net/~ulikoehler/+archive/ubuntu/opensfm

# https://gis.stackexchange.com/questions/178226/how-can-i-install-pyproj-into-arcpy

# https://pypi.python.org/pypi/pyproj?

# https://www.devmanuals.net/install/ubuntu/ubuntu-16-04-LTS-Xenial-Xerus/how-to-install-python-pyproj.html

bin/simple_bundle_adjuster
