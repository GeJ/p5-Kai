package Kai::Config;
use 5.010001;
use strict;
use warnings;
use utf8;

use Carp ();
use File::HomeDir;
use File::Glob ':bsd_glob';
use File::Spec;
use List::MoreUtils qw(first_value);

our $VERSION = "v0.0.1";

sub config {
    my $class = shift;
       $class = ref $class || $class;
    no strict 'refs';
    my $config = $class->_load();
    *{"$class\::config"} = sub { $config }; # Class cache.
    return $config;
}

sub _load {
    my $class = shift;

    my $pattern = '{' . join(',', $class->search_in) . '}/' . $class->file_name;
    my $fname = first_value { -f } bsd_glob($pattern);
    Carp::croak "Unable to find a configuration file"
        unless $fname;

    my $config = do $fname;
    Carp::croak("$fname: $@") if $@;
    Carp::croak("$fname: $!") unless defined $config;
    unless ( ref($config) eq 'HASH' ) {
        Carp::croak("$fname does not return HashRef.");
    }
    return $config;
}

sub config_home {
    return File::Spec->catdir(File::HomeDir->my_home, '.config')
};

#
# Overridable
#
sub file_name { 'app.pl' }

sub search_in { ( '/etc', '/usr/local/etc', config_home(), ) }

1;
__END__

=pod

=encoding utf-8

=head1 NAME

Kai::Config - Configuration made dead simple

=head1 VERSION

This document describes Kai::Config version v0.0.1

=head1 SYNOPSIS

Your config file, in say C<< "/etc/my_app.pl" >> :

    +{ DB => { dsn => ['dbi:SQLite:'] } };


Your configuration class :

    package My_App::Config;
    use parent Kai::Config;
    sub file_name { 'my_app.pl' }
    sub search_in { qw(etc /home/joe/.config) }

Your application class could go like this :

    package My_App;
    use My_App::Config;
    {
        no strict 'refs';
        *{__PACKAGE__.'::config'} = sub { My::App::Config->config() };
    }

And then anywhere else in your code :

    use My_App;
    my $conf = My::App->config;

=head1 DESCRIPTION

This is a default configuration file loader.

This module loads the configuration by C<< do >> function. Yes, it's just
plain perl code structure.

You can modify the name of the configuration file and where the module
should look for by overriding the  C<< file_name() >> and
C<< search_in() >> subs respectively.

=head1 METHODS

=over 4

=item $conf = My::Config->config()

The only method you should invoke, really. It loads the configuration file
and returns the result of its evaluation. The result is set in a cache so
that invoking the function later won't have to reparse the file again.

=item $dir = My::Config->config_home()

A helper function that returns the path to the C<< $HOME/.config >>
directory.

=item $file_name = My::Config->file_name()

The name of the file that contains the configuration data. The default is
C<< app.pl >>. This method should be overridden to suit your needs.

=item @path_list = My::Config->search_in()

A list of directories where the configuration file should be. When
searching for the file, the module won't do recursive search, and the
first match will stop the search. The default values are C<< /etc >>,
C<< /usr/local/etc >> and C<< $HOME/.config >> in that order. This
method should be overridden to suit your needs.

=back

=cut

# vim: syn=perl nu ai cin ts=4 et sw=4 fdm=marker
