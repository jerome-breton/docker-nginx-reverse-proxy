#!/bin/sh

sh /proxy/build-conf.sh

nginx -g "daemon off;"
