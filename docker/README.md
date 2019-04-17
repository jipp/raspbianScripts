# create alpine
docker import http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/armhf/alpine-minirootfs-3.9.3-armhf.tar.gz alpine:3.9.3

# create mosquitto
docker build -t mosquitto:1.5.8 mosquitto
docker run -d --rm --name mosquitto -p 1883:1883 -p 8883:8883 -v /etc/mosquitto:/etc/mosquitto mosquitto:1.5.8

# deploy
docker stack deploy -c docker-compose.yml raspi

