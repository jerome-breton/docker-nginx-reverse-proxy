#!/bin/sh

export IFS="${SEPARATOR-,}"
export LOCATIONS=/tmp/locations.csv
envsubst < /conf/locations.csv > $LOCATIONS

sh /proxy/index.html.sh > /usr/share/nginx/html/index.html
sh /proxy/default.conf.sh > /etc/nginx/conf.d/default.conf
