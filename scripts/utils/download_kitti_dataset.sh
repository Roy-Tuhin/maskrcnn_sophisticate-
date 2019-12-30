mkdir -p /aimldl-dat/data-public/vid2depth/kitti-raw-uncompressed
cd /aimldl-dat/data-public/vid2depth/kitti-raw-uncompressed
wget https://raw.githubusercontent.com/mrharicot/monodepth/master/utils/kitti_archives_to_download.txt
wget -i kitti_archives_to_download.txt
# unzip "*.zip"