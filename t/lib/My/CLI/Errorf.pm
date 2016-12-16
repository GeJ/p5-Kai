package My::CLI::Errorf;
use strict;
use warnings;
use utf8;

use Kai::CLI qw(errorf parse_options);

sub run {
    my ($self, @args) = @_;
    my $yes_opt = 0;
    parse_options(
        \@args,
        'y!' => \$yes_opt,
    );

    if ($yes_opt) {
        errorf("I'm %s\n", "dying");
    }
}

1;
