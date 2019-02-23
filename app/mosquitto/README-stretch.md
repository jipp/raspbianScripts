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
homegear:$6$hyOh5RLgjiTEcrJV$ZJy6bDtdXj4oTPMBaqPf+7peTuBAFhTZG0eUu4CNfZxoH8Aj5mxU4L36OB6Z52RWv5bQ3Gxb3qg+jvBzqa5Edw==
wohnzimmer:$6$2WK0DysUP/R3sGhj$ejO/KR8Z65JdGweue2DAFFtl41m2WBwOATc7ol1+svopPZn7jhsNXFAe0xAXKBASG3K5c8hEPn++5yEGFni1QA==
trial:$6$tfYSMWZWlv8vEyTt$wD6iRLJExkE4DHdXBAA3RxQP4f7l/KsDgfbclEMH5+4NPQda46RrxQXMYZ47vLOmifEbV35RM0WXUt9rX7kOaQ==
garage:$6$vAOINzRqWVHKqK3P$hSREkHl6zCgiRpz3VwrSjVPVmXJxcVbh7x3nWfw7IrhZBNszejyJkHoBeZhES8yPqTTSt7jm31WWtnd37gxK6g==
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
