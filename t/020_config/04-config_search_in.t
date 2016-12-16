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

my $conf1 = My::Config1->config;
is ref($conf1),   'HASH', '$conf1 loaded';
is $conf1->{foo}, 'bar',  '$conf1->{foo} is "bar"';

{
    package My::Config2;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in { (File::Spec->catdir($t::Util::DATA_DIR, qw(usr local etc))) }
}

my $conf2 = My::Config2->config;
is ref($conf2),   'HASH', '$conf2 loaded';
is $conf2->{foo}, 'baz',  '$conf2->{foo} is "baz"';

{
    package My::Config3;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in { (File::Spec->catdir($t::Util::DATA_DIR, qw(home gcs config))) }
}

my $conf3 = My::Config3->config;
is ref($conf3),   'HASH', '$conf3 loaded';
is $conf3->{foo}, 'quux', '$conf3->{foo} is "quux"';

{
    package My::Config4;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in {
        map { File::Spec->catdir($t::Util::DATA_DIR, @$_) }
            ( ['etc'], [qw(usr local etc)] );
    }
}

my $conf4 = My::Config4->config;
is ref($conf4),   'HASH', '$conf4 loaded';
is $conf4->{foo}, 'bar',  '$conf4->{foo} picks the config from "etc"'; 

{
    package My::Config5;
    use parent 'Kai::Config';

    sub file_name { 'my_app.pl' }

    sub search_in {
        map { File::Spec->catdir($t::Util::DATA_DIR, @$_) }
            ( [qw(usr local etc)], ['etc'] );
    }
}

my $conf5 = My::Config5->config;
is ref($conf5),   'HASH', '$conf5 loaded';
is $conf5->{foo}, 'baz',  '$conf5->{foo} picks the config from "usr/local/etc"'; 

done_testing;
