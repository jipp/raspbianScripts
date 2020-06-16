# install docker
 - `curl -sSL https://get.docker.com | sh`
 - `sudo usermod -aG docker pi`
 - `sudo apt install -y python3-pip`
 - `sudo pip3 install docker-compose`


# create docker network
docker network create \
 --driver bridge \
 --ipv6 \
 --subnet=2002:b0c6:b8e2:1::/64 \
 --opt com.docker.network.bridge.name=br-lemonpi \
 lemonpi-net


# eclipse-mosquitto

sudo mkdir -p /docker/mosquitto-data/config
sudo mkdir /docker/mosquitto-data/data
sudo mkdir /docker/mosquitto-data/log
sudo chown -R 1883:1883 /docker/mosquitto-data/config /docker/mosquitto-data/data /docker/mosquitto-data/log

docker run -d \
 --restart always \
 -p 1883:1883 \
 -p 8883:8883 \
 -v /docker/mosquitto-data/config:/mosquitto/config \
 -v /docker/mosquitto-data/log:/mosquitto/log \
 -v /docker/mosquitto-data/data:/mosquitto/data \
 --hostname mosquitto \
 --name mosquitto \
 --network lemonpi-net \
 eclipse-mosquitto


# homegear

sudo mkdir -p /docker/homegear-data/etc
sudo mkdir /docker/homegear-data/lib
sudo mkdir /docker/homegear-data/log

docker run -d \
 --restart always \
 -v /docker/homegear-data/etc:/etc/homegear:Z \
 -v /docker/homegear-data/lib:/var/lib/homegear:Z \
 -v /docker/homegear-data/log:/var/log/homegear:Z \
 -v /sys:/sys \
 -e TZ=Europe/Berlin \
 -e HOST_USER_ID=$(id -u) \
 -e HOST_USER_GID=$(id -g) \
 -p 2001:2001 \
 -p 2002:2002 \
 -p 2003:2003 \
 --device=/dev/ttyAMA0 \
 --device=/dev/ttyACM0 \
 --name homegear \
 --hostname homegear \
 --network lemonpi-net \
 homegear/homegear


# influxdb

sudo mkdir -p /docker/influxdb-data/etc
sudo mkdir /docker/influxdb-data/lib

docker run --rm influxdb influxd config > influxdb.conf

docker run -d \
 --restart always \
 -v /docker/influxdb-data/etc:/etc/influxdb \
 -v /docker/influxdb-data/lib:/var/lib/influxdb \
 -p 8086:8086 \
 --expose 25826/udp \
 -p 25826:25826/udp \
 --name influxdb \
 --hostname influxdb \
 --network lemonpi-net \
 influxdb


# telegraf

sudo mkdir -p /docker/telegraf-data

docker run --rm telegraf telegraf config > telegraf.conf

docker run -d \
 --restart always \
 -e HOST_PROC=/host/proc \
 -v /docker/telegraf-data/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
 -v /var/run/docker.sock:/var/run/docker.sock:ro \
 -v /proc:/host/proc \
 --name telegraf \
 --hostname telegraf \
 --network lemonpi-net \
 telegraf


# chronograf

sudo mkdir -p /docker/chronograf-data/lib

docker run -d \
 --restart always \
 -v /docker/chronograf-data/lib:/var/lib/chronograf \
 -p 8888:8888 \
 --name chronograf \
 --network lemonpi-net \
 chronograf --influxdb-url=http://influxdb:8086


# collectd

sudo mkdir -p /docker/collectd-data/etc
docker run --rm jipp13/fritzcollecd cat /usr/share/collectd/types.db > types.db

docker run -d \
 --restart always \
 -v /docker/collectd-data/etc:/etc/collectd:ro \
 --name collectd \
 --hostname collectd \
 --network lemonpi-net \
 jipp13/fritzcollecd


# grafana

docker volume create grafana-storage

docker run -d \
 --restart always \
 -v grafana-storage:/var/lib/grafana \
 -p 3000:3000 \
 --name grafana \
 --hostname grafana \
 --network lemonpi-net \
 grafana/grafana

# homebridge

sudo mkdir -p /docker/homebridge-data

docker run -d \
 --restart always \
 -v /docker/homebridge-data:/homebridge \
 -e TZ=Europe/Berlin \
 -e PGID=1000 \
 -e PUID=1000 \
 -e HOMEBRIDGE_CONFIG_UI=1 \
 -e HOMEBRIDGE_CONFIG_UI_PORT=8080 \
 --name homebridge \
 --network host \
 oznu/homebridge
