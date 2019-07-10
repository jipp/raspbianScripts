# install docker 
 - `curl -sSL https://get.docker.com | sh`
 - `sudo usermod -aG docker pi`
 
# install docker-compose
 - sudo apt install -y python-pip
 - sudo apt install -y libffi-dev libssl-dev
 - sudo pip install docker-compose

# docker-compose
docker-compose up -c docker-compose.yml --no-start

# swarm init
 - docker swarm init

# deploy
 - docker stack deploy -c docker-compose.yml raspi

# folder permissions
ls -l *
-rw-r--r-- 1 root root 3157 Jun 10 17:51 docker-compose.yml

chronograf:
total 4
drwxr-xr-x 3 999 spi 4096 Jun 24 22:10 data

eclipse-mosquitto:
total 12
drwxr-xr-x 4 1883 1883 4096 Jun 10 13:29 config
drwxr-xr-x 2 1883 1883 4096 Jul 10 10:22 data
drwxr-xr-x 2 1883 1883 4096 Jun  7 13:15 log

grafana:
total 4
drwxrwxrwx 4 472 472 4096 Jul 10 10:36 data

influxdb:
total 4
drwxr-xr-x 5 999 spi 4096 Jun  7 14:55 data

kapacitor:
total 8
drwxr-xr-x 2 root root 4096 Jun 10 17:54 config
drwxr-xr-x 3  999 spi  4096 Jun 10 17:52 data

telegraf:
total 4
drwxr-xr-x 3 root root 4096 Jun 10 18:09 config

