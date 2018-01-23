# installation
 - `wget https://apt.homegear.eu/Release.key && apt-key add Release.key && rm Release.key`
 - `echo 'deb https://apt.homegear.eu/Raspbian/ stretch/' >> /etc/apt/sources.list.d/homegear.list`
 - `apt update`
 - `apt -y install homegear homegear-nodes-core homegear-homematicbidcos`

# configuration
 - `patch -b /etc/udev/rules.d/99-com.rules 99-com.rules.patch`
 - `patch -b /etc/homegear/families/homematicbidcos.conf homematicbidcos.conf.patch`
 - `patch -b /etc/homegear/mqtt.conf mqtt.conf.patch`
 - `patch -b /lib/systemd/system/homegear.service homegear.service.patch`

# backup:
 - /etc/homegear
 - /var/lib/homegear
