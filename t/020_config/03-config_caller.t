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

{
    package My::App;
    {
        no strict 'refs';
        *{__PACKAGE__.'::config'} = sub { My::Config->config() };
    }
}

my $conf = My::Config->config;
is ref($conf),   'HASH', '$conf loaded';
is $conf->{foo}, 'bar',  '$conf->{foo} is "bar"';

my $app_conf = My::App->config;
is ref($app_conf),   'HASH', '$app_conf loaded';
is $app_conf->{foo}, 'bar',  '$app_conf->{foo} is "bar"';

{
    no strict 'refs';
    no warnings 'redefine';
    *{'My::Config::file_name'} = sub { 'unknown_file' };
    is(My::Config->file_name(), 'unknown_file', 'My::Class::file_name overwritten');

    my $app_conf2 = My::App->config;
    is ref($app_conf2),   'HASH', '$app_conf2 re-loaded';
    is $app_conf2->{foo}, 'bar',  '$app_conf2->{foo} is still "bar"';
}


is(My::Config->file_name(), 'unknown_file', 'My::Class::file_name still overwritten outside of closure');

done_testing;
