# docker

## installation

- `curl -sSL https://get.docker.com | sh`
- `sudo usermod -aG docker pi`

## docker-compose

- `sudo apt install -y python3-pip`
- `sudo pip3 install docker-compose`
- `docker-compose -f docker-compose.yml -p woke up`
- update: `sudo pip3 install -U docker-compose`

## docker daemon

- `sudo touch /etc/docker/daemon.json.orig`

```bash
sudo sh -c "cat <<EOT > /etc/docker/daemon.json 
{
  \"debug\": false,
  \"experimental\": true,
  \"ipv6\": true,
  \"ip6tables\": false,
  \"bip\": "192.168.16.1/24",
  \"fixed-cidr-v6\": \"2002:b0c6:d4db:0:16::/80\"
  \"dns\": [\"192.168.178.1\"]
}
EOT"
```

- `sudo touch /usr/lib/dhcpcd/dhcpcd-hooks/99-sysctl.orig`

```bash
sudo sh -c "cat <EOT> /usr/lib/dhcpcd/dhcpcd-hooks/99-sysctl
sysctl net.ipv6.conf.eth0.accept_ra=2
EOT"
```

## cgroup memory
- `sudo sed -i 's/$/ cgroup_enable=memory cgroup_memory=1/' /boot/cmdline.txt`

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
