package Kai::CLI;
use strict;
use warnings;
use utf8;
use Getopt::Long;
use Try::Tiny;

our $VERSION = "v0.0.1";

use Kai::Logger;
use Kai::Util qw(load_class);

sub new {
    my $proto = shift;
    my $class = ref($proto) ? ref($proto) : $proto;
    return bless {}, $proto;
}

sub run {
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
        print "$VERSION\n";
        exit 0;
    }
 
    push @commands, @ARGV;
 
    my $cmd = shift @commands || 'help';

    if ($cmd eq 'help') {
        $self->help(@commands);
    }
    else {
        my $class = try {
            my $klass = ($cmd =~ /^\+/) 
                ? load_class($cmd)
                : load_class(ucfirst($cmd), ref($self));
            return $klass;
        }
        catch {
            warnf "Could not find command '$cmd'";
            critf "$_\n";
            exit 2;
        };

        try {
            $class->run(@commands);
        }
        catch {
            critf "$_\n";
            exit 1;
        }
    }
}

sub help { # {{{
    my ($self, @args) = @_;

    my $module = $args[0] ? ( ref($self) . '::' . ucfirst $args[0] ) : ref($self);
    system ("perldoc", $module);
} # }}}

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
