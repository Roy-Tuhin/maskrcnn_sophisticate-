# AI Machine System Setup

* A curated list of shell scripts, software packages and libraries for AI ML DL using Nvidia GPU
* Tested on `Ubuntu 16.04 LTS` and `Ubuntu  18.04 LTS`
* Compatible with `Kali Linux 2019.2`

## Credits

* Derivative of the repo: [`mangalbhaskar/linuxscripts`](https://github.com/mangalbhaskar/linuxscripts.git)


## Notes - Please Read!

* Most of the packages if not available would be downloaded automatically
* Nvidia CUDA, cuDNN and tensorRT packages needs to be downloaded manually
* Downloading URLs, references, instructions and debugging errors tips are provided as comments inside the scripts
* Adjust the configuration according to your requirements
* Ubuntu 18.04 LTS is preferred installation
* Specific versions are selected based on compatibility across different dependent packages. Changing them is not advisable and do that at your own risk. More details of compatibility issues in master repo here:  [`mangalbhaskar/linuxscripts - README`](https://github.com/mangalbhaskar/linuxscripts/blob/master/README.md)

* **Final Note**:
  * If there is an interrupt and the installation fails, restart the installation
  * Don't be afraid to open and read the scripts, and make any changes if required
  * Use commonsense ;)


## Configuration Settings

* `linuxscripts.config.sh`
  - Main configuration file  
* `versions.sh`
  - defines all the software version
* `numthreads.sh`
  - configures optimal CPU threads for software compilation
* `common.sh`
  - utility scripts and debugging help


## 1. Copy Software Packages to `$HOME/Downloads`
* from `samba5/softwares/packages-for-new-system-install` to local system under `$HOME/Downloads` manually, or use `rsync`
  ```bash
  smbuser="xxxxx"
  smbserver="xx.x.xx.121"
  remotepath="/data/samba/software/packages-for-new-system-install"
  rsync -r ${smbuser}@${smbserver}:${remotepath} $HOME/Downloads
  ```


## 2. Install Nvidia GPU Driver - **skip if pre-installed**

* **WARNING:**
  * the script will remove any pre-installed nvidia packages
  * Do not change/re-install driver if it is already installed probably in new system
* **NOTE:**
  * Check using command 'nvidia-smi'
  * Reboot happens once the nvidia graphics driver is installed
  * Download latest Nvidia Drivers
  * Nvidia Driver 410+ minimum is required for CUDA 10.0 support
  * **Nvidia Driver 430** and **CUDA 10.0 is preferred**
    ```bash
    cd $HOME/Downloads
    chmod +x NVIDIA-Linux-x86_64-430.26.run
    ```
  * Login to virtual console: `ctrl+alt+F2` and execute following commands:
    ```bash
    cd $HOME/Downloads
    #
    ## Ubuntu 16.04 LTS
    sudo service lightdm stop
    #
    ## Ubuntu 18.04 LTS
    sudo service gdm stop
    sudo ./NVIDIA-Linux-x86_64-430.26.run
    ```
  * follow the installer instructions and then **re-boot system** after nvidia driver installation
* after system is re-booted, verify nvidia driver installation
  ```bash
  cd /codehub/scripts/system
  source nvidia-driver-info.sh
  ```


## 3. Install CUDA, CUDNN and Related Packages
* **mandatory packages**
  ```bash
  cd /codehub/scripts/system
  source cuda.install.sh
  source cudnn.install.sh
  ```
* optional, but preferred
  ```bash
  source tensorRT.install.sh
  ```


## 4. Install System Utilities and Other Software Packages

* **Execute `setup.sh` and `setup-extended.sh`**
  ```bash
  cd /codehub/scripts/system
  source setup.sh
  source setup-extended.sh
  ```


### Apache Configurations
   * Setup apache configuration for `userdir` and `wsgi`
   * The entries are already in output in terminal and color coded
   * These **settings are optimal only for development environment** and **not recommended** for **production deployment** and the production level configurations are provided elsewhere in the parent repo for individual components
   * Open and edit the required files as instructed in the terminal output


## 5. Verify System Installation

* By the end of the above steps, all the required system packages would be installed
* python virtual envrionment would be created with all the pre-requisites
* a) tensorflow, keras GPU based
* b) **Apache server test**
  * Test the apache2, process in browser by:
    ```bash
    http://localhost/~<username>
    http://localhost/~<username>/info.php
    ```
  * `wsgi-bin` test - **TODO**


## Debugging Installation Errors

* Open and read scripts for common errors and fixes, references and solutions are provided for different cases


### Python Environment Setup

* **Installing the python environment wrappers for python2 and python3**
  ```bash
  #
  ## For python2
  source python.virtualenvwrapper.install.sh 2
  #
  ## For python3
  source python.virtualenvwrapper.install.sh 3
  #
  ## `deactivate` is the command used to exit from environment
  deactivate
  ```
* **Install the required packages for AI only in python3 env**
  ```bash
  workon py_3 <and press tab key>
  pip install -r python.requirements-extras.txt
  pip install -r python.requirements-ai.txt
  ```
* **Note**: If there is an interrupt and the installation fails, restart the installation


### CUDA, cuDNN, tensorRT related issues

* Check `gcc` compactibility - **TODO: put proper compatibility issues**
* CUDA-9.0, cuDNN7 (gcc <= 6), CUDA-10.0, cuDNN7 (gcc <= 7)
  ```bash
  gcc --version
  ```


## Remote Access Setup - optional
* **Ubuntu 18.04 LTS**
  * `settings->sharing->'Remote Login': On`
  * `settings->sharing->'Screen Sharing': Active => Access Options as Require a password`
  * enable automatic login under: `settings->details->users`
  * disable automatic suspend: `settings->power->'Automatic suspend: Off`
* **Ubuntu 16.04 LTS**
  * Terminal commands for remote access
    ```bash
    sudo apt-get install openssh-server openssh-client dconf-editor
    ```
  * Allow ubuntu to do automatic login from `system settings panel`
  * `gsettings` for remote access:
    ```bash
    sudo gsettings set org.gnome.Vino require-encryption false
    ```
  * Remote desktop sharing preferences
    ```bash
    sudo vino-preferences
    ```
  * Check `Allow other users to view desktop`
  * Uncheck `You must confirm each access to this machine`
  * Check `Require the user to enter this password: <password>`


## Sublime editor settings - optional

* Refer: [technotes - sublime-text-editor](https://github.com/mangalbhaskar/technotes/blob/master/sublime-text-editor.md)

