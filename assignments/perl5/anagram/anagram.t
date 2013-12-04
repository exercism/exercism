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

plan tests => 3 + @$cases;
#diag explain $cases; 

ok -e 'Anagram.pm', 'missing Anagram.pm'
    or BAIL_OUT("You need to create a class called Anagram.pm with an function called match() that gets the original word as the first parameter and a reference to a list of word to check. It should return a referene to a list of words.");

eval "use Anagram";
ok !$@, 'Cannot load Anagram.pm'
    or BAIL_OUT('Does Anagram.pm compile?  Does it end with 1; ?');

can_ok('Anagram', 'match') or BAIL_OUT("Missing package Anagram; or missing sub match()");

foreach my $c (@$cases) {
    is_deeply Anagram::match($c->{word}, @{ $c->{words} }), $c->{expected}, $c->{name};
}


