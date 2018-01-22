# installation
 - `wget -qO - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -`
 - `cd /etc/apt/sources.list.d/`
 - `wget http://repo.mosquitto.org/debian/mosquitto-stretch.list`
 - `apt update`
 - `apt -y install mosquitto mosquitto-clients`

# configuration
 - `sudo touch /etc/mosquitto/passwd.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/passwd
openhab:$6$cx71d7drZSUApMWv$0WiaPNeHHf+UB7WZbAp4KBiZIh8vaMXZ0MEWURvzEBo/mzOnrjoR9YMr0+bqoShp23yciFTLttrOXonPMJ1ttQ==
esp8266:$6$oVpJmijrsIGrUvYn$RxaYHEzXHQaFqMof54cmKK6pbg5eOC1aN8b8me6RtCQcZh0Myznxgz/2rXO51r2CQ4FIseBY1Jn4PhvzPeV9sw==
homegear:$6$hyOh5RLgjiTEcrJV$ZJy6bDtdXj4oTPMBaqPf+7peTuBAFhTZG0eUu4CNfZxoH8Aj5mxU4L36OB6Z52RWv5bQ3Gxb3qg+jvBzqa5Edw==
EOT"
```
 - `sudo touch /etc/mosquitto/conf.d/debug.conf.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/conf.d/debug.conf
#log_type all
log_type error
log_type warning
EOT"
```
 - `sudo touch /etc/mosquitto/conf.d/security.conf.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/conf.d/security.conf
password_file /etc/mosquitto/passwd
allow_anonymous false
EOT"
```

# backup
 - /etc/mosquitto
