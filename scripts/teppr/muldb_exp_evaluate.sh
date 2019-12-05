#!/bin/bash

## https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/


declare -A dbexp

dbexp["PXL-081119_174857"]=("evaluate-79d77e0d-938d-48c5-8a24-9a91886f1cb7" "evaluate-79d77e0d-938d-48c5-8a24-9a91886f1cb7")
# dbexp["PXL-081119_181309"]="evaluate-467cd87c-1290-4ba3-9e67-5c800dfdb8d3"
# dbexp["PXL-081119_184710"]="evaluate-bf1329d0-8474-4a89-a9b4-1c04eadf0abd"
# dbexp["PXL-081119_193452"]="evaluate-404a20ce-45d2-4d0a-8ea6-7cc2b52d9066"
# dbexp["PXL-081119_215023"]="evaluate-02e3f1dc-a725-424c-b125-3be8483ad73b"
# dbexp["PXL-081119_225515"]="evaluate-a26ebc08-6cb5-4476-bd85-54a8fce4cbc6"
# dbexp["PXL-081119_231523"]="evaluate-4e90d5fe-4b2a-4207-90d4-4e30c3637a14"
# dbexp["PXL-081119_234430"]="evaluate-c5d62a26-70f7-4c5c-90d3-bcd05e93b689"
# dbexp["PXL-091119_011424"]="evaluate-9ce23797-13f1-4f7e-b5b4-bccac5ad61dd"
# dbexp["PXL-091119_013820"]="evaluate-751bf7ea-d2d5-49ac-9de3-8c584245f446"
# dbexp["PXL-091119_014238"]="evaluate-d4144a10-b286-4671-9808-00f7e5acc0e7"
# dbexp["PXL-091119_032434"]="evaluate-bb728e2d-e382-4d86-a61b-dc79486f9d1c"
# dbexp["PXL-091119_051633"]="evaluate-b8faf19e-60b9-4282-9082-d8d4eff2ba5d"
# dbexp["PXL-091119_061417"]="evaluate-24204cb5-3d74-4496-91ab-8ae53304fd04"
# dbexp["PXL-091119_062639"]="evaluate-9f1232b6-b1fe-498f-9c19-b510ac3727d6"
# dbexp["PXL-091119_064318"]="evaluate-391e380e-339b-475f-b95a-3d85c59958ad"
# dbexp["PXL-091119_064443"]="evaluate-0cc6b8ba-fb43-4a7b-8876-32f6e740af12"
# dbexp["PXL-091119_065015"]="evaluate-7e6319c7-f548-4d21-823c-fc805b11e9fe"
# dbexp["PXL-091119_065353"]="evaluate-c4b3078b-7cc6-4c57-b0dd-9223077fd427"
# dbexp["PXL-091119_065953"]="evaluate-1c8ceda6-ffc6-47cc-8916-13b12a5059a1"
# dbexp["PXL-091119_070646"]="evaluate-38a17e5d-9634-466b-9163-c2d4e6ae8bd6"
# dbexp["PXL-091119_071125"]="evaluate-2ac9a0e0-2f4a-49e8-bad8-beaad3573186"
# dbexp["PXL-091119_073030"]="evaluate-f2119522-0df3-4c7c-826b-6da072dfe792"
# dbexp["PXL-091119_073506"]="evaluate-efed0084-6eb6-456f-9206-2bd9706d36f2"
# dbexp["PXL-091119_073608"]="evaluate-105cc363-5458-4204-8cbe-0960f4de6516"


# echo ${dbexp[@]}

## # Looping through keys and values in an associative array
for K in "${!dbexp[@]}"; do echo $K --- ${dbexp[$K]}; done

# ## Loop through all values in an associative array
# for V in "${dbexp[@]}"; do echo $V; done