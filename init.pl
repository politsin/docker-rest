#!/usr/bin/perl

use strict;
use warnings;

my $passwd  = $ARGV[0];
my $docker  = '';
my $keys    = '/opt/docker-rest/ssl/proxy.crt';

my $docker_check = 'dpkg -l | grep -c docker-engine';
chomp($docker_check);

if (1){
  print "$passwd\n";
  system("htpasswd -bc /opt/docker-rest/.passwd synapse $passwd");
  system("echo $passwd > /opt/docker-rest/passwd");
}else{
  print "Need Passwd as ARGV[0]\n";
}

if(-e $keys){
  print "Keys Exist\n";
}else{
  system("openssl req -x509 -nodes -days 9000 -newkey rsa:2048 -keyout /opt/docker-rest/ssl/rest.key -out /opt/docker-rest/ssl/rest.crt");
}
