## Cron job schedular with email attachment
### Steps
  1. Installation of sSMTP and it's configuration
    * Install sSMTP
      ```bash
      sudo apt-get install ssmtp
      ```
    * Configure sSMTP
      ```bash
      sudo vi /etc/ssmtp/ssmtp.conf
      ```
      **Copy paste the following code in the above file**
      ```bash
      root=username@gmail.com
      mailhub=smtp.gmail.com:587
      rewriteDomain=
      hostname=username@gmail.com
      UseSTARTTLS=YES
      AuthUser=username
      AuthPass=password
      FromLineOverride=YES
      ```
    * Refer the below link to configure the ssmtp -
      https://www.nixtutor.com/linux/send-mail-with-gmail-and-ssmtp/

  2. Installation of mutt (Used to send an email with attachment)
  	* Install mutt
    ```bash
    sudo apt-get install mutt
    ```

	* Refer the following link for syntax
      https://www.tecmint.com/send-mail-from-command-line-using-mutt-command/

  3. To schedule a job, refer the below link
 	* Refer the following link for syntax
    https://www.ostechnix.com/a-beginners-guide-to-cron-jobs/
    * Example of a cronjob
    ```bash
    40 11 26 10 6 /usr/bin/python /codehub/practice/nikhil/python/add2no.py 1>/codehub/practice/nikhil/python/test.log 2>&1
    41 11 26 10 6 echo "Please find attached the backup file" | mutt -a "/codehub/practice/nikhil/python/test.log" -s "File attached" -- nikhil@mapmyindia.com
    ```