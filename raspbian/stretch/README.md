# preparation
 - create image:
 	- `sudo dd bs=4M if=<image> of=/dev/sda`
	- `sudo dd bs=4M if=<image> of=/dev/mmcblk0`
 - mount image:
 	- `sudo mount /dev/sda1 /mnt`
 	- `sudo mount /dev/mmcblk0p1 /mnt`
 - `cd /mnt`
 - `sudo cp config.txt config.txt.orig`
 - `sudo cp cmdline.txt cmdline.txt.orig`
 - `sudo sed -i s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt`                                                    
 - change boot reference:
 	- `sudo sed -i s/"PARTUUID=........-.."/"\/dev\/sda2"/ cmdline.txt`
	- `sudo sed -i s/"PARTUUID=........-.."/"\/dev\/mmcblk0p2"/ cmdline.txt`
 - `sudo touch ssh`
 - `sudo vi wpa_supplicant.conf` - add known wifi networks
 - `cd`
 - `sudo umount /mnt`

# installation

## configuration - general
 - `sudo apt update`
 - list upgrade packages:
 	- `apt list --upgradable`
	- `apt list -a --upgradable`
 - `sudo apt -y upgrade`
 - `sudo apt clean`
 - `sudo rpi-update`
 - `sudo reboot`
 - `sudo raspi-config`
	- 1 Change User Password `sudo passwd pi`
	- 4 Localisation Options
		- I2 Change Timezone
		`sudo raspi-config nonint do_change_timezone Europe/Berlin`
		- I4 Change Wi-fi Country
		`sudo raspi-config nonint do_wifi_country DE`
	- 5 Interfacing Options
		- P1 Camera
		`sudo raspi-config nonint do_camera 0|1` (enable|disable)
		- P2 SSH
		`sudo raspi-config nonint do_ssh 0`
		- P4 SPI
		`sudo raspi-config nonint do_spi 0|1` (enable|disable)
		- P5 I2C
		`sudo raspi-config nonint do_i2c 0|1` (enable|disable)
		- P6 Serial
		`sudo raspi-config nonint do_serial 1`; `sudo raspi-config nonint set_config_var enable_uart 1 /boot/config.txt`
	- 7 Advanced Options
		- A3 Memory Split
		`sudo raspi-config nonint do_memory_split 32|128` (normal|camera)
	- 2 Network Options
	 	- N1 Hostname
		`sudo raspi-config nonint do_hostname <hostname>`
 - `sudo reboot`
    
## configuration - optional

###  disable wifi
 - `sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"`

### disable bluetooth
 - `sudo sh -c "echo 'dtoverlay=pi3-disable-bt' >> /boot/config.txt"`
 - `sudo systemctl disable hciuart`

### disable audio
 - `sudo raspi-config nonint set_config_var dtparam=audio off /boot/config.txt`

### enable gpio-shutdown
 - `sudo sh -c "echo 'dtoverlay=gpio-shutdown' >> /boot/config.txt"`

### enable gpio-heartbeat
 - `sudo sh -c "echo 'dtoverlay=pi3-act-led,gpio=21,act_led_trigger=heartbeat' >> /boot/config.txt"`

### enable gpio-fan
 - `sudo sh -c "echo 'dtoverlay=gpio-fan' >> /boot/config.txt"`

## configuration - read-write
 - partition resize for sd card
	 - `sudo raspi-config`
		 - A1 Expand Filesystem

## mount/unmount image
 - sudo losetup -P /dev/loop0 raspbian-stretch-lite.img
 - sudo mount /dev/loop0p1 /mnt/
 - sudo umount /mnt
 - sudo losetup -D
 
## configuration - read-only

### system

#### disable ssh key save
 - patch -b /etc/ssh/ssh_config ssh_config.patch

#### disable swap
 - `sudo systemctl stop dphys-swapfile`
 - `sudo systemctl disable dphys-swapfile`
 - `sudo dphys-swapfile swapoff`
 - `sudo dphys-swapfile uninstall`
 
#### handle partition
 - `sudo parted /dev/mmcblk0 resizepart 2 8000M`
 - `sudo resize2fs /dev/mmcblk0p2`
 - `sudo parted /dev/mmcblk0 mkpart primary 15630336s 100%`
 - `sudo mkfs.ext4 /dev/mmcblk0p3`
 - `sudo mkdir /data`
 - `sudo cp /etc/fstab /etc/fstab.orig`
