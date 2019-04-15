#!/bin/sh

sudo mount -o remount,rw /
sudo mount -o remount,rw /boot
sudo apt update
sudo apt list -a --upgradeable
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot
