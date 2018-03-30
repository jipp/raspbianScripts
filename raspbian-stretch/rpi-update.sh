#!/bin/sh

sudo mount -o remount,rw /
sudo mount -o remount,rw /boot
sudo rpi-update
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot
