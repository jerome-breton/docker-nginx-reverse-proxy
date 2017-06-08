#!/bin/sh

export IFS=","
export ALIAS=/tmp/nginx-aliases.csv
envsubst < /conf/nginx-aliases.csv > $ALIAS

sh /proxy/index.html.sh > /usr/share/nginx/html/index.html
sh /proxy/default.conf.sh > /etc/nginx/conf.d/default.conf
