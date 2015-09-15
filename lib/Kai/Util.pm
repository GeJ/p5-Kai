package Kai::Util;
use 5.010001;
use strict;
use warnings;
use utf8;

our $VERSION = "v0.0.1";

use File::Basename;
use File::Path;
use parent qw(Exporter);

our @EXPORT_OK = qw(load_class trim write_file);

# Borrowed from Plack::Util
sub load_class {
    my ($class, $prefix) = @_;

    if ($prefix) {
        unless ($class =~ s/^\+// || $class =~ /^$prefix/) {
            $class = "$prefix\::$class";
        }
    }

    my $file = $class;
    $file =~ s!::!/!g;
    require "$file.pm"; ## no critic

    return $class;
}

sub trim {
    my $str = shift;
    $str =~ s/\A\s*//xms;
    $str =~ s/\s*\z//xms;
    $str;
}

# Borrowed from Amon2::Setup::Flavor
sub write_file {
    my ($filename, $content, $input_mode) = @_;
    Carp::croak("filename should not be a reference") if ref $filename;
    $input_mode ||= '>:encoding(utf-8)';

    my $dirname = dirname($filename);
    File::Path::make_path($dirname, {mode => 0755}) if $dirname;

    open my $ofh, $input_mode, $filename
        or die "Cannot open file: $filename: $!";
    print {$ofh} $content;
    close $ofh;
}

1;
__END__

=encoding utf-8

=head1 NAME

Kai::Util - Utility functions

=head1 VERSION

This document describes Kai::Util version v0.0.1

=head1 SYNOPSIS

    use Kai::Util qw(load_class trim write_file);

=head1 DESCRIPTION

Kai::Util is ...

=head1 LICENSE

Copyright (C) Geraud CONTINSOUZAS.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Geraud CONTINSOUZAS E<lt>geraud@scsi.ncE<gt>

=cut

# vim: syn=perl nu ai cin ts=4 et sw=4 fdm=marker
