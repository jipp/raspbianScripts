# install docker 
 - `curl -sSL https://get.docker.com | sh`
 - `sudo usermod -aG docker pi`
 
# install docker-compose
 - sudo apt install -y python-pip
 - sudo apt install -y libffi-dev libssl-dev
 - sudo pip install docker-compose

# create alpine
 - docker import http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/armhf/alpine-minirootfs-3.9.3-armhf.tar.gz alpine:3.9.3

# docker-compose
docker-compose up -c /home/pi/docker/docker-compose.yml --no-start

# swarm init
 - docker swarm init

# deploy
 - docker stack deploy -c docker-compose.yml raspi
