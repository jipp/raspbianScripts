# preparation
 - `dd if=2017-09-07-raspbian-stretch-lite.img of=/dev/sda`
 - `mount /dev/sda1 /mnt`
 - `cd /mnt`
	 - `cp config.txt config.txt.orig`
	 - `cp cmdline.txt cmdline.txt.orig`
	 - `sed -i s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt`
	 - `sed -i s/"PARTUUID=........-.."/"\/dev\/mmcblk0p2"/ cmdline.txt`
	 - `touch ssh`

# installation

## configuration - general
 - `sudo apt update`
 - `sudo apt list --upgradable`
 - `sudo apt -y upgrade`
 - `sudo reboot`
 - `sudo rpi-update`
 - `sudo reboot`
 - `sudo raspi-config`
	- 1 Change User Password - `sudo passwd pi`
	- 2 Network Options
	 	- N1 Hostname
		`sudo raspi-config nonint do_hostname <hostname>`
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
 - `sudo reboot`
    
## configuration - optional

###  disable wifi
 - `sudo raspi-config nonint set_config_var dtoverlay=pi3-disable-wifi /boot/config.txt`
 - `sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"`

### disable bluetooth
 - `sudo sh -c "echo 'dtoverlay=pi3-disable-bt' >> /boot/config.txt"`
 - `sudo systemctl disable hciuart`

### disable audio
 - `sudo raspi-config nonint set_config_var dtparam=audio off /boot/config.txt`
  
## configuration - read-write
 - partition resize
	 - `sudo raspi-config`
		 - A1 Expand Filesystem

## configuration - read-only

### system

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
tmpfs          /var/backups       tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=100m  0 0
tmpfs          /var/cache         tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=200m  0 0
tmpfs          /var/lib/dhcpcd5   tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=1m    0 0
tmpfs          /var/lib/logrotate tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=1m    0 0
tmpfs          /var/log           tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=100m  0 0
tmpfs          /var/tmp           tmpfs defaults,noatime,mode=1777,uid=root,gid=root,size=100m 0 0
EOT"
```
 - `sudo mount -a`

#### system app modifications

##### ntpd
 - `sudo apt -y install ntp`
 - `sudo sed -i.orig  s/"run\/ntp.conf.dhcp"/"var\/lib\/ntp\/ntp.conf.dhcp"/ /etc/init.d/ntp`
 - `sudo patch -b /etc/init.d/ntp ntp.patch`
 - `sudo systemctl daemon-reload`
```bash
sudo sh -c "cat <<EOT >> /etc/fstab
tmpfs          /var/lib/ntp       tmpfs defaults,noatime,mode=755,uid=ntp,gid=ntp,size=1m      0 0
EOT"
``` 
 
##### resolv.conf
 - `sudo mv /etc/resolv.conf /etc/resolv.conf.orig`
 - `sudo ln -s /var/tmp/resolv.conf /etc/resolv.conf`
 
##### daily_lock
 - `sudo mv /var/lib/apt/daily_lock /var/lib/apt/daily_lock.orig`
 - `sudo ln -s /var/tmp/daily_lock /var/lib/apt/daily_lock`

##### fake-hwclock
 - `sudo mv /etc/fake-hwclock.data /etc/fake-hwclock.data.orig`
 - `sudo ln -s /var/tmp/fake-hwclock.data /etc/fake-hwclock.data`

##### dhcpcd
 - `sudo mv /etc/dhcpcd.secret /etc/dhcpcd.secret.orig`
 - `sudo ln -s /var/tmp/dhcpcd.secret /etc/dhcpcd.secret`

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
After=var-log.mount var-cache.mount var-lib-ntp.mount var-lib-dhcpcd5.mount var-lib-dhcp.mount
Before=systemd-random-seed.service avahi-daemon.service

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

logger \"setup systemd folder\"
mkdir /var/tmp/systemd
chmod 755 /var/tmp/systemd

logger \"setup random-seed folder\"
touch /var/tmp/systemd/random-seed
chmod 600 /var/tmp/systemd/random-seed

which watchdog > /dev/null 2>&1
if [ \$? -eq 0 ]; then
        logger \"setup watchdog folder\"
        mkdir /var/log/watchdog
        chown root:root /var/log/watchdog
        chmod 750 /var/log/watchdog
fi

which homegear > /dev/null 2>&1
if [ \$? -eq 0 ]; then
        logger \"setup homegear folder\"
        mkdir /var/log/homegear
        chown homegear:homegear /var/log/homegear
        chmod 750 /var/log/homegear
fi

which mosquitto > /dev/null 2>&1
if [ \$? -eq 0 ]; then
        logger \"setup mosquitto folder\"
        mkdir /var/log/mosquitto
        chown mosquitto:root /var/log/mosquitto
        chmod 755 /var/log/mosquitto
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

#### lighttpd
 - `mv /var/lib/php/sessions /var/lib/php/sessions.orig`
 - `ln -s /var/tmp/sessions /var/lib/php/sessions`
 - `mkdir /data/lighttpd`
 - `chown -R www-data:www-data /data/lighttpd`

#### homegear
 - `patch -b /etc/homegear/main.conf main.conf.patch`
 - `patch -b /etc/homegear/php.ini php.ini.patch`
 - `patch -b /etc/homegear/homegear-start.sh homegear-start.sh.patch`
 - `mkdir -p /data/homegear/families`
 - `mkdir -p /data/homegear/db`
 - `mkdir -p /data/homegear/backup`
 - `mkdir -p /data/homegear/flows/data`
 - `chown homegear:homegear /data/homegear`

## system add-on
 - unix
	 - `sudo apt -y install nmap dnsutils tcpdump`
 - git
	 - `sudo apt -y install git`
 - python
	 - `sudo apt -y install python-dev python-pip virtualenv`
 - avr
	 - `sudo apt -y install gcc-avr avr-libc avrdude`

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
EOT"
```
 - `sudo touch /etc/hostapd/hostapd.conf.orig`
```bash
sudo sh -c "cat <<EOT >> /etc/hostapd/hostapd.conf
interface=wlan0

ssid=woke
channel=1
hw_mode=g
ieee80211n=1
ieee80211d=1
country_code=DE
wmm_enabled=1

auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=testtest
EOT"
```
 - `sudo patch -b /etc/default/hostapd hostapd.patch`
 - `sudo touch /etc/dnsmasq.d/wlan0.conf.orig`
```bash
sudo sh -c "cat <<EOT >> /etc/dnsmasq.d/wlan0.conf
domain-needed
interface=wlan0
listen-address=192.168.1.1
dhcp-range=192.168.1.100,192.168.1.150,12h
EOT"
```
 - for read-only 
    - `sudo ln -s /var/tmp/dnsmasq.leases /var/lib/misc/dnsmasq.leases`
