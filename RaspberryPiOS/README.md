


# installation image preparation
## mount/unmout
 - `sudo losetup -P /dev/loop0 <image>`
 - `sudo mount /dev/loop0p1 /mnt/`
 - `sudo umount /mnt`
 - `sudo losetup -D`
## prepare
   - `cd /mnt`
   - `sudo cp config.txt config.txt.orig`
   - `sudo cp cmdline.txt cmdline.txt.orig`
   - `sudo sed -i s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt`                                                    
   - `sudo touch ssh`
   - `sudo cp /etc/wpa/wpa_supplicant.conf .`
   - `cd`
## write
copy image (depending on where card is located)
 - `sudo dd bs=4M if=<image> of=/dev/sda`
 - `sudo dd bs=4M if=<image> of=/dev/sdb`
 - `sudo dd bs=4M if=<image> of=/dev/mmcblk0`
 # RaspberryPiOS preparation
 ## madatory
  - `sudo raspi-config`
	- 1 Change User Password
	`sudo passwd pi`
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
		`sudo raspi-config nonint do_camera 0|1`  (enable|disable)
		- P2 SSH
		`sudo raspi-config nonint do_ssh 0|1` (enable|disable)
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
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwNTg4MjM4NzldfQ==
-->