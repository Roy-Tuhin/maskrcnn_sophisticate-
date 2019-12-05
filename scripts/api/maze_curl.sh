https://superuser.com/questions/149329/what-is-the-curl-command-line-syntax-to-do-a-post-request


curl --referer debugLB http://example.com/bot.html http://www.cyberciti.biz

curl -X POST --referer http://10.4.71.121/stage/maze/mazeCBR.php --data "city=bangalore&qu=ban&prefixMode=1&ref=gaze_pdb_dates_bangalore&limit=5" http://10.4.71.121/stage/maze/vs/suggest.php


* Suggest

Get Date String

PDB Dates
http://10.4.71.121/stage/maze/vs/suggest.php?city=bangalore&qu=ba&prefixMode=1&ref=gaze_pdb_dates_bangalore&limit=5

Error ! Operation not permitted

Track Dates
http://10.4.71.121/stage/maze/vs/suggest.php?city=bangalore&qu=ba&prefixMode=1&ref=gaze_track_dates_bangalore&limit=5

Error ! Operation not permitted

Evaluation
http://10.4.71.121/stage/maze/vs/classSplit.php?city=bangalore&action=getAnnoOrConfigFileList&logFix=getAnnoOrConfigFileList&type=config&qu=a&prefixMode=1&ref=gaze_pdb_dates_bangalore&limit=5
["rld_job_081019\/images-p1-081019_AT1.json","rld_job_270919\/images-p1-110919_AT1.json","rld_job_270919\/images-p1-270919_AT1.json","ods_job_070619\/images-p1-070619_AT5.json","ods_job_070619\/images-p1-070619_AT4.json","ods_job_070619\/images-p1-070619_AT3.json","ods_job_070619\/images-p1-070619_AT1.json","ods_job_070619\/images-p1-070619_AT2.json","rld_job_230919\/images-p1-230919_AT1.json","rbd_job_190919\/images-p1-190919_AT2.json","ods_job_180419\/images-p1-030419_AT1.json","ods_job_030419\/images-p1-030419_AT1.json","ods_job_030419\/images-p1-030419_AT5.json","ods_job_030419\/images-p1-030419_AT4.json","ods_job_030419\/images-p1-030419_ATX.json","ods_job_030419\/images-p1-030419_AT2.json","ods_job_030419\/images-p1-030419_AT3.json","rbd_job_091019\/images-p1-091019_AT2.json","ods_job_120619\/images-p1-120619_AT3.json","ods_job_120619\/images-p2-250619_AT5.json","ods_job_120619\/images-p1-120619_AT1_via205_140619.json","ods_job_120619\/images-p1-120619_AT4.json","ods_job_120619\/images-p2-250619_AT2.json","ods_job_120619\/images-p2-250619_AT3.json","ods_job_120619\/images-p1-120619_AT1_via205_170619.json","ods_job_120619\/images-p1-120619_AT1_via205_120619.json","ods_job_120619\/images-p3-020719_AT5.json","ods_job_120619\/images-p2-250619_AT4.json","ods_job_120619\/images-p1-120619_AT5.json","ods_job_120619\/images-p2-250619_AT1.json","ods_job_120619\/images-p1-120619_AT1_via205_130619.json","ods_job_120619\/images-p1-120619_AT2.json","ods_job_120619\/images-p1-120619_AT1.json","rld_job_110919\/images-p1-110919_AT1.json","rld_job_110919\/images-p1-110919_AT3.json","ods_job_230119\/images-p3-250219_AT3.json","ods_job_230119\/images-p2-050219_AT4.json","ods_job_230119\/images-p2-050219_AT2.json","ods_job_230119\/images-p1-230119_AT1.json","ods_job_230119\/images-p3-250219_AT5.json","ods_job_230119\/images-p2-050219_AT1.json","rbd_job_031019\/images-p1-031019_AT2.json","ods_job_060519\/images-p1-060519_AT2.json","ods_job_060519\/images-p4-310519_AT2.json","ods_job_060519\/images-p1-060519_AT4.json","ods_job_060519\/images-p4-310519_AT4.json","ods_job_060519\/images-p1-060519_AT5.json","ods_job_060519\/images-p1-060519_AT1.json","ods_job_060519\/images-p1-060519_AT3.json","ods_job_110919\/images-p1-110919_AT1.json","ods_job_110919\/images-p1-110919_AT2.json","ods_job_110919\/images-p1-130919_AT1_via205_130919.json","ods_job_110919\/images-p1-110919_AT3.json"]

Stats
http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getStat&dateStr=bang-150518-T2&logFix=getStat


Gaze Tracks Date String
http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getRawTracks&city=bangalore&dateStr=<bang-DDMMYY-TX>&mode=gazeTracks
{"options":["bang-290419-T1","bang-270419-T1","bang-260419-T1","bang-250419-T1","bang-240419-T1","bang-230419-T1","bang-220419-T1","bang-190419-T1","bang-170419-T1","bang-160419-T1","bang-150419-T1","bang-130419-T1","bang-311218-T1","bang-311218-T2","bang-271218-T1"]}

* Get Thumbnail Images for a given date string
http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getThumbImage&dateStr=bang-311218-T1&dirFix=16/20/09&cameraSN=16716

* Get Image
http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getNdtImage&city=bangalore&mode=gazeTracks&dateStr=bang-311218-T1&dirFix=15%2F06%2F25&imageName=311218_150625_16716_zed_l_140.jpg

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getNdtImage&city=bangalore&mode=gazeTracks&dateStr=bang-311218-T1&imageList=311218_150625_16716_zed_l_140.jpg

