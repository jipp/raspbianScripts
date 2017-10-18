# preparation
* dd if=2017-09-07-raspbian-stretch-lite.img of=/dev/sda
* mount /dev/sda1 /mnt
* cd /mnt
  * cp config.txt config.txt.orig
  * cp cmdline.txt cmdline.txt.orig
  * sed s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt
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
    * P6 Serial - (onsole disabled, Serial enabled
  * 7 Advanced Options
    * A3 Memory Split - set to 32 or for camera min 128
    * A7 Network interface names

## configuration - optional
* disable wifi
  * sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"
* disable bluetooth
  * sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"
  * sudo systemctl disable hciuart
* disable audio
  * sed s/dtparam=audio=on/dtparam=audio=off/ /boot/config.txt

## configuration - normal
You can follow this if you plan to run the system as normal
* partition resize
  * sudo raspi-config
    * A1 Expand Filesystem
  
## configuration - read-only
You can follw this if you plan to run the system in read-only mode
* disable swap
  * sudo systemctl stop dphys-swapfile
  * sudo systemctl disable dphys-swapfile
  * sudo dphys-swapfile swapoff
  * sudo dphys-swapfile uninstall
* resize parition
  * sudo parted /dev/mmcblk0 resizepart 2 8000M
  * sudo resize2fs /dev/mmcblk0p2
  * sudo cp fstab /etc/fstab
  * change blkid inside fstab and cmdline.txt
    * sudo blkid
    * sudo vi /etc/fstab
    * sudo vi /boot/cmdline.txt
* partition create
  * sudo parted /dev/mmcblk0 mkpart primary 15630336s 100%
  * sudo mkfs.ext4 /dev/mmcblk0p3
  * sudo mkdir /data
  * sudo mount /data
* disable fsck
  * sudo sed s/" fsck.repair=yes"// /boot/cmdline.txt
* app modifications
  * ntpd
    * sudo apt -y install ntp
    * sudo patch -b /etc/init.d/ntp ntp.patch
    * sudo systemctl daemon-reload
  * resolv.conf
    * mv /etc/resolv.conf /etc/resolv.conf.orig
    * ln -s /var/tmp/resolv.conf /etc/resolv.conf
  * daily_lock
    * mv /var/lib/apt/daily_lock /var/lib/apt/daily_lock.orig
    * ln -s /var/tmp/daily_lock /var/lib/apt/daily_lock
  * fake-hwclock
    * mv /etc/fake-hwclock.data /etc/fake-hwclock.data.orig
    * ln -s /var/tmp/fake-hwclock.data /etc/fake-hwclock.data
  * dhcpcd
    * mv /etc/dhcpcd.secret /etc/dhcpcd.secret.orig
    * ln -s /var/tmp/dhcpcd.secret /etc/dhcpcd.secret
  * rsyslog
    * touch /etc/rsyslog.d/loghost.conf
    * patch -b /etc/rsyslog.d/loghost.conf loghost.conf.patch
    * systemctl restart rsyslog

## system add-on
* unix
  * apt-get -y install nmap dnsutils tcpdump
* git
  * sudo apt -y install git
* php
  * apt-get -y install python-dev python-pip
* avr
  * apt-get -y install gcc-avr avr-libc avrdude
