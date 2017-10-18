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

## configuration - normal
* partition resize
  * sudo raspi-config
    * A1 Expand Filesystem
* disable audio
  *
## configuration - read-only

## system add-on
* unix
  * apt-get -y install nmap dnsutils tcpdump
* git
  * sudo apt -y install git
* php
  * apt-get -y install python-dev python-pip
* avr
  * apt-get -y install gcc-avr avr-libc avrdude
