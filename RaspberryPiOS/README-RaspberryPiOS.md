# RasperryPiOS

## prepare installation image

### verify checksum

- `sha256sum -c <checksum file>`

### decompress image

- `xz -kd <image>`

### prepare image

- `sudo losetup -P /dev/loop0 <image>`

### prepare partitions

#### boot/firmware partition

- `sudo mount /dev/loop0p1 /mnt`
- `cd /mnt`
- `sudo cp config.txt config.txt.orig`
- `sudo cp cmdline.txt cmdline.txt.orig`

```bash
sudo sh -c "cat <<EOT > /mnt/custom.toml
config_version = 1

[system]
hostname = \"raspi\"

[user]
name = \"woke\"
password = \"$y$j9T$h8OxXB9qY4nLYk1jYf5ML.$.P8N.mbUz1lDnEzmsZ2ay8s3VYeFCdTtmhu5iScAUA.\"
password_encrypted = true

[ssh]
enabled = true
password_authentication = true

[wlan]
ssid = \"wobilix\"
password = \"49909842786a5568b0c916dcdd694d7081e999eac46d35340a07d70f2d3f2fb6\"
password_encrypted = true
hidden = false
country = \"DE\"

[locale]
keymap = \"de\"
timezone = \"Europe/Berlin\"
EOT"
```

- `cd`
- `sudo umount /mnt`

#### root partition

- `sudo mount /dev/loop0p2 /mnt`
- `cd /mnt`
- `sudo cp etc/fstab etc/fstab.orig`
- `cd`
- `sudo umount /mnt`

### unmount image

- `sudo losetup -D`

### write image

- `sudo dd bs=4M if=<image> of=/dev/<device>>`

## setup

### mandatory

- `sudo apt update && sudo apt -y upgrade && sudo apt clean`

### optional

#### boot reference

- `cd /boot/firmware`
- cmdline.txt:
  - `sudo sed -i s/"PARTUUID=........-02"/"\/dev\/<device>p2"/ cmdline.txt`
- `cd /etc`
- fstab:
  - `sudo sed -i s/"PARTUUID=........-01"/"\/dev\/<device>p1"/ fstab`
  - `sudo sed -i s/"PARTUUID=........-02"/"\/dev\/<device>p2"/ fstab`

#### disable wifi

- `sudo sh -c "echo 'dtoverlay=disable-wifi' >> /boot/firmware/config.txt"`

#### disable bluetooth

- `sudo sh -c "echo 'dtoverlay=disable-bt' >> /boot/firmware/config.txt"`
- `sudo systemctl disable hciuart`

#### wifi client

- `sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.orig`
- `wpa_passphrase "testing" "testingPassword" | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null`

#### wifi ap

- `sudo apt -y  install dnsmasq hostapd`
- `sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.orig`

```bash
sudo sh -c "cat <<EOT > /etc/dhcpcd.conf
interface wlan0
static ip_address=192.168.1.1/24
nohook wpa_supplicant
EOT"
```

- `sudo touch /etc/hostapd/hostapd.conf.orig`

```bash
sudo sh -c "cat <<EOT > /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
country_code=DE
hw_mode=g
channel=7
wmm_enabled=0

ssid=raspi
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=testtest
EOT"
```

- `sudo patch -b /etc/default/hostapd hostapd.patch`
- `sudo systemctl unmask hostapd`
- `sudo systemctl enable hostapd`
- `sudo touch /etc/dnsmasq.d/wlan0.conf.orig`

```bash
sudo sh -c "cat <<EOT > /etc/dnsmasq.d/wlan0.conf
interface=wlan0
dhcp-range=192.168.1.100,192.168.1.150,24h
EOT"
```

#### add-on

- `sudo apt -y install git`
- `sudo apt -y install sshguard`
- `sudo apt -y install watchdog`
- `sudo apt -y install nmap dnsutils tcpdump`
- `sudo apt -y install python-dev python-pip virtualenv`
- `sudo apt -y install python3-dev python3-pip virtualenv`
- `sudo apt -y install gcc-avr avr-libc avrdude`
- `sudo apt -y install ntp`
- `sudo apt -y install i2c-tools`

#### whitelist sshguard

- `sudo patch -b /etc/sshguard/whitelist whitelist.patch`

#### watchdog

- `sudo patch -b /etc/watchdog.conf watchdog.conf.patch`
- `sudo sh -c "echo 'dtparam=watchdog=on' >> /boot/config.txt"`