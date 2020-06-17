#!/bin/sh

sudo mount -o remount,rw /
sudo mount -o remount,rw /boot
sudo service watchdog stop
sudo rpi-update
sudo service watchdog start
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot
