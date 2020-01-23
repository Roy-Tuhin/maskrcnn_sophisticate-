# How to integrate new DNN Arch with the TEPPr workflow

**TODO: work in progress**

3. Develop a wrapper for original data in `/codehub/apps/falcon/arch`

**Note** - 
The file should be saved after the DNN architecture i.e `<'arch'>.py`

4. Create a script to start a port in `/codehub/apps/www/od/wsgi-bin`

**Example** -
```bash
ip=0.0.0.0
port=4100
api_model_key='vidteq-rld-1'
queue=false
gunicorn web_server:"main(API_MODEL_KEY='"${api_model_key}"', QUEUE='"${queue}"')" -b "${ip}:${port}"  --timeout 60 --log-level=debug
```
* Save the 
* Source the above script to start the port
```bash
cd /codehub/apps/www/od/wsgi-bin
source start.vidteq-rld-1.sh
```
5. Follow Test suite cases for system testing during updates for testing


1. Edit the `/codehub/scripts/config/systemd/gunicorn.service` accordingly
**Example** -
```bash
[Unit]
Description=Gunicorn Daemon
After=network.target docker.service

[Service]
User=<'username'>
Group=<'username'>
WorkingDirectory=/aimldl-cod/apps/www/od/wsgi-bin
Environment="PATH=/home/<'username'>/virtualmachines/virtualenvs/<'virtualenv'>/bin"
ExecStart=/home/<'username'>/virtualmachines/virtualenvs/<'virtualenv'>/bin/gunicorn web_server:"main(API_MODEL_KEY=<'api_model_key'>, QUEUE='false')" -b "0.0.0.0:<'port'>"

[Install]
WantedBy=multi-user.target

```