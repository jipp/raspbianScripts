# docker

## installation

- `curl -sSL https://get.docker.com | sh`
- `sudo usermod -aG docker pi`

## docker-compose

- `sudo apt install -y python3-pip`
- `sudo pip3 install docker-compose`

## network

```bash
docker network create \
 --driver bridge \
 --ipv6 \
 --subnet=2002:b0c6:b8e2:1::/64 \
 --opt com.docker.network.bridge.name=br-lemonpi \
 lemonpi-net
```

## app

### eclipse-mosquitto

```bash
sudo mkdir -p /docker/mosquitto/config
sudo mkdir /docker/mosquitto/data
sudo mkdir /docker/mosquitto/log
sudo chown -R 1883:1883 /docker/mosquitto/config /docker/mosquitto/data /docker/mosquitto/log
```

```bash
docker run -d \
 --restart always \
 -p 1883:1883 \
 -p 8883:8883 \
 -v /docker/mosquitto/config:/mosquitto/config \
 -v /docker/mosquitto/log:/mosquitto/log \
 -v /docker/mosquitto/data:/mosquitto/data \
 --hostname mosquitto \
 --name mosquitto \
 --network lemonpi-net \
 eclipse-mosquitto
```

### homegear

```bash
sudo mkdir -p /docker/homegear/etc
sudo mkdir /docker/homegear/lib
sudo mkdir /docker/homegear/log
```

```bash
docker run -d \
 --restart always \
 -v /docker/homegear/etc:/etc/homegear:Z \
 -v /docker/homegear/lib:/var/lib/homegear:Z \
 -v /docker/homegear/log:/var/log/homegear:Z \
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
```

### influxdb

```bash
sudo mkdir -p /docker/influxdb/etc
sudo mkdir /docker/influxdb/lib
```

```bash
sudo sh -c "docker run --rm influxdb influxd config > /docker/influxdb/etc/influxdb.conf"
```

```bash
docker run -d \
 --restart always \
 -v /docker/influxdb/etc:/etc/influxdb \
 -v /docker/influxdb/lib:/var/lib/influxdb \
 -p 8086:8086 \
 --expose 25826/udp \
 -p 25826:25826/udp \
 --name influxdb \
 --hostname influxdb \
 --network lemonpi-net \
 influxdb
```

### telegraf

```bash
sudo mkdir -p /docker/telegraf
```

```bash
sudo sh -c "docker run --rm telegraf telegraf config > /docker/telegraf/telegraf.conf"
```

```bash
docker run -d \
 --restart always \
 -e HOST_PROC=/host/proc \
 -v /docker/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
 -v /var/run/docker.sock:/var/run/docker.sock:ro \
 -v /proc:/host/proc \
 --name telegraf \
 --hostname telegraf \
 --network lemonpi-net \
 telegraf
```

### chronograf

```bash
sudo mkdir -p /docker/chronograf/lib
```

```bash
docker run -d \
 --restart always \
 -v /docker/chronograf/lib:/var/lib/chronograf \
 -p 8888:8888 \
 --name chronograf \
 --network lemonpi-net \
 chronograf --influxdb-url=http://influxdb:8086
```

### collectd

```bash
sudo mkdir -p /docker/collectd/etc
```

```bash
sudo sh -c "docker run --rm jipp13/fritzcollecd cat /usr/share/collectd/types.db > /docker/influxdb/etc/types.db"
```

```bash
docker run -d \
 --restart always \
 -v /docker/collectd/etc:/etc/collectd:ro \
 --name collectd \
 --hostname collectd \
 --network lemonpi-net \
 jipp13/fritzcollecd
```

### grafana

```bash
docker volume create grafana-storage
```

```bash
docker run -d \
 --restart always \
 -v grafana-storage:/var/lib/grafana \
 -p 3000:3000 \
 --name grafana \
 --hostname grafana \
 --network lemonpi-net \
 grafana/grafana
```

### homebridge

```bash
sudo mkdir -p /docker/homebridge
```

```bash
docker run -d \
 --restart always \
 -v /docker/homebridge:/homebridge \
 -e TZ=Europe/Berlin \
 -e PGID=1000 \
 -e PUID=1000 \
 -e HOMEBRIDGE_CONFIG_UI=1 \
 -e HOMEBRIDGE_CONFIG_UI_PORT=8080 \
 --name homebridge \
 --network host \
 oznu/homebridge
```
