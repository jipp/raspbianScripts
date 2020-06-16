


# image preparation
## mount/unmout installation image on linux
 - `sudo losetup -P /dev/loop0 <image>`
 - `sudo mount /dev/loop0p1 /mnt/`
 - `sudo umount /mnt`
 - `sudo losetup -D`
## prepare installation image
 - general preparation
   - `cd /mnt`
   - `sudo cp config.txt config.txt.orig`
   - `sudo cp cmdline.txt cmdline.txt.orig`
 - `sudo sed -i s/" init=\/usr\/lib\/raspi-config\/init_resize.sh"// cmdline.txt`                                                    
 - `sudo touch ssh`
 - `sudo cp /etc/wpa/wpa_supplicant.conf .`
 - `cd`

## prepare SD card
copy image (depending on where card is located)
 - `sudo dd bs=4M if=<image> of=/dev/sda`
 - `sudo dd bs=4M if=<image> of=/dev/sdb`
 - `sudo dd bs=4M if=<image> of=/dev/mmcblk0`
 
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0MjAxMjkzOTldfQ==
-->