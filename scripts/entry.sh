#!/bin/sh

. /config/config.env

CERTS=/data/certs
OPTS="--accept-tos --path=$CERTS --email=$EMAIL --dns=$DNS --domains=$DOMAINS --key-type rsa2048 --dns.resolvers 8.8.8.8"

while :
do
    if [ -d "$CERTS" ]; then
        ./lego $OPTS renew --days 30
    else
        mkdir "$CERTS"
        ./lego $OPTS run
    fi
    # 1day = 24*3600 = 86400
    sleep 86400
done
