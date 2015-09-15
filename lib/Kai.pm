package Kai;
use 5.008001;
use strict;
use warnings;

our $VERSION = "v0.0.1";



1;
__END__

=encoding utf-8

=head1 NAME

Kai - It's my wheel, there are many like it, but I like this one better.

=head1 VERSION

This document describes Kai version v0.0.1

=head1 DESCRIPTION

L<Kai> is my simple attempt at gathering all the code I usually have to
cut-n-paste over and over again and put it in a module for reuse.

While perusing code written by other CPAN authors, you often find some little
gems.  Some functions so simple, yet so useful that you need to copy them
in your own module (provided license permits it). And the next time you
start a new module, you go dig the CPAN to find them and to copy them
again.

Sure, you could add the module as a dependency, but tell me why should I
add say, a whole web-oriented framework when I just need a dozen lines
of code burried deep in a 'Util' sub-module for a command-line tool?

Hence L<Kai>, I gather everything worth reusing and put it there just to
make my life simple... you know, laziness and stuff.

Why "Kai"? Well, it's short, and there's no way that this author will ever
forget this name.

=head1 INSTALL

Unless I have pushed this module on CPAN, your best chance to install
it is :

    cpanm git://github.com/GeJ/p5-Kai.git

Otherwise, just simply use your favorite CPAN client :

    cpanm Kai

That's it.

=head1 TODO

Properly give credit to those giants I borrowed the code from.

Oh, and tests... yeah, definitely some tests.

=head1 LICENSE

Copyright (C) Geraud CONTINSOUZAS.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Geraud CONTINSOUZAS E<lt>gcs@cpan.orgE<gt>

=cut

# vim: syn=perl nu ai cin ts=4 et sw=4 fdm=marker
