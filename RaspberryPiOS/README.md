


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
 
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTA4OTI5NTc4M119
-->