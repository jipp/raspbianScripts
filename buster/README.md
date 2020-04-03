# prepare image

## mount/unmount SW image
 - `sudo losetup -P /dev/loop0 <image>`
 - `sudo mount /dev/loop0p1 /mnt/`
 - `sudo umount /mnt`
 - `sudo losetup -D`

## prepare SW image
 - `cd /mnt`
 - `sudo cp config.txt config.txt.orig`
 - `sudo cp cmdline.txt cmdline.txt.orig`
 - `sudo sed -i s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt`                                                    
 - `sudo touch ssh`
 - `sudo cp /etc/wpa/wpa_supplicant.conf .`
 - `cd`

## create SD image
 - create image
 	- `sudo dd bs=4M if=<image> of=/dev/sda`
	- `sudo dd bs=4M if=<image> of=/dev/mmcblk0`

# configuration

## general
 - `cd /boot`
 - change boot reference
 	- `sudo sed -i s/"PARTUUID=........-02"/"\/dev\/sda2"/ cmdline.txt`
	- `sudo sed -i s/"PARTUUID=........-02"/"\/dev\/mmcblk0p2"/ cmdline.txt`
 - `sudo apt update`
 - list upgrade packages:
 	- `apt list --upgradable`
	- `apt list -a --upgradable`
 - `sudo apt -y upgrade`
 - `sudo apt clean`
 - `sudo reboot`
 - `sudo raspi-config`
	- 1 Change User Password `sudo passwd pi`
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
	- A1 Expand Filesystem
		- `sudo parted /dev/mmcblk0 resizepart 2 100%`
                - `sudo resize2fs /dev/mmcblk0p2`
		- `sudo parted /dev/sda resizepart 2 100%`
		- `sudo resize2fs /dev/sda2`
 - modify mounts
 	- `cd /etc`
	- `sudo cp fstab fstab.orig`
  	- `sudo sed -i s/"PARTUUID=........-01"/"\/dev\/sda1     "/ fstab`
  	- `sudo sed -i s/"PARTUUID=........-02"/"\/dev\/sda2     "/ fstab`
	- `sudo sed -i s/"PARTUUID=........-01"/"\/dev\/mmcblk0p1"/ fstab`
	- `sudo sed -i s/"PARTUUID=........-02"/"\/dev\/mmcblk0p2"/ fstab`
 - `sudo reboot`

## optional

###  disable wifi
 - `sudo sh -c "echo 'dtoverlay=pi3-disable-wifi' >> /boot/config.txt"`

### disable bluetooth
 - `sudo sh -c "echo 'dtoverlay=pi3-disable-bt' >> /boot/config.txt"`
 - `sudo systemctl disable hciuart`

### disable audio
 - `sudo raspi-config nonint set_config_var dtparam=audio off /boot/config.txt`

### enable gpio-shutdown (can conflict with I2C)
 - `sudo sh -c "echo 'dtoverlay=gpio-shutdown' >> /boot/config.txt"`
