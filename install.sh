#!/bin/bash


apt update
apt remove -y exim4-base exim4-config exim4-daemon-light
apt upgrade -y
apt autoremove -y
apt install -y -qq \
    apt-transport-https \
    ca-certificates \
    apache2-utils \
    mc \
    git \
    nnn \
    zip \
    htop \
    curl \
    ncdu \
    unzip \
    python3 \
    dnsutils \
    net-tools \
    inetutils-ping \
    software-properties-common
apt install -y -qq docker docker-compose
docker --version && docker-compose --version

# Setup.
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
