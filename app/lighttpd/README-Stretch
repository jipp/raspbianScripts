# installation
 - `sudo apt -y install lighttpd php php-cgi php-sqlite3 sqlite3`
 - `sudo lighty-enable-mod cgi`
 - `sudo lighty-enable-mod fastcgi`
 - `sudo lighty-enable-mod fastcgi-php`
 - `sudo service lighttpd force-reload`

# configuration
 - info.php
```bash
sudo sh -c "cat <<EOT > /var/www/html/info.php
<?php
        phpinfo();
?>
EOT"
```

## for esp8266 ota updates
- `sudo mkdir -p /var/www/html/esp/update/bin`
- `sudo cp *.php /var/www/html/esp/update`
- `sudo chown -R www-data:www-data /var/www/html/esp`

# backup
 - /etc/lighttpd
 - /var/www
