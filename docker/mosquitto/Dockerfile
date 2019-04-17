FROM alpine:3.9.3

ENV VERSION=1.5.8

RUN apk --no-cache add tzdata && \
 cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
 echo "Europe/Berlin" >  /etc/timezone && \
 apk del tzdata

RUN apk --no-cache add --virtual build-deps build-base cmake util-linux-dev libwebsockets-dev openssl-dev c-ares-dev && \
 addgroup -S -g 1883 mosquitto && \
 adduser -S -u 1883 -D -H -h /var/lib/mosquitto -s /sbin/nologin -G mosquitto -g mosquitto mosquitto && \
 mkdir /build && \
 cd /build && \
 mkdir mosquitto && \
 wget https://mosquitto.org/files/source/mosquitto-${VERSION}.tar.gz -O mosquitto.tar.gz && \
 tar --strip=1 -xzf mosquitto.tar.gz -C mosquitto && \
 cd mosquitto && \
 make all && \
 make install && \
 mkdir -p /etc/mosquitto/conf.d && \
 mkdir -p /var/log/mosquitto/ && \
 mkdir -p /var/lib/mosquitto/ && \
 chown mosquitto /var/log/mosquitto/ && \
 chown mosquitto:mosquitto /var/lib/mosquitto/ && \
 make clean && \
 cd .. && \
 rm -rf mosquitto* && \
 cd .. && \
 rm -rf /build && \
 apk del build-deps && \
 apk --no-cache add libuuid

VOLUME ["/var/log/mosquitto", "/var/lib/mosquitto"]

EXPOSE 1883/tcp 8883/tcp

CMD ["/usr/local/sbin/mosquitto", "-c", "/etc/mosquitto/mosquitto.conf"]
