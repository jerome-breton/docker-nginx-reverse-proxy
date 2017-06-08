#!/bin/sh

cat <<BEGIN
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html;
    }
}
BEGIN

while read code name url dom dest image
do
cat <<DOMAINS

server {
    listen  80;
    server_name ${dom};
    location / {
        proxy_pass ${dest};
        proxy_set_header X-Real-IP $$remote_addr;
        proxy_set_header X-Forwarded-For $$remote_addr;
        proxy_set_header Host $$host;
    }
}
DOMAINS
done < $ALIAS


