#!/usr/bin/perl

use strict;
use warnings;

my $passwd  = $ARGV[0];

if (!$passwd){
  my @chars = ("A".."Z", "a".."z");
  my $string;
  $passwd .= $chars[rand @chars] for 1..12;
}

if (1){
  print "PASS: $passwd\n";
  system("htpasswd -bc /opt/docker-rest/.passwd synapse $passwd");
  system("echo $passwd > /opt/docker-rest/passwd");
}else{
  print "Need Passwd as ARGV[0]\n";
}