```bash
sudo sh -c "cat <<EOT > /etc/fstab
proc           /proc              proc  defaults                                               0 0
/dev/mmcblk0p1 /boot              vfat  defaults,ro                                            0 2
/dev/mmcblk0p2 /                  ext4  defaults,noatime,ro                                    0 1
/dev/mmcblk0p3 /data              ext4  defaults,noatime                                       0 2
tmpfs          /tmp               tmpfs defaults,noatime,mode=1777,uid=root,gid=root,size=100m 0 0
tmpfs          /var/backups       tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=15m   0 0
tmpfs          /var/cache         tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=200m  0 0
tmpfs          /var/lib/dhcpcd5   tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=80k   0 0
tmpfs          /var/lib/logrotate tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=40k   0 0
tmpfs          /var/log           tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=4m    0 0
tmpfs          /var/tmp           tmpfs defaults,noatime,mode=1777,uid=root,gid=root,size=10m  0 0
#tmpfs          /var/lib/ntp       tmpfs defaults,noatime,mode=755,uid=ntp,gid=ntp,size=40k     0 0
EOT"
```
 - `sudo mount -a`

#### system app modifications
 
##### resolv.conf
 - `sudo mv /etc/resolv.conf /etc/resolv.conf.orig`
 - `sudo ln -s /var/tmp/resolv.conf /etc/resolv.conf`
 
##### daily_lock
 - `sudo mv /var/lib/apt/daily_lock /var/lib/apt/daily_lock.orig`
 - `sudo ln -s /var/tmp/daily_lock /var/lib/apt/daily_lock`

##### fake-hwclock
 - `sudo mv /etc/fake-hwclock.data /etc/fake-hwclock.data.orig`
 - `sudo ln -s /var/tmp/fake-hwclock.data /etc/fake-hwclock.data`

##### rsyslog
 - `sudo touch /etc/rsyslog.d/loghost.conf.orig`
 - `sudo sh -c "echo '*.*     @192.168.0.27' >> /etc/rsyslog.d/loghost.conf"`
 - `sudo systemctl restart rsyslog`

#### create service and script for read-only workarounds

##### service
 - `sudo touch /lib/systemd/system/setup-tmpfs.service.orig`
```bash
sudo sh -c "cat <<EOT > /lib/systemd/system/setup-tmpfs.service
[Unit]
Description=setup-tmpfs
DefaultDependencies=no
After=var-log.mount
Before=

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/lib/systemd/scripts/setup-tmpfs.sh
TimeoutSec=30s

[Install]
WantedBy=sysinit.target
EOT"
```
 - `sudo systemctl enable setup-tmpfs.service`
 
##### script
 - `sudo mkdir /lib/systemd/scripts`
 - `sudo touch /lib/systemd/scripts/setup-tmpfs.sh.orig`
```bash
sudo sh -c "cat <<EOT > /lib/systemd/scripts/setup-tmpfs.sh
#!/bin/bash

touch /var/log/lastlog
chmod 664 /var/log/lastlog
chgrp utmp /var/log/lastlog

which mosquitto > /dev/null 2>&1
if [ \$? -eq 0 ]; then
        logger \"setup mosquitto folder\"
        mkdir /var/log/mosquitto
        chown mosquitto:root /var/log/mosquitto
        chmod 755 /var/log/mosquitto
fi

which homegear > /dev/null 2>&1
if [ \$? -eq 0 ]; then
        logger \"setup homegear folder\"
        mkdir /var/log/homegear
        chown homegear:homegear /var/log/homegear
        chmod 750 /var/log/homegear
        mkdir -p /var/tmp/homegear/tmp/php
        chown -R homegear:homegear /var/tmp/homegear
        chmod -R 770 /var/tmp/homegear
fi

which lighttpd > /dev/null 2>&1
if [ \$? -eq 0 ]; then
        logger \"setup lighttpd folder\"
        mkdir /var/log/lighttpd
        chown www-data:www-data /var/log/lighttpd
        chmod 750 /var/log/lighttpd

        mkdir /var/cache/lighttpd
        chmod 755 /var/cache/lighttpd
        mkdir /var/cache/lighttpd/compress
        chown www-data:www-data /var/cache/lighttpd/compress
        chmod 755 /var/cache/lighttpd/compress
        mkdir /var/cache/lighttpd/uploads
        chown www-data:www-data /var/cache/lighttpd/uploads
        chmod 755 /var/cache/lighttpd/uploads
fi
EOT"
```
 - `sudo chmod +x /lib/systemd/scripts/setup-tmpfs.sh`
    
