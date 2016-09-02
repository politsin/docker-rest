#!/usr/bin/perl

use strict;
use warnings;



my $passwd  = $ARGV[0];
my $docker  = '';
my $drupal  = 'http://docker.s3dev.ru/libraries/docker/build-drupal';
my $install = 'http://docker.s3dev.ru/libraries/docker/build-single';

print "$passwd\n";
my $docker_check = `dpkg -l | grep -c docker-engine`;
chomp($docker_check);
if ( $docker_check == 0 ) {
	system("apt-get update");
	system("apt-get install -qq apt-transport-https ca-certificates curl -y");
	system("apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D");
	system("echo \"deb https://apt.dockerproject.org/repo ubuntu-xenial main\" >> /etc/apt/sources.list.d/docker.list");
	system("apt-get update");
	system("apt-get purge lxc-docker");
	system("apt-get install -qq -y linux-image-extra-\$(uname -r)");
	system("apt-get install -qq docker-engine apache2-utils htop -y");
	system("echo 'DOCKER_OPTS=\"-H unix:///var/run/docker.sock\"' >> /etc/default/docker");
	system("service docker restart");
}
#if ( $docker_check > 0 ) {
  if ( ! -d "/tmp/docker-setup" ) { system("mkdir /tmp/docker-setup"); }
  if ( ! -d "/var/web" ) { system("mkdir /var/web"); }
  system("curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose");
  system("chmod +x /usr/bin/docker-compose");

  if ( ! -d "/opt/nginx-rest"  ) { system("mkdir /opt/nginx-rest"); }
  if ( ! -d "/opt/nginx-proxy" ) { system("mkdir /opt/nginx-proxy"); }
  if ( ! -d "/opt/setup"       ) { system("mkdir /opt/setup"); }
  if ( ! -d "/opt/res"         ) { system("mkdir /opt/res"); }
  if ( ! -d "/opt/sites"       ) { system("mkdir /opt/sites"); }

  system("wget ".$install."/nginx-rest.tar.gz  -O /tmp/nginx-rest.tar.gz");
  system("wget ".$install."/nginx-proxy.tar.gz -O /tmp/nginx-proxy.tar.gz");
  system("wget ".$install."/setup.tar.gz       -O /tmp/setup.tar.gz");
  system("wget ".$install."/res.tar.gz         -O /tmp/res.tar.gz");

  system("tar zxvf /tmp/nginx-rest.tar.gz  -C /opt/nginx-rest");
  system("tar zxvf /tmp/nginx-proxy.tar.gz -C /opt/nginx-proxy");
  system("tar zxvf /tmp/setup.tar.gz       -C /opt/setup");
  system("tar zxvf /tmp/res.tar.gz         -C /opt/res");
#}
#############
system("htpasswd -b /opt/nginx-rest/.passwd synapse $passwd");
system("echo $passwd > /opt/nginx-rest/passwd");
system("echo 'Europe/Moscow' > /etc/timezone");


chdir("/opt/nginx-rest");
system("docker-compose up -d nginx-rest");

chdir("/opt/nginx-proxy");
system("docker-compose up -d nginx-proxy");

chdir("/opt/setup");
system("docker build -t nginx-fpm .");
system("docker pull mysql");
#############
