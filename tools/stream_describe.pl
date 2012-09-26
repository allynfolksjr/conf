#!/usr/local/bin/perl
# agraf suggested using this. I'm not sure who wrote it.
# Spits out information about a media file that is being streamed.
use strict;
use Socket;

my $URL = shift(@ARGV);
if ( "$URL" eq "" ) {
	print STDERR "usage: $0 URL of media to describe\nexample: >stream_describe.pl rtsp://media.staff.washington.edu/agraf/april.mov\n";
	exit 1;
}
$URL =~ /\w{4}:\/\/([\w\.]+)\/.*/; #finds hostname
my $host = $1;
print "$host\n";

my $port = 554; #rtsp port
my $iaddr   = inet_aton($host)		|| die "no host: $host";
my $paddr   = sockaddr_in($port, $iaddr);

my $proto   = getprotobyname('rtsp');
socket(SOCK, PF_INET, SOCK_STREAM, $proto)	|| die "socket: $!";
connect(SOCK, $paddr)    || die "connect: $!";
select(SOCK); $| = 1; select(STDOUT);

#while (defined(my $line = <SOCK>)) {
#	print $line;
#}

print SOCK "DESCRIBE $URL RTSP/1.0\n\n";

while (defined(my $line = <SOCK>)) {
	print $line;
}
print SOCK "";
close (SOCK)	    || die "close: $!";
exit;
