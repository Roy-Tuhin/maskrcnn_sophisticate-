#!/bin/bash

wget -c https://dl.influxdata.com/telegraf/releases/telegraf_1.12.6-1_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/telegraf_1.12.6-1_amd64.deb

wget -c https://dl.influxdata.com/influxdb/releases/influxdb_1.7.9_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/influxdb_1.7.9_amd64.deb

wget -c https://dl.influxdata.com/chronograf/releases/chronograf_1.7.14_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/chronograf_1.7.14_amd64.deb

wget -c https://dl.influxdata.com/kapacitor/releases/kapacitor_1.5.3_amd64.deb -P $HOME/Downloads
sudo dpkg -i $HOME/Downloads/kapacitor_1.5.3_amd64.deb
