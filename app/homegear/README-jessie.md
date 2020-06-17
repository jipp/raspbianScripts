installation:
apt install apt-transport-https
wget https://homegear.eu/packages/Release.key && apt-key add Release.key && rm Release.key
echo 'deb https://homegear.eu/packages/Raspbian/ jessie/' >> /etc/apt/sources.list.d/homegear.list
apt update
apt-get -y install homegear homegear-nodes-core homegear-nodes-extra homegear-homematicbidcos

configuration:
mv /etc/udev/rules.d/99-com.rules /etc/udev/rules.d/99-com.rules.dis
patch -b /etc/homegear/families/homematicbidcos.conf homematicbidcos.conf.patch
patch -b /etc/homegear/mqtt.conf mqtt.conf.patch
patch -b /lib/systemd/system/homegear.service homegear.service.patch

enable/start:

backup:
/etc/homegear
/var/lib/homegear
