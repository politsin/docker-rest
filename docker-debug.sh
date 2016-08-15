#!/bin/bash

docker run --name nginx-rest -p 11666:80 --rm -ti -v /opt/nginx-rest/nginx.conf:/etc/nginx/nginx.conf -v /opt/nginx-rest/.passwd:/etc/nginx/.passwd:ro -v /opt/nginx-rest/www:/var/www:ro  nginx:alpine /bin/sh


docker run --name nginx-rest -p 11666:80 --rm -ti -v /opt/nginx-rest/www:/var/www:ro -v /opt/nginx-rest/nginx.conf:/etc/nginx/nginx.conf -v /opt/nginx-rest/ssl:/etc/nginx/ssl nginx:alpine 