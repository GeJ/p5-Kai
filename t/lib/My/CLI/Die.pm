package My::CLI::Die;
use strict;
use warnings;
use utf8;

use Kai::CLI qw(parse_options);

sub run {
    my ($self, @args) = @_;
    my $yes_opt = 0;
    parse_options(
        \@args,
        'y!' => \$yes_opt,
    );

    if ($yes_opt) {
        die "I'm dying";
    }
}

1;
