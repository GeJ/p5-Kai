package t::Util;
use 5.010_001;
use strict;
use warnings;
use utf8;

use File::Basename;
use File::Path qw(make_path remove_tree);
use File::Spec;

use Kai::Util;

BEGIN {
    our $TEST_DIR = File::Spec->rel2abs(dirname(__FILE__));
    our $DATA_DIR = File::Spec->catdir($TEST_DIR, 'data');

    my $orig = Kai::Util->can('write_file');

    no warnings 'redefine';
    no strict 'refs';
    *Kai::Util::write_file = sub {
            use strict 'refs';
            my @args = @_;
            $args[0] = File::Spec->catfile($t::Util::DATA_DIR, $args[0]);
            return $orig->(@args);
        };
}

1;
__END__
