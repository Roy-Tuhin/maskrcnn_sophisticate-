#!/bin/bash

## https://flatpak.org
## https://flatpak.org/setup/Ubuntu/
sudo add-apt-repository -y ppa:alexlarsson/flatpak
sudo -E apt update
sudo -E apt -q -y install flatpak

