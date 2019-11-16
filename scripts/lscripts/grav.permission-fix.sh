#!/bin/bash

ps aux | grep -v root | grep apache | cut -d\  -f1 | sort | uniq

chown -R bhaskar:www-data .
find . -type f | xargs chmod 664
find ./bin -type f | xargs chmod 775
find . -type d | xargs chmod 775
find . -type d | xargs chmod +s