* Get Track Predictions
http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getTrackPredictions&city=bangalore&dateStr=bang-311218-T1&mode=gazeTracks

* Get Image Name
http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15%2F06%2F25

["311218_150625_16718_zed_l_973.json","311218_150625_16718_zed_l_973.jpg","311218_150625_16718_zed_l_905.json","311218_150625_16718_zed_l_905.jpg","311218_150625_16718_zed_l_839.json","311218_150625_16718_zed_l_839.jpg","311218_150625_16718_zed_l_771.json","311218_150625_16718_zed_l_771.jpg","311218_150625_16718_zed_l_706.json","311218_150625_16718_zed_l_706.jpg","311218_150625_16718_zed_l_638.json","311218_150625_16718_zed_l_638.jpg","311218_150625_16718_zed_l_571.json","311218_150625_16718_zed_l_571.jpg","311218_150625_16718_zed_l_506.json","311218_150625_16718_zed_l_506.jpg","311218_150625_16718_zed_l_438.json","311218_150625_16718_zed_l_438.jpg","311218_150625_16718_zed_l_372.json","311218_150625_16718_zed_l_372.jpg","311218_150625_16718_zed_l_305.json","311218_150625_16718_zed_l_305.jpg","311218_150625_16718_zed_l_239.json","311218_150625_16718_zed_l_239.jpg","311218_150625_16718_zed_l_171.json","311218_150625_16718_zed_l_171.jpg","311218_150625_16718_zed_l_105.json","311218_150625_16718_zed_l_105.jpg","311218_150625_16718_zed_l_038.json","311218_150625_16718_zed_l_038.jpg","311218_150625_16717_zed_l_946.json","311218_150625_16717_zed_l_946.jpg","311218_150625_16717_zed_l_880.json","311218_150625_16717_zed_l_880.jpg","311218_150625_16717_zed_l_813.json","311218_150625_16717_zed_l_813.jpg","311218_150625_16717_zed_l_747.json","311218_150625_16717_zed_l_747.jpg","311218_150625_16717_zed_l_680.json","311218_150625_16717_zed_l_680.jpg","311218_150625_16717_zed_l_614.json","311218_150625_16717_zed_l_614.jpg","311218_150625_16717_zed_l_547.json","311218_150625_16717_zed_l_547.jpg","311218_150625_16717_zed_l_480.json","311218_150625_16717_zed_l_480.jpg","311218_150625_16717_zed_l_413.json","311218_150625_16717_zed_l_413.jpg","311218_150625_16717_zed_l_347.json","311218_150625_16717_zed_l_347.jpg","311218_150625_16717_zed_l_280.json","311218_150625_16717_zed_l_280.jpg","311218_150625_16717_zed_l_213.json","311218_150625_16717_zed_l_213.jpg","311218_150625_16717_zed_l_147.json","311218_150625_16717_zed_l_147.jpg","311218_150625_16717_zed_l_080.json","311218_150625_16717_zed_l_080.jpg","311218_150625_16717_zed_l_013.json","311218_150625_16717_zed_l_013.jpg","311218_150625_16716_zed_l_939.json","311218_150625_16716_zed_l_939.jpg","311218_150625_16716_zed_l_873.json","311218_150625_16716_zed_l_873.jpg","311218_150625_16716_zed_l_806.json","311218_150625_16716_zed_l_806.jpg","311218_150625_16716_zed_l_739.json","311218_150625_16716_zed_l_739.jpg","311218_150625_16716_zed_l_672.json","311218_150625_16716_zed_l_672.jpg","311218_150625_16716_zed_l_606.json","311218_150625_16716_zed_l_606.jpg","311218_150625_16716_zed_l_539.json","311218_150625_16716_zed_l_539.jpg","311218_150625_16716_zed_l_472.json","311218_150625_16716_zed_l_472.jpg","311218_150625_16716_zed_l_406.json","311218_150625_16716_zed_l_406.jpg","311218_150625_16716_zed_l_339.json","311218_150625_16716_zed_l_339.jpg","311218_150625_16716_zed_l_272.json","311218_150625_16716_zed_l_272.jpg","311218_150625_16716_zed_l_206.json","311218_150625_16716_zed_l_206.jpg","311218_150625_16716_zed_l_140.json","311218_150625_16716_zed_l_140.jpg","311218_150625_16716_zed_l_072.json","311218_150625_16716_zed_l_072.jpg","311218_150625_16716_zed_l_006.json","311218_150625_16716_zed_l_006.jpg","..","."]

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1

["stamp.txt","16","15","14","13","12","11","10","..","."]

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15
["59","58","57","54","53","52","51","50","49","48","47","46","45","44","43","42","41","40","39","37","36","35","34","33","32","31","30","29","28","27","26","25","24","23","22","21","20","19","18","17","16","15","14","13","12","11","10","09","08","07","06","05","04","03","..","."]

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15%2F59


http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15%2F../../../../..

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15%2F../../../../../Bangalore_Gaze_Exported_Data/PCDDATA

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15%2F../../../../../Bangalore_Gaze_Exported_Data/PCDDATA/April-19/bang-290419-T1

http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=15%2F../../../../../Bangalore_Gaze_Raw_Data/IMAGEDATA/August-19/bang-120819-T1/10/31/36


http://10.4.71.121/stage/maze/vs/trackSticker.php?action=getAllImageNames&dateStr=bang-311218-T1&dirFix=..

["bang-311218-T1","bang-271218-T1","bang-071218-T2","bang-071218-T1","..","."]



tilecache
http://10.4.71.121/stage/DMT/D3V/vs/tilecache.php?layers=BANG_GIRGITI&z=16&x=46906&y=30391