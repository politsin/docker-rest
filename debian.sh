#!/bin/bash

apt-get update
echo 'Europe/Moscow' > /etc/timezone
apt-get install -y -qq apt-transport-https ca-certificates curl apache2-utils htop git python-software-properties

apt-get install gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce

curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-Linux-x86_64 > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

echo 'DOCKER_OPTS=\"-H unix:///var/run/docker.sock\"' >> /etc/default/docker
service docker restart

htpasswd -bc /opt/docker-rest/.passwd synapse $1
echo $1 > /opt/docker-rest/passwd
cd /opt/docker-rest
docker-compose up -d docker-rest
