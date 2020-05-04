FROM alpine:3.10

LABEL maintainer="wolfgang.keller@wobilix.de"

#RUN apk add --no-cache collectd collectd-python collectd-network py-pip libxml2-dev libxslt-dev gcc musl-dev python2-dev bash && \
#    pip install --no-cache-dir fritzcollectd

RUN apk add --no-cache --virtual .build-deps libxml2-dev libxslt-dev gcc musl-dev python2-dev py-pip && \
    apk add --no-cache collectd collectd-python collectd-network bash && \
    pip install --no-cache-dir fritzcollectd && \
    apk del --no-cache .build-deps && \
    apk add --no-cache libxslt py-setuptools && \
    rm -rf /var/cache/apk/*

VOLUME ["/etc/collectd"]
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/collectd", "-f"]
