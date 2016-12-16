use 5.014002;
use strict;
use warnings;
use utf8;

use File::Spec qw(catdir);
use Test::More 0.98;

use t::Util;
use Kai::Config;

{
    package My::Config1;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in { (File::Spec->catdir($t::Util::DATA_DIR, 'etc')) }
}

{
    package My::Config2;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in { (File::Spec->catdir($t::Util::DATA_DIR, qw(usr local etc))) }
}

my $conf1 = My::Config1->config;
is ref($conf1),   'HASH', 'conf1 loaded';
is $conf1->{foo}, 'bar',  '$conf1->{foo} = bar';


my $conf2 = My::Config2->config;
is ref($conf2),   'HASH', 'conf2 loaded';
is $conf2->{foo}, 'baz',  '$conf1->{foo} = baz';

done_testing;
