#!/bin/bash

timestamp_start=$(date -d now +'%d%m%y_%H%M%S')
execution_start_time=$(date)
pyver=3
arch=mask_rcnn

prog=${AI_APP}/falcon/falcon.py
base_log_dir=${AI_LOGS}/${arch}

uuid=$(uuidgen)
username=$(whoami)
pyenv=$(lsvirtualenv -b | grep ^py_${pyver} | tr '\n' ',' | cut -d',' -f1)

cmd=evaluate
summary_file=${cmd}-${arch}.csv
summary_filepath=${base_log_dir}/${summary_file}

##----------------------------------------------------------
### AI Workload for single run or batch
##----------------------------------------------------------

iou=0.80

declare -a on_param=(val)
# declare -a on_param=(test val train)
# declare -a evals_on=(test val)
# declare -a evals_on=(test)

## DB and experiment ID's should have one-to-one correspondance
# declare -a aids_dbs=("PXL-161019_175838")
# declare -a experiment_ids=("evaluate-7120f149-0cdf-4ee3-ac9b-d72c15e639c3")


# declare -a aids_dbs=("PXL-081119_174857" "PXL-081119_181309" "PXL-081119_184710" "PXL-081119_193452" "PXL-081119_215023" "PXL-081119_225515" "PXL-081119_231523" "PXL-081119_234430" "PXL-091119_011424" "PXL-091119_013820" "PXL-091119_014238" "PXL-091119_032434" "PXL-091119_051633" "PXL-091119_061417" "PXL-091119_062639" "PXL-091119_064318" "PXL-091119_064443" "PXL-091119_065015" "PXL-091119_065353" "PXL-091119_065953" "PXL-091119_070646" "PXL-091119_071125" "PXL-091119_073030" "PXL-091119_073506" "PXL-091119_073608")
# declare -a experiment_ids=("evaluate-79d77e0d-938d-48c5-8a24-9a91886f1cb7" "evaluate-467cd87c-1290-4ba3-9e67-5c800dfdb8d3" "evaluate-bf1329d0-8474-4a89-a9b4-1c04eadf0abd" "evaluate-404a20ce-45d2-4d0a-8ea6-7cc2b52d9066" "evaluate-02e3f1dc-a725-424c-b125-3be8483ad73b" "evaluate-a26ebc08-6cb5-4476-bd85-54a8fce4cbc6" "evaluate-4e90d5fe-4b2a-4207-90d4-4e30c3637a14" "evaluate-c5d62a26-70f7-4c5c-90d3-bcd05e93b689" "evaluate-9ce23797-13f1-4f7e-b5b4-bccac5ad61dd" "evaluate-751bf7ea-d2d5-49ac-9de3-8c584245f446" "evaluate-d4144a10-b286-4671-9808-00f7e5acc0e7" "evaluate-bb728e2d-e382-4d86-a61b-dc79486f9d1c" "evaluate-b8faf19e-60b9-4282-9082-d8d4eff2ba5d" "evaluate-24204cb5-3d74-4496-91ab-8ae53304fd04" "evaluate-9f1232b6-b1fe-498f-9c19-b510ac3727d6" "evaluate-391e380e-339b-475f-b95a-3d85c59958ad" "evaluate-0cc6b8ba-fb43-4a7b-8876-32f6e740af12" "evaluate-7e6319c7-f548-4d21-823c-fc805b11e9fe" "evaluate-c4b3078b-7cc6-4c57-b0dd-9223077fd427" "evaluate-1c8ceda6-ffc6-47cc-8916-13b12a5059a1" "evaluate-38a17e5d-9634-466b-9163-c2d4e6ae8bd6" "evaluate-2ac9a0e0-2f4a-49e8-bad8-beaad3573186" "evaluate-f2119522-0df3-4c7c-826b-6da072dfe792" "evaluate-efed0084-6eb6-456f-9206-2bd9706d36f2" "evaluate-105cc363-5458-4204-8cbe-0960f4de6516")

# declare -a aids_dbs=("PXL-161019_175838" "PXL-131119_191127" "PXL-131119_190820")
# declare -a experiment_ids=("evaluate-aeece4e1-b684-458c-a0c3-955ede37970e" "evaluate-0e64888b-d01a-44f7-a6f9-4a8f78966767" "evaluate-42ab60a4-340b-43bd-b22b-ebfb675173e1")

# declare -a aids_dbs=("PXL-151119_175327" "PXL-151119_175327" "PXL-151119_175327")
# declare -a experiment_ids=("evaluate-97591269-f016-4a66-9467-823fa1d2b834" "evaluate-8390df7a-da12-4d8f-bc32-1f1beaf66981" "evaluate-52f8d1ce-fcd2-416e-b753-1cad073b778e")

declare -a aids_dbs=("PXL-301219_174758")
declare -a experiment_ids=("evaluate-6c0de61f-6bb8-47fa-9817-eb9b6584bfb2")