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


#diag explain $cases; 
plan tests => 3 + @$cases;

ok -e 'Triangle.pm', 'missing Triangle.pm'
    or BAIL_OUT("You need to create a class called Triangle.pm with an function called kind() that gets 3 numbers - the length of the sides. It should return a single word like equilateral, isosceles, or scalene. Or, it should throw and exception.");

eval "use Triangle";
ok !$@, 'Cannot load Triangle.pm'
    or BAIL_OUT('Does Triangle.pm compile?  Does it end with 1; ?');

can_ok('Triangle', 'kind') or BAIL_OUT("Missing package Triangle; or missing sub kind()");

foreach my $c (@$cases) {
    my $kind;
    eval {
        $kind = Triangle::kind(@{ $c->{input} });
    };
    if ($c->{exception}) {
		like $@, qr/^$c->{exception}/, "Exception $c->{name}";
	} else {
        is $kind, $c->{expected}, $c->{name};
    }
}


