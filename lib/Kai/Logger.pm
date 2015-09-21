package Kai::Logger;
use strict;
use Exporter 'import';
use Log::Minimal ();

our $VERSION = "v0.0.1";

our @EXPORT = @Log::Minimal::EXPORT;

BEGIN {
    foreach my $method (@Log::Minimal::EXPORT) {
        no strict 'refs';
        *{$method} = sub {
            local $Log::Minimal::COLOR = -t STDOUT ? 1 : 0;
            local $Log::Minimal::PRINT = \&MYPRINT;
            "Log::Minimal::$method"->(@_);
        };
    }
}

sub MYPRINT {
    my ($time, $type, $message, $trace, $raw) = @_;
    my $fh = $type =~ /^(?:WARN|CRIT:)$/ ? \*STDERR : \*STDOUT;

    my $msg = $Log::Minimal::COLOR ? $message : $raw;
    printf $fh ( "%s %s\n", $time, $msg );
}

1;
__END__

=encoding utf-8

=head1 NAME

Kai::Logger - Log::Minimal tweaked to my liking.

=head1 VERSION

This document describes Kai::Logger version v0.0.1

=head1 LICENSE

Copyright (C) Geraud CONTINSOUZAS.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Geraud CONTINSOUZAS E<lt>gcs@cpan.orgE<gt>

=cut

# vim: syn=perl nu ai cin ts=4 et sw=4 fdm=marker
