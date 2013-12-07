use strict;
use warnings;

use Test::More;
use JSON qw(from_json);

my $module = $ENV{EXERCISM} ? 'Example' : 'Anagram';

my $cases_file = 'cases.json';
my $cases;
if (open my $fh, '<', $cases_file) {
    local $/ = undef;
    $cases = from_json scalar <$fh>;
} else {
    die "Could not open '$cases_file' $!";
}

plan tests => 3 + @$cases;
#diag explain $cases;

ok -e "$module.pm", "missing $module.pm"
    or BAIL_OUT("You need to create a class called $module.pm with an function called match() that gets the original word as the first parameter and a reference to a list of word to check. It should return a referene to a list of words.");

eval "use $module";
ok !$@, 'Cannot load $module.pm'
    or BAIL_OUT("Does $module.pm compile?  Does it end with 1; ?");

can_ok($module, 'match') or BAIL_OUT("Missing package $module; or missing sub match()");

my $sub = $module . '::match';

foreach my $c (@$cases) {
    no strict 'refs';
    is_deeply $sub->($c->{word}, @{ $c->{words} }), $c->{expected}, $c->{name};
}


