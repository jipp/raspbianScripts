#!/bin/sh

sudo mount -o remount,rw /
sudo mount -o remount,rw /boot
sudo apt -y upgrade
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot
