#!/usr/bin/python3

import sys
import uuid
import os
import subprocess
import platform

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv)
# Vars
passw = ""
docker = "docker-ce"
compose = "1.21.2"

# Set Pass form ARG or GEN
if 1 < len(sys.argv):
    passw = str(sys.argv[1])
if len(passw) < 5:
    uid = uuid.uuid4()
    passw = uid.hex
print ('Pass=', passw)

docker_check = os.system('dpkg -l | grep -c %s' % (docker))
if (docker_check):
    os.system('apt-get update')
    os.system('apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common')
    os.system('curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -')
    os.system('apt-key fingerprint 0EBFCD88')
    ostype = platform.dist()[0]
    deb = "https://download.docker.com/linux/%s $(lsb_release -cs) stable" % (ostype)
    os.system('add-apt-repository "deb [arch=amd64] %s"' % (deb))
    os.system('apt-get update')
    os.system('apt-get install -y --force-yes docker-ce')
    os.system("echo 'DOCKER_OPTS=\"-H unix:///var/run/docker.sock\"' >> /etc/default/docker")
    os.system("service docker restart")
    os.system("curl -L https://github.com/docker/compose/releases/download/%s/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose" % (compose))
    os.system("chmod +x /usr/bin/docker-compose")
    os.system("echo 'Europe/Moscow' > /etc/timezone")
    os.system("htpasswd -bc /opt/docker-rest/.passwd synapse %s" % (passw))
    os.system("echo %s > /opt/docker-rest/passwd" % (passw))
    os.system("cd /opt/docker-rest && docker-compose up -d docker-rest")

else:
    ver = os.system("docker --version")
    print ('Docker exist', ver)
