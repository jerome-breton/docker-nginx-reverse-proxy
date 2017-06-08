Simple NGINX reverse-proxy with landing page
============================================

This docker image is meant to build a lightweight landing page to display multiple services. Each of this services are reverse-proxied by NGINX.

![Landing page](https://github.com/jerome-breton/docker-nginx-reverse-proxy/raw/master/doc/landing.png)

Usage
-----

###Locations

You need a configuration file `locations.csv` containing a list of services :

| code |     label    | url in landing page      | domain for routing | service location     | image for landing page |
|:----:|:------------:|--------------------------|--------------------|----------------------|:----------------------:|
| mage |    Magento   | http://magento.local     | magento.local      | http://php:80        |       magento.svg      |
|  wp  |   Wordpress  | http://wordpress.local   | wordpress.local    | http://php:8080      |         wp.svg         |
| mail |  Mailcatcher | http://mailcatcher.local | mailcatcher.local  | http://mail:80       |     mailcatcher.png    |
|  red |     Redis    | http://phpredmin.local   | phpredmin.local    | http://phpredmin:80  |        redis.svg       |
|  pma |  phpMyAdmin  | http://pma.local         | pma.local          | http://phpmyadmin:80 |         pma.svg        |
| prof | PHP Profiler | http://profiler.local    | profiler.local     | http://profiler:80   |      profiler.svg      |

will result in this file :

```
mage,Magento,http://magento.local,magento.local,http://php:80,magento.svg
wp,Wordpress,http://wordpress.local,wordpress.local,http://php:8080,wp.svg
mail,Mailcatcher,http://mailcatcher.local,mailcatcher.local,http://mail:80,mailcatcher.png
red,Redis,http://phpredmin.local,phpredmin.local,http://phpredmin:80,redis.svg
pma,phpMyAdmin,http://pma.local,pma.local,http://phpmyadmin:80,pma.svg
prof,PHPProfiler,http://profiler.local,profiler.local,http://profiler:80,profiler.svg
```

Keep in mind that this is not a fully complient CSV file. It's only a basic split on lines and commas. Please do not try using quotes and special chars. If comma doesn't fit your needs, see the advanced section below.

###Images

Images given in locations array are relative to the path `/usr/share/nginx/html/img` so you must link a folder there to see the logos of your favorite services.

###docker usage

    docker run -d -p 80:80 -v $(pwd)/conf:/conf -v $(pwd)/img:/usr/share/nginx/html/img jeromebreton/nginx-reverse-proxy

###docker-compose usage

    version: '2'
    services:
      proxy:
        image: jeromebreton/nginx-reverse-proxy
        ports:
          - 80:80
        volumes:
          - ./proxy/conf:/conf
          - ./proxy/img:/usr/share/nginx/html/img



Advanced usage
--------------

###Change locations separator

If an environment variable `SEPARATOR` is set, it will be used for reading `locations.csv` file. It defaults to `,`.

    docker run -d [...] -e SEPARATOR="|" [...] jeromebreton/nginx-reverse-proxy

or

    version: '2'
    services:
      proxy:
        image: jeromebreton/nginx-reverse-proxy
        [...]
        env:
          SEPARATOR: "|"


###Inject variables in locations.csv

The `locations.csv` file variables will be expanded. So you can use any variable in it and define it like an environement variable when running your container.

Your `locations.csv` could look like that :

    mail,Mailcatcher,http://mail.${DOMAIN},mailcatcher.${DOMAIN},http://mail:80,mailcatcher.png
    pma,phpMyAdmin,http://pma.${DOMAIN},pma.${DOMAIN},http://phpmyadmin:80,pma.svg

And then in your `docker-compose.yml` you can add :

        env:
          DOMAIN: "test.local"


###Change landing page HTML/CSS

Landing page is built with a simple SH file containing all the template. This file is packaged in the image but you can link it via volumes if you want to edit it.

1. Find the running proxy container name with `docker ps | grep jeromebreton/nginx-reverse-proxy`
2. `docker cp <running_conainer_name>:/proxy/index.html.sh ./proxy/index.html.sh`
3. Edit the copied file to your needs
4. Relaunch the container with a new volume for this file
```
    version: '2'
    services:
      proxy:
        image: jeromebreton/nginx-reverse-proxy
          [...]
        volumes:
          - ./proxy/conf:/conf
          - ./proxy/img:/usr/share/nginx/html/img
          - ./proxy/index.html.sh:/proxy/index.html.sh
```


###Change nginx routing configuration

Nginx configuration is built with the same idea than landing page. A simple SH file containing all the template. This file is packaged in the image but you can link it via volumes if you want to edit it.

1. Find the running proxy container name with `docker ps | grep jeromebreton/nginx-reverse-proxy`
2. `docker cp <running_conainer_name>:/proxy/default.conf.sh ./proxy/default.conf.sh`
3. Edit the copied file to your needs
4. Relaunch the container with a new volume for this file
```
    version: '2'
    services:
      proxy:
        image: jeromebreton/nginx-reverse-proxy
          [...]
        volumes:
          - ./proxy/conf:/conf
          - ./proxy/img:/usr/share/nginx/html/img
          - ./proxy/default.conf.sh:/proxy/default.conf.sh
```

This container is built on **nginx:alpine** so any information stated here https://hub.docker.com/_/nginx/ should be true.
