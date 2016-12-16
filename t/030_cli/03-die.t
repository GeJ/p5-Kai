use 5.014002;
use strict;
use warnings;
use lib qw(t/lib);
use Test::More;
use Test::Exception;
use Test::Trap;

use My::CLI;

my @return = trap { My::CLI->new()->run(qw(die -y)); };
is   ($trap->stdout, "",              "STDOUT is empty");
like ($trap->stderr, qr{I'm dying at t/lib/My/CLI/Die.pm line}, "STDERR has the error message");
is   ($trap->exit,   1,               "Exit with code 1");

done_testing;
