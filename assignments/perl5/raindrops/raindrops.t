use strict;
use warnings;

use Test::More;
use JSON qw(from_json);

my $cases_file = 'cases.json';
my $cases;
if (open my $fh, '<', $cases_file) {
    local $/ = undef;
    $cases = from_json scalar <$fh>;
} else {
    die "Could not open '$cases_file' $!";
}

#plan tests => 3 + @$cases;
#diag explain $cases; 

ok -e 'Raindrops.pm', 'missing Raindrops.pm'
    or BAIL_OUT("You need to create a class called Raindrops.pm with a constructor called convert.");

eval "use Raindrops";
ok !$@, 'Cannot load Raindrops.pm'
    or BAIL_OUT("Does Raindrops.pm compile?  Does it end with 1; ? ($@)");

can_ok('Raindrops', 'convert') or BAIL_OUT("Missing package Raindrops; or missing sub convert()");

foreach my $c (@$cases) {
   is_deeply Raindrops::convert($c->{input}), $c->{expected}, $c->{name}
}


done_testing();
