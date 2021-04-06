#!/bin/bash


apt update
apt install docker docker-compose
cd /opt/docker-rest

PASS=$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c20)
if [ -z "$1" ]; then
  PASS=$1
fi
echo 'DOCKER_OPTS="-H unix:///var/run/docker.sock"' >> /etc/default/docker
service docker restart
echo 'Europe/Moscow' > /etc/timezone
htpasswd -bc /opt/docker-rest/.passwd synapse $PASS
echo $PASS > /opt/docker-rest/passwd
cd /opt/docker-rest && docker-compose up -d docker-rest
