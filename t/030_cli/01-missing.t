use 5.014002;
use strict;
use warnings;
use lib qw(t/lib);
use Test::More;
use Test::Exception;
use Test::Trap;

use My::CLI;

my @return = trap { My::CLI->new()->run(qw(missing -y)); };
is   ($trap->stdout, "",                                   "STDOUT is empty");
like ($trap->stderr, qr/Could not find command 'missing'/, "STDERR has the error message");
is   ($trap->exit,   2,                                    "Exit with code 2");

done_testing;
