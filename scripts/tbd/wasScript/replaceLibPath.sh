#!/bin/bash

echo "Enter the path at which Lib paths files are present: "
read libFilePath

sed -i 's/D\:\/profiles\/P2_DEVEAR\/msapp/\/home\/was6\/profiles\/HUBDev\/MSApp/g' *.txt