### apps

#### mosquitto
 - `mkdir /data/mosquitto`
 - `chown -R mosquitto:root /data/mosquitto`
 - `patch -b /etc/mosquitto/mosquitto.conf mosquitto.conf.patch`

#### homegear
 - `patch -b /etc/homegear/homegear-start.sh homegear-start.sh.patch`
 - `patch -b /etc/homegear/main.conf main.conf.patch`
 - `patch -b /etc/homegear/management.conf management.conf.patch`
 - `patch -b /etc/homegear/php.ini php.ini.patch`
 - `mkdir -p /data/homegear/backup`
 - `mkdir -p /data/homegear/db`
 - `mkdir -p /data/homegear/families`
 - `mkdir -p /data/homegear/flows/data`
 - `chown -R homegear:homegear /data/homegear`
 
#### lighttpd
 - `mv /var/lib/php/sessions /var/lib/php/sessions.orig`
 - `ln -s /var/tmp/sessions /var/lib/php/sessions`
 - `mkdir /data/lighttpd`
 - `chown -R www-data:www-data /data/lighttpd`

## system add-on
 - unix
	 - `sudo apt -y install nmap dnsutils tcpdump`
 - git
	 - `sudo apt -y install git`
 - python
	 - `sudo apt -y install python-dev python-pip virtualenv`
 - avr
	 - `sudo apt -y install gcc-avr avr-libc avrdude`
 - ntp (check fstab for mounted filesystem)
	 - `sudo apt -y install ntp`
 - i2c tools
	 - `sudo apt -y install i2c-tools`
 - sshguard
 	 - `sudo apt -y install sshguard`

# system settings

## wifi client
- `sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig`
- `wpa_passphrase "testing" "testingPassword" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null`

## wifi ap
 - `sudo apt -y  install dnsmasq hostapd`
 - `sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.orig`
```bash
sudo sh -c "cat <<EOT >> /etc/dhcpcd.conf
interface wlan0
static ip_address=192.168.1.1/24
nohook wpa_supplicant
EOT"
```
 - `sudo touch /etc/hostapd/hostapd.conf.orig`
```bash
sudo sh -c "cat <<EOT >> /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
country_code=DE
hw_mode=g
channel=7
wmm_enabled=0

ssid=raspi
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=testtest
EOT"
```
 - `sudo patch -b /etc/default/hostapd hostapd.patch`
 - `sudo systemctl unmask hostapd`
 - `sudo systemctl enable hostapd`
 - `sudo touch /etc/dnsmasq.d/wlan0.conf.orig`
```bash
sudo sh -c "cat <<EOT >> /etc/dnsmasq.d/wlan0.conf
interface=wlan0
dhcp-range=192.168.1.100,192.168.1.150,24h
EOT"
```
 - for read-only 
    - `sudo ln -s /var/tmp/dnsmasq.leases /var/lib/misc/dnsmasq.leases`
    
## RTC
 - enable i2c
 	- HW i2c:
		- `sudo raspi-config nonint do_i2c 0`
		- `sudo sh -c "echo 'dtoverlay=i2c-rtc,ds3231' >> /boot/config.txt"`
	- SW i2c: 
		- `sudo sh -c "echo 'dtoverlay=i2c-rtc-gpio,ds3231,i2c_gpio_sda=10,i2c_gpio_scl=9' >> /boot/config.txt"`
 - `sudo apt -y install i2c-tools`
 - `sudo systemctl stop fake-hwclock.service`
 - `sudo systemctl disable fake-hwclock.service`
 - `sudo patch -b /etc/default/hwclock hwclock.patch`
 - `sudo patch -b /lib/udev/hwclock-set hwclock-set.patch`
 - `sudo reboot`
 - `sudo hwclock -r`
 - `sudo hwclock -w`

## OTG (for Raspberry Zero only)

### Serial
 - cmdline.txt: modules-load=dwc2,g_serial
 - echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
 - systemctl enable getty@ttyGS0.service
 