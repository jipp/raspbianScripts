# mosquitto

## configuration

- `cd /docker/mosquitto/config`

- `sudo touch mosquitto.conf.orig`

```bash
sudo sh -c "cat <<EOT > mosquitto.conf
persistence true
persistence_location /mosquitto/data/

log_timestamp_format %m/%d/%y %H:%M:%S
log_dest stderr
log_dest file /mosquitto/log/mosquitto.log

include_dir /mosquitto/config/conf.d
EOT"
```

- `sudo touch passwd.orig`

```bash
sudo sh -c "cat <<EOT > passwd
homegear:$6$hyOh5RLgjiTEcrJV$ZJy6bDtdXj4oTPMBaqPf+7peTuBAFhTZG0eUu4CNfZxoH8Aj5mxU4L36OB6Z52RWv5bQ3Gxb3qg+jvBzqa5Edw==
wohnzimmer:$6$2WK0DysUP/R3sGhj$ejO/KR8Z65JdGweue2DAFFtl41m2WBwOATc7ol1+svopPZn7jhsNXFAe0xAXKBASG3K5c8hEPn++5yEGFni1QA==
schlafzimmer:$6$ySLV08R3nubhbm3R$byJbaIyz+DOLHQpfg5REj2gTK2qDUCHBw2j4ZWqx4hWNW1GnJvkKjsqvCLNFQpJPCJUkqZKe0lGj2s+9VJ4Grw==
garage:$6$tfYSMWZWlv8vEyTt$wD6iRLJExkE4DHdXBAA3RxQP4f7l/KsDgfbclEMH5+4NPQda46RrxQXMYZ47vLOmifEbV35RM0WXUt9rX7kOaQ==
trial:$6$tfYSMWZWlv8vEyTt$wD6iRLJExkE4DHdXBAA3RxQP4f7l/KsDgfbclEMH5+4NPQda46RrxQXMYZ47vLOmifEbV35RM0WXUt9rX7kOaQ==
octoprint:$6$tfYSMWZWlv8vEyTt$wD6iRLJExkE4DHdXBAA3RxQP4f7l/KsDgfbclEMH5+4NPQda46RrxQXMYZ47vLOmifEbV35RM0WXUt9rX7kOaQ==
EOT"
```

- `sudo touch conf.d/debug.conf.orig`

```bash
sudo sh -c "cat <<EOT > conf.d/debug.conf
#log_type all
log_type error
log_type warning
log_type information
EOT"
```

- `sudo touch conf.d/security.conf.orig`

```bash
sudo sh -c "cat <<EOT > conf.d/security.conf
password_file /mosquitto/config/passwd
allow_anonymous false
EOT"
```

- `sudo touch conf.d/tls.conf.orig`

```bash
sudo sh -c "cat <<EOT > conf.d/tls.conf
listener 1883
#listener 1883 127.0.0.1
#listener 1883 ::1

listener 8883
tls_version tlsv1.2
cafile /mosquitto/config/certs/ca/ca.crt
certfile /mosquitto/config/certs/broker/broker.crt
keyfile /mosquitto/config/certs/broker/broker.key
EOT"
```

## tls

- `mkdir openssl`
- `cd openssl`

- Certificate Authority

```bash
sudo openssl req -new -x509 -days 3650 -extensions v3_ca -keyout ca.key -out ca.crt -subj "/C=DE/ST=NRW/L=Aachen/O=wobilix/OU=lemonpi/CN=wobilix.de"
```

- Generate a server key without encryption

```bash
sudo openssl genrsa -out server.key 2048
```

- create openssl.cnf

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

- Generate a certificate signing request to send to the CA

```bash
sudo openssl req -out server.csr -key server.key -new -config openssl.cnf
```

- Send the CSR to the CA, or sign it with your CA key

```bash
sudo openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 3650 -extensions req_cert_extensions -extfile openssl.cnf
```

- install certificates

```bash
sudo cp ca.crt /docker/mosquitto/config/ca_certificates/
sudo cp server.crt server.key /docker/mosquitto/config/certs/
```

- get fingerprint

```bash
echo | openssl s_client -connect localhost:8883 | openssl x509 -fingerprint -noout
```

- display content

```bash
openssl req -text -noout -verify -in broker/broker.csr
openssl x509 -in broker/broker.crt  -text -noout
openssl x509 -in ca/ca.crt  -text -noout
```

- `chmod -R 1883:1883 /docker/mosquitto/config /docker/mosquitto/data /docker/mosquitto/log


-------------------

sudo mkdir openssl
cd openssl

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

sudo mkdir ca
cd ca/
sudo openssl req -new -x509 -days 3650 -extensions v3_ca -keyout ca.key -out ca.crt -subj "/C=DE/ST=NRW/L=Aachen/O=wobilix/OU=lemonpi/CN=wobilix.de"
cd ..

sudo mkdir broker
cd broker
sudo openssl genrsa -out broker.key 2048
sudo openssl req -out broker.csr -key broker.key -new -config ../openssl.cnf
sudo openssl x509 -req -in broker.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out broker.crt -days 3650
cd ..

sudo mkdir client
cd client
sudo openssl genrsa -out client.key 2048
sudo openssl req -out client.csr -key client.key -new -config ../openssl.cnf
sudo openssl x509 -req -in client.csr -CA ../ca/ca.crt -CAkey ../ca/ca.key -CAcreateserial -out client.crt -days 3650
cd ..