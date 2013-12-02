use strict;
use warnings;
use open ':std', ':encoding(utf8)';
use utf8;

use Test::More;

my @cases = (
    # input                                       expected output                  title
    ['word',                                      {word =>  1},                    'one word'],
    ['one of each',                               {one => 1, of => 1, each => 1},  'one of each'], 
    ['one fish two fish red fish blue fish',
            {one => 1, fish => 4, two => 1, red => 1, blue => 1},
                 'multiple occurences'],
    ['car : carpet as java : javascript!!&@$%^&',
            {car => 1, carpet => 1, as => 1, java => 1, javascript => 1},
                'ignore punctuation'],
    ['testing, 1, 2 testing',                     {testing => 2, 1 => 1, 2 => 1}, 'include numbers'],
    ['go Go GO',                                  {go => 3},                       'normalize case'],
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


