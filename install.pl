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
  system("apt-get install curl apt-transport-https ca-certificates software-properties-common -y");
  system("curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -");
  system("add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"");
  system("apt-get update");
  system("apt-get install docker-ce -y");
  system("apt-get install apache2-utils htop mc -y");
  system("echo 'DOCKER_OPTS=\"-H unix:///var/run/docker.sock\"' >> /etc/default/docker");
  system("service docker restart");
  system("curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose");
  system("chmod +x /usr/bin/docker-compose");
  system("echo 'Europe/Moscow' > /etc/timezone");
  
  print "PASS: $passwd\n";
  system("htpasswd -bc /opt/docker-rest/.passwd synapse $passwd");
  system("echo $passwd > /opt/docker-rest/passwd");
  
  chdir("/opt/docker-rest");
  system("docker-compose up -d docker-rest");
}else{
  print "allready done \n";
}
