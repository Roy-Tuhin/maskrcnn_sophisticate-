# How to configure api using loadbalancer


* Install nginx
  * https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04
    ```bash
    ## Step 1 – Installing Nginx
    sudo apt update
    sudo apt install nginx
    ## Adjusting the Firewall
    sudo ufw app list
    sudo ufw allow 'Nginx HTTP'
    ## verify the changes
    sudo ufw status
    ## Checking the Server
    sudo systemctl status nginx.service
    ## Managing the Nginx Process
    sudo systemctl stop nginx
    sudo systemctl start nginx
    sudo systemctl restart nginx
    # sudo systemctl reload nginx
    ```
  * locate nginx.service
    ```bash
    /usr/lib/systemd/system/nginx.service
    /var/lib/systemd/deb-systemd-helper-enabled/nginx.service.dsh-also
    /var/lib/systemd/deb-systemd-helper-enabled/multi-user.target.wants/nginx.service
    ```
* Configure the settings for **Nginx 413 Request Entity Too Large**
  * https://www.linglom.com/administration/fix-413-request-entity-too-large-on-nginx-web-server/
  ```bash
  sudo vi /etc/nginx/nginx.conf
  ```
  * Put the command below in http section. You can replace the number as file size limit that you want.
  ```bash
  http {
    client_max_body_size 8M;
  }
  ```
  * Test the syntax and if no error, restart the service
  ```bash
  sudo nginx -t
  sudo systemctl restart nginx.service
  ```
* **Configure** the nginx **load_balaner.conf**: `/aimldl-cod/scripts/config/nginx/load_balancer.conf`
  * https://upcloud.com/community/tutorials/configure-load-balancing-nginx/
  * Provide the IPs and other settings
* enable the configuration
  ```bash
  sudo cp /aimldl-cod/scripts/config/nginx/load_balancer.conf /etc/nginx/sites-available/
  sudo ln -s /etc/nginx/sites-available/load_balancer.conf /etc/nginx/sites-enabled
  sudo rm /etc/nginx/sites-enabled/default
  sudo systemctl reload nginx.service
  sudo systemctl restart nginx.service
  ```
* Check the logs
  ```bash
  sudo journalctl -xe
  sudo tail -f /var/log/nginx/error.log /var/log/nginx/access.log
  ```
