#!/bin/bash

##----------------------------------------------------------
### AI Workload
##----------------------------------------------------------

## ious
##----------------------------------------------------------
# declare -a ious=($(seq 0.90 0.05 0.95))
# declare -a ious=(0.50 0.75 0.90)
# declare -a ious=(0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95)
# declare -a ious=($(seq 0.50 0.05 0.95)) ## 10 items
declare -a ious=(0.50)

## dataset_cfgs
##----------------------------------------------------------

# declare -a dataset_cfgs=(100519_112427)

##-------

## This workload is for experimenting by decreasing the learning rate and increasing the dataset side
# declare -a dataset_cfgs=(100519_112427 130519_185650 140519_160253 140519_193751)
# declare -a dataset_cfgs=(280519_130559)
# declare -a dataset_cfgs=(070519_161514)
# declare -a dataset_cfgs=(070519_141306 060519_160720 070519_120534 060519_131650)
# declare -a dataset_cfgs=(070519_171334)
# declare -a dataset_cfgs=(030619_155727 030619_160143 030619_160423)
# declare -a dataset_cfgs=(040619_155615 040619_160050)
# declare -a dataset_cfgs=(030619_155727)
declare -a dataset_cfgs=(030619_160423)



##-------

# declare -a dataset_cfgs=(010519_190022  300419_185629  010519_122911  030519_112936  030519_171003  020519_153021  070519_121943  020519_194124  080519_095545  020519_194124  070519_171334  060519_115510  070519_161514  070519_141306  060519_160720  070519_120534  060519_131650  100519_112427  130519_185650  130519_185650  140519_160253  140519_193751)

##-------


## experiment_ids
##----------------------------------------------------------
##declare -a experiment_ids=($(echo {1..6} | tr ' ' ','))
# declare -a experiment_ids=($(echo {1..1}))
declare -a experiment_ids=(2)
