package Kai::CLI;
use 5.014002;
use strict;
use warnings;
use utf8;

use Getopt::Long;
use Log::Minimal ();
use Try::Tiny;

use Kai::Util qw(load_class);

use parent qw(Exporter);

our $VERSION = "0.001";

our @EXPORT_OK = qw(errorf parse_options);

sub new {
    my $proto = shift;
    my $class = ref($proto) ? ref($proto) : $proto;
    return bless {}, $proto;
}

sub run { # {{{
    my ($self, @args) = @_;
 
    local @ARGV = @args;
    my @commands;
    my $version;
    my $debug = 0;

    my $p = Getopt::Long::Parser->new(
        config => [ "no_ignore_case", "pass_through" ],
    );
    $p->getoptions(
        "h|help"         => sub { unshift @commands, 'help' },
        "debug!"         => \$debug,
        'version!'       => \$version,
    );

    if ($version) {
        say $VERSION;
        exit 0;
    }
 
    push @commands, @ARGV;
 
    my $cmd = shift @commands || 'help';

    if ($cmd eq 'help') {
        $self->help(@commands);
    }
    else {
        my $class = try {
            load_class(ucfirst($cmd), ref($self));
        }
        catch {
            _warnf("Could not find command '$cmd'");
            if (/^Can't locate @{[ref($self)]}/) {
                _critf("$_\n");
            }
            exit 2;
        };

        try {
            $class->run(@commands);
        }
        catch {
            /Kai::CLI::Error::CommandExit/ and return;
            _critf("$_\n");
            exit 1;
        }
    }
} # }}}

sub help { # {{{
    my ($self, @args) = @_;

    my $module = $args[0] ? ( ref($self) . '::' . ucfirst $args[0] ) : ref($self);
    system ("perldoc", $module);
} # }}}

###
# Utility function
###
sub _log { # {{{
    my ($level, @msg) = @_;

    my $MYPRINT = sub {
        my ($time, $type, $msg) = @_;
        print {*STDERR} "$msg";
    };
    local $Log::Minimal::COLOR             = 1;
    local $Log::Minimal::ESCAPE_WHITESPACE = 0;
    local $Log::Minimal::PRINT             = $MYPRINT;
    local $Log::Minimal::DEFAULT_COLOR
        = +{
            'warn' =>     { text => 'yellow', },
            'critical' => { text => 'red', },
        };

    if ('CRITICAL' eq $level) {
        Log::Minimal::critf(@msg);
    }
    elsif ('WARNING' eq $level) {
        Log::Minimal::warnf(@msg);
    }

} # }}}
sub _critf { _log('CRITICAL', @_); }
sub _warnf { _log('WARNING',  @_); }

###
# Exported function
###
sub errorf { # {{{
    my @msg = @_;
    _critf(@msg);

    my $fmt = shift @msg;
    Kai::CLI::Error::CommandExit->throw(sprintf($fmt, @msg));
} # }}}

sub parse_options { # {{{
    my ( $args, @spec ) = @_;
    Getopt::Long::GetOptionsFromArray( $args, @spec );
} # }}}


package # Hide from PAUSE
    Kai::CLI::Error::CommandExit;
use strict;
use warnings;
use Carp ();

sub throw {
    my ($class, $body) = @_;
    my $self = bless { body => $body, message => Carp::longmess($class) }, $class;
    die $self;
}

sub body    { shift->{body} }
sub message { shift->{message} }

1;
__END__

=encoding utf-8

=head1 NAME

Kai::CLI - Quick and painless CLI.

=head1 VERSION

This document describes Kai::CLI version v0.0.1

=head1 LICENSE

Copyright (C) Geraud CONTINSOUZAS.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Geraud CONTINSOUZAS E<lt>gcs@cpan.orgE<gt>

=cut

# vim: syn=perl nu ai cin ts=4 et sw=4 fdm=marker
