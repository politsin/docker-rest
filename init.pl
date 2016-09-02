#!/usr/bin/perl

use strict;
use warnings;

my $passwd  = $ARGV[0];
my $docker  = '';

my $docker_check = 'dpkg -l | grep -c docker-engine';
chomp($docker_check);

if ($passwd){
  print "$passwd\n";
  system("htpasswd -b /opt/docker-rest/.passwd synapse $passwd");
  system("echo $passwd > /opt/docker-rest/passwd");
  system("openssl req -x509 -nodes -days 9000 -newkey rsa:2048 -keyout /opt/docker-rest/ssl/proxy.key -out /opt/docker-rest/ssl/proxy.crt");
}else{
  'Need Passwd as ARGV[0]';
}