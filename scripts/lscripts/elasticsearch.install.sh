#!/bin/bash

##----------------------------------------------------------
### Elastic Search (ES)
##----------------------------------------------------------

#### dependencies
sudo apt-get install apt-transport-https

#### Add repository
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get install elasticsearch

#### test ES installation
sudo systemctl start elasticsearch.service
curl -XGET 'localhost:9200/?pretty'
