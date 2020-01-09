## ChangeList

* Notes for AI API (Tesselate) v3 - scheduled
  * Modelinfo rel_num changed from int to string datatype in database; re-load the MODELINFO in production or change the datatype manually for all the records
  * Lanenet integration
  * breaking API changes: /predict changed to `/predict/bbox` and `/predict/polygon`
  * `/predict/lane` added for lanenet
  * Though, option for `q=<model_key>` added; have issues with switching between mask_rcnn and lanenet at runtime. If server started with single model; default model no issues
  * mask_rcnn limiting gpu memory changes
  * gunicorn server timeout setting increased from default 30 seconds to 60 seconds


03rd-Aug-2018:
1. Nvidia - driver, cuda, cudnn, tensorrt on Dell Latitude 5580 (Nvidia GeForce 940MX)

