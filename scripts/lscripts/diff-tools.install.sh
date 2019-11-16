#!/bin/bash

# Reference:
# https://askubuntu.com/questions/2946/what-are-some-good-gui-diff-and-merge-applications-available-for-ubuntu
# https://www.slant.co/topics/5882/~linux-diff-tools
# https://www.linuxlinks.com/difftools/
# tkdiff - https://packages.ubuntu.com/trusty/tkdiff

# * xxdiff - File and directories comparator and merge tool
# * KDiff3  - Text difference analyzer for up to 3 input files
# * Kompare - KDE diff tool
# * DiffMerge -   Visually compare and merge files
# * vimdiff
# * GNU Diffutils (diff)
# * P4Merge
# * tkdiff

sudo -E apt -q -y install tkcvs
sudo -E apt -q -y install meld
