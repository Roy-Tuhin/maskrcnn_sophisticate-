#!/bin/bash

## Ref: https://gforge.inria.fr/frs/?group_id=5833
wget -c https://gforge.inria.fr/frs/download.php/file/38227/Geogram-1.7.3.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/Geogram-1.7.3.deb
