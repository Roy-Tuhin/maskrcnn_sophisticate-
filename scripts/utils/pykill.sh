#!/bin/bash

pids=$(pgrep -f python)
echo "PIDS will be killed: ${pids}"
sudo kill -9 ${pids}

# ## kills specific program
# prog=${AI_APP}/falcon/falcon.py
# pids=$(pgrep -f ${prog})
# echo "These ${prog} pids will be killed: ${pids}"
# pkill -f ${prog}