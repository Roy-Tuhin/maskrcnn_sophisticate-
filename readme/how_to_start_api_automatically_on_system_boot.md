# How to deploy start api automatically on system boot

* The service daemon are created using: `systemd`

1. setup the proper paths for the conf files: `*.service`
  ```bash
  vi /aimldl-cod/scripts/config/systemd/gunicorn.service
  ```
2. run the script to create and enable service that gets started on system boot
  ```bash
  source /aimldl-cod/scripts/setup.services.sh
  ```

**NOTES:**
* docker needs to be started before gunicorn server/service
* nginx as load balancer service is configured to start at port `8100`, so it does not conflict with apache, gunicorn, php, nodejs default server IPs
