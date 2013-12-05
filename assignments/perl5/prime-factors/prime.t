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

ok -e 'Prime.pm', 'missing Prime.pm'
    or BAIL_OUT("You need to create a class called Prime.pm with a constructor called factors.");

eval "use Prime";
ok !$@, 'Cannot load Prime.pm'
    or BAIL_OUT("Does Prime.pm compile?  Does it end with 1; ? ($@)");

can_ok('Prime', 'factors') or BAIL_OUT("Missing package Prime; or missing sub factors()");

foreach my $c (@$cases) {
   is_deeply Prime::factors($c->{input}), $c->{expected}, $c->{name}
}


done_testing();
