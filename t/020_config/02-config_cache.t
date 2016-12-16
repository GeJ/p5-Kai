use 5.014002;
use strict;
use warnings;
use utf8;

use File::Spec qw(catdir);
use Test::More 0.98;

use t::Util;
use Kai::Config;

{
    package My::Config;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in { (File::Spec->catdir($t::Util::DATA_DIR, 'etc')) }
}

my $conf = My::Config->config;
is ref($conf),   'HASH', 'conf loaded';
is $conf->{foo}, 'bar',  '$conf->{foo} is "bar"';

{
    no strict 'refs';
    no warnings 'redefine';
    *{'My::Config::file_name'} = sub { 'unknown_file' };
    is(My::Config->file_name(), 'unknown_file', 'My::Class::file_name overwritten');

    my $conf = My::Config->config;
    is ref($conf),   'HASH', 'conf re-loaded';
    is $conf->{foo}, 'bar',  '$conf->{foo} is still "bar"';
}

done_testing;
