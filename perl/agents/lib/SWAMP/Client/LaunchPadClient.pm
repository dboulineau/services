# This file is subject to the terms and conditions defined in
# 'LICENSE.txt', which is part of this source code distribution.
#
# Copyright 2012-2016 Software Assurance Marketplace

#** @file LaunchPadClient.pm
#
# @brief This file contains the client interface to the AgentMonitor
# @author Dave Boulineau (db), dboulineau@continuousassurance.org
#*

package SWAMP::Client::LaunchPadClient;

use 5.014;
use utf8;
use strict;
use warnings;
use parent qw(Exporter);

use RPC::XML;
use RPC::XML::Client;
use Log::Log4perl;
use SWAMP::RPCUtils qw(rpccall);
use SWAMP::SWAMPUtils qw(getMethodName);

#** @class SWAMP::Client::LaunchPadClient
# This package contains the client interface to the AgentMonitor. Perl clients wishing to communicate with the Agent Monitor
# should use this package's functions.
#*
BEGIN {
    our $VERSION = '1.00';
}
our (@EXPORT_OK);

BEGIN {
    require Exporter;
    @EXPORT_OK = qw(
      configureClient
      launchPadCreateID
      launchPadStart
    );
}

use English '-no_match_vars';
use Carp qw(croak carp);

my $uri = 'http://localhost:8082';
my $client;

#** @method configureClient ($state)
# This method will change and keep track of the various states that the state machine
# transitions to and from. Having this information allows you to return to a previous
# state. If you pass nothing in to this method it will restore the previous state.
# @param state - optional string (state to change to)
#*
sub configureClient {
    my $host = shift;
    my $port = shift;
    $uri = "http://$host:$port";
    undef $client;
    logDebug("LaunchPadClient::configureClient: $uri");
    return;
}

sub getClient {
    if ( !defined($client) ) {
        $client = RPC::XML::Client->new($uri);
    }
    return $client;
}

## PerlCritic cannot properly handle packages with multiple
# classes such as RPC::XML.pm.
## no critic (RequireExplicitInclusion)

sub launchPadCreateID {
    my $mapref = shift;
    my $req    = RPC::XML::request->new( getMethodName('LAUNCHPAD_CREATEEXECID') );
    logDebug("LaunchPadClient::launchPadCreateID on $uri");
    return rpccall( getClient(), $req );
}

sub launchPadStart {
    my $mapref    = shift;
    my $execrunid = $mapref->{'execrunid'};
    my $req =
      RPC::XML::request->new( getMethodName('LAUNCHPAD_START'), RPC::XML::struct->new($mapref) );
    logDebug("LaunchPadClient::launchPadStart on $uri execid is $execrunid");
    return rpccall( getClient(), $req );
}

sub logDebug {
    if ( Log::Log4perl->initialized() ) {
        my $msg = shift;
        Log::Log4perl->get_logger(q{})->debug($msg);
    }
    return;
}
1;

__END__
=pod

=encoding utf8

=head1 NAME

LaunchPadClient - methods for creation and manipulating VMs 

=head1 SYNOPSIS

ToDO: write synopsis

=head1 DESCRIPTION

ToDO: write description

=head1 OPTIONS

=over 8

=item 


=back

=head1 EXAMPLES

=head1 SEE ALSO

=cut
