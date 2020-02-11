#!/bin/sh

. /config/config.env

CERTS=/data/certs

while :
do
    if [ -d "$CERTS" ]; then
        ./lego --accept-tos --path="$CERTS" --email="$EMAIL" --dns="$DNS" --domains="$DOMAINS"  --dns.resolvers 8.8.8.8 renew --days 30
    else
        mkdir "$CERTS"
        ./lego --accept-tos --path="$CERTS" --email="$EMAIL" --dns="$DNS" --domains="$DOMAINS"  --dns.resolvers 8.8.8.8 run
    fi
    # 1day = 24*3600 = 86400
    sleep 86400
done
