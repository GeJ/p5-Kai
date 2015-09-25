use strict;
use warnings;
use lib qw(t/lib);
use Test::More;
use Test::Exception;
use Test::Requires qw(Capture::Tiny);

use My::CLI;

my ($out, $err, @result) = Capture::Tiny::capture { My::CLI->new()->run(qw(error -y)); };
is   ($out, "", "STDOUT is empty");
like ($err, qr/I'm dying\n/, "STDERR has the error message");

done_testing;
