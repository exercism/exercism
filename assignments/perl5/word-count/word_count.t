use strict;
use warnings;
use open ':std', ':encoding(utf8)';
use utf8;

use Test::More;

my @cases = (
    # input                                           expected output        title
#    ['Tom-ay-to, tom-aaaah-to.',                       'Whatever.',          'stating something'],
);


plan tests => 3 + @cases;

ok -e 'Phrase.pm', 'missing Phrase.pm'
    or BAIL_OUT("You need to create a module called Phrase.pm with a function called word_count() that gets one parameter: the text in which to count the words.");

eval "use Phrase";
ok !$@, 'Cannot load Phrase.pm'
    or BAIL_OUT('Does Phrase.pm compile?  Does it end with 1; ?');

can_ok('Phrase', 'word_count') or BAIL_OUT("Missing package Phrase; or missing sub word_count()");

foreach my $c (@cases) {
    is_deeply Phrase::word_count($c->[0]), $c->[1], $c->[2];
}


