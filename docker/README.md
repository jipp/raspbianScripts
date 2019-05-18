# install docker 
 - `curl -sSL https://get.docker.com | sh`
 - `sudo usermod -aG docker pi`
 
# install docker-compose
 - sudo apt install -y python-pip
 - sudo apt install -y libffi-dev libssl-dev
 - sudo pip install docker-compose

# create alpine
 - docker import http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/armhf/alpine-minirootfs-3.9.3-armhf.tar.gz alpine:3.9.3

# run mosquitto
 - docker run -it --rm --name mosquitto -p 1883:1883 -v /home/pi/docker/mosquitto/config:/mosquitto/config -v /home/pi/docker/mosquitto/data:/mosquitto/data -v /home/pi/docker/mosquitto/log:/mosquitto/log eclipse-mosquitto

# run influxdb
 - docker run -d --rm --name influxdb -p 8086:8086 -v /home/pi/docker/influxdb:/var/lib/influxdb influxdb

# run telegraf
 - docker run -d --rm --name telegraf -v /home/pi/docker/telegraf:/etc/telegraf:ro telegraf --config-directory /etc/telegraf/conf.d

# run chronograf
 - docker run -d --rm --name chronograf -p 8888:8888 -v /home/pi/docker/chronograf:/var/lib/chronograf chronograf --influxdb-url=http://raspi:8086

# connect to running container
 - docker exec -it mosquitto /bin/sh

# swarm init
 - docker swarm init

# deploy
 - docker stack deploy -c docker-compose.yml raspi
