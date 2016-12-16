use 5.014002;
use strict;
use warnings;
use lib qw(t/lib);
use Test::More;
use Test::Exception;
use Test::Trap;

use My::CLI;

my @return = trap { My::CLI->new()->run(qw(errorf -y)); };
is   ($trap->stdout, "",              "STDOUT is empty");
like ($trap->stderr, qr/I'm dying\n/, "STDERR has the error message");

done_testing;
