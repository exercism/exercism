use strict;
use warnings;

my $module = $ENV{EXERCISM} ? 'Example' : 'Triangle';

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

ok -e "$module.pm", "missing $module.pm"
    or BAIL_OUT("You need to create a class called $module.pm with an function called kind() that gets 3 numbers - the length of the sides. It should return a single word like equilateral, isosceles, or scalene. Or, it should throw and exception.");

eval "use $module";
ok !$@, "Cannot load $module.pm"
    or BAIL_OUT("Does $module.pm compile?  Does it end with 1; ?");

can_ok($module, 'kind') or BAIL_OUT("Missing package $module; or missing sub kind()");

my $sub = $module . '::kind';

foreach my $c (@$cases) {
    my $kind;
    eval {
    	no strict 'refs';
        $kind = $sub->(@{ $c->{input} });
    };
    if ($c->{exception}) {
		like $@, qr/^$c->{exception}/, "Exception $c->{name}";
	} else {
        is $kind, $c->{expected}, $c->{name};
    }
}


