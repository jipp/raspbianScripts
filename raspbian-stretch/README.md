# preparation
* dd if=2017-09-07-raspbian-stretch-lite.img of=/dev/sda
* mount /dev/sda1 /mnt
* cd /mnt
  * cp config.txt config.txt.orig
  * cp cmdline.txt cmdline.txt.orig
  * sed -i s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt
  * touch ssh

# installation
## configuration - general
* sudo apt update
* sudo apt list --upgradable
* sudo apt -y upgrade
* sudo raspi-config
  * 1 Change User Password
  * 2 Hostname
  * 4 Localisation Options
    * I2 Change Timezone
    * I4 Change Wi-fi Country
  * 5 Interfacing Options
    * P1 Camera - enable on demand
    * P2 SSH
    * P4 SPI
    * P5 I2C
    * P6 Serial - Console disabled, Serial enabled
  * 7 Advanced Options
    * A3 Memory Split - set to 32 or for camera min 128
    * A7 Network interface names

## configuration - optional
* disable wifi
  * sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"
* disable bluetooth
  * sudo sh -c "echo 'dtoverlay=pi3-disable-bt' >> /boot/config.txt"
  * sudo systemctl disable hciuart
* disable audio
  * sudo sh -c "sed -i s/dtparam=audio=on/dtparam=audio=off/ /boot/config.txt"

## configuration - read-write
You can follow this if you plan to run the system as normal
* partition resize
  * sudo raspi-config
    * A1 Expand Filesystem
  
## configuration - read-only
You can follow this if you plan to run the system in read-only mode
### system
* disable swap
  * sudo systemctl stop dphys-swapfile
  * sudo systemctl disable dphys-swapfile
  * sudo dphys-swapfile swapoff
  * sudo dphys-swapfile uninstall
* resize parition
  * sudo parted /dev/mmcblk0 resizepart 2 8000M
  * sudo resize2fs /dev/mmcblk0p2
  * sudo cp /etc/fstab /etc/fstab.orig
```
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
tmpfs          /var/lib/ntp       tmpfs defaults,noatime,mode=755,uid=ntp,gid=ntp,size=1m      0 0
tmpfs          /var/log           tmpfs defaults,noatime,mode=755,uid=root,gid=root,size=100m  0 0
tmpfs          /var/tmp           tmpfs defaults,noatime,mode=1777,uid=root,gid=root,size=100m 0 0
EOT"
```
  * change blkid inside fstab and cmdline.txt
    * sudo blkid
    * sudo vi /boot/cmdline.txt
* partition create
  * sudo parted /dev/mmcblk0 mkpart primary 15630336s 100%
  * sudo mkfs.ext4 /dev/mmcblk0p3
  * sudo mkdir /data
  * sudo mount /data
* system app modifications
  * ntpd
    * sudo apt -y install ntp
    * sudo patch -b /etc/init.d/ntp ntp.patch
    * sudo systemctl daemon-reload
  * resolv.conf
    * sudo mv /etc/resolv.conf /etc/resolv.conf.orig
    * sudo ln -s /var/tmp/resolv.conf /etc/resolv.conf
  * daily_lock
    * sudo mv /var/lib/apt/daily_lock /var/lib/apt/daily_lock.orig
    * sudo ln -s /var/tmp/daily_lock /var/lib/apt/daily_lock
  * fake-hwclock
    * sudo mv /etc/fake-hwclock.data /etc/fake-hwclock.data.orig
    * sudo ln -s /var/tmp/fake-hwclock.data /etc/fake-hwclock.data
  * dhcpcd
    * sudo mv /etc/dhcpcd.secret /etc/dhcpcd.secret.orig
    * sudo ln -s /var/tmp/dhcpcd.secret /etc/dhcpcd.secret
  * rsyslog
    * sudo touch /etc/rsyslog.d/loghost.conf
    * sudo patch -b /etc/rsyslog.d/loghost.conf loghost.conf.patch
    * sudo systemctl restart rsyslog
* create service and script for read-only workarounds
  * service
    * sudo touch /lib/systemd/system/setup-tmpfs.service
    * sudo patch -b /lib/systemd/system/setup-tmpfs.service setup-tmpfs.service.patch
    * sudo systemctl enable setup-tmpfs.service
  * script
    * sudo mkdir /lib/systemd/scripts
    * sudo touch /lib/systemd/scripts/setup-tmpfs.sh
    * sudo patch -b /lib/systemd/scripts/setup-tmpfs.sh setup-tmpfs.sh.patch
    * sudo chmod +x /lib/systemd/scripts/setup-tmpfs.sh

### apps
#### mosquitto
* mkdir /data/mosquitto
* chown -R mosquitto:root /data/mosquitto
* patch -b /etc/mosquitto/mosquitto.conf mosquitto.conf.patch

#### lighttpd
* mv /var/lib/php/sessions /var/lib/php/sessions.orig
* ln -s /var/tmp/sessions /var/lib/php/sessions
* mkdir /data/lighttpd
* chown -R www-data:www-data /data/lighttpd

#### homegear
* patch -b /etc/homegear/main.conf main.conf.patch
* patch -b /etc/homegear/php.ini php.ini.patch
* patch -b /etc/homegear/homegear-start.sh homegear-start.sh.patch
* mkdir -p /data/homegear/families
* mkdir -p /data/homegear/db
* mkdir -p /data/homegear/backup
* mkdir -p /data/homegear/flows/data
* chown homegear:homegear /data/homegear
  
## system add-on
* unix
  * apt -y install nmap dnsutils tcpdump
* git
  * sudo apt -y install git
* python
  * apt -y install python-dev python-pip
* avr
  * apt -y install gcc-avr avr-libc avrdude

# system settings
## wifi client
* sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig
* wpa_passphrase "testing" "testingPassword" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null

## wifi ap
* sudo apt -y  install dnsmasq hostapd
* sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
```
sudo sh -c "cat <<EOT >> /etc/dhcpcd.conf
interface wlan0
static ip_address=192.168.1.1/24
EOT"
```
* sudo touch /etc/hostapd/hostapd.conf.orig
```
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
* sudo patch -b /etc/default/hostapd hostapd.patch
* sudo touch /etc/dnsmasq.d/wlan0.conf.orig
```
sudo sh -c "cat <<EOT >> /etc/dnsmasq.d/wlan0.conf
domain-needed
interface=wlan0
listen-address=192.168.1.1
dhcp-range=192.168.1.100,192.168.1.150,12h
EOT"
```
  * sudo ln -s /var/tmp/dnsmasq.leases /var/lib/misc/dnsmasq.leases - for read-only
