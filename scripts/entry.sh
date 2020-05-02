#!/bin/sh

. /config/config.env

CERTS=/data/certs
STATS=/data/stats

OPTS="--accept-tos --path=$CERTS --email=$EMAIL --dns=$DNS --domains=$DOMAINS --key-type rsa2048 --dns.resolvers 8.8.8.8"
CUR_STATS=$STATS/cur_stats
NEW_STATS=$STATS/new_stats

mkdir -p $STATS
touch $CUR_STATS

while :
do
    if [ -d "$CERTS" ]; then
        ./lego $OPTS renew --days 30
    else
        mkdir "$CERTS"
        ./lego $OPTS run
    fi

    # get modification time
    stat $CERTS/certificates/* -c '%y' > $NEW_STATS
    diff $CUR_STATS $NEW_STATS > /dev/null

    if [ "$?" != "0" ]; then
        /bin/sh -c "$REPORT"
        cp $NEW_STATS $CUR_STATS
    fi

    # 1day = 24*3600 = 86400
    sleep 86400
done
