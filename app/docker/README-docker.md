# docker

## installation

- `curl -sSL https://get.docker.com | sh`
- `sudo usermod -aG docker pi`

## docker-compose

- `sudo apt install -y python3-pip`
- `sudo pip3 install docker-compose`
- `docker-compose -f docker-compose.yml -p woke up`

## ipv6
- `sudo apt install ndppd`

## cgroup memory
- `sed -i 's/$/ cgroup_enable=memory cgroup_memory=1/' /boot/cmdline.txt`

## app

### influxdb

```bash
sudo sh -c "docker run --rm influxdb influxd config > /docker/influxdb/etc/influxdb.conf"
```

### telegraf

```bash
sudo sh -c "docker run --rm telegraf telegraf config > /docker/telegraf/etc/telegraf.conf"
```

### collectd

```bash
sudo sh -c "docker run --rm jipp13/fritzcollectd cat /usr/share/collectd/types.db > /docker/influxdb/etc/types.db"
```
