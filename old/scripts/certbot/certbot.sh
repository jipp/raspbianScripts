#!/bin/sh

sudo /home/pi/certbot/certbot-auto certonly --email wolfgang.keller@wobilix.de --rsa-key-size 4096 --standalone -d dyndns.wobilix.de -d diskstation --dry-run
