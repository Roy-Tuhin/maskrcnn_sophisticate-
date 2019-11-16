#!/bin/bash

id=$(. /etc/os-release;echo $ID)
version_id=$(. /etc/os-release;echo $VERSION_ID)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

echo $id
echo $version_id
echo $distribution
