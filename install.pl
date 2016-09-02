#!/usr/bin/perl

use strict;
use warnings;

my $passwd  = $ARGV[0];

if (!$passwd){
  my @chars = ("A".."Z", "a".."z");
  my $string;
  $passwd .= $chars[rand @chars] for 1..12;
}

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
  system("curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose");
  system("chmod +x /usr/bin/docker-compose");
  system("echo 'Europe/Moscow' > /etc/timezone");
  
  print "PASS: $passwd\n";
  system("htpasswd -bc /opt/docker-rest/.passwd synapse $passwd");
  system("echo $passwd > /opt/docker-rest/passwd");
}else{
  print "allready done \n";
}
