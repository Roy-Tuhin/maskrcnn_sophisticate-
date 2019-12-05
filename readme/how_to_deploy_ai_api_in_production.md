# How to deploy AI API in production


## Generic Checklist

* Server IP's are static
* Starting servers as a service on system bootup
* Scaling across multiple servers
* Port selection
* Socket permissions
* Firewall
* Securing SSH
* Creating Alerts
* Monitor and Watch Server Access Logs Daily


## AI API Specific

* Server IP should be static
* docker, gunicorn, nginx are enabled as systemd service to startup on the system boot
* Application logs
  * logs settings in the application should be set to 'Error' level in application
  * rotation log policy to be
* Server logs
  * server and related service log settings to be set to required level
  * appropriate log settings to be used
* Only required ports and services to be enabled in the firewall settings
* Email alerts to be configured to appropriate email IDs
