#!/usr/bin/perl

use strict;
use warnings;

my $keys    = '/opt/docker-rest/ssl/rest.crt';

if(-e $keys){
  print "Keys Exist\n";
}else{
  system("openssl req -x509 -nodes -days 9000 -newkey rsa:2048 -keyout /opt/docker-rest/ssl/rest.key -out /opt/docker-rest/ssl/rest.crt");
  system("sed -i -e 's/example.crt/rest.crt/g' /opt/docker-rest/nginx.conf");
  system("sed -i -e 's/example.key/rest.key/g' /opt/docker-rest/nginx.conf");
  
}
my $docker_check = `dpkg -l | grep -c docker-engine`;
chomp($docker_check);
if ( $docker_check == 0 ) {
  
}else{
  system("docker restart docker-rest");
}