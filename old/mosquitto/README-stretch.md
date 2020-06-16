# installation
 - `wget -qO - http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | apt-key add -`
 - `cd /etc/apt/sources.list.d/`
 - `wget http://repo.mosquitto.org/debian/mosquitto-stretch.list`
 - `apt update`
 - `apt -y install mosquitto mosquitto-clients`

# configuration
 - `sudo touch /etc/mosquitto/passwd.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/passwd
homegear:$6$hyOh5RLgjiTEcrJV$ZJy6bDtdXj4oTPMBaqPf+7peTuBAFhTZG0eUu4CNfZxoH8Aj5mxU4L36OB6Z52RWv5bQ3Gxb3qg+jvBzqa5Edw==
wohnzimmer:$6$2WK0DysUP/R3sGhj$ejO/KR8Z65JdGweue2DAFFtl41m2WBwOATc7ol1+svopPZn7jhsNXFAe0xAXKBASG3K5c8hEPn++5yEGFni1QA==
trial:$6$tfYSMWZWlv8vEyTt$wD6iRLJExkE4DHdXBAA3RxQP4f7l/KsDgfbclEMH5+4NPQda46RrxQXMYZ47vLOmifEbV35RM0WXUt9rX7kOaQ==
garage:$6$vAOINzRqWVHKqK3P$hSREkHl6zCgiRpz3VwrSjVPVmXJxcVbh7x3nWfw7IrhZBNszejyJkHoBeZhES8yPqTTSt7jm31WWtnd37gxK6g==
EOT"
```
 - `sudo touch /etc/mosquitto/conf.d/debug.conf.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/conf.d/debug.conf
#log_type all
log_type error
log_type warning
EOT"
```
 - `sudo touch /etc/mosquitto/conf.d/security.conf.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/conf.d/security.conf
password_file /etc/mosquitto/passwd
allow_anonymous false
EOT"
```
 - `sudo touch /etc/mosquitto/conf.d/tls.conf.orig`
```bash
sudo sh -c "cat <<EOT > /etc/mosquitto/conf.d/tls.conf
listener 1883 127.0.0.1
listener 1883 ::1

listener 8883
tls_version tlsv1.2
cafile /etc/mosquitto/ca_certificates/ca.crt
certfile /etc/mosquitto/certs/server.crt
keyfile /etc/mosquitto/certs/server.key
EOT"
```

# tls
 - Certificate Authority:
```bash
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout ca.key -out ca.crt -subj "/C=DE/ST=NRW/L=Aachen/O=wobilix/OU=lemonpi/CN=wobilix.de"
```
 - Generate a server key without encryption:
```bash
openssl genrsa -out server.key 2048
```
 - Generate a certificate signing request to send to the CA:
```bash
openssl req -out server.csr -key server.key -new -config openssl.cnf
```
 - Send the CSR to the CA, or sign it with your CA key:
```bash
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650 -extensions req_cert_extensions -extfile openssl.cnf
```
 - create openssl.cnf:
```bash
sudo sh -c "cat <<EOT > openssl.cnf
[ req ]
distinguished_name = req_distinguished_name
req_extensions = req_cert_extensions
prompt = no

[ req_distinguished_name ]
C = DE
ST = NRW
L = Aachen
O = wobilix
OU = lemonpi
CN = lemonpi
emailAddress = wolfgang.keller@wobilix.de

[ req_cert_extensions ]
subjectAltName = @subject_alt_name

[ subject_alt_name ]
DNS.1 = lemonpi
DNS.2 = lemonpi.fritz.box
DNS.3 = dyndns.wobilix.de
IP.1 = 127.0.0.1
IP.2 = ::1
EOT"
```
 - install certificates:
```bash
cp ca.crt /etc/mosquitto/ca_certificates/
cp server.crt server.key /etc/mosquitto/certs/
systemctl stop mosquitto
systemctl start mosquitto
systemctl status mosquitto
```
 - get fingerprint:
```bash
echo | openssl s_client -connect localhost:8883 | openssl x509 -fingerprint -noout
```
- display content:
```bash
openssl req -text -noout -verify -in server.csr
openssl x509 -in server.crt  -text -noout
openssl x509 -in ca.crt  -text -noout
```

# backup
 - /etc/mosquitto
