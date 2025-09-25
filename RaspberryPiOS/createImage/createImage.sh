#!/bin/bash

if [ $# -eq 0 ]; then
	echo "No arguments supplied"
	exit 1
fi

echo "check checksum"
sha256sum -c $1.xz.sha256
if [ $? -ne 0 ]; then
	exit 1
fi

echo "decompress"
xz -kd $1.xz
sudo losetup -P /dev/loop0 $1

echo "modify image part 1"
sudo mount /dev/loop0p1 /mnt
sudo cp custom.toml /mnt
cd /mnt
sudo cp config.txt config.txt.orig
sudo cp cmdline.txt cmdline.txt.orig
ls -lh *.orig
cd ~/createImage
sudo umount /mnt

echo "modify part 2"
sudo mount /dev/loop0p2 /mnt
cd /mnt/etc
sudo cp fstab fstab.orig
ls -lh *.orig
cd ~/createImage
sudo umount /mnt

echo "clean-up"
sudo losetup -D

echo "rename"
cd ~/createImage
mv $1 raspios.img

echo "compress"
xz -z raspios.img
sha256sum raspios.img.xz > raspios.img.xz.sha256
