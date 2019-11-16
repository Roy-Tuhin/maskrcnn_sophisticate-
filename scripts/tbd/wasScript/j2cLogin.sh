#!/bin/bash
profilePath="/home/was6/profiles/HUBDev"
scriptHome="$profilePath/wasScript"

$profilePath/bin/wsadmin.sh -lang jython -f $scriptHome/j2cLogin.py
