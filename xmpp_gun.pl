#!/usr/bin/perl

use strict;
use warnings;

use Net::XMPP;
use Getopt::Std;
use v5.10;

my $con = new Net::XMPP::Client();

my %opts;
my $opt_str = "bhisu";
getopt('bhisu', \%opts);
die &usage unless keys %opts == 5;
my $mesg = shift @ARGV;

$con->SetCallBacks(onconnect => sub { say "Connecting......";},
		onauth => \&send_message,
		);
$con->Execute(hostname => $opts{h},
		port => 5222,
		tls => 1,
		username => $opts{u},
		password => $opts{s},
		resource => "bot",
		register => 0,
		connectiontype => 'tcpip'
	     );

sub send_message {
	while (1) {
		say 'Message sending......';
		$con->MessageSend(to => $opts{b},
				body => $mesg
				);
		say 'Message sent';
		sleep $opts{i};
	}
}

sub usage {
	say << 'END_OF_USAGE';
Usage: xmpp_gun.pl <options> <message>
	-b	buddy jid
	-h	server
	-i	interval between message sent
	-u	user 
	-s	password
END_OF_USAGE
}

=head
Send message to buddy repeatly on a specified interval.
=cut
